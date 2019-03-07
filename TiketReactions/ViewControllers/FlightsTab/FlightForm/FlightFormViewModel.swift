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

public enum FlightStatusTab {
    case roundTrip
    case oneWay
    
    public static let allTabs: [FlightStatusTab] = [.roundTrip, .oneWay]
}

public protocol FlightFormViewModelInputs {
    func roundTripButtonTapped()
    func oneWayButtonTapped()
    func switchFlightStatusSearch(tab: FlightStatusTab)
    func originButtonTapped()
    func desinationButtonTapped()
    func passengersButtonTapped()
    func crossPathButtonTapped()
    func pickDateButtonTapped()
    func submitSearchFlightTapped()
    func selectedOrigin(airport: AirportResult)
    func selectedDestination(airport: AirportResult)
    func selectedPassengers(adult: Int, child: Int, infant: Int)
    func selectedDate(first: Date, returned: Date?)
    func viewDidLoad()
    
}

public protocol FlightFormViewModelOutputs {
    var currentSelectedStatusTab: FlightStatusTab { get }
    var navigateToFlightStatusTab: Signal<FlightStatusTab, NoError> { get }
    var setSelectedButton: Signal<FlightStatusTab, NoError> { get }
    var pinSelectedIndicatorTab: Signal<(FlightStatusTab, Bool), NoError> { get }
    
    var goToOrigin: Signal<AirportResult, NoError> { get }
    var originChanged: Signal<AirportResult, NoError> { get }
    var originAirportText: Signal<String, NoError> { get }
    
    var goToDestination: Signal<AirportResult, NoError> { get }
    var destinationChanged: Signal<String, NoError> { get }
    var destinationAirportText: Signal<String, NoError> { get }
    
    var firstDateText: Signal<String, NoError> { get }
    var secondDateText: Signal<String, NoError> { get }
    
    var singleStatusFlight: Signal<(), NoError> { get }
    
    var crossedDestination: Signal<(origin: AirportResult, destination: AirportResult), NoError> { get }
    
    var goToPassengers: Signal<(Int, Int, Int), NoError> { get }
    var passengersChanged: Signal<(Int, Int, Int), NoError> { get }
    
    var goToPickDate: Signal<FlightStatusTab, NoError> { get }
    
    var goToFlightResults: Signal<SearchFlightParams, NoError> { get }
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
        
        let originInitialDateText = self.viewDidLoadProperty.signal.mapConst(Date())
        let returnInitialDateText = self.viewDidLoadProperty.signal.mapConst(Calendar.current.date(byAdding: .day, value: +1, to: Date())!)
        
        let originReplaced = finalPath.map { $0.origin }
        let destReplaced = finalPath.map { $0.destination }
        
        self.goToOrigin = Signal.merge(origin, originReplaced).takeWhen(self.originTappedProperty.signal)
        self.originChanged = .empty
        
        self.originAirportText =  Signal.merge(origin.signal.map { "\($0.locationName), \($0.airportCode)" }, self.viewDidLoadProperty.signal.mapConst(Localizations.OriginFlightTitleForm))
        
        self.destinationAirportText = Signal.merge(destination.signal.map { "\($0.locationName), \($0.airportCode)" }, self.viewDidLoadProperty.signal.mapConst(Localizations.DestinationFlightTitleForm))
        
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
        
        let selectedDate = self.selectedDateProperty.signal.skipNil()
        
        self.navigateToFlightStatusTab = Signal.merge(self.viewDidLoadProperty.signal.mapConst(.roundTrip), self.roundTripTappedProperty.signal.mapConst(.roundTrip), self.oneWayTappedProperty.signal.mapConst(.oneWay))
        
        self.goToPickDate = self.navigateToFlightStatusTab.signal.takeWhen(self.pickdateTappedProperty.signal)
        
        self.setSelectedButton = .empty
        
        self.pinSelectedIndicatorTab = self.navigateToFlightStatusTab.map { ($0, true) }.skipRepeats(==)
        
        self.firstDateText = Signal.merge(originInitialDateText.signal.map { Format.date(secondsInUTC: $0.timeIntervalSince1970, template: "d MMM yyyy") ?? "" }, self.selectedDateProperty.signal.skipNil().map { Format.date(secondsInUTC: $0.first.timeIntervalSince1970, template: "d MMM yyyy") ?? "" })

        self.secondDateText = Signal.merge(returnInitialDateText.signal.map { Format.date(secondsInUTC: $0.timeIntervalSince1970, template: "d MMM yyyy") ?? "" }, self.selectedDateProperty.signal.skipNil().map(second).skipNil().map { Format.date(secondsInUTC: $0.timeIntervalSince1970, template: "d MMM yyyy") ?? "" })
        
        let firstDateExtend = Signal.merge(originInitialDateText.signal, self.selectedDateProperty.signal.skipNil().map(first)).map { Format.date(secondsInUTC: $0.timeIntervalSince1970, template: "yyyy-MM-dd") ?? "" }
        
        let returnDateExtend = Signal.merge(returnInitialDateText.signal, self.selectedDateProperty.signal.skipNil().map(second).skipNil()).map { Format.date(secondsInUTC: $0.timeIntervalSince1970, template: "yyyy-MM-dd") ?? "" }
        
