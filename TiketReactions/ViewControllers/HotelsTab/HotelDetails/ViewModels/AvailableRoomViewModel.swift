//
//  AvailableRoomViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 11/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol AvailableRoomViewModelInputs {
    func configureWith(room: AvailableRoom)
    func tappedBookingButton()
}

public protocol AvailableRoomViewModelOutputs {
    var titleRoomText: Signal<String, NoError> { get }
    var descriptionRoomText: Signal<String, NoError> { get }
    var priceRoomText: Signal<String, NoError> { get }
    var availableRoomText: Signal<String, NoError> { get }
    var imageRoomUrl: Signal<URL?, NoError> { get }
    var notifyDelegateNextCheckout: Signal<AvailableRoom, NoError> { get }
}

public protocol AvailableRoomViewModelType {
    var inputs: AvailableRoomViewModelInputs { get }
    var outputs: AvailableRoomViewModelOutputs { get }
}


public final class AvailableRoomViewModel: AvailableRoomViewModelType, AvailableRoomViewModelInputs, AvailableRoomViewModelOutputs {
    
    public init() {
        let room = self.configDataProperty.signal.skipNil()
        
        self.titleRoomText = room.map { $0.roomName }
        self.descriptionRoomText = room.map { includedBreakfast($0.withBreakfasts) }
        self.priceRoomText = room.map { "\(Format.symbolForCurrency($0.currency)) \(Format.currency($0.price, country: "Rp")) / malam" }
        self.availableRoomText = room.map { Localizations.AvailableroomTitle($0.roomAvailable) }
        self.imageRoomUrl = room.map { $0.photoUrl }.map { URL.init(string: $0)! }
        
        self.notifyDelegateNextCheckout = room.takeWhen(self.tapBookingProperty.signal)
    }
    
    fileprivate let configDataProperty = MutableProperty<AvailableRoom?>(nil)
    public func configureWith(room: AvailableRoom) {
        self.configDataProperty.value = room
    }
    
    fileprivate let tapBookingProperty = MutableProperty(())
    public func tappedBookingButton() {
        self.tapBookingProperty.value = ()
    }
    
    public let titleRoomText: Signal<String, NoError>
    public let descriptionRoomText: Signal<String, NoError>
    public let priceRoomText: Signal<String, NoError>
    public let availableRoomText: Signal<String, NoError>
    public let imageRoomUrl: Signal<URL?, NoError>
    public let notifyDelegateNextCheckout: Signal<AvailableRoom, NoError>
    
    public var inputs: AvailableRoomViewModelInputs { return self }
    public var outputs: AvailableRoomViewModelOutputs { return self }
}

private func includedBreakfast(_ status: String) -> String {
    switch status {
    case "0":
        return Localizations.UnavailablebreakfastTitle
    case "1":
        return Localizations.AvailablebreakfastTitle
    default:
        return "Tidak diketahui"
    }
}

