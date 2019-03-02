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


public struct InstantTransferPaymentEnvelope {
    public let diagnostic: Diagnostic
    public let orderId: String
    public let steps: [TransferATMSteps]
    public let message: String
    public let grandTotal: Double
}

extension InstantTransferPaymentEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<InstantTransferPaymentEnvelope> {
        return curry(InstantTransferPaymentEnvelope.init)
            <^> json <| "diagnostic"
            <*> json <| "orderId"
            <*> json <|| "steps"
            <*> json <| "message"
            <*> json <| "grand_total"
    }
}

public struct TransferATMSteps {
    public let name: String
    public let stepsDecrtiption: [String]
}

extension TransferATMSteps: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<TransferATMSteps> {
        return curry(TransferATMSteps.init)
            <^> json <| "name"
            <*> json <|| "step"
    }
}

public struct InstantTransferResult {
    public let paymentSubsiderTiket: Int
    public let currencyBeConverted: String
    public let fromAnotherCurrency: Bool
    public let resellerId: String
    
    public let paymentDiscount: Int
    public let orderTypes: [String]
    public let orderId: String
    public let orderHash: String
    public let currency: String
    public let breakdown: BreakdownResult
    
    public struct BreakdownResult {
        public let paymentCharge: Int
        public let giftPromo: Bool
        public let subTotal: Double
        public let isReschedule: Bool
        public let breakdownSchedule: [String]
        public let uniqueCode: Int
    }
    
    public let grandTotal: Double
    public let grandSubtotal: Double
    // OrdersResult
    public let orders: [InstantHotelOrderResult]
    public let statusResult: StatusResult
    
    public struct StatusResult {
        public let confirmPageMobile: Bool
        public let gag: String
        public let paymentType: Int
        public let isConfirmation: Bool
        public let isChangePayment: Bool
        public let type: Bool
        public let checkoutUrl: String
    }
}

extension InstantTransferResult: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<InstantTransferResult> {
        let tmp1 = curry(InstantTransferResult.init)
            <^> json <| "payment_subsider_tiket"
            <*> json <| "currency_to_be_converted"
            <*> json <| "from_another_currency"
            <*> json <| "reseller_id"
        
        let tmp2 = tmp1
            <*> json <| "payment_discount"
            <*> json <|| "order_types"
            <*> json <| "order_id"
            <*> json <| "order_hash"
            <*> json <| "currency"
            <*> InstantTransferResult.BreakdownResult.decode(json)
            
        return tmp2
            <*> json <| "grand_total"
            <*> json <| "grand_subtotal"
            <*> json <|| "orders"
            <*> InstantTransferResult.StatusResult.decode(json)
    }
}

extension InstantTransferResult.BreakdownResult: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<InstantTransferResult.BreakdownResult> {
        return curry(InstantTransferResult.BreakdownResult.init)
            <^> json <| "payment_charge"
            <*> json <| "giftPromo"
            <*> json <| "sub_total"
            <*> json <| "is_reschedule"
            <*> json <|| "breakdown_reschedule"
            <*> json <| "unique_code"
    }
}

extension InstantTransferResult.StatusResult: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<InstantTransferResult.StatusResult> {
        return curry(InstantTransferResult.StatusResult.init)
            <^> json <| "confirm_page_mobile"
            <*> json <| "gaq"
            <*> json <| "payment_type"
            <*> json <| "is_confirmation"
            <*> json <| "is_change_payment"
            <*> json <| "type"
            <*> json <| "checkout_url"
    }
}

public struct InstantHotelOrderResult {
    public let orderDetailId: String
    public let orderType: String
    public let hotelName: String
    public let currency: String
    public let price: Double
    public let checkinDate: String
    public let rooms: String
    public let businessAdress1: String
    public let checkoutDate: String
}

extension InstantHotelOrderResult: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<InstantHotelOrderResult> {
        return curry(InstantHotelOrderResult.init)
            <^> json <| "order_detail_id"
            <*> json <| "order_type"
            <*> json <| "hotel_name"
            <*> json <| "currency"
            <*> json <| "price"
            <*> json <| "checkin_date"
            <*> json <| "rooms"
            <*> json <| "business_address1"
            <*> json <| "checkout_date"
    }
}


public struct BankTransferPaymentEnvelope {
    public let diagnostic: Diagnostic
    public let orderId: String
    public let banks: [Bank]
    public let messages: String
    public let confirmPayment: String
    public let grandTotal: Double
    
    public struct Bank {
        public let photo1: String
        public let photo2: String
        public let nameRekening: String
        public let nameBank: String
        public let cabang: String
        public let noRekening: String
        public let destination: String
    }
}

extension BankTransferPaymentEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<BankTransferPaymentEnvelope> {
        return curry(BankTransferPaymentEnvelope.init)
            <^> json <| "diagnostic"
            <*> json <| "orderId"
            <*> json <|| "banks"
            <*> json <| "message"
            <*> json <| "confirm_payment"
            <*> json <| "grand_total"
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
            <*> json <| "No_Rekening"
            <*> json <| "Destination"
    }
}

public struct KlikBCAPaymentEnvelope {
    public let diagnostic: Diagnostic
    public let orderId: String
    public let result: InstantTransferResult
    public let steps: [String]
    public let grandTotal: Double
    public let message: String
}

extension KlikBCAPaymentEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<KlikBCAPaymentEnvelope> {
        return curry(KlikBCAPaymentEnvelope.init)
            <^> json <| "diagnostic"
            <*> json <| "orderId"
            <*> json <| "result"
            <*> json <|| ["steps", "step"]
            <*> json <| "grand_total"
            <*> json <| "message"
    }
}

