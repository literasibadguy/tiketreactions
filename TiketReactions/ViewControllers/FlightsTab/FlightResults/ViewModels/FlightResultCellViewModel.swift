//
//  FlightResultCellViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 17/08/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import TiketKitModels

public protocol FlightResultCellViewModelInputs {
    func configureWith(_ flight: Flight)
}

public protocol FlightResultCellViewModelOutputs {
    var flightPriceText: Signal<String, NoError> { get }
    var departureCodeText: Signal<String, NoError> { get }
    var arrivalCodeText: Signal<String, NoError> { get }
    var departureTimeText: Signal<String, NoError> { get }
    var arrivalTimeText: Signal<String, NoError> { get }
    var flightCodeText: Signal<String, NoError> { get }
    var directTimeText: Signal<String, NoError> { get }
}

public protocol FlightResultCellViewModelType {
    var inputs: FlightResultCellViewModelInputs { get }
    var outputs: FlightResultCellViewModelOutputs { get }
}

public final class FlightResultCellViewModel: FlightResultCellViewModelType, FlightResultCellViewModelInputs, FlightResultCellViewModelOutputs {
    
    public init() {
        let flight = self.configFlightProperty.signal.skipNil()
        
        self.flightPriceText = flight.signal.map { "\(symbolForCurrency(AppEnvironment.current.apiService.currency)) \(Format.currency(Double($0.priceValue)!, country: AppEnvironment.current.locale.currencyCode ?? "IDR"))" }
        self.departureCodeText = flight.signal.map { $0.departureCity }
        self.arrivalCodeText = flight.signal.map { $0.arrivalCity }
        self.departureTimeText = flight.signal.map { $0.flightDetail.simpleDepartureTime }
        self.arrivalTimeText = flight.signal.map { $0.flightDetail.simpleArrivalTime }
        self.flightCodeText = flight.signal.map { $0.flightNumber }
        self.directTimeText = flight.signal.map { $0.inner.duration }
    }
    
    fileprivate let configFlightProperty = MutableProperty<Flight?>(nil)
    public func configureWith(_ flight: Flight) {
        self.configFlightProperty.value = flight
    }
    
    public let flightPriceText: Signal<String, NoError>
    public let departureCodeText: Signal<String, NoError>
    public let arrivalCodeText: Signal<String, NoError>
    public let departureTimeText: Signal<String, NoError>
    public let arrivalTimeText: Signal<String, NoError>
    public let flightCodeText: Signal<String, NoError>
    public let directTimeText: Signal<String, NoError>
    
    public var inputs: FlightResultCellViewModelInputs { return self }
    public var outputs: FlightResultCellViewModelOutputs { return self }
}
