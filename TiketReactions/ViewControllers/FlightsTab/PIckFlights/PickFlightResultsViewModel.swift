//
//  PickFlightResultsViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 21/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol PickFlightResultsViewModelInputs {
    func configureWith(_ envelope: SearchFlightEnvelope)
    func configureWith(_ params: SearchFlightParams)
    func tappedButtonDismiss()
    func tappedButtonNextStep()
    func tapped(flight: Flight)
    func viewWillAppear(_ animated: Bool)
    func viewDidAppear()
    func viewDidDisappear(animated: Bool)
    func willDisplayRow(_ row: Int, outOf totalRows: Int)
    func viewDidLoad()
}

public protocol PickFlightResultsViewModelOutputs {
    var flightsAreLoading: Signal<Bool, NoError> { get }
    var flights: Signal<([Flight], PickNoticeFlight), NoError> { get }
    var dismissToPickDate: Signal<(), NoError> { get }
    var showNextSteps: Signal<Bool, NoError> { get }
    var showDestinationText: Signal<String, NoError> { get }
    var showDateText: Signal<String, NoError> { get }
    var returnFlights: Signal<[Flight], NoError> { get }
    var showEmptyState: Signal<EmptyState, NoError> { get }
    var hideEmptyState: Signal<(), NoError> { get }
    var goToFlight: Signal<Flight, NoError> { get }
    var goToReturnFlights: Signal<(SearchFlightEnvelope, Flight), NoError> { get }
}

public protocol PickFlightResultsViewModelType {
    var inputs: PickFlightResultsViewModelInputs { get }
    var outputs: PickFlightResultsViewModelOutputs { get }
}


public final class PickFlightResultsViewModel: PickFlightResultsViewModelType, PickFlightResultsViewModelInputs, PickFlightResultsViewModelOutputs {
    
    public init() {
        let current = Signal.combineLatest(self.viewDidLoadProperty.signal, self.configEnvelopeProperty.signal.skipNil()).map(second)
        
        let currentParam = Signal.combineLatest(self.viewDidLoadProperty.signal, self.configParamFlightProperty.signal.skipNil()).map(second)
        
        let flightsLoading = MutableProperty(false)
        let fetchFlightServices = currentParam.switchMap { AppEnvironment.current.apiService.fetchFlightResults(params: $0)
            .on(started: { flightsLoading.value = true }, terminated: { flightsLoading.value = false }).materialize() }
        
        self.flightsAreLoading = flightsLoading.signal
        
        let noticeSignal = fetchFlightServices.values().map(takeFlightsIntoNotice(_ :))
        self.flights = Signal.combineLatest(fetchFlightServices.values().map { $0.departResuts }.skipNil(), noticeSignal)
        self.showNextSteps = self.tappedFlightProperty.signal.skipNil().mapConst(true)
        self.showDestinationText = Signal.combineLatest(current.map { "\($0.paramSearchFlight.fromAirport ?? "") - \($0.paramSearchFlight.toAirport ?? "")" }, self.viewDidLoadProperty.signal.mapConst("")).map(first)
        self.showDateText = Signal.combineLatest(noticeSignal.map { $0.date }.skipNil(), self.viewDidLoadProperty.signal.mapConst("")).map(first)
        self.returnFlights = .empty
        self.showEmptyState = self.flights.signal.map(first).filter { $0.isEmpty }.map { _ in emptyStateFlight() }
        self.hideEmptyState = Signal.merge(self.viewWillAppearProperty.signal.ignoreValues().take(first: 1), self.flights.map(first).filter { !$0.isEmpty }.ignoreValues())
        
        self.goToFlight = Signal.combineLatest(fetchFlightServices.values().filter { $0.returnResults.isNil }, self.tappedFlightProperty.signal.skipNil()).map(second).takeWhen(self.tappedButtonNextStepProperty.signal)
        self.goToReturnFlights = Signal.combineLatest(fetchFlightServices.values().filter { !$0.returnResults.isNil }, self.tappedFlightProperty.signal.skipNil()).takeWhen(self.tappedButtonNextStepProperty.signal)

        self.dismissToPickDate = self.tappedButtonDismissProperty.signal
        
    }
    
    fileprivate let configEnvelopeProperty = MutableProperty<SearchFlightEnvelope?>(nil)
    public func configureWith(_ envelope: SearchFlightEnvelope) {
        self.configEnvelopeProperty.value = envelope
    }
    
    fileprivate let configParamFlightProperty = MutableProperty<SearchFlightParams?>(nil)
    public func configureWith(_ params: SearchFlightParams) {
        self.configParamFlightProperty.value = params
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
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let flightsAreLoading: Signal<Bool, NoError>
    public let flights: Signal<([Flight], PickNoticeFlight), NoError>
    public let showNextSteps: Signal<Bool, NoError>
    public let showDestinationText: Signal<String, NoError>
    public let showDateText: Signal<String, NoError>
    public let returnFlights: Signal<[Flight], NoError>
    public let showEmptyState: Signal<EmptyState, NoError>
    public let hideEmptyState: Signal<(), NoError>
    public let goToFlight: Signal<Flight, NoError>
    public let goToReturnFlights: Signal<(SearchFlightEnvelope, Flight), NoError>
    public let dismissToPickDate: Signal<(), NoError>
    
    public var inputs: PickFlightResultsViewModelInputs { return self }
    public var outputs: PickFlightResultsViewModelOutputs { return self }
}

private func takeFlightsIntoNotice(_ envelope: SearchFlightEnvelope) -> PickNoticeFlight {
    if let firstResultFlight = envelope.departResuts?.first {
        return PickNoticeFlight(date: firstResultFlight.inner.departureFlightDateStr, route: Localizations.OutboundNoticePickFlight(firstResultFlight.flightDetail.departureCityName))
    } else {
        return PickNoticeFlight(date: nil, route: nil)
    }
}

private func isFlightStored(withFlight flight: Flight) -> Bool {
    return AppEnvironment.current.ubiquitousStore.temporaryCartFlights.index(of: flight) != nil
}

private func saveFirstFlight(_ flight: Flight) {
    if let index = AppEnvironment.current.ubiquitousStore.temporaryCartFlights.index(of: flight) {
        AppEnvironment.current.ubiquitousStore.temporaryCartFlights.remove(at: index)
    } else {
        AppEnvironment.current.ubiquitousStore.temporaryCartFlights.append(flight)
    }
}
private func listCartFlights() -> SignalProducer<[Flight], NoError> {
    let temporary = AppEnvironment.current.ubiquitousStore.temporaryCartFlights
    return SignalProducer(value: temporary)
}

private func emptyStateFlight() -> EmptyState {
    return EmptyState.flightResult
}

private func somehowToCurlForceUpdate(_ force: String) {
    print("Somehow to Curl Force Update")
    if let sample = URL(string: force) {
        var request = URLRequest(url: sample)
        request.httpMethod = "GET"
        let session = URLSession.shared
        session.dataTask(with: request).resume()
    }
}

