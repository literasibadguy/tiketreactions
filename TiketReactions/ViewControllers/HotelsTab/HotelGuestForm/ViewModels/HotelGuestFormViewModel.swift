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
import TiketKitModels

public protocol HotelGuestFormViewModelInputs {
    func configureWith(hotelDirect: HotelDirect, availableRoom: AvailableRoom, booking: HotelBookingSummary)
    func configureExtendParam(_ param: CheckoutGuestParams)
    func contactFormValid(_ valid: Bool)
    func anotherGuestFormValid(_ valid: Bool)
    func contactFormDataChange(salutation: String, fullname: String, email: String, phone: String)
    func anotherGuestFormDataChange(_ param: CheckoutGuestParams)
    func guestOptionChanged(_ option: Bool)
    func viewDidAppear(animated: Bool)
    func viewDidLoad()
    func viewWillAppear(animated: Bool)
}

public protocol HotelGuestFormViewModelOutputs {
    var loadHotelAndAvailableRoomIntoDataSource: Signal<(HotelDirect, AvailableRoom, HotelBookingSummary), NoError> { get }
    var loadExtendingParam: Signal<CheckoutGuestParams, NoError> { get }
    var hideExtendingParam: Signal<(), NoError> { get }
    var guestFirstFormValid: Signal<Bool, NoError> { get }
    var expandGuestCell: Signal<CheckoutGuestParams, NoError> { get }
    var removeGuestCell: Signal<(), NoError> { get }
    var finalCheckoutData: Signal<CheckoutGuestParams, NoError> { get }
}

public protocol HotelGuestFormViewModelType {
    var inputs: HotelGuestFormViewModelInputs { get }
    var outputs: HotelGuestFormViewModelOutputs { get }
}

public final class HotelGuestFormViewModel: HotelGuestFormViewModelType, HotelGuestFormViewModelInputs, HotelGuestFormViewModelOutputs {
    
    public init() {
        
        self.loadHotelAndAvailableRoomIntoDataSource = self.configDataProperty.signal.skipNil()
        
        self.loadExtendingParam = .empty
        
        self.guestFirstFormValid = Signal.merge(Signal.combineLatest(self.anotherGuestFormProperty.signal, self.contactFormProperty.signal, self.guestOptionProperty.signal).map { isTrue($0 && $1 && $2) }, self.contactFormProperty.signal)
        
        self.expandGuestCell = self.extendParamProperty.signal.skipNil().sample(on: self.guestOptionProperty.signal.filter { $0 == true }.ignoreValues())
        
        self.removeGuestCell = self.guestOptionProperty.signal.filter { isFalse($0) }.ignoreValues()
        
        self.finalCheckoutData = Signal.merge(self.anotherGuestFormDataProperty.signal.skipNil(), self.extendParamProperty.signal.skipNil())
        self.hideExtendingParam = self.guestOptionProperty.signal.filter { $0 == true }.ignoreValues()
    }
    
    fileprivate let configDataProperty = MutableProperty<(HotelDirect, AvailableRoom, HotelBookingSummary)?>(nil)
    public func configureWith(hotelDirect: HotelDirect, availableRoom: AvailableRoom, booking: HotelBookingSummary) {
        self.configDataProperty.value = (hotelDirect, availableRoom, booking)
    }
    
    fileprivate let extendParamProperty = MutableProperty<CheckoutGuestParams?>(nil)
    public func configureExtendParam(_ params: CheckoutGuestParams) {
        self.extendParamProperty.value = params
    }
    
    fileprivate let contactFormProperty = MutableProperty(false)
    public func contactFormValid(_ valid: Bool) {
        self.contactFormProperty.value = valid
    }
    
    fileprivate let anotherGuestFormProperty = MutableProperty(false)
    public func anotherGuestFormValid(_ valid: Bool) {
        self.anotherGuestFormProperty.value = valid
    }
    
    fileprivate let contactFormDataProperty = MutableProperty<(String, String, String, String)?>(nil)
    public func contactFormDataChange(salutation: String, fullname: String, email: String, phone: String) {
        self.contactFormDataProperty.value = (salutation, fullname, email, phone)
    }
    
    fileprivate let anotherGuestFormDataProperty = MutableProperty<CheckoutGuestParams?>(nil)
    public func anotherGuestFormDataChange(_ param: CheckoutGuestParams) {
        self.anotherGuestFormDataProperty.value = param
    }
    
    fileprivate let guestOptionProperty = MutableProperty(false)
    public func guestOptionChanged(_ option: Bool) {
        self.guestOptionProperty.value = option
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
    
    public let loadHotelAndAvailableRoomIntoDataSource: Signal<(HotelDirect, AvailableRoom, HotelBookingSummary), NoError>
    public let loadExtendingParam: Signal<CheckoutGuestParams, NoError>
    public let hideExtendingParam: Signal<(), NoError>
    public let expandGuestCell: Signal<CheckoutGuestParams, NoError>
    public let removeGuestCell: Signal<(), NoError>
    public let guestFirstFormValid: Signal<Bool, NoError>
    public let finalCheckoutData: Signal<CheckoutGuestParams, NoError>
    
    public var inputs: HotelGuestFormViewModelInputs { return self }
    public var outputs: HotelGuestFormViewModelOutputs { return self }
}
