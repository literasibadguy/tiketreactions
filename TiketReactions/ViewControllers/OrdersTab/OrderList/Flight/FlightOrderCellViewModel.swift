//
//  FlightOrderCellViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 03/10/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import TiketKitModels

public protocol FlightOrderCellViewModelInputs {
    func configureFlightWith(_ order: FlightOrderData)
    func deleteOrderButtonTapped()
}

public protocol FlightOrderCellViewModelOutputs {
    
    var orderTypeText: Signal<String, NoError> { get }
    var orderNameText: Signal<String, NoError> { get }
    var orderNameDetailText: Signal<String, NoError> { get }
    var startDateText: Signal<String, NoError> { get }
    
    var notifyToDeleteOrder: Signal<FlightOrderData, NoError> { get }
}

public protocol FlightOrderCellViewModelType {
    var inputs: FlightOrderCellViewModelInputs { get }
    var outputs: FlightOrderCellViewModelOutputs { get }
}

public final class FlightOrderCellViewModel: FlightOrderCellViewModelType, FlightOrderCellViewModelInputs, FlightOrderCellViewModelOutputs {
    
    public init() {
        let order = self.configFlightOrderProperty.signal.skipNil()
        
        self.orderTypeText = order.signal.map { "\($0.orderType)" }
        self.orderNameText = order.signal.map { $0.orderName  }
        self.orderNameDetailText = order.signal.map { $0.orderNameDetail }
        self.startDateText = .empty
        
        self.notifyToDeleteOrder = order.takeWhen(self.deleteOrderTappedProperty.signal)
    }
    
    fileprivate let configFlightOrderProperty = MutableProperty<FlightOrderData?>(nil)
    public func configureFlightWith(_ order: FlightOrderData) {
        self.configFlightOrderProperty.value = order
    }
    
    fileprivate let deleteOrderTappedProperty = MutableProperty(())
    public func deleteOrderButtonTapped() {
        self.deleteOrderTappedProperty.value = ()
    }
    
    public let orderTypeText: Signal<String, NoError>
    public let orderNameText: Signal<String, NoError>
    public let orderNameDetailText: Signal<String, NoError>
    public let startDateText: Signal<String, NoError>
    public let notifyToDeleteOrder: Signal<FlightOrderData, NoError>
    
    public var inputs: FlightOrderCellViewModelInputs { return self }
    public var outputs: FlightOrderCellViewModelOutputs { return self }
}
