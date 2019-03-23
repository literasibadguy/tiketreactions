//
//  FlightDirectsCellViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 20/08/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import TiketKitModels

public protocol FlightDirectsCellViewModelInputs {
    func configureWith(_ flight: Flight)
}

public protocol FlightDirectsCellViewModelOutputs {
    var dateDirectFlightText: Signal<String, NoError> { get }
    var flightRouteNameText: Signal<String, NoError> { get }
    var logoFlightImage: Signal<String, NoError> { get }
    var flightNameText: Signal<String, NoError> { get }
    var flightTimeText: Signal<String, NoError> { get }
    var flightStatusText: Signal<String, NoError> { get }
    var flightDurationText: Signal<String, NoError> { get }
}

public protocol FlightDirectsCellViewModelType {
    var inputs: FlightDirectsCellViewModelInputs { get }
    var outputs: FlightDirectsCellViewModelOutputs { get }
}


public final class FlightDirectsCellViewModel: FlightDirectsCellViewModelType, FlightDirectsCellViewModelInputs, FlightDirectsCellViewModelOutputs {
    
    public init() {
        let currentFlight = self.configFlightProperty.signal.skipNil()
        
        self.dateDirectFlightText = currentFlight.signal.map { $0.inner.departureFlightDateStrShort }
        self.flightRouteNameText = currentFlight.signal.map { "\($0.departureCity) - \($0.arrivalCity), \($0.airlinesName)" }
        self.logoFlightImage = .empty
        self.flightNameText = currentFlight.map { $0.flightNumber }
        self.flightTimeText = currentFlight.map { "\($0.flightDetail.simpleDepartureTime) - \($0.flightDetail.simpleArrivalTime)" }
        self.flightStatusText = currentFlight.map { $0.stopTimes }
        
        
        
        self.flightDurationText = currentFlight.map { $0.inner.duration }
    }
    
    fileprivate let configFlightProperty = MutableProperty<Flight?>(nil)
    public func configureWith(_ flight: Flight) {
        self.configFlightProperty.value = flight
    }
    
    public let dateDirectFlightText: Signal<String, NoError>
    public let flightRouteNameText: Signal<String, NoError>
    public let logoFlightImage: Signal<String, NoError>
    public let flightNameText: Signal<String, NoError>
    public let flightTimeText: Signal<String, NoError>
    public let flightStatusText: Signal<String, NoError>
    public let flightDurationText: Signal<String, NoError>
    
    public var inputs: FlightDirectsCellViewModelInputs { return self }
    public var outputs: FlightDirectsCellViewModelOutputs { return self }
}
