//
//  FacilityListViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 25/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol FacilityListViewModelInputs {
    func configureWith(_ facilities: [HotelDirect.AvailableFacility])
    func tappedCancelButton()
    func viewDidLoad()
}

public protocol FacilityListViewModelOutputs {
    var facilities: Signal<[HotelDirect.AvailableFacility], NoError> { get }
    var goBack: Signal<(), NoError> { get }
}

public protocol FacilityListViewModelType {
    var inputs: FacilityListViewModelInputs { get }
    var outputs: FacilityListViewModelOutputs { get }
}


public final class FacilityListViewModel: FacilityListViewModelType, FacilityListViewModelInputs, FacilityListViewModelOutputs {
    
    init() {
        
        let current = Signal.combineLatest(self.configDirectProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        self.facilities = current
        
        self.goBack = self.tapCancelProperty.signal
    }
    
    fileprivate let configDirectProperty = MutableProperty<[HotelDirect.AvailableFacility]?>(nil)
    public func configureWith(_ facilities: [HotelDirect.AvailableFacility]) {
        self.configDirectProperty.value = facilities
    }
    
    fileprivate let tapCancelProperty = MutableProperty(())
    public func tappedCancelButton() {
        self.tapCancelProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let facilities: Signal<[HotelDirect.AvailableFacility], NoError>
    public let goBack: Signal<(), NoError>
    
    public var inputs: FacilityListViewModelInputs { return self }
    public var outputs: FacilityListViewModelOutputs { return self }
}
