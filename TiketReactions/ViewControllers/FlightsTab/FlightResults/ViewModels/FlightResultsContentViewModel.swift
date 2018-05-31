//
//  FlightResultsContentViewModel.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 12/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol FlightResultsContentViewModelInputs {
    func configureWith(sort: SearchFlightParams)
    func configureReturnWith(selectedDepart: Flight)
    func tapped(flight: Flight)
    func viewDidAppear()
    func viewDidDisappear(animated: Bool)
    func viewWillAppear()
    func willDisplayRow(_ row: Int, outOf totalRows: Int)
}

public protocol FlightResultsContentViewModelOutputs {
    var hideEmptyState: Signal<(), NoError> { get }
    var selectedFlight: Signal<Flight, NoError> { get }
    var goToFlight: Signal<Flight, NoError> { get }
    var envelope: Signal<SearchFlightEnvelope, NoError> { get }
    var flights: Signal<[Flight], NoError> { get }
    var returnedFlights: Signal<[Flight], NoError> { get }
    var flightsAreLoading: Signal<Bool, NoError> { get }
    var showEmptyState: Signal<Bool, NoError> { get }
}

public protocol FlightResultsContentViewModelTypes {
    var inputs: FlightResultsContentViewModelInputs { get }
    var outputs: FlightResultsContentViewModelOutputs { get }
}

public final class FlightResultsContentViewModel: FlightResultsContentViewModelTypes, FlightResultsContentViewModelInputs, FlightResultsContentViewModelOutputs {
    
    init() {
        
        let paramsChanged = self.sortProperty.signal.skipNil()
        
        let isVisible = Signal.merge(self.viewDidAppearProperty.signal.mapConst(true), self.viewDidDisappearProperty.signal.mapConst(false)).skipRepeats()
        
        let searchFlightParams = .defaults
            |> SearchFlightParams.lens.departDate .~ "2018-03-10"
            |> SearchFlightParams.lens.returnDate .~ "2018-03-11"
            |> SearchFlightParams.lens.adult .~ 1
            |> SearchFlightParams.lens.child .~ 0
            |> SearchFlightParams.lens.infant .~ 0
            |> SearchFlightParams.lens.fromAirport .~ "CGK"
            |> SearchFlightParams.lens.toAirport .~ "DPS"
        
        let requestFlightResults = Signal.combineLatest(self.viewDidAppearProperty.signal, paramsChanged, isVisible).filter { _, _, visible in visible }.skipRepeats {
            lhs, rhs in lhs.0 == rhs.0 && lhs.1 == rhs.1
            }.map(second).switchMap { params in
                AppEnvironment.current.apiService.fetchFlightResults(params: params).demoteErrors()
        }
        
        self.envelope = requestFlightResults
        self.flights = requestFlightResults.map { $0.departResuts  }
        
        self.returnedFlights = .empty
    
        self.flightsAreLoading = Signal.merge(self.viewDidAppearProperty.signal.mapConst(true), self.flights.filter { !$0.isEmpty }.mapConst(false))
        
        self.hideEmptyState = Signal.merge(self.viewWillAppearProperty.signal.take(first: 1), self.flights.filter { $0.isEmpty }.ignoreValues())
        self.showEmptyState = .empty
        
        self.selectedFlight = self.tappedFlightProperty.signal.skipNil()
        
        self.goToFlight = .empty
    }
    
    fileprivate let sortProperty = MutableProperty<SearchFlightParams?>(nil)
    public func configureWith(sort: SearchFlightParams) {
        self.sortProperty.value = sort
    }
    
    fileprivate let departDataProperty = MutableProperty<Flight?>(nil)
    public func configureReturnWith(selectedDepart: Flight) {
        self.departDataProperty.value = selectedDepart
    }
    
    fileprivate let tappedFlightProperty = MutableProperty<Flight?>(nil)
    public func tapped(flight: Flight) {
        self.tappedFlightProperty.value = flight
    }
    
    fileprivate let viewDidAppearProperty = MutableProperty(())
    public func viewDidAppear() {
        self.viewDidAppearProperty.value = ()
    }
    
    fileprivate let viewDidDisappearProperty = MutableProperty(())
    public func viewDidDisappear(animated: Bool) {
        self.viewDidDisappearProperty.value = ()
    }
    
    fileprivate let viewWillAppearProperty = MutableProperty(())
    public func viewWillAppear() {
        self.viewWillAppearProperty.value = ()
    }
    
    fileprivate let willDisplayRowProperty = MutableProperty<(row: Int, total: Int)?>(nil)
    public func willDisplayRow(_ row: Int, outOf totalRows: Int) {
        self.willDisplayRowProperty.value = (row, totalRows)
    }
    
    public let hideEmptyState: Signal<(), NoError>
    public let selectedFlight: Signal<Flight, NoError>
    public let goToFlight: Signal<Flight, NoError>
    public let envelope: Signal<SearchFlightEnvelope, NoError>
    public let flights: Signal<[Flight], NoError>
    public let returnedFlights: Signal<[Flight], NoError>
    public let flightsAreLoading: Signal<Bool, NoError>
    public let showEmptyState: Signal<Bool, NoError>
    
    public var inputs: FlightResultsContentViewModelInputs { return self }
    public var outputs: FlightResultsContentViewModelOutputs { return self }
}


