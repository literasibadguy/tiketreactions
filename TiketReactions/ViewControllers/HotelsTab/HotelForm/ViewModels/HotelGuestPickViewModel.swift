//
//  HotelGuestPickViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 26/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels
import UIKit

public protocol HotelGuestPickViewModelInputs {
    func configureWith(guest: Int, room: Int)
    func configureWith(param: SearchHotelParams)
    func roomStepperHasChanged(_ stepper: Double)
    func guestStepperHasChanged(_ stepper: Double)
    func continueButtonTapped()
    func viewDidLoad()
}

public protocol HotelGuestPickViewModelOutputs {
    var guestValueText: Signal<String, NoError> { get }
    var roomValueText: Signal<String, NoError> { get }
    var guestValue: Signal<Double, NoError> { get }
    var roomValue: Signal<Double, NoError> { get }
    var dismissPickGuest: Signal<SearchHotelParams, NoError> { get }
    var dismissCounts: Signal<(Int, Int), NoError> { get }
}

public protocol HotelGuestPickViewModelType {
    var inputs: HotelGuestPickViewModelInputs { get }
    var outputs: HotelGuestPickViewModelOutputs { get }
}

public final class HotelGuestPickViewModel: HotelGuestPickViewModelType, HotelGuestPickViewModelInputs, HotelGuestPickViewModelOutputs {
    
    public init() {
        
        let paramsChanged = Signal.combineLatest(self.configParamProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        let countChanged = Signal.combineLatest(self.configCountProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        let guestChanged = Signal.merge(countChanged.map { Double($0.0) }, self.guestStepperValueProperty.signal.skipNil()).map { Int($0) }
        let roomChanged = Signal.merge(countChanged.map { Double($0.1) }, self.roomStepperValueProperty.signal.skipNil()).map { Int($0) }
        
        self.guestValue = countChanged.map { Double($0.0) }
        self.roomValue = countChanged.map { Double($0.1) }
        
        self.guestValueText = guestChanged.map { "\(Int($0)) Tamu" }
        self.roomValueText = roomChanged.map { "\(Int($0)) Kamar" }
        
        self.dismissPickGuest = Signal.combineLatest(paramsChanged, guestChanged, roomChanged).map { param, guest, room in
            let custom = param
                |> SearchHotelParams.lens.adult .~ String(guest)
                |> SearchHotelParams.lens.room .~ room
            
            return custom
        }.takeWhen(self.continueButtonProperty.signal)
        
        self.dismissCounts = Signal.combineLatest(guestChanged, roomChanged).takeWhen(self.continueButtonProperty.signal)
    }
    
    fileprivate let configCountProperty = MutableProperty<(Int, Int)?>(nil)
    public func configureWith(guest: Int, room: Int) {
        self.configCountProperty.value = (guest, room)
    }
    
    fileprivate let configParamProperty = MutableProperty<SearchHotelParams?>(nil)
    public func configureWith(param: SearchHotelParams) {
        self.configParamProperty.value = param
    }
    
    fileprivate let roomStepperValueProperty = MutableProperty<Double?>(nil)
    public func roomStepperHasChanged(_ stepper: Double) {
        self.roomStepperValueProperty.value = stepper
    }
    
    fileprivate let guestStepperValueProperty = MutableProperty<Double?>(nil)
    public func guestStepperHasChanged(_ stepper: Double) {
        self.guestStepperValueProperty.value = stepper
    }
    
    fileprivate let continueButtonProperty = MutableProperty(())
    public func continueButtonTapped() {
        self.continueButtonProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let guestValueText: Signal<String, NoError>
    public let roomValueText: Signal<String, NoError>
    public let guestValue: Signal<Double, NoError>
    public let roomValue: Signal<Double, NoError>
    public let dismissPickGuest: Signal<SearchHotelParams, NoError>
    public let dismissCounts: Signal<(Int, Int), NoError>
    
    public var inputs: HotelGuestPickViewModelInputs { return self }
    public var outputs: HotelGuestPickViewModelOutputs { return self }
}
