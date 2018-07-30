//
//  HotelDetailsNavViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 26/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol HotelDetailsNavViewModelInputs {
    func configureWith(hotel: HotelResult)
    func tappedButtonCancel()
    func viewDidLoad()
}

public protocol HotelDetailsNavViewModelOutputs {
    var hotelNameText: Signal<String, NoError> { get }
    var dismissViewController: Signal<(), NoError> { get }
}

public protocol HotelDetailsNavViewModelType {
    var inputs: HotelDetailsNavViewModelInputs { get }
    var outputs: HotelDetailsNavViewModelOutputs { get }
}

public final class HotelDetailsNavViewModel: HotelDetailsNavViewModelType, HotelDetailsNavViewModelInputs, HotelDetailsNavViewModelOutputs {
    
    public init() {
        
        let selectedHotel = Signal.combineLatest(self.configDataProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        self.hotelNameText = Signal.merge(self.viewDidLoadProperty.signal.mapConst(""), selectedHotel.map { $0.name ?? "" })
        self.dismissViewController = self.tappedCancelProperty.signal.ignoreValues()
    }
    
    fileprivate let configDataProperty = MutableProperty<HotelResult?>(nil)
    public func configureWith(hotel: HotelResult) {
        self.configDataProperty.value = hotel
    }
    
    fileprivate let tappedCancelProperty = MutableProperty(())
    public func tappedButtonCancel() {
        self.tappedCancelProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let hotelNameText: Signal<String, NoError>
    public let dismissViewController: Signal<(), NoError>
    
    public var inputs: HotelDetailsNavViewModelInputs { return self }
    public var outputs: HotelDetailsNavViewModelOutputs { return self }
    
}
