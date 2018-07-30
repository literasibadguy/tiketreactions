//
//  CheckoutPaymentEnvelope.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 13/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

// Bank Transfer -> https://api-sandbox.tiket.com/checkout/checkout_payment/2?token=2ee91e32f9113e863da4c57e235098d1&currency=IDR&btn_booking=1&output=json

// KlikBCA -> https://api-sandbox.tiket.com/checkout/checkout_payment/3?token=2ee91e32f9113e863da4c57e235098d1&btn_booking=1&user_bca=examplee1810&currency=IDR&output=json

// Virtual Transfer -> http://api-sandbox.tiket.com/checkout/checkout_payment/35?token=4c71d60d367bbffa1b293cb663afc4e9&btn_booking=1&currency=IDR&output=json

// * CHECKOUT TOKEN PARTNER *

// Credit Card -> http://sandbox.tiket.com/payment/checkout_payment?checkouttoken=84ab8cba79dace1eef8edc7081147b49

// BCA Klikpay -> http://sandbox.tiket.com/payment/checkout_payment?checkouttoken=84ab8cba79dace1eef8edc7081147b49&payment_type=4

// CIMB Clicks -> http://sandbox.tiket.com/payment/checkout_payment?checkouttoken=84ab8cba79dace1eef8edc7081147b49&payment_type=31

// ePay BRI -> http://sandbox.tiket.com/payment/checkout_payment?checkouttoken=84ab8cba79dace1eef8edc7081147b49&payment_type=33


import Argo
import Curry
import Runes

public struct CheckoutPayEnvelope {
    public let diagnostic: Diagnostic
}

extension CheckoutPayEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<CheckoutPayEnvelope> {
        return curry(CheckoutPayEnvelope.init)
            <^> json <| "diagnostic"
    }
}

public struct AvailablePaymentEnvelope {
    public let diagnostic: Diagnostic
    public let payments: [AvailablePayment]
    
    public struct AvailablePayment {
        public let link: String
        public let text: String
        public let message: String
    }
}

extension AvailablePaymentEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<AvailablePaymentEnvelope> {
        return curry(AvailablePaymentEnvelope.init)
            <^> json <| "diagnostic"
            <*> json <|| "available_payment"
    }
}

extension AvailablePaymentEnvelope.AvailablePayment: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<AvailablePaymentEnvelope.AvailablePayment> {
        return curry(AvailablePaymentEnvelope.AvailablePayment.init)
            <^> json <| "link"
            <*> json <| "text"
            <*> json <| "message"
    }
}


public struct BankTransferPaymentEnvelope {
    public let diagnostic: Diagnostic
    public let banks: [Bank]
    
    public struct Bank {
        public let photo1: String
        public let photo2: String
        public let nameBank: String
        public let cabang: String
        public let noRekening: String
    }
}

extension BankTransferPaymentEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<BankTransferPaymentEnvelope> {
        return curry(BankTransferPaymentEnvelope.init)
            <^> json <| "diagnostic"
            <*> json <|| "banks"
    }
}

extension BankTransferPaymentEnvelope.Bank: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<BankTransferPaymentEnvelope.Bank> {
        return curry(BankTransferPaymentEnvelope.Bank.init)
            <^> json <| "photo_1"
            <*> json <| "photo_2"
            <*> json <| "Nama"
            <*> json <| "Bank"
            <*> json <| "Cabang"
    }
}



