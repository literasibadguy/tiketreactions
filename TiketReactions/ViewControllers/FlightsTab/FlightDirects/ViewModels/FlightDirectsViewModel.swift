//
//  FlightDirectsViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 01/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol FlightDirectsViewModelInputs {
    func configureWith(param: SearchSingleFlightParams, flight: Flight)
    func configureWith(param: SearchFlightParams, depart: Flight, returned: Flight)
    func configureWith(flight: Flight)
    func configureWith(flight: Flight, returnedFlight: Flight)
    func backButtonTapped()
    func passengerTitlesPicked()
    func getContactInfoForm(title: String, fullname: String, email: String, phone: String)
    func viewDidLoad()
    func viewWillAppear(animated: Bool)
}

public protocol FlightDirectsViewModelOutputs {
    var configureParamWithFlight: Signal<(SearchSingleFlightParams, Flight), NoError> { get }
    var configureParamWithReturnFlight: Signal<(SearchFlightParams, Flight, Flight), NoError> { get }
    var goToPassengerTitlePick: Signal<String, NoError> { get }
    var dismissFlightDirect: Signal<(), NoError> { get }
}

public protocol FlightDirectsViewModelType {
    var inputs: FlightDirectsViewModelInputs { get }
    var outputs: FlightDirectsViewModelOutputs { get }
}

public final class FlightDirectsViewModel: FlightDirectsViewModelType, FlightDirectsViewModelInputs, FlightDirectsViewModelOutputs {
    
    public init() {
        
        self.configureParamWithFlight = Signal.combineLatest(self.configParamProperty.signal.skipNil(),
            self.viewDidLoadProperty.signal).map(first)

        self.configureParamWithReturnFlight = Signal.combineLatest(self.configReturnParamProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        self.dismissFlightDirect = self.backButtonProperty.signal
        
        let currentTitle = Signal.merge(self.viewDidLoadProperty.signal.mapConst(""), self.contactInfoProperty.signal.skipNil().map { $0.0 })
        
        self.goToPassengerTitlePick = self.viewDidLoadProperty.signal.mapConst("").takeWhen(self.passengerTitlePickProperty.signal)
    }
    
    fileprivate let configParamProperty = MutableProperty<(SearchSingleFlightParams, Flight)?>(nil)
    public func configureWith(param: SearchSingleFlightParams, flight: Flight) {
    self.configParamProperty.value = (param, flight)
    }
    
    fileprivate let configReturnParamProperty = MutableProperty<(SearchFlightParams, Flight, Flight)?>(nil)
    public func configureWith(param: SearchFlightParams, depart: Flight, returned: Flight) {
        self.configReturnParamProperty.value = (param, depart, returned)
    }
    
    fileprivate let configDataProperty = MutableProperty<Flight?>(nil)
    public func configureWith(flight: Flight) {
        self.configDataProperty.value = flight
    }
    
    fileprivate let configReturnDataProperty = MutableProperty<(Flight, Flight)?>(nil)
    public func configureWith(flight: Flight, returnedFlight: Flight) {
        self.configReturnDataProperty.value = (flight, returnedFlight)
    }
    
    fileprivate let backButtonProperty = MutableProperty(())
    public func backButtonTapped() {
        self.backButtonProperty.value = ()
    }
    
    fileprivate let passengerTitlePickProperty = MutableProperty(())
    public func passengerTitlesPicked() {
        self.passengerTitlePickProperty.value = ()
    }
    
    fileprivate let contactInfoProperty = MutableProperty<(String, String, String, String)?>(nil)
    public func getContactInfoForm(title: String, fullname: String, email: String, phone: String) {
        self.contactInfoProperty.value = (title, fullname, email, phone)
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    fileprivate let viewWillAppearProperty = MutableProperty(false)
    public func viewWillAppear(animated: Bool) {
        self.viewWillAppearProperty.value = animated
    }
    
    public let configureParamWithFlight: Signal<(SearchSingleFlightParams, Flight), NoError>
    public let configureParamWithReturnFlight: Signal<(SearchFlightParams, Flight, Flight), NoError>
    public let goToPassengerTitlePick: Signal<String, NoError>
    public let dismissFlightDirect: Signal<(), NoError>
    
    public var inputs: FlightDirectsViewModelInputs { return self }
    public var outputs: FlightDirectsViewModelOutputs { return self }
}
