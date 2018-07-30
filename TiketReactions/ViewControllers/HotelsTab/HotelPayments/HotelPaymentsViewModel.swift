//
//  HotelPaymentsViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 13/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import Result
import TiketKitModels

/*
print("CREDIT CARD SELECTED")
goToCheckout()
} else if indexPath.row == 2 {
    print("BANK TRANSFER SELECTED")
} else if indexPath.row == 3 {
    print("BCA KlikPay SELECTED")
} else if indexPath.row == 4 {
    print("CIMB Clicks SELECTED")
 */

public protocol HotelPaymentsViewModelInputs {
    func configureWith(myOrder: MyOrder)
    func configureWith(envelope: HotelOrderEnvelope)
    func bankTransferTapped()
    func paymentTapped(_ row: AvailablePaymentEnvelope.AvailablePayment)
    func viewDidLoad()
}

public protocol HotelPaymentsViewModelOutputs {
    var paymentsAvailable: Signal<(MyOrder, AvailablePaymentEnvelope), NoError> { get }
    var goToPayment: Signal<URLRequest, NoError> { get }
}

public protocol HotelPaymentsViewModelType {
    var inputs: HotelPaymentsViewModelInputs { get }
    var outputs: HotelPaymentsViewModelOutputs { get }
}

public final class HotelPaymentsViewModel: HotelPaymentsViewModelType, HotelPaymentsViewModelInputs, HotelPaymentsViewModelOutputs {
    
    public init() {
        let currentCheckout = self.configDataProperty.signal.skipNil().takeWhen(self.viewDidLoadProperty.signal)
        
        let availables = self.viewDidLoadProperty.signal.switchMap { _ in
            AppEnvironment.current.apiService.availablePaymentsHotel().demoteErrors()
        }
        let checkoutToken = AppEnvironment.current.apiService.tiketToken?.token ?? ""
        
        self.paymentsAvailable = Signal.combineLatest(currentCheckout, availables)
        
        let payLink = self.paymentTapProperty.signal.skipNil().switchMap { payment in creditCard(token: checkoutToken).map { $0 }.materialize() }
        
        self.goToPayment = payLink.values()
    }
    
    fileprivate let configDataProperty = MutableProperty<MyOrder?>(nil)
    public func configureWith(myOrder: MyOrder) {
        self.configDataProperty.value = myOrder
    }
    
    fileprivate let configEnvelopeProperty = MutableProperty<HotelOrderEnvelope?>(nil)
    public func configureWith(envelope: HotelOrderEnvelope) {
        self.configEnvelopeProperty.value = envelope
    }
    
    fileprivate let bankTransferTapProperty = MutableProperty(())
    public func bankTransferTapped() {
        self.bankTransferTapProperty.value = ()
    }
    
    fileprivate let paymentTapProperty = MutableProperty<AvailablePaymentEnvelope.AvailablePayment?>(nil)
    public func paymentTapped(_ row: AvailablePaymentEnvelope.AvailablePayment) {
        self.paymentTapProperty.value = row
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let paymentsAvailable: Signal<(MyOrder, AvailablePaymentEnvelope), NoError>
    public let goToPayment: Signal<URLRequest, NoError>
    
    public var inputs: HotelPaymentsViewModelInputs { return self }
    public var outputs: HotelPaymentsViewModelOutputs { return self }
}

private func bankTransfer(payment: AvailablePaymentEnvelope.AvailablePayment) -> SignalProducer<URLRequest, NoError> {
    guard let url = URL(string: payment.link.appending("?btn_booking=1&currency=IDR")) else { return .empty }
    let request = URLRequest(url: url)
    return SignalProducer(value: request)
}

private func creditCard(token: String) -> SignalProducer<URLRequest, NoError> {
    guard let url = URL(string: "https://sandbox.tiket.com/payment/checkout_payment?checkouttoken=\(token)") else { return .empty }
    let request = URLRequest(url: url)
    return SignalProducer(value: request)
}


