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
    func deleteOrderTapped(_ order: FlightOrderData)
    func confirmDeleteOrder(_ shouldDelete: Bool)
    func refreshAfterDeleted()
    func paymentButtonTapped()
    func willDisplayRow(_ row: Int, outOf totalRows: Int)
    func viewDidLoad()
    func viewWillAppear(_ animated: Bool)
}


public protocol FlightOrderListViewModelOutputs {
    var flightsAreLoading: Signal<Bool, NoError> { get }
    var loadingOverlaysIsHidden: Signal<Bool, NoError> { get }
    var flightOrders: Signal<[FlightOrderData], NoError> { get }
    var hideEmptyState: Signal<(), NoError> { get }
    var showEmptyState: Signal<Bool, NoError> { get }
    var deleteOrderReminder: Signal<String, NoError> { get }
    var deletedOrder: Signal<Diagnostic, NoError> { get }
    var goToPayments: Signal<FlightMyOrder, NoError> { get }
}

public protocol FlightOrderListViewModelType {
    var inputs: FlightOrderListViewModelInputs { get }
    var outputs: FlightOrderListViewModelOutputs { get }
}

public final class FlightOrderListViewModel: FlightOrderListViewModelType, FlightOrderListViewModelInputs, FlightOrderListViewModelOutputs {
    
    public init() {
        
        let ordersAreLoading = MutableProperty(false)
        let flightOrdersEnvelope = Signal.merge(self.viewWillAppearProperty.signal.ignoreValues(), self.refreshDeletedProperty.signal).switchMap { _ in
            AppEnvironment.current.apiService.fetchFlightOrder().ck_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler).on(started: { ordersAreLoading.value = true }, terminated: { ordersAreLoading.value = false }).materialize()
        }
        
        self.flightOrders = flightOrdersEnvelope.values().map { $0.myOrder?.orderData }.skipNil()
        
        self.deleteOrderReminder = self.deleteOrderTappedProperty.signal.ignoreValues().map { "Apakah Yakin Membatalkan Order Ini?" }
        
        let deleteOrderEnvelope = self.deleteOrderTappedProperty.signal.skipNil().takeWhen(self.confirmedDeleteProperty.signal.filter(isTrue)).switchMap { flightOrder in
            AppEnvironment.current.apiService.deleteFlightOrder(url: flightOrder.deleteUri).ck_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler).on(started: { ordersAreLoading.value = true },  interrupted: { ordersAreLoading.value = false }).materialize()
        }
        
        self.hideEmptyState = Signal.merge(self.viewDidLoadProperty.signal.ignoreValues(), ordersAreLoading.signal.filter { $0 == true }.ignoreValues(), self.flightOrders.combinePrevious([]).filter { previousOrders, currentOrders in previousOrders.isEmpty && !currentOrders.isEmpty }.ignoreValues())
        
        self.showEmptyState =  Signal.merge(flightOrdersEnvelope.values().filter { isTrue($0.myOrder.isNil) }.mapConst(false), self.flightOrders.filter { $0.isEmpty }.mapConst(false), flightOrdersEnvelope.errors().mapConst(false))
        
        self.loadingOverlaysIsHidden = ordersAreLoading.signal.negate()
        
        self.flightsAreLoading = ordersAreLoading.signal
        
        self.deletedOrder = deleteOrderEnvelope.values().map { $0.diagnostic }
        
        self.goToPayments = flightOrdersEnvelope.values().map { $0.myOrder }.skipNil().takeWhen(self.paymentTappedProperty.signal)
    }
    
    fileprivate let deleteOrderTappedProperty = MutableProperty<FlightOrderData?>(nil)
    public func deleteOrderTapped(_ order: FlightOrderData) {
        self.deleteOrderTappedProperty.value = order
    }
    
    fileprivate let confirmedDeleteProperty = MutableProperty(false)
    public func confirmDeleteOrder(_ shouldDelete: Bool) {
        self.confirmedDeleteProperty.value = shouldDelete
    }
    
    fileprivate let refreshDeletedProperty = MutableProperty(())
    public func refreshAfterDeleted() {
        self.refreshDeletedProperty.value = ()
    }
    
    fileprivate let paymentTappedProperty = MutableProperty(())
    public func paymentButtonTapped() {
        self.paymentTappedProperty.value = ()
    }
    
    private let viewWillAppearProperty = MutableProperty(false)
    public func viewWillAppear(_ animated: Bool) {
        self.viewWillAppearProperty.value = animated
    }
    
    private let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    private let willDisplayRowProperty = MutableProperty<(row: Int, total: Int)?>(nil)
    public func willDisplayRow(_ row: Int, outOf totalRows: Int) {
        self.willDisplayRowProperty.value = (row, totalRows)
    }
    
    public let flightsAreLoading: Signal<Bool, NoError>
    public let loadingOverlaysIsHidden: Signal<Bool, NoError>
    public let flightOrders: Signal<[FlightOrderData], NoError>
    public let hideEmptyState: Signal<(), NoError>
    public let showEmptyState: Signal<Bool, NoError>
    public let deleteOrderReminder: Signal<String, NoError>
    public let deletedOrder: Signal<Diagnostic, NoError>
    public let goToPayments: Signal<FlightMyOrder, NoError>
    
    public var inputs: FlightOrderListViewModelInputs { return self }
    public var outputs: FlightOrderListViewModelOutputs { return self }
}
