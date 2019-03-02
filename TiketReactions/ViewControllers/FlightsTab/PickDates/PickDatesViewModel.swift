//
//  PickDatesViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 22/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import Result
import ReactiveSwift
import TiketKitModels

public protocol PickDatesViewModelInputs {
    func configureWith(flightParams: SearchFlightParams, status: Bool)
    func configureWith(_ status: FlightStatusTab)
    func isThisOneWayFlight(_ status: Bool)
    func tappedButtonCancel()
    func startDate(_ selected: Date)
    func endDate(_ selected: Date)
    func flightButtonTapped()
    func dismissError()
    func viewDidLoad()
}

public protocol PickDatesViewModelOutputs {
    var dismissPickDates: Signal<(), NoError> { get }
    var statusPickDate: Signal<FlightStatusTab, NoError> { get }
    var startDateText: Signal<String, NoError> { get }
    var endDateText: Signal<String, NoError> { get }
    var isRoundFlight: Signal<Bool, NoError> { get }
    var singleFlightStatus: Signal<String, NoError> { get }
    var goToFlightResults: Signal<SearchFlightEnvelope, NoError> { get }
    var flightsAreLoading: Signal<Bool, NoError> { get }
    var flightsAreError: Signal<String, NoError> { get }
    var showErrorOccured: Signal<(), NoError> { get }
    var selectedDate: Signal<(first: Date, second: Date?), NoError> { get }
    var selectedSingleDate: Signal<Date, NoError> { get }
    var hideReturnLabels: Signal<Bool, NoError> { get }
    var singleFlightDate: Signal<Bool, NoError> { get }
}

public protocol PickDatesViewModelType {
    var inputs: PickDatesViewModelInputs { get }
    var outputs: PickDatesViewModelOutputs { get }
}

public final class PickDatesViewModel: PickDatesViewModelType, PickDatesViewModelInputs, PickDatesViewModelOutputs {
    
