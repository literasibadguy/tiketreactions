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
    func configureWith(flightParams: SearchFlightParams)
    func tappedButtonCancel()
    func startDate(_ selected: Date)
    func endDate(_ selected: Date)
    func flightButtonTapped()
    func viewDidLoad()
}

public protocol PickDatesViewModelOutputs {
    var dismissPickDates: Signal<(), NoError> { get }
    var startDateText: Signal<String, NoError> { get }
    var endDateText: Signal<String, NoError> { get }
    var singleFlightStatus: Signal<String, NoError> { get }
    var goToSingleFlightResults: Signal<SearchSingleFlightParams, NoError> { get }
    var goToFlightResults: Signal<SearchFlightParams, NoError> { get }
}

public protocol PickDatesViewModelType {
    var inputs: PickDatesViewModelInputs { get }
    var outputs: PickDatesViewModelOutputs { get }
}

public final class PickDatesViewModel: PickDatesViewModelType, PickDatesViewModelInputs, PickDatesViewModelOutputs {
    
    init() {
        self.dismissPickDates = self.tappedCancelProperty.signal
        
        let configData = Signal.combineLatest(self.configDataProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        let initialDateText = self.viewDidLoadProperty.signal.mapConst("")
        
        // GET FIRST DATE
        var components = AppEnvironment.current.calendar.dateComponents([.year, .month], from: Date())
        components.day = 1
        
        // GET FIRST DATE FOR SECTION
        let textFirstDate = Signal.merge(self.startDateProperty.signal.skipNil().map { Format.date(secondsInUTC: $0.timeIntervalSince1970, template: "yyyy-MM-dd")! }, initialDateText)
        let showFirstDate = Signal.merge(self.startDateProperty.signal.skipNil().map { Format.date(secondsInUTC: $0.timeIntervalSince1970, template: "EEEE, MMM d, yyyy")! }, initialDateText)
        let textEndDate = self.endDateProperty.signal.skipNil().map { Format.date(secondsInUTC: $0.timeIntervalSince1970, template: "yyyy-MM-dd")! }
        let showEndDate = Signal.merge(self.endDateProperty.signal.skipNil().map { Format.date(secondsInUTC: $0.timeIntervalSince1970, template: "EEEE, MMM d, yyyy")! }, initialDateText)
        
        let resetDate = self.startDateProperty.signal.map { _ in "" }
        
        self.startDateText = showFirstDate.signal.map { $0 }
        self.endDateText = Signal.merge(showEndDate, resetDate)
        
        let singleParam = Signal.combineLatest(configData, textFirstDate.filter { !$0.isEmpty }, textEndDate.filter { $0.isEmpty }).map { (arg) -> SearchSingleFlightParams in
            let (config, first, _) = arg
            let custom = .defaults
                |> SearchSingleFlightParams.lens.fromAirport .~ config.fromAirport
                |> SearchSingleFlightParams.lens.toAirport .~ config.toAirport
                |> SearchSingleFlightParams.lens.departDate .~ first
                |> SearchSingleFlightParams.lens.adult .~ config.adult
                |> SearchSingleFlightParams.lens.child .~ config.child
                |> SearchSingleFlightParams.lens.infant .~ config.infant
            
            return custom
        }
        
        let paramCurrents = Signal.combineLatest(configData, textFirstDate, textEndDate.filter { !$0.isEmpty }).map { (arg) -> SearchFlightParams in
            
            let (config, firstDate, endDate) = arg
            let custom = config
                |> SearchFlightParams.lens.departDate .~ firstDate
                |> SearchFlightParams.lens.returnDate .~ endDate
            return custom
        }
        
        self.singleFlightStatus = Signal.merge(singleParam.map { _ in "Penerbangan Satu Tujuan" }, paramCurrents.map { _ in "Penerbangan Pulang Pergi" })
        
        self.goToFlightResults = paramCurrents.takeWhen(self.tappedFlightProperty.signal)
        self.goToSingleFlightResults = singleParam.takeWhen(self.tappedFlightProperty.signal)
    }
    
    fileprivate let configDataProperty = MutableProperty<SearchFlightParams?>(nil)
    public func configureWith(flightParams: SearchFlightParams) {
        self.configDataProperty.value = flightParams
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
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let dismissPickDates: Signal<(), NoError>
    public let startDateText: Signal<String, NoError>
    public let endDateText: Signal<String, NoError>
    public let singleFlightStatus: Signal<String, NoError>
    public let goToSingleFlightResults: Signal<SearchSingleFlightParams, NoError>
    public let goToFlightResults: Signal<SearchFlightParams, NoError>
    
    public var inputs: PickDatesViewModelInputs { return self }
    public var outputs: PickDatesViewModelOutputs { return self }
}

