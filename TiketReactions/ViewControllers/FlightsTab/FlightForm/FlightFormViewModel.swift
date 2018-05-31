//
//  FlightFormViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 22/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol FlightFormViewModelInputs {
    func originButtonTapped()
    func desinationButtonTapped()
    func passengersButtonTapped()
    func crossPathButtonTapped()
    func pickDateButtonTapped()
    func selectedOrigin(airport: AirportResult)
    func selectedDestination(airport: AirportResult)
    func selectedPassengers(adult: Int, child: Int, infant: Int)
    func viewDidLoad()
    
}

public protocol FlightFormViewModelOutputs {
    var goToOrigin: Signal<AirportResult, NoError> { get }
    var originChanged: Signal<AirportResult, NoError> { get }
    var originAirportText: Signal<String, NoError> { get }
    
    var goToDestination: Signal<AirportResult, NoError> { get }
    var destinationChanged: Signal<String, NoError> { get }
    var destinationAirportText: Signal<String, NoError> { get }
    
    var crossedDestination: Signal<(origin: AirportResult, destination: AirportResult), NoError> { get }
    
    var goToPassengers: Signal<(Int, Int, Int), NoError> { get }
    var passengersChanged: Signal<(Int, Int, Int), NoError> { get }
    
    var goToPickDate: Signal<SearchFlightParams, NoError> { get }
    var pickEmptyDate: Signal<(), NoError> { get }
}

public protocol FlightFormViewModelType {
    var inputs: FlightFormViewModelInputs { get }
    var outputs: FlightFormViewModelOutputs { get }
}

public final class FlightFormViewModel: FlightFormViewModelType, FlightFormViewModelInputs, FlightFormViewModelOutputs {
    
    init() {
        
        let initialAirport = self.viewDidLoadProperty.signal.mapConst(AirportResult.defaults)
        
        let origin = Signal.merge(self.selectedOriginProperty.signal.skipNil(), initialAirport)
        let destination = Signal.merge(self.selectedDestinationProperty.signal.skipNil(), initialAirport)
        
        let initialPath = Signal.combineLatest(origin, destination).map { (origin: $0.0, destination: $0.1) }.takeWhen(self.crosspathTappedProperty.signal)
        
        let crossingDestination = Signal.combineLatest(origin, destination).map { (origin: $0.1, destination: $0.0) }.takeWhen(self.crosspathTappedProperty.signal)
        
        let finalPath = Signal.merge(initialPath, crossingDestination)
        
        let originReplaced = finalPath.map { $0.origin }
        let destReplaced = finalPath.map { $0.destination }
        
        self.goToOrigin = Signal.merge(origin, originReplaced).takeWhen(self.originTappedProperty.signal)
        self.originChanged = .empty
        
        self.originAirportText = Signal.merge(origin, originReplaced).map { origin in return "\(origin.locationName) (\(origin.airportCode))" }
        
        self.destinationAirportText = Signal.merge(destination, destReplaced).map { destination in return "\(destination.locationName) (\(destination.airportCode))" }
        
        let initialAdult = self.viewDidLoadProperty.signal.mapConst(1)
        let initialChildInfant = self.viewDidLoadProperty.signal.mapConst(0)
        
        let passengersSelected = self.selectedPassengersProperty.signal.skipNil()
        
        let adultCount = Signal.merge(passengersSelected.map { $0.0 }, initialAdult)
        let childCount = Signal.merge(passengersSelected.map { $0.1 }, initialChildInfant)
        let infantCount = Signal.merge(passengersSelected.map { $0.2 }, initialChildInfant)
        
        self.goToDestination = Signal.merge(destination, destReplaced).takeWhen(self.destinationTappedProperty.signal)
        self.destinationChanged = .empty
        self.goToPassengers = Signal.combineLatest(adultCount, childCount, infantCount).takeWhen(self.passengersTappedProperty.signal)
        
        self.crossedDestination = finalPath
        
        let passengersParam = Signal.combineLatest(adultCount, childCount, infantCount)
        
        self.passengersChanged = passengersParam
        
        let paramsChanged = Signal.combineLatest(self.selectedOriginProperty.signal.skipNil(), self.selectedDestinationProperty.signal.skipNil(), passengersParam).map { (arg) -> SearchFlightParams in

            let (origin, destination, passengers) = arg
            let param = .defaults
                |> SearchFlightParams.lens.fromAirport .~ origin.airportCode
                |> SearchFlightParams.lens.toAirport .~ destination.airportCode
                |> SearchFlightParams.lens.adult .~ passengers.0
                |> SearchFlightParams.lens.child .~ passengers.1
                |> SearchFlightParams.lens.infant .~ passengers.2
            
            return param
        }
        
        let tapDate = paramsChanged.takeWhen(self.pickdateTappedProperty.signal)
        
        self.goToPickDate = tapDate
        self.pickEmptyDate = self.pickdateTappedProperty.signal
    }
    
    fileprivate let originTappedProperty = MutableProperty(())
    public func originButtonTapped() {
        self.originTappedProperty.value = ()
    }
    
    fileprivate let destinationTappedProperty = MutableProperty(())
    public func desinationButtonTapped() {
        self.destinationTappedProperty.value = ()
    }
    
    fileprivate let crosspathTappedProperty = MutableProperty(())
    public func crossPathButtonTapped() {
        self.crosspathTappedProperty.value = ()
    }
    
    fileprivate let passengersTappedProperty = MutableProperty(())
    public func passengersButtonTapped() {
        self.passengersTappedProperty.value = ()
    }
    
    fileprivate let pickdateTappedProperty = MutableProperty(())
    public func pickDateButtonTapped() {
        self.pickdateTappedProperty.value = ()
    }
    
    fileprivate let selectedOriginProperty = MutableProperty<AirportResult?>(nil)
    public func selectedOrigin(airport: AirportResult) {
        self.selectedOriginProperty.value = airport
    }
    
    fileprivate let selectedDestinationProperty = MutableProperty<AirportResult?>(nil)
    public func selectedDestination(airport: AirportResult) {
        self.selectedDestinationProperty.value = airport
    }
    
    fileprivate let selectedPassengersProperty = MutableProperty<(Int, Int, Int)?>(nil)
    public func selectedPassengers(adult: Int, child: Int, infant: Int) {
        self.selectedPassengersProperty.value = (adult, child, infant)
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let goToOrigin: Signal<AirportResult, NoError>
    public let originChanged: Signal<AirportResult, NoError>
    public let originAirportText: Signal<String, NoError>
    public let goToDestination: Signal<AirportResult, NoError>
    public let destinationChanged: Signal<String, NoError>
    public let destinationAirportText: Signal<String, NoError>
    
    public let crossedDestination: Signal<(origin: AirportResult, destination: AirportResult), NoError>
    
    public let goToPassengers: Signal<(Int, Int, Int), NoError>
    public let passengersChanged: Signal<(Int, Int, Int), NoError>
    
    public let goToPickDate: Signal<SearchFlightParams, NoError>
    public let pickEmptyDate: Signal<(), NoError>
    
    public var inputs: FlightFormViewModelInputs { return self }
    public var outputs: FlightFormViewModelOutputs { return self }
}

