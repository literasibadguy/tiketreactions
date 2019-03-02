//
//  PickFlightReturnsViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 26/08/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol PickFlightReturnsViewModelInputs {
    func configureWith(_ envelope: SearchFlightEnvelope, departFlight: Flight)
    func tappedButtonDismiss()
    func tappedButtonNextStep()
    func tapped(flight: Flight)
    func viewWillAppear(_ animated: Bool)
    func viewDidAppear()
    func viewDidDisappear(animated: Bool)
    func willDisplayRow(_ row: Int, outOf totalRows: Int)
}

public protocol PickFlightReturnsViewModelOutputs {
    var flights: Signal<([Flight], PickNoticeFlight), NoError> { get }
    var dismissToFirsts: Signal<(), NoError> { get }
    var showNextSteps: Signal<Bool, NoError> { get }
    var showDestinationText: Signal<String, NoError> { get }
    var showDateText: Signal<String, NoError> { get }
    var showEmptyState: Signal<EmptyState, NoError> { get }
    var hideEmptyState: Signal<(), NoError> { get }
    var goToCartFlight: Signal<(departure: Flight, arrival: Flight), NoError> { get }
}

public protocol PickFlightReturnsViewModelType {
    var inputs: PickFlightReturnsViewModelInputs { get }
    var outputs: PickFlightReturnsViewModelOutputs { get }
}

public final class PickFlightReturnsViewModel: PickFlightReturnsViewModelType, PickFlightReturnsViewModelInputs, PickFlightReturnsViewModelOutputs {
    
    public init() {
       let currentReturned = Signal.combineLatest(self.viewDidAppearProperty.signal, self.configEnvelopeProperty.signal.skipNil().map(first)).map(second)
        
        self.flights = Signal.combineLatest(currentReturned.signal.map { $0.returnResults! }, currentReturned.map(takeReturnFlightsIntoNotice(_ :)))
        self.dismissToFirsts = self.tappedButtonDismissProperty.signal
        self.showNextSteps = self.tappedFlightProperty.signal.mapConst(true)
        self.showDestinationText = .empty
        self.showDateText = .empty
        self.showEmptyState = .empty
        self.hideEmptyState = .empty
        self.goToCartFlight = Signal.combineLatest(self.configEnvelopeProperty.signal.skipNil().map(second), self.tappedFlightProperty.signal.skipNil()).map { (departure: $0.0, arrival: $0.1) }.takeWhen(self.tappedButtonNextStepProperty.signal)
    }
    
    fileprivate let configEnvelopeProperty = MutableProperty<(envelope: SearchFlightEnvelope, departSelected: Flight)?>(nil)
    public func configureWith(_ envelope: SearchFlightEnvelope, departFlight: Flight) {
        self.configEnvelopeProperty.value = (envelope: envelope, departSelected: departFlight)
    }
    
    fileprivate let tappedButtonDismissProperty = MutableProperty(())
    public func tappedButtonDismiss() {
        self.tappedButtonDismissProperty.value = ()
    }
    
    fileprivate let tappedButtonNextStepProperty = MutableProperty(())
    public func tappedButtonNextStep() {
        self.tappedButtonNextStepProperty.value = ()
    }
    
    fileprivate let tappedFlightProperty = MutableProperty<Flight?>(nil)
    public func tapped(flight: Flight) {
        self.tappedFlightProperty.value = flight
    }
    
    fileprivate let viewWillAppearProperty = MutableProperty(false)
    public func viewWillAppear(_ animated: Bool) {
        self.viewWillAppearProperty.value = animated
    }
    
    fileprivate let viewDidAppearProperty = MutableProperty(())
    public func viewDidAppear() {
        self.viewDidAppearProperty.value = ()
    }
    
    fileprivate let viewDidDisappearProperty = MutableProperty(false)
    public func viewDidDisappear(animated: Bool) {
        self.viewDidDisappearProperty.value = animated
    }
    
    fileprivate let willDisplayRowProperty = MutableProperty<(row: Int, total: Int)?>(nil)
    public func willDisplayRow(_ row: Int, outOf totalRows: Int) {
        self.willDisplayRowProperty.value = (row, totalRows)
    }
    
    public let flights: Signal<([Flight], PickNoticeFlight), NoError>
    public let dismissToFirsts: Signal<(), NoError>
    public let showNextSteps: Signal<Bool, NoError>
    public let showDestinationText: Signal<String, NoError>
    public let showDateText: Signal<String, NoError>
    public let showEmptyState: Signal<EmptyState, NoError>
    public let hideEmptyState: Signal<(), NoError>
    public let goToCartFlight: Signal<(departure: Flight, arrival: Flight), NoError>
    
    public var inputs: PickFlightReturnsViewModelInputs { return self }
    public var outputs: PickFlightReturnsViewModelOutputs { return self }
}

private func takeReturnFlightsIntoNotice(_ envelope: SearchFlightEnvelope) -> PickNoticeFlight {
    if let firstResultFlight = envelope.returnResults?.first {
        return PickNoticeFlight(date: firstResultFlight.inner.departureFlightDateStr, route: Localizations.ReturnNoticePickFlight(firstResultFlight.flightDetail.departureCityName))
    } else {
        return PickNoticeFlight(date: nil, route: nil)
    }
}

