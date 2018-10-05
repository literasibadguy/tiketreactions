//
//  FlightOrderListViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 03/10/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol FlightOrderListViewModelInputs {
    
    func refreshAfterDeleted()
    
    func viewWillAppear(_ animated: Bool)
    
    func willDisplayRow(_ row: Int, outOf totalRows: Int)
}


public protocol FlightOrderListViewModelOutputs {
    var flightOrders: Signal<[FlightOrderData], NoError> { get }
}

public protocol FlightOrderListViewModelType {
    var inputs: FlightOrderListViewModelInputs { get }
    var outputs: FlightOrderListViewModelOutputs { get }
}

public final class FlightOrderListViewModel: FlightOrderListViewModelType, FlightOrderListViewModelInputs, FlightOrderListViewModelOutputs {
    
    public init() {
        
        let flightOrdersEnvelope = self.viewWillAppearProperty.signal.switchMap { _ in
            AppEnvironment.current.apiService.fetchFlightOrder().materialize()
        }
        
        self.flightOrders = flightOrdersEnvelope.values().map { $0.myOrder.orderData }
        
    }
    
    private let refreshDeletedProperty = MutableProperty(())
    public func refreshAfterDeleted() {
        self.refreshDeletedProperty.value = ()
    }
    
    private let viewWillAppearProperty = MutableProperty(false)
    public func viewWillAppear(_ animated: Bool) {
        self.viewWillAppearProperty.value = animated
    }
    
    private let willDisplayRowProperty = MutableProperty<(row: Int, total: Int)?>(nil)
    public func willDisplayRow(_ row: Int, outOf totalRows: Int) {
        self.willDisplayRowProperty.value = (row, totalRows)
    }
    
    public let flightOrders: Signal<[FlightOrderData], NoError>
    
    public var inputs: FlightOrderListViewModelInputs { return self }
    public var outputs: FlightOrderListViewModelOutputs { return self }
}
