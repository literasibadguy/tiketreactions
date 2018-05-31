//
//  HotelFormViewModel.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 13/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol HotelFormViewModelInputs {
    
    func destinationButtonTapped()
    func destinationHotelSelected(row: AutoHotelResult)
    
    func guestButtonTapped()
    func roomGuestSelected(param: SearchHotelParams)
    func selectedCounts(guest: Int, room: Int)
    
    func selectDatePressed()
    
    func viewDidLoad()
}

public protocol HotelFormViewModelOutputs {
    var dismissDestinationHotelList: Signal<(), NoError> { get }
    var destinationHotelLabelText: Signal<String, NoError> { get }
    var guestHotelLabelText: Signal<String, NoError> { get }
    var roomGuestFilledParam: Signal<(Int, Int), NoError> { get }
    var showDestinationHotelList: Signal<(), NoError> { get }
    var showGuestRoomPick: Signal<(Int, Int), NoError> { get }
    var goToPickDate: Signal<(AutoHotelResult, SearchHotelParams), NoError> { get }
}

public protocol HotelFormViewModelType {
    var inputs: HotelFormViewModelInputs { get }
    var outputs: HotelFormViewModelOutputs { get }
}

public final class HotelFormViewModel: HotelFormViewModelType, HotelFormViewModelInputs, HotelFormViewModelOutputs {
    
    public init() {
        
        let initialParam = SearchHotelParams.defaults
        let defaultDestination = AutoHotelResult.defaults
        let initialDestination = self.viewDidLoadProperty.signal.mapConst(defaultDestination)
        let initialGuest = self.viewDidLoadProperty.signal.mapConst(2)
        let initialRoom = self.viewDidLoadProperty.signal.mapConst(1)
        
        let destination = Signal.merge(self.destinationHotelSelectedProperty.signal.skipNil(), initialDestination)
        let guest = Signal.merge(self.roomGuestSelectedProperty.signal.skipNil().map { Int($0.adult!) ?? 0 }, initialGuest)
        let room = Signal.merge(self.roomGuestSelectedProperty.signal.skipNil().map { $0.room! }, initialRoom)
        
        let guestCount = Signal.merge(self.selectedCountsProperty.signal.skipNil().map { $0.0 }, initialGuest)
        let roomCount = Signal.merge(self.selectedCountsProperty.signal.skipNil().map { $0.1 }, initialRoom)
        
        let pickDateEvent = Signal.combineLatest(destination, guest, room).takeWhen(self.selectDatePressedProperty.signal).map { (arg) -> SearchHotelParams in
            
            let (hotelResult, guest, room) = arg
            return SearchHotelParams.defaults
                |> SearchHotelParams.lens.adult .~ String(guest)
                |> SearchHotelParams.lens.room .~ room
                |> SearchHotelParams.lens.query .~ hotelResult.category.components(separatedBy: " ").first!
        }
        
        let pickDateRequest = Signal.combineLatest(destination, guestCount, roomCount).switchMap { (arg) -> SignalProducer<SearchHotelParams, NoError> in
            
            let (hotelResult, guest, room) = arg
            let param = SearchHotelParams.defaults
                |> SearchHotelParams.lens.adult .~ String(guest)
                |> SearchHotelParams.lens.room .~ room
                |> SearchHotelParams.lens.query .~ hotelResult.category.replacingOccurrences(of: " ", with: "%20")
            return SignalProducer(value: param)
        }.materialize()
        
        self.destinationHotelLabelText = self.destinationHotelSelectedProperty.signal.skipNil().map { selected in
            return selected.category
        }
        self.guestHotelLabelText = Signal.combineLatest(guestCount, roomCount).map { "\(Localizations.GuestTitle($0)), \(Localizations.RoomTitle($1))" }
        
        self.dismissDestinationHotelList = self.destinationHotelSelectedProperty.signal.ignoreValues().ck_delay(.milliseconds(400), on: AppEnvironment.current.scheduler)
        
        self.showDestinationHotelList = self.destinationButtonTappedProperty.signal
        self.showGuestRoomPick = Signal.combineLatest(guestCount, roomCount).takeWhen(self.guestButtonTappedProperty.signal)
        
        self.roomGuestFilledParam = .empty
        self.goToPickDate = Signal.combineLatest(destination, pickDateRequest.values()).takeWhen(self.selectDatePressedProperty.signal)
    }
    
    fileprivate let destinationButtonTappedProperty = MutableProperty(())
    public func destinationButtonTapped() {
        self.destinationButtonTappedProperty.value = ()
    }
    
    fileprivate let destinationHotelSelectedProperty = MutableProperty<AutoHotelResult?>(nil)
    public func destinationHotelSelected(row: AutoHotelResult) {
        self.destinationHotelSelectedProperty.value = row
    }
    
    fileprivate let roomGuestSelectedProperty = MutableProperty<SearchHotelParams?>(nil)
    public func roomGuestSelected(param: SearchHotelParams) {
        self.roomGuestSelectedProperty.value = param
    }
    
    fileprivate let selectedCountsProperty = MutableProperty<(Int, Int)?>(nil)
    public func selectedCounts(guest: Int, room: Int) {
        self.selectedCountsProperty.value = (guest, room)
    }
    
    fileprivate let guestButtonTappedProperty = MutableProperty(())
    public func guestButtonTapped() {
        self.guestButtonTappedProperty.value = ()
    }
    
    fileprivate let selectDatePressedProperty = MutableProperty(())
    public func selectDatePressed() {
        self.selectDatePressedProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let dismissDestinationHotelList: Signal<(), NoError>
    public let destinationHotelLabelText: Signal<String, NoError>
    public let guestHotelLabelText: Signal<String, NoError>
    public let showDestinationHotelList: Signal<(), NoError>
    public let roomGuestFilledParam: Signal<(Int, Int), NoError>
    public let showGuestRoomPick: Signal<(Int, Int), NoError>
    public let goToPickDate: Signal<(AutoHotelResult, SearchHotelParams), NoError>
    
    public var inputs: HotelFormViewModelInputs { return self }
    public var outputs: HotelFormViewModelOutputs { return self }
}
