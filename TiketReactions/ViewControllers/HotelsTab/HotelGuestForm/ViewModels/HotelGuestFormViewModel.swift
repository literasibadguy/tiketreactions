//
//  HotelGuestFormViewModel.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 15/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import Result
import TiketAPIs

public protocol HotelGuestFormViewModelInputs {
    func configureWith(hotelDirect: HotelDirect, availableRoom: AvailableRoom)
    func viewDidAppear(animated: Bool)
    func viewDidLoad()
    func viewWillAppear(animated: Bool)
}

public protocol HotelGuestFormViewModelOutputs {
    var loadHotelAndAvailableRoomIntoDataSource: Signal<(HotelDirect, AvailableRoom), NoError> { get }
}

public protocol HotelGuestFormViewModelType {
    var inputs: HotelGuestFormViewModelInputs { get }
    var outputs: HotelGuestFormViewModelOutputs { get }
}

public final class HotelGuestFormViewModel: HotelGuestFormViewModelType, HotelGuestFormViewModelInputs, HotelGuestFormViewModelOutputs {
    
    public init() {
        self.loadHotelAndAvailableRoomIntoDataSource = self.configDataProperty.signal.skipNil()
    }
    
    fileprivate let configDataProperty = MutableProperty<(HotelDirect, AvailableRoom)?>(nil)
    public func configureWith(hotelDirect: HotelDirect, availableRoom: AvailableRoom) {
        self.configDataProperty.value = (hotelDirect, availableRoom)
    }
    
    fileprivate let viewDidAppearAnimatedProperty = MutableProperty(false)
    public func viewDidAppear(animated: Bool) {
        self.viewDidAppearAnimatedProperty.value = animated
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    fileprivate let viewWillAppearAnimatedProperty = MutableProperty(false)
    public func viewWillAppear(animated: Bool) {
        self.viewWillAppearAnimatedProperty.value = animated
    }
    
    public let loadHotelAndAvailableRoomIntoDataSource: Signal<(HotelDirect, AvailableRoom), NoError>
    
    public var inputs: HotelGuestFormViewModelInputs { return self }
    public var outputs: HotelGuestFormViewModelOutputs { return self }
}
