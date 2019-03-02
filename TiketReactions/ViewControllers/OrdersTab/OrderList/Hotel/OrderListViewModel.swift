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
    var flightMyOrders: Signal<[FlightOrderData], NoError> { get }
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
        let ordersRequest = Signal.merge(self.viewWillAppearProperty.signal.ignoreValues(), self.viewDidLoadProperty.signal, self.shouldRefreshProperty.signal).switchMap {
            AppEnvironment.current.apiService.fetchHotelOrder().on(started: { orderListIsLoading.value = true }, terminated: { orderListIsLoading.value = false }).retry(upTo: 2).materialize()
        }
        
        let orderPayment = ordersRequest.values().map { result in return result.myOrder }.skipNil()
        let ordersAvailable = ordersRequest.values().map { result in return result.myOrder?.orderData }
        
        self.flightMyOrders = .empty
        
        self.orders = ordersAvailable.skipNil()

//        self.showEmptyState = Signal.merge(self.orders.map { $0.i sEmpty }, ordersRequest.map { $0.diagnostic.status == .empty }).skipRepeats(==).mapConst(true)
        self.hideEmptyState = Signal.merge(self.viewDidLoadProperty.signal.ignoreValues(), orderListIsLoading.signal.filter { $0 == true }.ignoreValues(), self.orders.combinePrevious([]).filter { previousOrders, currentOrders in previousOrders.isEmpty && !currentOrders.isEmpty }.ignoreValues())
        
        self.deleteOrderReminder = self.deletedOrderProperty.signal.ignoreValues().map { Localizations.CancelorderTitle }
        
        let deleteOrderEvents = self.deletedOrderProperty.signal.skipNil().takeWhen(self.confirmDeleteProperty.signal.filter(isTrue)).switchMap { order in
            AppEnvironment.current.apiService.deleteOrder(url: order.deleteUri).ck_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler).on(started: { orderListIsLoading.value = true }, terminated: { orderListIsLoading.value = false }).materialize()
        }
        
        self.ordersAreLoading = orderListIsLoading.signal
        
        self.showEmptyState = Signal.merge(ordersRequest.values().filter { isTrue($0.myOrder.isNil) }.mapConst(false), self.orders.filter { $0.isEmpty }.mapConst(false), ordersRequest.errors().mapConst(false))
        
        self.loadingOverlaysIsHidden = orderListIsLoading.signal.negate()
        
        self.deletedOrder = deleteOrderEvents.values().map { $0.diagnostic }
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
    
    fileprivate let viewWillAppearProperty = MutableProperty(())
    public func viewWillAppear(animated: Bool) {
        self.viewWillAppearProperty.value = ()
    }
    
    public let ordersAreLoading: Signal<Bool, NoError>
    public let loadingOverlaysIsHidden: Signal<Bool, NoError>
    public let orders: Signal<[OrderData], NoError>
    public let flightMyOrders: Signal<[FlightOrderData], NoError>
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
