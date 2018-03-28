//
//  NavGuestFormViewModel.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 18/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import TiketAPIs

public protocol NavGuestFormViewModelInputs {
    func configWith(room: AvailableRoom)
    func bookingButtonTapped()
    func configFromContactInfo()
    func configFormGuest(_ guest: CheckoutGuestParams)
    func viewDidLoad()
}


public protocol NavGuestFormViewModelOutputs {
    var checkoutGuestParam: Signal<CheckoutGuestParams, NoError> { get }
    var goToPayment: Signal<AddOrderEnvelope, NoError> { get }
    var showLoadingOverlay: Signal<Bool, NoError> { get }
}

public protocol NavGuestFormViewModelType {
    var inputs: NavGuestFormViewModelInputs { get }
    var outputs: NavGuestFormViewModelOutputs { get }
}

public final class NavGuestFormViewModel: NavGuestFormViewModelType, NavGuestFormViewModelInputs, NavGuestFormViewModelOutputs {

    public init() {
        
        self.goToPayment = Signal.combineLatest(self.configWithData.signal.skipNil(), self.bookingButtonTappedProperty.signal.mapConst(true)).switchMap { room, book in
            AppEnvironment.current.apiService.addOrder(url: room.bookURI).demoteErrors()
        }
        
        self.showLoadingOverlay = self.bookingButtonTappedProperty.signal.mapConst(true)
        self.checkoutGuestParam = .empty
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
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let goToPayment: Signal<AddOrderEnvelope, NoError>
    public let checkoutGuestParam: Signal<CheckoutGuestParams, NoError>
    public let showLoadingOverlay: Signal<Bool, NoError>
    
    public var inputs: NavGuestFormViewModelInputs { return self }
    public var outputs: NavGuestFormViewModelOutputs { return self }
}
