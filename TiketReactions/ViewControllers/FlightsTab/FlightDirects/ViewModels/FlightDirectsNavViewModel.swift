//
//  FlightDirectsNavViewModel.swift
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

public protocol FlightDirectsNavViewModelInputs {
    func configureWith(flight: Flight)
    func configureRoundedWith(flight: Flight, returnFlight: Flight)
    func changedParams(params: GroupPassengersParam)
    func addOrderButtonTapped()
    func viewDidLoad()
}

public protocol FlightDirectsNavViewModelOutputs {
    var addOrder: Signal<AddOrderFlightEnvelope, NoError> { get }
}

public protocol FlightDirectsNavViewModelType {
    var inputs: FlightDirectsNavViewModelInputs { get }
    var outputs: FlightDirectsNavViewModelOutputs { get }
}
public final class FlightDirectsNavViewModel: FlightDirectsNavViewModelType, FlightDirectsNavViewModelInputs, FlightDirectsNavViewModelOutputs {
    
    public init() {
        let flightSelected = Signal.combineLatest(self.configDataProperty.signal.skipNil(), self.viewDidLoadProperty.signal.ignoreValues()).map(first)
        
        let passenger = Signal.combineLatest(self.changedParamsProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        let flightId = flightSelected.signal.map { $0.flightId }.demoteErrors()
        
        let paramsChanged = .defaults
            |> GroupPassengersParam.lens.flightId .~ ""
            |> GroupPassengersParam.lens.returnFlightId .~ ""
            |> GroupPassengersParam.lens.conFirstName .~ ""
            |> GroupPassengersParam.lens.conLastName .~ ""
            |> GroupPassengersParam.lens.conEmailAddress .~ ""
            |> GroupPassengersParam.lens.conPhone .~ ""
            |> GroupPassengersParam.lens.adult .~ 1
            |> GroupPassengersParam.lens.child .~ 1
        
        let orderSummary = Signal.combineLatest(flightSelected, passenger).map { (arg) -> GroupPassengersParam in
            
            let (flight, groups) = arg
            let current = .defaults
                |> GroupPassengersParam.lens.flightId .~ flight.flightId
                |> GroupPassengersParam.lens.conFirstName .~ groups.conFirstName
                |> GroupPassengersParam.lens.conEmailAddress .~ groups.conEmailAddress
                |> GroupPassengersParam.lens.conPhone .~ groups.conPhone
            
            return current
        }
        
        let addOrderRequest = orderSummary.switchMap { passengers in
            AppEnvironment.current.apiService.addOrderFlight(params: passengers).demoteErrors()
        }
        
        self.addOrder = addOrderRequest.takeWhen(self.orderButtonTappedProperty.signal)
    }
    
    fileprivate let configDataProperty = MutableProperty<Flight?>(nil)
    public func configureWith(flight: Flight) {
        self.configDataProperty.value = flight
    }
    
    fileprivate let configRoundedDataProperty = MutableProperty<(Flight, Flight)?>(nil)
    public func configureRoundedWith(flight: Flight, returnFlight: Flight) {
        self.configRoundedDataProperty.value = (flight, returnFlight)
    }
    
    fileprivate let changedParamsProperty = MutableProperty<GroupPassengersParam?>(nil)
    public func changedParams(params: GroupPassengersParam) {
        self.changedParamsProperty.value = params
    }
    
    fileprivate let orderButtonTappedProperty = MutableProperty(())
    public func addOrderButtonTapped() {
        self.orderButtonTappedProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let addOrder: Signal<AddOrderFlightEnvelope, NoError>
    
    public var inputs: FlightDirectsNavViewModelInputs { return self }
    public var outputs: FlightDirectsNavViewModelOutputs { return self }
}