    init() {
        self.dismissPickDates = self.tappedCancelProperty.signal
        
        let configData = Signal.combineLatest(self.configDataProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        let configStatus = Signal.combineLatest(self.configStatusProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        configData.observe(on: UIScheduler()).observeValues { data in
            print("Config Data Param: \(data)")
        }
        
        let initialDateText = self.viewDidLoadProperty.signal.mapConst("")
        
        // GET FIRST DATE FOR SECTION
        let textFirstDate = Signal.merge(self.startDateProperty.signal.skipNil().map { Format.date(secondsInUTC: $0.timeIntervalSince1970, template: "yyyy-MM-dd") }, self.endDateProperty.signal.mapConst(nil))
        let showFirstDate = Signal.merge(self.startDateProperty.signal.skipNil().map { Format.date(secondsInUTC: $0.timeIntervalSince1970, template: "E, d MMM")! }, initialDateText)
        let textEndDate = Signal.merge(self.endDateProperty.signal.skipNil().map { Format.date(secondsInUTC: $0.timeIntervalSince1970, template: "yyyy-MM-dd") })
        let showEndDate = Signal.merge(self.endDateProperty.signal.skipNil().map { Format.date(secondsInUTC: $0.timeIntervalSince1970, template: "E, d MMM")! }, initialDateText)
        
        let resetDate = self.startDateProperty.signal.map { _ in "" }
        
        self.startDateText = showFirstDate.signal.map { $0 }
        self.endDateText = Signal.merge(showEndDate, resetDate)
        
        let singleParamCurrents = Signal.combineLatest(configData.map(first), textFirstDate.skipNil()).takeWhen(self.tappedFlightProperty.signal).map {
            (arg) -> SearchFlightParams in
            
            let (config, firstDate) = arg
            let custom = config
                |> SearchFlightParams.lens.departDate .~ firstDate
    
            return custom
            }
        
        let paramCurrents = Signal.combineLatest(singleParamCurrents, textEndDate.skipNil()).takeWhen(self.tappedFlightProperty.signal).map { (arg) -> SearchFlightParams in
            
            let (config, endDate) = arg
            let custom = config
                |> SearchFlightParams.lens.returnDate .~ endDate
            return custom
        }
        
        self.isRoundFlight = configData.signal.map(second)
        
        self.singleFlightStatus = Signal.merge(textFirstDate.skipNil().map { _ in Localizations.SingleStatusTitlePickDate }, textEndDate.skipNil().map { _ in Localizations.ReturnStatusTitlePickDate })
        
        let fetchLoading = MutableProperty(false)
        
        self.statusPickDate = configStatus.signal
        
        self.hideReturnLabels = configStatus.signal.filter { $0 == .oneWay }.mapConst(true)
        
        let statusFlightOneWay = Signal.combineLatest(self.oneWayStatusProperty.signal.skipNil().map(isTrue), self.startDateProperty.signal.skipNil())
        
        self.singleFlightDate = statusFlightOneWay.signal.map(first)

        self.flightsAreLoading = .empty
        self.flightsAreError = .empty

        self.goToFlightResults = .empty
        
        self.showErrorOccured = .empty
        
        self.selectedDate = Signal.combineLatest(self.startDateProperty.signal.skipNil(), self.endDateProperty.signal).map { return ($0.0, $0.1) }.takeWhen(self.tappedFlightProperty.signal)
        
        self.selectedSingleDate = statusFlightOneWay.signal.map(second).takeWhen(self.tappedFlightProperty.signal)
    
    }
    
    fileprivate let configDataProperty = MutableProperty<(SearchFlightParams, Bool)?>(nil)
    public func configureWith(flightParams: SearchFlightParams, status: Bool) {
//        self.configDataProperty.value = flightParams
        self.configDataProperty.value = (flightParams, status)
    }
    
    fileprivate let configStatusProperty = MutableProperty<FlightStatusTab?>(nil)
    public func configureWith(_ status: FlightStatusTab) {
        self.configStatusProperty.value = status
    }
    
    fileprivate let oneWayStatusProperty = MutableProperty<Bool?>(nil)
    public func isThisOneWayFlight(_ status: Bool) {
        self.oneWayStatusProperty.value = status
    }
    
    fileprivate let tappedCancelProperty = MutableProperty(())
    public func tappedButtonCancel() {
        self.tappedCancelProperty.value = ()
    }
    
    fileprivate let startDateProperty = MutableProperty<Date?>(nil)
    public func startDate(_ selected: Date) {
        self.startDateProperty.value = selected
    }
    
    fileprivate let endDateProperty = MutableProperty<Date?>(nil)
    public func endDate(_ selected: Date) {
        self.endDateProperty.value = selected
    }
    
    fileprivate let tappedFlightProperty = MutableProperty(())
    public func flightButtonTapped() {
        self.tappedFlightProperty.value = ()
    }
    
    fileprivate let dismissErrorProperty = MutableProperty(())
    public func dismissError() {
        self.dismissErrorProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let dismissPickDates: Signal<(), NoError>
    public let statusPickDate: Signal<FlightStatusTab, NoError>
    public let startDateText: Signal<String, NoError>
    public let endDateText: Signal<String, NoError>
    public let isRoundFlight: Signal<Bool, NoError>
    public let singleFlightStatus: Signal<String, NoError>
    public let goToFlightResults: Signal<SearchFlightEnvelope, NoError>
    public let flightsAreLoading: Signal<Bool, NoError>
    public let flightsAreError: Signal<String, NoError>
    public let showErrorOccured: Signal<(), NoError>
    public let selectedDate: Signal<(first: Date, second: Date?), NoError>
    public let selectedSingleDate: Signal<Date, NoError>
    public let hideReturnLabels: Signal<Bool, NoError>
    public let singleFlightDate: Signal<Bool, NoError>
    
    public var inputs: PickDatesViewModelInputs { return self }
    public var outputs: PickDatesViewModelOutputs { return self }
}


private func somehowToCurlForceUpdate(_ force: SearchFlightParams) {
    let forceSandbox = "https://sandbox.tiket.com/fl/fu/\(force.fromAirport ?? "")/\(force.toAirport ?? "")/\(force.departDate ?? "")/\(force.adult ?? 1)/\(force.child ?? 0)/\(force.infant ?? 0)/GARUDA?Preview"
    print("Somehow to Curl Force Update: \(forceSandbox)")
    if let sample = URL(string: forceSandbox) {
        var request = URLRequest(url: sample)
        request.httpMethod = "GET"
        let session = URLSession.shared
        session.dataTask(with: request).resume()
    }
}

