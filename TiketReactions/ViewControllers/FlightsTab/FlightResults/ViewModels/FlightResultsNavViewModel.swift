//
//  FlightResultsNavViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 05/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result

public protocol FlightResultsNavViewModelInputs {
    func configureEnvelope(flightEnvelope: SearchFlightEnvelope)
    func tappedButtonCancel()
    func viewDidLoad()
}

public protocol FlightResultsNavViewModelOutputs {
    var departureAirportCodeText: Signal<String, NoError> { get }
    var arrivalAirportCodeText: Signal<String, NoError> { get }
    var backToPickDates: Signal<(), NoError> { get }
    
}

public protocol FlightResultsNavViewModelType {
    var inputs: FlightResultsNavViewModelInputs { get }
    var outputs: FlightResultsNavViewModelOutputs { get }
}

public final class FlightResultsNavViewModel: FlightResultsNavViewModelType, FlightResultsNavViewModelInputs, FlightResultsNavViewModelOutputs {
    
    public init() {
        let flightEnvelope = Signal.combineLatest(self.configEnvelopeProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        self.departureAirportCodeText = flightEnvelope.map { flightEnvelope in flightEnvelope.paramSearchFlight.fromAirport! }
        self.arrivalAirportCodeText = flightEnvelope.map { flightEnvelope in flightEnvelope.paramSearchFlight.toAirport! }
        
        self.backToPickDates = self.tappedCancelProperty.signal
    }
    
    fileprivate let configEnvelopeProperty = MutableProperty<SearchFlightEnvelope?>(nil)
    public func configureEnvelope(flightEnvelope: SearchFlightEnvelope) {
        self.configEnvelopeProperty.value = flightEnvelope
    }
    
    fileprivate let tappedCancelProperty = MutableProperty(())
    public func tappedButtonCancel() {
        self.tappedCancelProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let departureAirportCodeText: Signal<String, NoError>
    public let arrivalAirportCodeText: Signal<String, NoError>
    public let backToPickDates: Signal<(), NoError>
    
    public var inputs: FlightResultsNavViewModelInputs { return self }
    public var outputs: FlightResultsNavViewModelOutputs { return self }
}
