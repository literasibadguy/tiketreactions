//
//  PickDatesHotelViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 08/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol PickDatesHotelViewModelInputs {
    func configureWith(selected: AutoHotelResult, searchHotel: SearchHotelParams)
    func pickStartDate(start: Date)
    func pickEndDate(end: Date)
    func shouldClearDate(shouldFalse: Bool)
    func tappedCancelButton()
    func tappedHotelFindButton()
    func viewDidLoad()
}

public protocol PickDatesHotelViewModelOutputs {
    var checkInDateText: Signal<String, NoError> { get }
    var checkOutDateText: Signal<String, NoError> { get }
    var rangesNightText: Signal<String, NoError> { get }
    var overNightAlertText: Signal<String, NoError> { get }
    var bookingText: Signal<String, NoError> { get }
    var goToResults: Signal<(AutoHotelResult, SearchHotelParams, HotelBookingSummary), NoError> { get }
    var enabledHotelResultsButton: Signal<Bool, NoError> { get }
    var dismissPickDate: Signal<(), NoError> { get }
}

public protocol PickDatesHotelViewModelType {
    var inputs: PickDatesHotelViewModelInputs { get }
    var outputs: PickDatesHotelViewModelOutputs { get }
}

public final class PickDatesHotelViewModel: PickDatesHotelViewModelType, PickDatesHotelViewModelInputs, PickDatesHotelViewModelOutputs {
    public init() {
        
        let current = Signal.combineLatest(self.configDataProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        let param = current.signal.map(second)
        let selectedContent = current.signal.map(first)
        
        let initialDate = self.viewDidLoadProperty.signal.mapConst(Date())
        let initialDateText = self.viewDidLoadProperty.signal.mapConst("")
        
        let textFirstDate = self.startDateProperty.signal.skipNil().map { Format.date(secondsInUTC: $0.timeIntervalSince1970, template: "yyyy-MM-dd") }
        let displayFirstDate = self.startDateProperty.signal.skipNil().map { Format.date(secondsInUTC: $0.timeIntervalSince1970, template: "E, d MMM") }
        
        let checkoutSignText = textFirstDate.signal.mapConst(Localizations.CheckoutDateTitle)
        
        let textEndDate = self.endDateProperty.signal.skipNil().map { Format.date(secondsInUTC: $0.timeIntervalSince1970, template: "yyyy-MM-dd") }
        let displayEndDate = self.endDateProperty.signal.skipNil().map { Format.date(secondsInUTC: $0.timeIntervalSince1970, template: "E, d MMM") }
        
        let rangedDate = Signal.combineLatest(self.startDateProperty.signal.skipNil(), self.endDateProperty.signal.skipNil()).map { (arg) -> Int in
            let (start, end) = arg
            return AppEnvironment.current.calendar.dateComponents([.day], from: start, to: end).day!
        }.takeWhen(self.endDateProperty.signal.ignoreValues())
        
        self.rangesNightText = Signal.merge(self.viewDidLoadProperty.signal.mapConst(Localizations.HowNightsTitle), rangedDate.signal.map { Localizations.CountNightsTitle($0) }.takeWhen(self.endDateProperty.signal.ignoreValues()), self.startDateProperty.signal.mapConst(Localizations.HowNightsTitle))
        
        self.overNightAlertText = rangedDate.filter { $0 >= 11 }.map { _ in Localizations.MaximumNightsAlertTitle }
        
        self.checkInDateText = Signal.merge(displayFirstDate.skipNil(), initialDateText)
        self.checkOutDateText = Signal.merge(displayEndDate.skipNil(), checkoutSignText, initialDateText)
        
        let findHotelParam = Signal.combineLatest(param, textFirstDate.skipNil(), textEndDate.skipNil(), rangedDate).map { (arg) -> SearchHotelParams in
            let (current, first, end, ranged) = arg
            return current
                |> SearchHotelParams.lens.startDate .~ first
                |> SearchHotelParams.lens.endDate .~ end
                |> SearchHotelParams.lens.night .~ ranged
        }
        
        self.enabledHotelResultsButton = Signal.merge(self.startDateProperty.signal.mapConst(false), self.endDateProperty.signal.map { !$0.isNil }, self.clearDateProperty.signal)
        
        self.bookingText = Signal.merge(self.viewDidLoadProperty.signal.mapConst(Localizations.CheckinPickTitle), self.startDateProperty.signal.mapConst(Localizations.CheckoutPickTitle), self.endDateProperty.signal.mapConst(Localizations.FindHotelTitle), self.clearDateProperty.signal.mapConst(Localizations.MaximumNightsReminderTitle))
        
        let findHotelEvent = findHotelParam.switchMap { hotelParam in
            AppEnvironment.current.apiService.fetchHotelResults(params: hotelParam).demoteErrors()
        }
        
        let tempSummary = Signal.combineLatest(self.checkInDateText.signal, self.checkOutDateText.signal, findHotelParam.signal.map { $0.adult! }).switchMap { startDate, endDate, guest -> SignalProducer<HotelBookingSummary, NoError> in
            let summary = .defaults
                |> HotelBookingSummary.lens.dateRange .~ "\(startDate) - \(endDate)"
                |> HotelBookingSummary.lens.guestCount .~ "\(guest) \(Localizations.GuestTitle)"
            return SignalProducer(value: summary)
        }.materialize()
        
        self.goToResults = Signal.combineLatest(selectedContent, findHotelParam, tempSummary.values()).takeWhen(self.hotelFindButtonProperty.signal)
        self.dismissPickDate = self.cancelButtonProperty.signal
    }
    
    fileprivate let configDataProperty = MutableProperty<(AutoHotelResult, SearchHotelParams)?>(nil)
    public func configureWith(selected: AutoHotelResult, searchHotel: SearchHotelParams) {
        self.configDataProperty.value = (selected, searchHotel)
    }
    
    fileprivate let startDateProperty = MutableProperty<Date?>(nil)
    public func pickStartDate(start: Date) {
        self.startDateProperty.value = start
    }
    
    fileprivate let endDateProperty = MutableProperty<Date?>(nil)
    public func pickEndDate(end: Date) {
        self.endDateProperty.value = end
    }
    
    fileprivate let clearDateProperty = MutableProperty(false)
    public func shouldClearDate(shouldFalse: Bool) {
        self.clearDateProperty.value = shouldFalse
    }
    
    fileprivate let cancelButtonProperty = MutableProperty(())
    public func tappedCancelButton() {
        self.cancelButtonProperty.value = ()
    }
    
    fileprivate let hotelFindButtonProperty = MutableProperty(())
    public func tappedHotelFindButton() {
        self.hotelFindButtonProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let checkInDateText: Signal<String, NoError>
    public let checkOutDateText: Signal<String, NoError>
    public let rangesNightText: Signal<String, NoError>
    public let overNightAlertText: Signal<String, NoError>
    public let bookingText: Signal<String, NoError>
    public let goToResults: Signal<(AutoHotelResult, SearchHotelParams, HotelBookingSummary), NoError>
    public let enabledHotelResultsButton: Signal<Bool, NoError>
    public let dismissPickDate: Signal<(), NoError>
    
    public var inputs: PickDatesHotelViewModelInputs { return self }
    public var outputs: PickDatesHotelViewModelOutputs { return self }
}
