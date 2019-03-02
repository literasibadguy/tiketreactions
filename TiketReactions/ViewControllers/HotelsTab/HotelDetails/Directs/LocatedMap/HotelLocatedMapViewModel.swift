//
//  HotelLocatedMapViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 12/01/19.
//  Copyright © 2019 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol HotelLocatedMapViewModelInputs {
    func configureWith(hotel: HotelResult)
    func cancelButtonTapped()
    func viewDidLoad()
}

public protocol HotelLocatedMapViewModelOutputs {
    var hotelTitleText: Signal<String, NoError> { get }
    var hotelMap: Signal<HotelResult, NoError> { get }
    var dismissFullMap: Signal<(), NoError> { get }
}

public protocol HotelLocatedMapViewModelType {
    var inputs: HotelLocatedMapViewModelInputs { get }
     var outputs: HotelLocatedMapViewModelOutputs { get }
}

public final class HotelLocatedMapViewModel: HotelLocatedMapViewModelType, HotelLocatedMapViewModelInputs, HotelLocatedMapViewModelOutputs {
    
    public init() {
        let current = Signal.combineLatest(self.viewDidLoadProperty.signal, self.configHotelProperty.signal.skipNil()).map(second)
        
        self.hotelTitleText = current.signal.map { $0.name }.skipNil()
        
        self.hotelMap = current.signal
        
        self.dismissFullMap = self.cancelButtonTappedProperty.signal
    }
    
    private let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    private let cancelButtonTappedProperty = MutableProperty(())
    public func cancelButtonTapped() {
        self.cancelButtonTappedProperty.value = ()
    }
    
    private let configHotelProperty = MutableProperty<HotelResult?>(nil)
    public func configureWith(hotel: HotelResult) {
        self.configHotelProperty.value = hotel
    }
    
    public let hotelTitleText: Signal<String, NoError>
    public let hotelMap: Signal<HotelResult, NoError>
    public let dismissFullMap: Signal<(), NoError>
    
    public var inputs: HotelLocatedMapViewModelInputs { return self }
    public var outputs: HotelLocatedMapViewModelOutputs { return self }
}
