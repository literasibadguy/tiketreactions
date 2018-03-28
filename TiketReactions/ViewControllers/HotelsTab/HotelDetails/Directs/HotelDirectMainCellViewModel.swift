//
//  HotelDirectMainCellViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 11/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

public protocol HotelDirectMainCellViewModelInputs {
    func configureWith(hotel: HotelDirect)
}

public protocol HotelDirectMainCellViewModelOutputs {
    
}

public protocol HotelDirectMainCellViewModelType {
    var inputs: HotelDirectMainCellViewModelInputs { get }
    var outputs: HotelDirectMainCellViewModelOutputs { get }
}

public final class HotelDirectMainCellViewModel: HotelDirectMainCellViewModelType, HotelDirectMainCellViewModelInputs, HotelDirectMainCellViewModelOutputs {
    
    public init() {
        
    }
    
    fileprivate let configHotelProperty = MutableProperty<HotelDirect?>(nil)
    public func configureWith(hotel: HotelDirect) {
        self.configHotelProperty.value = hotel
    }
    
    public var inputs: HotelDirectMainCellViewModelInputs { return self }
    public var outputs: HotelDirectMainCellViewModelOutputs { return self }
}
