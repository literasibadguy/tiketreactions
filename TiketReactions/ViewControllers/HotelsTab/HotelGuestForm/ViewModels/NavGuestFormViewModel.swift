//
//  NavGuestFormViewModel.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 18/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol NavGuestFormViewModelInputs {
    func configWith(room: AvailableRoom)
    func bookingButtonTapped()
    func configFromContactInfo()
    func configFormGuest(_ guest: CheckoutGuestParams)
    func form(completed: Bool)
    func viewDidLoad()
}


public protocol NavGuestFormViewModelOutputs {
    var checkoutGuestParam: Signal<CheckoutGuestParams, NoError> { get }
    var diagnosticEvent: Signal<String, NoError> { get }
    var totalPriceText: Signal<String, NoError> { get }
    var isCheckoutButtonEnabled: Signal<Bool, NoError> { get }
    var showLoadingOverlay: Signal<Bool, NoError> { get }
}

public protocol NavGuestFormViewModelType {
    var inputs: NavGuestFormViewModelInputs { get }
    var outputs: NavGuestFormViewModelOutputs { get }
}

public final class NavGuestFormViewModel: NavGuestFormViewModelType, NavGuestFormViewModelInputs, NavGuestFormViewModelOutputs {

    public init() {
        
        let roomCheckout = self.configWithData.signal.skipNil()
        let guest = self.configFormGuestProperty.signal.skipNil()
        
        let checkoutGuest = Signal.combineLatest(self.configWithData.signal.skipNil(), self.configFormGuestProperty.signal.skipNil())
        
        self.totalPriceText = roomCheckout.signal.map { "\(Format.symbolForCurrency($0.currency)) \(Localizations.PricepernightHotelTitle(Format.currency($0.price, country: "Rp")))" }
        
        self.diagnosticEvent = .empty
        self.isCheckoutButtonEnabled = self.formCompletedProperty.signal
        
        self.showLoadingOverlay = self.bookingButtonTappedProperty.signal.mapConst(true)
        self.checkoutGuestParam = self.configFormGuestProperty.signal.skipNil()
    }
    
    fileprivate let configWithData = MutableProperty<AvailableRoom?>(nil)
    public func configWith(room: AvailableRoom) {
        self.configWithData.value = room
    }
    
    fileprivate let bookingButtonTappedProperty = MutableProperty(())
    public func bookingButtonTapped() {
        self.bookingButtonTappedProperty.value = ()
    }
    
    fileprivate let configContactInfo = MutableProperty(())
    public func configFromContactInfo() {
        self.configContactInfo.value = ()
    }
    
    fileprivate let configFormGuestProperty = MutableProperty<CheckoutGuestParams?>(nil)
    public func configFormGuest(_ guest: CheckoutGuestParams) {
        self.configFormGuestProperty.value = guest
    }
    
    fileprivate let formCompletedProperty = MutableProperty(false)
    public func form(completed: Bool) {
        self.formCompletedProperty.value = completed
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let checkoutGuestParam: Signal<CheckoutGuestParams, NoError>
    public let diagnosticEvent: Signal<String, NoError>
    public let totalPriceText: Signal<String, NoError>
    public let isCheckoutButtonEnabled: Signal<Bool, NoError>
    public let showLoadingOverlay: Signal<Bool, NoError>
    
    public var inputs: NavGuestFormViewModelInputs { return self }
    public var outputs: NavGuestFormViewModelOutputs { return self }
}
