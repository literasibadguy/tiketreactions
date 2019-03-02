//
//  FlightSummariesViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 05/09/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels 

public protocol FlightSummariesViewModelInputs {
    func configureSingleWith(_ first: Flight)
    func configureWith(first: Flight, returned: Flight)
    func nextStepsButtonTapped()
    func viewDidLoad()
}

public protocol FlightSummariesViewModelOutputs {
    var loadSingleFlightSource: Signal<Flight, NoError> { get }
    var loadFlightSources: Signal<(Flight, Flight), NoError> { get }
    var loadPriceValueTotal: Signal<String, NoError> { get }
    var getFlightDataLoading: Signal<Bool, NoError> { get }
    var goToPassengerList: Signal<GetFlightDataEnvelope, NoError> { get }
}

public protocol FlightSummariesViewModelType {
    var inputs: FlightSummariesViewModelInputs { get }
    var outputs: FlightSummariesViewModelOutputs { get }
}

public final class FlightSummariesViewModel: FlightSummariesViewModelType, FlightSummariesViewModelInputs, FlightSummariesViewModelOutputs {
    
    public init() {
        
        let singleCurrent = Signal.combineLatest(self.viewDidLoadProperty.signal, self.configSingleFlightProperty.signal.skipNil()).map(second)
        
        let current = Signal.combineLatest(self.viewDidLoadProperty.signal, self.configFlightSummariesProperty.signal.skipNil()).map(second)
        
        self.loadSingleFlightSource = singleCurrent.signal
        self.loadFlightSources = current.signal
        self.loadPriceValueTotal = Signal.merge(singleCurrent.map(giveSingleTotal(_ :)) ,current.map(giveFlightTotal(_ :returned:)))
        
        // Get Flight Data Params
        let singleFlightDataParam = singleCurrent.signal.switchMap { first -> SignalProducer<GetFlightDataParams, NoError> in
            let goodTime = first.inner.departureFlightDate.index(of: " ")!
            
            let param = .defaults
                |> GetFlightDataParams.lens.date .~ String(first.inner.departureFlightDate[...goodTime])
                |> GetFlightDataParams.lens.flightId .~ first.flightId
            
            return SignalProducer(value: param)
        }
        
        let flightDataParam = current.signal.switchMap { first, returned -> SignalProducer<GetFlightDataParams, NoError> in
            let goodTime = first.inner.departureFlightDate.index(of: " ")!
            let badTime = returned.inner.departureFlightDate.index(of: " ")!
            
            let param = .defaults
                |> GetFlightDataParams.lens.date .~ String(first.inner.departureFlightDate[...goodTime])
                |> GetFlightDataParams.lens.flightId .~ first.flightId
                |> GetFlightDataParams.lens.returnDate .~ String(returned.inner.departureFlightDate[...badTime])
                |> GetFlightDataParams.lens.returnFlightId .~ returned.flightId
            
            return SignalProducer(value: param)
        }
        
        
        // Get Flight Data Envelope Request
        let dataIsLoading = MutableProperty(false)
        let getFlightDataEnvelope = Signal.merge(singleFlightDataParam, flightDataParam).sample(on: self.nextStepsTappedProperty.signal).signal.switchMap { dataParam in
            AppEnvironment.current.apiService.getFlightData(params: dataParam).on(started: { dataIsLoading.value = true }, terminated: { dataIsLoading.value = false }).materialize()
        }
        
        getFlightDataEnvelope.values().observe(on: UIScheduler()).observeValues { envelope in
            print("Give me behind this: \(envelope)")
        }
        
        self.getFlightDataLoading = dataIsLoading.signal
        self.goToPassengerList = getFlightDataEnvelope.values()
    }
    
    fileprivate let configSingleFlightProperty = MutableProperty<Flight?>(nil)
    public func configureSingleWith(_ first: Flight) {
        self.configSingleFlightProperty.value = first
    }
    
    fileprivate let configFlightSummariesProperty = MutableProperty<(Flight, Flight)?>(nil)
    public func configureWith(first: Flight, returned: Flight) {
        self.configFlightSummariesProperty.value = (first, returned)
    }
    
    fileprivate let nextStepsTappedProperty = MutableProperty(())
    public func nextStepsButtonTapped() {
        self.nextStepsTappedProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let loadSingleFlightSource: Signal<Flight, NoError>
    public let loadFlightSources: Signal<(Flight, Flight), NoError>
    public let loadPriceValueTotal: Signal<String, NoError>
    public let getFlightDataLoading: Signal<Bool, NoError>
    public let goToPassengerList: Signal<GetFlightDataEnvelope, NoError>
    
    public var inputs: FlightSummariesViewModelInputs { return self }
    public var outputs: FlightSummariesViewModelOutputs { return self }
}

private func giveSingleTotal(_ depart: Flight) -> String {
    let total = Double(depart.priceValue)!
    return "\(symbolForCurrency(AppEnvironment.current.locale.currencyCode ?? "")) \(Format.currency(total, country: "Rp"))"
}

private func giveFlightTotal(_ depart: Flight, returned: Flight) -> String {
    let total = Double(depart.priceValue)! + Double(depart.priceValue)!
    return "\(symbolForCurrency(AppEnvironment.current.locale.currencyCode ?? "")) \(Format.currency(total, country: "Rp"))"
}

