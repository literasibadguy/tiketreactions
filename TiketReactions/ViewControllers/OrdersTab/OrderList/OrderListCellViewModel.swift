//
//  OrderListCellViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 08/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import TiketKitModels

public protocol OrderListCellViewModelInputs {
    func configureWith(_ order: OrderData)
    func deleteOrderButtonTapped()
}

public protocol OrderListCellViewModelOutputs {
    
    var orderTypeText: Signal<String, NoError> { get }
    var orderNameText: Signal<String, NoError> { get }
    var orderNameDetailText: Signal<String, NoError> { get }
    var startDateText: Signal<String, NoError> { get }
    
    var notifyToDeleteOrder: Signal<OrderData, NoError> { get }
}

public protocol OrderListCellViewModelType {
    var inputs: OrderListCellViewModelInputs { get }
    var outputs: OrderListCellViewModelOutputs { get }
}

public final class OrderListCellViewModel: OrderListCellViewModelType, OrderListCellViewModelInputs, OrderListCellViewModelOutputs {
    
    public init() {
        let order = self.configOrderProperty.signal.skipNil()
        
        self.orderTypeText = order.signal.map { $0.orderType }
        self.orderNameText = order.signal.map { $0.orderName  }
        self.orderNameDetailText = order.signal.map { $0.orderNameDetail }
        self.startDateText = order.signal.map { "\($0.detail.startdate)-\($0.detail.enddate), \($0.detail.nights) Malam" }
        
        self.notifyToDeleteOrder = order.sample(on: self.deleteOrderTappedProperty.signal)
    }
    
    fileprivate let configOrderProperty = MutableProperty<OrderData?>(nil)
    public func configureWith(_ order: OrderData) {
        self.configOrderProperty.value = order
    }
    
    fileprivate let deleteOrderTappedProperty = MutableProperty(())
    public func deleteOrderButtonTapped() {
        self.deleteOrderTappedProperty.value = ()
    }
    
    public let orderTypeText: Signal<String, NoError>
    public let orderNameText: Signal<String, NoError>
    public let orderNameDetailText: Signal<String, NoError>
    public let startDateText: Signal<String, NoError>
    public let notifyToDeleteOrder: Signal<OrderData, NoError>
    
    public var inputs: OrderListCellViewModelInputs { return self }
    public var outputs: OrderListCellViewModelOutputs { return self }
}
