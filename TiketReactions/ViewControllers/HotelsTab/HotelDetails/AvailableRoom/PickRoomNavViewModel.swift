//
//  PickRoomNavViewModel.swift
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

public protocol PickRoomNavViewModelInputs {
    func configureWith(hotelDirect: HotelDirect, booking: HotelBookingSummary)
    func chooseRoomsButtonTapped()
    func viewDidLoad()
}

public protocol PickRoomNavViewModelOutputs {
    var startPriceRoomTitleText: Signal<String, NoError> { get }
    var goToAvailableRooms: Signal<(HotelDirect, HotelBookingSummary), NoError> { get }
}

public protocol PickRoomNavViewModelType {
    var inputs: PickRoomNavViewModelInputs { get }
    var outputs: PickRoomNavViewModelOutputs { get }
}

public final class PickRoomNavViewModel: PickRoomNavViewModelType, PickRoomNavViewModelInputs, PickRoomNavViewModelOutputs {
    
    public init() {
        
        let initial = self.viewDidLoadProperty.signal.mapConst("")
        
        let hotel = self.configHotelProperty.signal.skipNil()
        let firstRoom = hotel.map { $0.0.availableRooms.roomResults.first! }
        
        self.startPriceRoomTitleText = Signal.merge(firstRoom.map { "\(Format.symbolForCurrency($0.currency)) \(Localizations.PricepernightHotelTitle(Format.currency($0.price, country: "Rp")))" }, initial)
        
        self.goToAvailableRooms = hotel.takeWhen(self.roomButtonTapped.signal)
    }
    
    fileprivate let configHotelProperty = MutableProperty<(HotelDirect, HotelBookingSummary)?>(nil)
    public func configureWith(hotelDirect: HotelDirect, booking: HotelBookingSummary) {
        self.configHotelProperty.value = (hotelDirect, booking)
    }
    
    fileprivate let roomButtonTapped = MutableProperty(())
    public func chooseRoomsButtonTapped() {
        self.roomButtonTapped.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let startPriceRoomTitleText: Signal<String, NoError>
    public let goToAvailableRooms: Signal<(HotelDirect, HotelBookingSummary), NoError>
    
    public var inputs: PickRoomNavViewModelInputs { return self }
    public var outputs: PickRoomNavViewModelOutputs { return self }
}
