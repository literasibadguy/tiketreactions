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
import TiketAPIs

public protocol HotelDirectsViewModelInputs {
    func configureWith(hotelDirect: HotelDirect)
    func tappedRoomAvailable(availableRoom: AvailableRoom)
    func viewWillAppear(animated: Bool)
    func viewDidAppear(animated: Bool)
    func viewDidLoad()
}

public protocol HotelDirectsViewModelOutputs {
    var goToRoomAvailable: Signal<(HotelDirect, AvailableRoom), NoError> { get }
    var loadHotelDirect: Signal<HotelDirect, NoError> { get }
}

public protocol HotelDirectsViewModelType {
    var inputs: HotelDirectsViewModelInputs { get }
    var outputs: HotelDirectsViewModelOutputs { get }
}

public final class HotelDirectsViewModel: HotelDirectsViewModelType, HotelDirectsViewModelInputs, HotelDirectsViewModelOutputs {
    
    public init() {
        
        let project = Signal.combineLatest(self.configDataProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        self.loadHotelDirect = project
        
        self.goToRoomAvailable = Signal.combineLatest(project, self.tappedRoomAvailableProperty.signal.skipNil())
    }
    
    fileprivate let configDataProperty = MutableProperty<HotelDirect?>(nil)
    public func configureWith(hotelDirect: HotelDirect) {
        self.configDataProperty.value = hotelDirect
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
    
    public let goToRoomAvailable: Signal<(HotelDirect, AvailableRoom), NoError>
    public let loadHotelDirect: Signal<HotelDirect, NoError>
    
    public var inputs: HotelDirectsViewModelInputs { return self }
    public var outputs: HotelDirectsViewModelOutputs { return self }
}



