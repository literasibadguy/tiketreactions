//
//  PickFlightResultsViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 21/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol PickFlightResultsViewModelInputs {
    func configureSingleWith(params: SearchSingleFlightParams)
    func configureWith(params: SearchFlightParams)
    func configureReturn(params: SearchFlightParams, selected: Flight, returns: [Flight])
    func tappedButtonDismiss()
    func tappedButtonNextStep()
    func tapped(flight: Flight)
    func viewWillAppear(_ animated: Bool)
    func viewDidAppear()
    func viewDidDisappear(animated: Bool)
    func willDisplayRow(_ row: Int, outOf totalRows: Int)
}

public protocol PickFlightResultsViewModelOutputs {
    var dismissFlightResults: Signal<(), NoError> { get }
    var flightsAreLoading: Signal<Bool, NoError> { get }
    
    var destinationTitleText: Signal<String, NoError> { get }
    var dateTitleText: Signal<String, NoError> { get }
    var goRoundButtonTitleText: Signal<String, NoError> { get }
    var goOrderButtonTitleText: Signal<String, NoError> { get }
    
    var flights: Signal<[Flight], NoError> { get }
    var showNextSteps: Signal<Bool, NoError> { get }
    var showReturnFlightsText: Signal<String, NoError> { get }
    var showSingleDirectText: Signal<String, NoError> { get }
    var showReturnDirectText: Signal<String, NoError> { get }
    var goToSingleFlights: Signal<(SearchSingleFlightParams, Flight), NoError> { get }
    var goToReturnFlights: Signal<(SearchFlightParams, Flight, [Flight]), NoError> { get }
    var goToDirectReturnFlights: Signal<(SearchFlightParams, Flight, Flight), NoError> { get }
    var returnFlights: Signal<[Flight], NoError> { get }
    var showEmptyState: Signal<EmptyState, NoError> { get }
    var hideEmptyState: Signal<(), NoError> { get }
}

public protocol PickFlightResultsViewModelType {
    var inputs: PickFlightResultsViewModelInputs { get }
    var outputs: PickFlightResultsViewModelOutputs { get }
}


public final class PickFlightResultsViewModel: PickFlightResultsViewModelType, PickFlightResultsViewModelInputs, PickFlightResultsViewModelOutputs {
    
    public init() {
        let paramsChanged = Signal.combineLatest(self.configParamProperty.signal.skipNil(), self.configReturnProperty.signal.skipNil())
        
        let onlySingle = Signal.combineLatest(self.configSingleParamProperty.signal.skipNil(), self.viewDidAppearProperty.signal).map(first)
        let onlyParams = Signal.combineLatest(self.configParamProperty.signal.skipNil(), self.viewDidAppearProperty.signal).map(first)
        let paramReturns = self.configReturnProperty.signal.skipNil().map(first)
        
        let isVisible = Signal.merge(self.viewDidAppearProperty.signal.mapConst(true), self.viewDidDisappearProperty.signal.mapConst(false)).skipRepeats()
        
        self.dismissFlightResults = self.tappedButtonDismissProperty.signal
        
        self.destinationTitleText = onlyParams.map { envelope in "\(envelope.fromAirport ?? "") - \(envelope.toAirport ?? "")" }
        self.dateTitleText = .empty
        
        let requestFirstPage = Signal.combineLatest(self.viewDidAppearProperty.signal, paramsChanged, isVisible).filter { _, _, visible in visible }.skipRepeats { lhs, rhs in lhs.0 == rhs.0 && lhs.2 == rhs.2 }.map(second)
        
        let requestSingleFlightResults = Signal.combineLatest(self.viewDidAppearProperty.signal, onlySingle, isVisible).filter { _, _, visible in visible }.skipRepeats { lhs, rhs in lhs.0 == rhs.0 && lhs.2 == rhs.2 }
            .map(second).switchMap { singleParams in
                AppEnvironment.current.apiService.fetchSingleFlightResults(params: singleParams).demoteErrors()
        }
        
        let requestFlightResults = Signal.combineLatest(self.viewDidAppearProperty.signal, onlyParams, isVisible).filter { _, _, visible in visible }.skipRepeats {
            lhs, rhs in lhs.0 == rhs.0 && lhs.1 == rhs.1
            }.map(second).switchMap { params in
                AppEnvironment.current.apiService.fetchFlightResults(params: params).demoteErrors()
        }
        
        self.goOrderButtonTitleText = .empty
        self.goRoundButtonTitleText = .empty
        
        self.flights = .empty
        
        let flightSelected = self.tappedFlightProperty.signal.skipNil()
        let singleFlight = Signal.combineLatest(onlySingle, flightSelected)
            
        self.showNextSteps = flightSelected.mapConst(false)
        
        self.showSingleDirectText = singleFlight.mapConst("Order Sekarang")
        
        self.goToSingleFlights = singleFlight.takeWhen(self.tappedButtonNextStepProperty.signal)
        
        let returnedFlights = Signal.combineLatest(onlyParams, flightSelected, requestFlightResults.filter { $0.returnResults?.flights != nil }.map { ($0.returnResults?.flights)! })
        
        self.showReturnFlightsText = singleFlight.mapConst("Pilih Tiket Pulang")
        self.goToReturnFlights = returnedFlights.takeWhen(self.tappedButtonNextStepProperty.signal)
        
        let initialReturns = self.goToReturnFlights.map(second)
        
        self.returnFlights = self.configReturnProperty.signal.skipNil().map(third).takeWhen(self.viewDidAppearProperty.signal)
        
        self.flightsAreLoading = Signal.merge(self.viewDidAppearProperty.signal.mapConst(true), self.flights.filter { !$0.isEmpty }.mapConst(false), self.returnFlights.filter { !$0.isEmpty }.mapConst(false))
        
        let depart = self.configReturnProperty.signal.skipNil().map(second)
        let directReturnedFlight = Signal.combineLatest(depart, self.tappedFlightProperty.signal.skipNil())
        
        let variousButtonText = Signal.merge(singleFlight.mapConst(""), singleFlight.mapConst(""), directReturnedFlight.mapConst(""))
        
        self.showReturnDirectText = variousButtonText
        
        self.goToDirectReturnFlights = Signal.combineLatest(paramReturns, depart, self.tappedFlightProperty.signal.skipNil()).takeWhen(self.tappedButtonNextStepProperty.signal)
        
        self.showEmptyState = .empty
        
        self.hideEmptyState = Signal.merge(self.viewWillAppearProperty.signal.take(first: 1).ignoreValues(), requestFlightResults.map { !$0.departResuts.isEmpty && !($0.returnResults?.flights.isEmpty)! })
        
        
    }
    
