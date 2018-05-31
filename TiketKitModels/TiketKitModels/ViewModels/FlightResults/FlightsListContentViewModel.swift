//
//  FlightsListContentViewModel.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 18/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import Result

public protocol FlightsListContentViewModelInputs {
    func configureWith(params: SearchFlightParams)
    func configureReturn(params: SearchFlightParams)
    func flight(round: Bool)
    func tapped(flight: Flight)
    func viewWillAppear(_ animated: Bool)
    func willDisplayRow(_ row: Int, outOf totalRows: Int)
}

public protocol FlightsListContentViewModelOutputs {
    var isOrderRounds: Signal<Bool, NoError> { get }
    var flights: Signal<[Flight], NoError> { get }
    var returnFlights: Signal<[Flight], NoError> { get }
    var pickReturnFlights: Signal<Flight, NoError> { get }
    var goToFlight: Signal<Flight, NoError> { get }
    var flightsAreLoading: Signal<Bool, NoError> { get }
}

public protocol FlightsListContentViewModelType {
    var inputs: FlightsListContentViewModelInputs { get }
    var outputs: FlightsListContentViewModelOutputs { get }
}

public final class FlightsListContentViewModel: FlightsListContentViewModelType, FlightsListContentViewModelInputs, FlightsListContentViewModelOutputs {
    
    public init() {
        let currentParam = Signal.combineLatest(self.configParamsProperty.signal.skipNil(), self.viewWillAppearProperty.signal).map(first)
        
        
        let returnDate = currentParam.map { $0.returnDate }
        let roundFlight = returnDate.skipNil().filterMap { !$0.isEmpty }
        
        let returnFlights = Signal.combineLatest(currentParam, roundFlight).switchMap { params, _ in
            AppEnvironment.current.apiService.fetchFlighResults(params: params).demoteErrors()
        }
        self.isOrderRounds = .empty
        
        let returns = returnFlights.filter { $0.flightResults.departureResults?.flights != nil }
        
        self.flights = returns.map { flightEnvelope in
            (flightEnvelope.flightResults.departureResults?.flights)!
        }
        
        self.returnFlights = .empty
        self.pickReturnFlights = .empty
        self.goToFlight = .empty
        self.flightsAreLoading = .empty
    }
    
    fileprivate let configParamsProperty = MutableProperty<SearchFlightParams?>(nil)
    public func configureWith(params: SearchFlightParams) {
        self.configParamsProperty.value = params
    }
    
    fileprivate let flightRoundProperty = MutableProperty(false)
    public func flight(round: Bool) {
        self.flightRoundProperty.value = round
    }
    
    fileprivate let tappedFlightProperty = MutableProperty<Flight?>(nil)
    public func tapped(flight: Flight) {
        self.tappedFlightProperty.value = flight
    }
    
    public func configureReturn(params: SearchFlightParams) {
        
    }
    
    
    fileprivate let viewWillAppearProperty = MutableProperty(false)
    public func viewWillAppear(_ animated: Bool) {
        self.viewWillAppearProperty.value = animated
    }
    
    fileprivate let willDisplayRowProperty = MutableProperty<(row: Int, total: Int)?>(nil)
    public func willDisplayRow(_ row: Int, outOf totalRows: Int) {
        self.willDisplayRowProperty.value = (row, totalRows)
    }
    
    public let isOrderRounds: Signal<Bool, NoError>
    public let flights: Signal<[Flight], NoError>
    public let returnFlights: Signal<[Flight], NoError>
    public let pickReturnFlights: Signal<Flight, NoError>
    public let goToFlight: Signal<Flight, NoError>
    public let flightsAreLoading: Signal<Bool, NoError>
    
    public var inputs: FlightsListContentViewModelInputs { return self }
    public var outputs: FlightsListContentViewModelOutputs { return self }
}

