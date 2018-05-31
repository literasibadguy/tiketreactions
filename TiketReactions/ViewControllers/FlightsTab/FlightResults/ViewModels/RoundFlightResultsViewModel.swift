//
//  RoundFlightResultsViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 05/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol RoundFlightResultsViewModelInputs {
    func configureWith(params: SearchFlightParams)
    func configureReturned(flights: [Flight])
    func flightContentSelected(flight: Flight)
    func nextButtonTapped()
    func viewDidLoad()
    func viewWillAppear(animated: Bool)
}

public protocol RoundFlightResultsViewModelOutputs {
    var flightData: Signal<SearchFlightEnvelope, NoError> { get }
    var flightParamsData: Signal<SearchFlightParams, NoError> { get }
    var goToRoundResults: Signal<(Flight, [Flight]), NoError> { get }
    var goToFlightDirect: Signal<Flight, NoError> { get }
    var goToRoundFlightDirect: Signal<(Flight, Flight), NoError> { get }
    var showNextButton: Signal<Bool, NoError> { get }
}

public protocol RoundFlightResultsViewModelType {
    var inputs: RoundFlightResultsViewModelInputs { get }
    var outputs: RoundFlightResultsViewModelOutputs { get }
}

public final class RoundFlightResultsViewModel: RoundFlightResultsViewModelType, RoundFlightResultsViewModelInputs, RoundFlightResultsViewModelOutputs {
    
    public init() {
        
        let currentParam = Signal.combineLatest(self.configDataProperty.signal.skipNil(), self.viewWillAppearProperty.signal).map(first)
        
        let searchFlightParams = .defaults
            |> SearchFlightParams.lens.fromAirport .~ "CGK"
            |> SearchFlightParams.lens.toAirport .~ "DPS"
            |> SearchFlightParams.lens.adult .~ 1
            |> SearchFlightParams.lens.child .~ 0
            |> SearchFlightParams.lens.infant .~ 0
        
        let departs = searchFlightParams |> SearchFlightParams.lens.departDate .~ "2018-03-11"
        let rounds = departs |> SearchFlightParams.lens.returnDate .~ "2018-03-12"
        
        let envelopeCurrent = currentParam.takeWhen(self.viewDidLoadProperty.signal).switchMap { param in
            AppEnvironment.current.apiService.fetchFlightResults(params: param).demoteErrors()
        }
        self.flightData = envelopeCurrent
        
        let searchFlightParameter = .defaults
            |> SearchFlightParams.lens.departDate .~ "2018-03-21"
            |> SearchFlightParams.lens.returnDate .~ "2018-03-22"
            |> SearchFlightParams.lens.adult .~ 1
            |> SearchFlightParams.lens.child .~ 0
            |> SearchFlightParams.lens.infant .~ 0
            |> SearchFlightParams.lens.fromAirport .~ "CGK"
            |> SearchFlightParams.lens.toAirport .~ "DPS"
        
        self.flightParamsData = self.viewDidLoadProperty.signal.mapConst(searchFlightParameter)
        
        let firstFlight = self.flightSelectedProperty.signal.skipNil()
        let flightSelected = firstFlight.mapConst(false)
        
//        let findingReturn = Signal.combineLatest(firstFlight, envelopeCurrent.signal.filter { !$0.returnsResults.isNil })
        let availableReturn = Signal.combineLatest(firstFlight, self.configReturnedProperty.signal.skipNil())
        self.goToRoundResults = availableReturn.takeWhen(self.nextButtonTappedProperty.signal)
        
        self.showNextButton = flightSelected
        
        self.goToFlightDirect = firstFlight.takeWhen(self.nextButtonTappedProperty.signal)
        self.goToRoundFlightDirect = .empty
    }
    
    fileprivate let configDataProperty = MutableProperty<SearchFlightParams?>(nil)
    public func configureWith(params: SearchFlightParams) {
        self.configDataProperty.value = params
    }
    
    fileprivate let configReturnedProperty = MutableProperty<[Flight]?>(nil)
    public func configureReturned(flights: [Flight]) {
        self.configReturnedProperty.value = flights
    }
    
    fileprivate let flightSelectedProperty = MutableProperty<Flight?>(nil)
    public func flightContentSelected(flight: Flight) {
        self.flightSelectedProperty.value = flight
    }
    
    fileprivate let nextButtonTappedProperty = MutableProperty(())
    public func nextButtonTapped() {
        self.nextButtonTappedProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    fileprivate let viewWillAppearProperty = MutableProperty(false)
    public func viewWillAppear(animated: Bool) {
        self.viewWillAppearProperty.value = animated
    }
    
    fileprivate let willTransitionToPageProperty = MutableProperty<Int>(0)
    public func willTransition(toPage nextPage: Int) {
        self.willTransitionToPageProperty.value = nextPage
    }
    
    public let flightData: Signal<SearchFlightEnvelope, NoError>
    public let flightParamsData: Signal<SearchFlightParams, NoError>
    public let goToRoundResults: Signal<(Flight, [Flight]), NoError>
    public let goToFlightDirect: Signal<Flight, NoError>
    public let goToRoundFlightDirect: Signal<(Flight, Flight), NoError>
    public let showNextButton: Signal<Bool, NoError>
    
    public var inputs: RoundFlightResultsViewModelInputs { return self }
    public var outputs: RoundFlightResultsViewModelOutputs { return self }
}