    fileprivate let configSingleParamProperty = MutableProperty<SearchSingleFlightParams?>(nil)
    public func configureSingleWith(params: SearchSingleFlightParams) {
        self.configSingleParamProperty.value = params
    }
    
    fileprivate let configParamProperty = MutableProperty<SearchFlightParams?>(nil)
    public func configureWith(params: SearchFlightParams) {
        self.configParamProperty.value = params
    }
    
    fileprivate let configReturnProperty = MutableProperty<(SearchFlightParams, Flight, [Flight])?>(nil)
    public func configureReturn(params: SearchFlightParams, selected: Flight, returns: [Flight]) {
        self.configReturnProperty.value = (params, selected, returns)
    }
    
    fileprivate let tappedButtonDismissProperty = MutableProperty(())
    public func tappedButtonDismiss() {
        self.tappedButtonDismissProperty.value = ()
    }
    
    fileprivate let tappedButtonNextStepProperty = MutableProperty(())
    public func tappedButtonNextStep() {
        self.tappedButtonNextStepProperty.value = ()
    }
    
    fileprivate let tappedFlightProperty = MutableProperty<Flight?>(nil)
    public func tapped(flight: Flight) {
        self.tappedFlightProperty.value = flight
    }
    
    fileprivate let viewWillAppearProperty = MutableProperty(false)
    public func viewWillAppear(_ animated: Bool) {
        self.viewWillAppearProperty.value = animated
    }
    
    fileprivate let viewDidAppearProperty = MutableProperty(())
    public func viewDidAppear() {
        self.viewDidAppearProperty.value = ()
    }
    
    fileprivate let viewDidDisappearProperty = MutableProperty(false)
    public func viewDidDisappear(animated: Bool) {
        self.viewDidDisappearProperty.value = animated
    }
    
    fileprivate let willDisplayRowProperty = MutableProperty<(row: Int, total: Int)?>(nil)
    public func willDisplayRow(_ row: Int, outOf totalRows: Int) {
        self.willDisplayRowProperty.value = (row, totalRows)
    }
    
    public let dismissFlightResults: Signal<(), NoError>
    public let flightsAreLoading: Signal<Bool, NoError>
    public let destinationTitleText: Signal<String, NoError>
    public let dateTitleText: Signal<String, NoError>
    public let goRoundButtonTitleText: Signal<String, NoError>
    public let goOrderButtonTitleText: Signal<String, NoError>
    public let flights: Signal<[Flight], NoError>
    public let showNextSteps: Signal<Bool, NoError>
    public let showReturnFlightsText: Signal<String, NoError>
    public let showSingleDirectText: Signal<String, NoError>
    public let showReturnDirectText: Signal<String, NoError>
    public let goToSingleFlights: Signal<(SearchSingleFlightParams, Flight), NoError>
    public let goToReturnFlights: Signal<(SearchFlightParams, Flight, [Flight]), NoError>
    public let goToDirectReturnFlights: Signal<(SearchFlightParams, Flight, Flight), NoError>
    public let returnFlights: Signal<[Flight], NoError>
    public let showEmptyState: Signal<EmptyState, NoError>
    public let hideEmptyState: Signal<(), NoError>
    
    public var inputs: PickFlightResultsViewModelInputs { return self }
    public var outputs: PickFlightResultsViewModelOutputs { return self }
}
