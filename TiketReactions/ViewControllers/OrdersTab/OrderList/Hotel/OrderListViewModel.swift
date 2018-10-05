//
//  OrderListViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 24/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

private struct OrderListRetryError: Error {}

public protocol OrderListViewModelInputs {
    func tappedOrderDetail(_ order: OrderData)
    func deletedOrderTapped(_ order: OrderData)
    func confirmDeleteOrder(_ shouldDelete: Bool)
    func historyButtonTapped()
    func paymentMethodButtonTapped()
    func shouldRefresh()
    func viewDidLoad()
    func viewWillAppear(animated: Bool)
}

public protocol OrderListViewModelOutputs {
    var ordersAreLoading: Signal<Bool, NoError> { get }
    var loadingOverlaysIsHidden: Signal<Bool, NoError> { get }
    var orders: Signal<[OrderData], NoError> { get }
    var goToOrderDetail: Signal<OrderData, NoError> { get }
    var goToPayment: Signal<MyOrder, NoError> { get }
    var goToBookingCompleted: Signal<(), NoError> { get }
    var deleteOrderReminder: Signal<String, NoError> { get }
    var deletedOrder: Signal<Diagnostic, NoError> { get }
    var hideEmptyState: Signal<(), NoError> { get }
    var showEmptyState: Signal<Bool, NoError> { get }
}

public protocol OrderListViewModelType {
    var inputs: OrderListViewModelInputs { get }
    var outputs: OrderListViewModelOutputs { get }
}

public final class OrderListViewModel: OrderListViewModelType, OrderListViewModelInputs, OrderListViewModelOutputs {
    
    
    public init() {
        
        let orderListIsLoading = MutableProperty(false)
        
        /*
        let viewDidLoadRequest = self.viewDidLoadProperty.signal.switchMap {
            AppEnvironment.current.apiService.fetchHotelOrder().on(started: { orderListIsLoading.value = true } , terminated: { orderListIsLoading.value = false }).retry(upTo: 2).materialize()
        }.values()
         */
 
        let ordersRequest = Signal.merge(self.viewWillAppearProperty.signal.ignoreValues(), self.viewDidLoadProperty.signal).switchMap {
            AppEnvironment.current.apiService.fetchHotelOrder().on(started: { orderListIsLoading.value = true }, terminated: { orderListIsLoading.value = false }).retry(upTo: 2).materialize()
        }.values()
        
        let refreshedRequest = self.shouldRefreshProperty.signal.switchMap {
            AppEnvironment.current.apiService.fetchHotelOrder().on(started: { orderListIsLoading.value = true }, terminated: { orderListIsLoading.value = false }).retry(upTo: 2).materialize()
        }.values()
        
        ordersRequest.observe(on: UIScheduler()).observeValues { envelope in
            print("DIAGNOSTIC: \(envelope.diagnostic.status)")
        }
        
        let orderPayment = ordersRequest.map { result in return result.myOrder }.skipNil()
        
        let ordersAvailable = Signal.merge(ordersRequest, refreshedRequest).map { result in return result.myOrder?.orderData }
        
        self.orders = ordersAvailable.skipNil()
        self.showEmptyState = Signal.merge(self.orders.map { $0.isEmpty }, ordersRequest.map { $0.diagnostic.status == .empty }).skipRepeats(==).mapConst(true)
        self.hideEmptyState = Signal.merge(self.viewDidLoadProperty.signal.ignoreValues(), self.orders.filter { orders in
            !orders.isEmpty
        }.ignoreValues())
        
        self.deleteOrderReminder = self.deletedOrderProperty.signal.ignoreValues().map { "Apakah Yakin Membatalkan Order Ini?" }
        
        let deleteOrderEnvelope = self.deletedOrderProperty.signal.skipNil().promoteError(OrderListRetryError.self).switchMap { order in
            SignalProducer<(), OrderListRetryError>(value: ()).flatMap {
                _ in AppEnvironment.current.apiService.deleteOrder(url: order.deleteUri).on(started: { orderListIsLoading.value = true }, terminated: { orderListIsLoading.value = false })
                    .flatMapError { _ in
                    return SignalProducer(error: OrderListRetryError())
                    }.flatMap { envelope -> SignalProducer<DeleteOrderEnvelope, OrderListRetryError> in
                        return SignalProducer(value: envelope)
                }
            }
            }.materialize().takeWhen(self.confirmDeleteProperty.signal.filter(isTrue).ignoreValues())
        
        self.ordersAreLoading = orderListIsLoading.signal
        
        self.loadingOverlaysIsHidden = orderListIsLoading.signal.negate()
        
        self.deletedOrder = deleteOrderEnvelope.values().map { $0.diagnostic }
        self.goToOrderDetail = self.tapOrderDetailProperty.signal.skipNil()
        
        self.goToBookingCompleted = self.historyButtonTappedProperty.signal
        
        self.goToPayment = orderPayment.takeWhen(self.paymentMethodTappedProperty.signal)
    }
    
    fileprivate let tapOrderDetailProperty = MutableProperty<OrderData?>(nil)
    public func tappedOrderDetail(_ order: OrderData) {
        self.tapOrderDetailProperty.value = order
    }
    
    fileprivate let deletedOrderProperty = MutableProperty<OrderData?>(nil)
    public func deletedOrderTapped(_ order: OrderData) {
        self.deletedOrderProperty.value = order
    }
    
    fileprivate let confirmDeleteProperty = MutableProperty(false)
    public func confirmDeleteOrder(_ shouldDelete: Bool) {
        self.confirmDeleteProperty.value = shouldDelete
    }
    
    fileprivate let orderButtonTappedProperty = MutableProperty(())
    public func orderButtonTapped() {
        self.orderButtonTappedProperty.value = ()
    }
    
    fileprivate let historyButtonTappedProperty = MutableProperty(())
    public func historyButtonTapped() {
        self.historyButtonTappedProperty.value = ()
    }
    
    fileprivate let paymentMethodTappedProperty = MutableProperty(())
    public func paymentMethodButtonTapped() {
        self.paymentMethodTappedProperty.value = ()
    }
    
    fileprivate let shouldRefreshProperty = MutableProperty(())
    public func shouldRefresh() {
        self.shouldRefreshProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    fileprivate let viewWillAppearProperty = MutableProperty<Bool?>(nil)
    public func viewWillAppear(animated: Bool) {
        self.viewWillAppearProperty.value = animated
    }
    
    public let ordersAreLoading: Signal<Bool, NoError>
    public let loadingOverlaysIsHidden: Signal<Bool, NoError>
    public let orders: Signal<[OrderData], NoError>
    public let goToOrderDetail: Signal<OrderData, NoError>
    public let goToBookingCompleted: Signal<(), NoError>
    public let goToPayment: Signal<MyOrder, NoError>
    public let deleteOrderReminder: Signal<String, NoError>
    public let deletedOrder: Signal<Diagnostic, NoError>
    public let hideEmptyState: Signal<(), NoError>
    public let showEmptyState: Signal<Bool, NoError>
    
    public var inputs: OrderListViewModelInputs { return self }
    public var outputs: OrderListViewModelOutputs { return self }
}
