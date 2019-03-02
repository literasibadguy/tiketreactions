//
//  HotelDirectsViewModel.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 07/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol HotelDirectsViewModelInputs {
    func configureWith(selected: HotelResult, hotelDirect: HotelDirect, booking: HotelBookingSummary)
    func tapHotelFacility(_ facilities: String)
    func tappedMapEmbed()
    func tappedRoomAvailable(availableRoom: AvailableRoom)
    func viewWillAppear(animated: Bool)
    func viewDidAppear(animated: Bool)
    func viewDidLoad()
}

public protocol HotelDirectsViewModelOutputs {
    var goToFacilities: Signal<[HotelDirect.AvailableFacility], NoError> { get }
    var goToRoomAvailable: Signal<(HotelDirect, AvailableRoom, HotelBookingSummary), NoError> { get }
    var goToFullMapHotel: Signal<HotelResult, NoError> { get }
    var loadMinimalHotelDirect: Signal<HotelDirect, NoError> { get }
    var loadHotelDirect: Signal<(HotelResult, HotelDirect), NoError> { get }
    var directsAreLoading: Signal<Bool, NoError> { get }
}

public protocol HotelDirectsViewModelType {
    var inputs: HotelDirectsViewModelInputs { get }
    var outputs: HotelDirectsViewModelOutputs { get }
}

public final class HotelDirectsViewModel: HotelDirectsViewModelType, HotelDirectsViewModelInputs, HotelDirectsViewModelOutputs {
    
    public init() {
        
        let hotelDirect = Signal.combineLatest(self.configDataProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        let direct = hotelDirect.map(second)
        
        self.loadHotelDirect = Signal.combineLatest(hotelDirect.map { $0.0 }, hotelDirect.map { $0.1 })
        
        self.loadMinimalHotelDirect = .empty
        self.goToRoomAvailable = .empty
        
        self.goToFullMapHotel = hotelDirect.signal.map(first).takeWhen(self.tappedMapProperty.signal)
        
        self.directsAreLoading = Signal.combineLatest(self.configDataProperty.signal.ignoreValues(), self.viewDidLoadProperty.signal).mapConst(false)
        
        self.goToFacilities = direct.map { $0.availFacilities }.takeWhen(self.tapFacilityProperty.signal.ignoreValues())
    }
    
    fileprivate let configDataProperty = MutableProperty<(HotelResult, HotelDirect, HotelBookingSummary)?>(nil)
    public func configureWith(selected: HotelResult, hotelDirect: HotelDirect, booking: HotelBookingSummary) {
        self.configDataProperty.value = (selected, hotelDirect, booking)
    }
    
    fileprivate let tapFacilityProperty = MutableProperty("")
    public func tapHotelFacility(_ facilities: String) {
        self.tapFacilityProperty.value = facilities
    }
    
    fileprivate let tappedMapProperty = MutableProperty(())
    public func tappedMapEmbed() {
        self.tappedMapProperty.value = ()
    }
    
    fileprivate let tappedRoomAvailableProperty = MutableProperty<AvailableRoom?>(nil)
    public func tappedRoomAvailable(availableRoom: AvailableRoom) {
        self.tappedRoomAvailableProperty.value = availableRoom
    }
    
    fileprivate let viewWillAppearAnimatedProperty = MutableProperty(false)
    public func viewWillAppear(animated: Bool) {
        self.viewWillAppearAnimatedProperty.value = animated
    }
    
    fileprivate let viewDidAppearAnimatedProperty = MutableProperty(false)
    public func viewDidAppear(animated: Bool) {
        self.viewDidAppearAnimatedProperty.value = animated
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let goToFacilities: Signal<[HotelDirect.AvailableFacility], NoError>
    public let goToRoomAvailable: Signal<(HotelDirect, AvailableRoom, HotelBookingSummary), NoError>
    public let goToFullMapHotel: Signal<HotelResult, NoError>
    public let loadMinimalHotelDirect: Signal<HotelDirect, NoError>
    public let loadHotelDirect: Signal<(HotelResult, HotelDirect), NoError>
    public let directsAreLoading: Signal<Bool, NoError>
    
    public var inputs: HotelDirectsViewModelInputs { return self }
    public var outputs: HotelDirectsViewModelOutputs { return self }
}



