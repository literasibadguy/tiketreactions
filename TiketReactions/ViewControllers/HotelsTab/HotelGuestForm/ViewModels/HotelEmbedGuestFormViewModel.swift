//
//  HotelEmbedGuestFormViewModel.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 15/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketAPIs

public protocol HotelEmbedGuestFormViewModelInputs {
    func configureWith(hotelDirect: HotelDirect, availableRoom: AvailableRoom)
    func loadingProgressBegin(_ loading: Bool)
    func viewDidAppear(animated: Bool)
    func viewDidLoad()
    func viewWillAppear(animated: Bool)
}

public protocol HotelEmbedGuestFormViewModelOutputs {
    var configureEmbedVCWithHotelAndRoom: Signal<(HotelDirect, AvailableRoom), NoError> { get }
    var loadingOverlayIsHidden: Signal<Bool, NoError> { get }
    var orderIsLoading: Signal<Bool, NoError> { get }
}

public protocol HotelEmbedGuestFormViewModelType {
    var inputs: HotelEmbedGuestFormViewModelInputs { get }
    var outputs: HotelEmbedGuestFormViewModelOutputs { get }
}

public final class HotelEmbedGuestFormViewModel: HotelEmbedGuestFormViewModelType, HotelEmbedGuestFormViewModelInputs, HotelEmbedGuestFormViewModelOutputs {
    
    init() {
        self.configureEmbedVCWithHotelAndRoom = Signal.combineLatest(self.configDataProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        let isLoading = self.loadingProgressProperty.signal
        self.orderIsLoading = isLoading.signal
        
        self.loadingOverlayIsHidden = Signal.merge(self.viewDidLoadProperty.signal.mapConst(true), self.orderIsLoading.map(negate))
        
    }
    
    private let configDataProperty = MutableProperty<(HotelDirect, AvailableRoom)?>(nil)
    public func configureWith(hotelDirect: HotelDirect, availableRoom: AvailableRoom) {
        self.configDataProperty.value = (hotelDirect, availableRoom)
    }
    
    private let loadingProgressProperty = MutableProperty(false)
    public func loadingProgressBegin(_ loading: Bool) {
        self.loadingProgressProperty.value = loading
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    fileprivate let viewDidAppearAnimated = MutableProperty(false)
    public func viewDidAppear(animated: Bool) {
        self.viewDidAppearAnimated.value = animated
    }
    
    fileprivate let viewWillAppearAnimated = MutableProperty(false)
    public func viewWillAppear(animated: Bool) {
        self.viewWillAppearAnimated.value = animated
    }
    
    public let configureEmbedVCWithHotelAndRoom: Signal<(HotelDirect, AvailableRoom), NoError>
    public let loadingOverlayIsHidden: Signal<Bool, NoError>
    public let orderIsLoading: Signal<Bool, NoError>
    
    public var inputs: HotelEmbedGuestFormViewModelInputs { return self }
    public var outputs: HotelEmbedGuestFormViewModelOutputs { return self }
}
