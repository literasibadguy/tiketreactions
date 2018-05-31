//
//  AvailableRoomListsViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 13/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol AvailableRoomListsViewModelInputs {
    func configureWith(hotelDirect: HotelDirect, booking: HotelBookingSummary)
    func selected(room: AvailableRoom)
    func viewDidAppear(_ animated: Bool)
    func viewDidLoad()
}

public protocol AvailableRoomListsViewModelOutputs {
    var rooms: Signal<[AvailableRoom], NoError> { get }
    var goToCheckout: Signal<(HotelDirect, HotelBookingSummary, AvailableRoom), NoError> { get }
}

public protocol AvailableRoomListsViewModelType {
    var inputs: AvailableRoomListsViewModelInputs { get }
    var outputs: AvailableRoomListsViewModelOutputs { get }
}

public final class AvailableRoomListsViewModel: AvailableRoomListsViewModelType, AvailableRoomListsViewModelInputs, AvailableRoomListsViewModelOutputs {

    public init() {
        let hotelDirect = Signal.combineLatest(self.configHotelProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        
        self.rooms = hotelDirect.map { $0.0.availableRooms.roomResults }
        
        let updateSummary = Signal.combineLatest(hotelDirect.map { $0.0.breadcrumb.businessName }, hotelDirect.map { $0.1 }, self.selectedRoomProperty.signal.skipNil()).switchMap { businessName, direct, selectedRoom -> SignalProducer<HotelBookingSummary, NoError> in
            
            let updated = direct
                |> HotelBookingSummary.lens.hotelName .~ "\(businessName)"
                |> HotelBookingSummary.lens.roomType .~ "\(selectedRoom.roomName)"
            
            return SignalProducer(value: updated)
        }.materialize()
        
        self.goToCheckout = Signal.combineLatest(hotelDirect.map { $0.0 }, updateSummary.values(), self.selectedRoomProperty.signal.skipNil()).takeWhen(self.selectedRoomProperty.signal.ignoreValues())
    }
    
    fileprivate var configHotelProperty = MutableProperty<(HotelDirect, HotelBookingSummary)?>(nil)
    public func configureWith(hotelDirect: HotelDirect, booking: HotelBookingSummary) {
        self.configHotelProperty.value = (hotelDirect, booking)
    }
    
    fileprivate var selectedRoomProperty = MutableProperty<AvailableRoom?>(nil)
    public func selected(room: AvailableRoom) {
        self.selectedRoomProperty.value = room
    }
    
    fileprivate var viewDidAppearProperty = MutableProperty(false)
    public func viewDidAppear(_ animated: Bool) {
        self.viewDidAppearProperty.value = animated
    }
    
    fileprivate var viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let rooms: Signal<[AvailableRoom], NoError>
    public let goToCheckout: Signal<(HotelDirect, HotelBookingSummary, AvailableRoom), NoError>
    
    public var inputs: AvailableRoomListsViewModelInputs { return self }
    public var outputs: AvailableRoomListsViewModelOutputs { return self }
}


