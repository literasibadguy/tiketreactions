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
    func viewDidLoad()
    func viewWillAppear(animated: Bool)
}

public protocol OrderListViewModelOutputs {
    var orders: Signal<[OrderData], NoError> { get }
    var hideEmptyState: Signal<(), NoError> { get }
    var showEmptyState: Signal<Bool, NoError> { get }
}

public protocol OrderListViewModelType {
    var inputs: OrderListViewModelInputs { get }
    var outputs: OrderListViewModelOutputs { get }
}

public final class OrderListViewModel: OrderListViewModelType, OrderListViewModelInputs, OrderListViewModelOutputs {
    
    
    public init() {
        
        let ordersRequest = Signal.merge(self.viewWillAppearProperty.signal.ignoreValues(), self.viewDidLoadProperty.signal).switchMap {
            AppEnvironment.current.apiService.fetchHotelOrder().demoteErrors()
            }.map { result in
                return result.myOrder.orderData
        }
        
        self.orders = ordersRequest
        let emptyStateConfigured = self.orders.signal.filter(isNil).mapConst(false)
        
        self.showEmptyState = ordersRequest.takeWhen(self.viewWillAppearProperty.signal.skipNil()).filter(isNil).mapConst(true)
        
        self.hideEmptyState = Signal.merge(self.viewDidLoadProperty.signal.ignoreValues(), self.orders.filter { orders in
            !orders.isEmpty
        }.ignoreValues())
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    fileprivate let viewWillAppearProperty = MutableProperty<Bool?>(nil)
    public func viewWillAppear(animated: Bool) {
        self.viewWillAppearProperty.value = animated
    }
    
    public let orders: Signal<[OrderData], NoError>
    public let hideEmptyState: Signal<(), NoError>
    public let showEmptyState: Signal<Bool, NoError>
    
    public var inputs: OrderListViewModelInputs { return self }
    public var outputs: OrderListViewModelOutputs { return self }
}
