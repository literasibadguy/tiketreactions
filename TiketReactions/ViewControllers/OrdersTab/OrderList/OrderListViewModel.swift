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

public protocol OrderListViewModelInputs {
    func tappedOrderDetail(_ order: OrderData)
    func deletedOrderTapped(_ order: OrderData)
    func confirmDeleteOrder(_ shouldDelete: Bool)
    func viewDidLoad()
    func viewWillAppear(animated: Bool)
}

public protocol OrderListViewModelOutputs {
    var ordersAreLoading: Signal<Bool, NoError> { get }
    var loadingOverlaysIsHidden: Signal<Bool, NoError> { get }
    var orders: Signal<[OrderData], NoError> { get }
    var goToOrderDetail: Signal<OrderData, NoError> { get }
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
        
        let ordersRequest = Signal.merge(self.viewWillAppearProperty.signal.ignoreValues(), self.viewDidLoadProperty.signal).switchMap {
            AppEnvironment.current.apiService.fetchHotelOrder().on(started: { orderListIsLoading.value = true }, terminated: { orderListIsLoading.value = false }).retry(upTo: 2).materialize()
        }.values()
        
        
        let orderRequestError = ordersRequest.signal.filter { $0.diagnostic.status == 201 }.map { _ in "Error" }
        
        ordersRequest.observe(on: UIScheduler()).observeValues { envelope in
            print("DIAGNOSTIC: \(envelope.diagnostic.status)")
        }
        
        let ordersAvailable = ordersRequest.map { result in
            return result.myOrder.orderData
        }
        
        let orderToUpdate: Signal<OrderData?, NoError> = self.viewWillAppearProperty.signal.skipNil().take(first: 1).mapConst(nil)
        
        self.orders = ordersAvailable
        let emptyStateConfigured = self.orders.signal.filter(isNil).mapConst(false)
        
        self.showEmptyState = self.orders.map { $0.isEmpty }
        
        self.hideEmptyState = Signal.merge(self.viewDidLoadProperty.signal.ignoreValues(), self.orders.filter { orders in
            !orders.isEmpty
        }.ignoreValues())
        
        self.deleteOrderReminder = self.deletedOrderProperty.signal.ignoreValues().map { "Apakah Yakin Membatalkan Order Ini?" }
        
        let deleteOrderEvent = self.deletedOrderProperty.signal.skipNil().switchMap {
            AppEnvironment.current.apiService.deleteOrder(url: $0.deleteUri).on(started: { orderListIsLoading.value = true }, terminated: { orderListIsLoading.value = false }).materialize()
        }.takeWhen(self.confirmDeleteProperty.signal.skipNil().filter(isTrue))
        
        self.ordersAreLoading = orderListIsLoading.signal
        
        self.loadingOverlaysIsHidden = orderListIsLoading.signal.negate()
        
        self.deletedOrder = deleteOrderEvent.values().map { $0.diagnostic }
        
        self.goToOrderDetail = self.tapOrderDetailProperty.signal.skipNil()
        
        let checkoutURI = ordersRequest.map { $0.checkout }
    }
    
    fileprivate let tapOrderDetailProperty = MutableProperty<OrderData?>(nil)
    public func tappedOrderDetail(_ order: OrderData) {
        self.tapOrderDetailProperty.value = order
    }
    
    fileprivate let deletedOrderProperty = MutableProperty<OrderData?>(nil)
    public func deletedOrderTapped(_ order: OrderData) {
        self.deletedOrderProperty.value = order
    }
    
    fileprivate let confirmDeleteProperty = MutableProperty<Bool?>(nil)
    public func confirmDeleteOrder(_ shouldDelete: Bool) {
        self.confirmDeleteProperty.value = shouldDelete
    }
    
    fileprivate let orderButtonTappedProperty = MutableProperty(())
    public func orderButtonTapped() {
        self.orderButtonTappedProperty.value = ()
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
    public let deleteOrderReminder: Signal<String, NoError>
    public let deletedOrder: Signal<Diagnostic, NoError>
    public let hideEmptyState: Signal<(), NoError>
    public let showEmptyState: Signal<Bool, NoError>
    
    public var inputs: OrderListViewModelInputs { return self }
    public var outputs: OrderListViewModelOutputs { return self }
}
