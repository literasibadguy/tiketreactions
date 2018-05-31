//
//  FlightDirectsContentViewModel.swift
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

public protocol FlightDirectsContentViewModelInputs {
    func configureSingleWith(param: SearchSingleFlightParams, flight: Flight)
    func configureReturnWith(param: SearchFlightParams, departed: Flight, returned: Flight)
    func configureWith(flight: Flight)
    func configureReturnWith(departed: Flight, returned: Flight)
    func contactForm(salutation: String, fullname: String, email: String, phone: String)
    func contactFormCompleted(_ completed: Bool)
    func contactOptionPassengerChanged(_ passenger: Bool)
    func viewDidLoad()
}

public protocol FlightDirectsContentViewModelOutputs {
    var loadFlightParamDataSource: Signal<(SearchSingleFlightParams, Flight), NoError> { get }
    var loadFlightIntoDataSource: Signal<Flight, NoError> { get }
    var loadReturnedFlightIntoDataSource: Signal<(Flight, Flight), NoError> { get }
    var loadReturnedFlightParamDataSource: Signal<(SearchFlightParams, Flight, Flight), NoError> { get }
    var preparingPassenger: Signal<GroupPassengersParam, NoError> { get }
    var filledOrder: Signal<AddOrderFlightEnvelope, NoError> { get }
}

public protocol FlightDirectsContentViewModelType {
    var inputs: FlightDirectsContentViewModelInputs { get }
    var outputs: FlightDirectsContentViewModelOutputs { get }
}

public final class FlightDirectsContentViewModel: FlightDirectsContentViewModelType, FlightDirectsContentViewModelInputs, FlightDirectsContentViewModelOutputs {
    
    public init() {
        
        self.loadFlightParamDataSource = Signal.combineLatest(self.configParamProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        self.loadFlightIntoDataSource = Signal.combineLatest(self.configuredDataProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        self.loadReturnedFlightIntoDataSource = Signal.combineLatest(self.configuredReturnDataProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        self.loadReturnedFlightParamDataSource = Signal.combineLatest(self.configParamReturnProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        let contactForm = self.contactFormProperty.signal.skipNil().map { (arg) -> GroupPassengersParam in
            let (title, name, email, phone) = arg
            let form = .defaults
                |> GroupPassengersParam.lens.conSalutation .~ title
                |> GroupPassengersParam.lens.conFirstName .~ name
                |> GroupPassengersParam.lens.conPhone .~ phone
                |> GroupPassengersParam.lens.conEmailAddress .~ email
            return form
        }
        
        let passengerForm = self.contactFormProperty.signal.skipNil().map { (arg) -> AdultPassengerParam in
            
            let (title, name, email, phone) = arg
            let form = .defaults
                |> AdultPassengerParam.lens.firstname .~ name
                |> AdultPassengerParam.lens.title .~ title
            
            return form
        }
        
        let sameAsPassenger = Signal.combineLatest(contactForm, passengerForm).map { (arg) -> GroupPassengersParam in
            
            let (contact, firstPassenger) = arg
            let form = contact
                |> GroupPassengersParam.lens.adults .~ [firstPassenger]
            
            return form
        }
        
        let addOrderPost = Signal.combineLatest(self.contactCompletedProperty.signal.map { $0 == true }, sameAsPassenger).switchMap { _, passenger in
            AppEnvironment.current.apiService.addOrderFlight(params: passenger).demoteErrors()
        }
        
        let addOrderEvent = sameAsPassenger.switchMap {
            AppEnvironment.current.apiService.addOrderFlight(params: $0).demoteErrors()
            }.takeWhen(self.contactCompletedProperty.signal.map { $0 == true })
        
        self.preparingPassenger = sameAsPassenger
        self.filledOrder = .empty
    }
    
    fileprivate let configParamProperty = MutableProperty<(SearchSingleFlightParams, Flight)?>(nil)
    public func configureSingleWith(param: SearchSingleFlightParams, flight: Flight) {
        self.configParamProperty.value = (param, flight)
    }
    
    fileprivate let configParamReturnProperty = MutableProperty<(SearchFlightParams, Flight, Flight)?>(nil)
    public func configureReturnWith(param: SearchFlightParams, departed: Flight, returned: Flight) {
        self.configParamReturnProperty.value = (param, departed, returned)
    }
    
    fileprivate let configuredDataProperty = MutableProperty<Flight?>(nil)
    public func configureWith(flight: Flight) {
        self.configuredDataProperty.value = flight
    }
    
    fileprivate let configuredReturnDataProperty = MutableProperty<(Flight, Flight)?>(nil)
    public func configureReturnWith(departed: Flight, returned: Flight) {
        self.configuredReturnDataProperty.value = (departed, returned)
    }
    
    fileprivate let contactFormProperty = MutableProperty<(String, String, String, String)?>(nil)
    public func contactForm(salutation: String, fullname: String, email: String, phone: String) {
        self.contactFormProperty.value = (salutation, fullname, email, phone)
    }
    
    fileprivate let contactCompletedProperty = MutableProperty(false)
    public func contactFormCompleted(_ completed: Bool) {
        self.contactCompletedProperty.value = completed
    }
    
    fileprivate let contactOptionPassengerProperty = MutableProperty(false)
    public func contactOptionPassengerChanged(_ passenger: Bool) {
        self.contactOptionPassengerProperty.value = passenger
    }

    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let loadFlightParamDataSource: Signal<(SearchSingleFlightParams, Flight), NoError>
    public let loadFlightIntoDataSource: Signal<Flight, NoError>
    public let loadReturnedFlightIntoDataSource: Signal<(Flight, Flight), NoError>
    public let loadReturnedFlightParamDataSource: Signal<(SearchFlightParams, Flight, Flight), NoError>
    public let preparingPassenger: Signal<GroupPassengersParam, NoError>
    public let filledOrder: Signal<AddOrderFlightEnvelope, NoError>
    
    public var inputs: FlightDirectsContentViewModelInputs { return self }
    public var outputs: FlightDirectsContentViewModelOutputs { return self }
}