        let inputsRoundParam = Signal.combineLatest(self.selectedOriginProperty.signal.skipNil(), self.selectedDestinationProperty.signal.skipNil(), passengersParam, firstDateExtend.signal, returnDateExtend.signal).switchMap(configureFlightParam(origin:destination:passengers:departDate:returnDate:))
        
        let inputsSingleParam = Signal.combineLatest(self.selectedOriginProperty.signal.skipNil(), self.selectedDestinationProperty.signal.skipNil(), passengersParam, firstDateExtend.signal).switchMap(configureFlightSingleParam(origin:destination:passengers:departDate:))
        
        let singleFlightParams = Signal.combineLatest(self.navigateToFlightStatusTab.signal.filter { $0 == .oneWay }, inputsSingleParam).map(second)
        let returnFlightParams = Signal.combineLatest(self.navigateToFlightStatusTab.signal.filter { $0 == .roundTrip }, inputsRoundParam).map(second)
        
        self.goToFlightResults = Signal.merge(singleFlightParams, returnFlightParams).signal.takeWhen(self.searchFlightTappedProperty.signal)
        
        self.singleStatusFlight = self.navigateToFlightStatusTab.signal.filter { $0 == .oneWay }.ignoreValues()
    }
    
    fileprivate let roundTripTappedProperty = MutableProperty(())
    public func roundTripButtonTapped() {
        self.roundTripTappedProperty.value = ()
    }
    
    fileprivate let oneWayTappedProperty = MutableProperty(())
    public func oneWayButtonTapped() {
        self.oneWayTappedProperty.value = ()
    }
    
    fileprivate let roundFlightBoolProperty = MutableProperty<FlightStatusTab?>(nil)
    public func switchFlightStatusSearch(tab: FlightStatusTab) {
        self.roundFlightBoolProperty.value = tab
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
    
    fileprivate let searchFlightTappedProperty = MutableProperty(())
    public func submitSearchFlightTapped() {
        self.searchFlightTappedProperty.value = ()
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
    
    fileprivate let selectedDateProperty = MutableProperty<(first: Date, returned: Date?)?>(nil)
    public func selectedDate(first: Date, returned: Date?) {
        self.selectedDateProperty.value = (first, returned)
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    fileprivate let currentSelectedTabProperty = MutableProperty<FlightStatusTab>(.roundTrip)
    public var currentSelectedStatusTab: FlightStatusTab {
        return self.currentSelectedTabProperty.value
    }
    
    public let navigateToFlightStatusTab: Signal<FlightStatusTab, NoError>
    public let setSelectedButton: Signal<FlightStatusTab, NoError>
    public let pinSelectedIndicatorTab: Signal<(FlightStatusTab, Bool), NoError>
    public let goToOrigin: Signal<AirportResult, NoError>
    public let originChanged: Signal<AirportResult, NoError>
    public let originAirportText: Signal<String, NoError>
    public let goToDestination: Signal<AirportResult, NoError>
    public let destinationChanged: Signal<String, NoError>
    public let destinationAirportText: Signal<String, NoError>
    
    public let firstDateText: Signal<String, NoError>
    public let secondDateText: Signal<String, NoError>
    
    public let singleStatusFlight: Signal<(), NoError>
    
    public let crossedDestination: Signal<(origin: AirportResult, destination: AirportResult), NoError>
    
    public let goToPassengers: Signal<(Int, Int, Int), NoError>
    public let passengersChanged: Signal<(Int, Int, Int), NoError>
    
    public let goToPickDate: Signal<FlightStatusTab, NoError>
    
    public let goToFlightResults: Signal<SearchFlightParams, NoError>
    
    public var inputs: FlightFormViewModelInputs { return self }
    public var outputs: FlightFormViewModelOutputs { return self }
}

private func configureFlightParam(origin: AirportResult, destination: AirportResult, passengers: (adult: Int, child: Int, infant: Int), departDate: String, returnDate: String? = "") -> SignalProducer<SearchFlightParams, NoError> {
    
    let param = SearchFlightParams.defaults
        |> SearchFlightParams.lens.fromAirport .~ origin.airportCode
        |> SearchFlightParams.lens.toAirport .~ destination.airportCode
        |> SearchFlightParams.lens.departDate .~ departDate
        |> SearchFlightParams.lens.returnDate .~ returnDate
        |> SearchFlightParams.lens.adult .~ passengers.adult
        |> SearchFlightParams.lens.child .~ passengers.child
        |> SearchFlightParams.lens.infant .~ passengers.infant
    
    return SignalProducer(value: param)
}

private func configureFlightSingleParam(origin: AirportResult, destination: AirportResult, passengers: (adult: Int, child: Int, infant: Int), departDate: String) -> SignalProducer<SearchFlightParams, NoError> {
    
    let param = SearchFlightParams.defaults
        |> SearchFlightParams.lens.fromAirport .~ origin.airportCode
        |> SearchFlightParams.lens.toAirport .~ destination.airportCode
        |> SearchFlightParams.lens.departDate .~ departDate
        |> SearchFlightParams.lens.adult .~ passengers.adult
        |> SearchFlightParams.lens.child .~ passengers.child
        |> SearchFlightParams.lens.infant .~ passengers.infant
    
    return SignalProducer(value: param)
}


