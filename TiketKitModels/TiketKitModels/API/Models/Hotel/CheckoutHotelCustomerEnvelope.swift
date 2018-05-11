//
//  CheckoutCustomerEnvelope.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 19/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct CheckoutHotelCustomerEnvelope {
    public let diagnostic: Diagnostic
    public let currentProfileArr: CurrentProfile?
    public let currProfileId: String
    public let travellerProfileArr: SummaryProfile
    public let contactProfileArr: SummaryProfile
    public let statusClass: String
    public let nextPaymentUrl: String
    public let currBookArr: CurrentBookingHotel
    public let loginStatus: String
    public let id: String
}

public struct CheckoutHotelTemporary {
    public let diagnostic: Diagnostic
    public let loginStatus: String
    public let token: String
}

extension CheckoutHotelTemporary: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<CheckoutHotelTemporary> {
        return curry(CheckoutHotelTemporary.init)
            <^> json <| "diagnostic"
            <*> json <| "login_status"
            <*> json <| "token"
    }
}

extension CheckoutHotelCustomerEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<CheckoutHotelCustomerEnvelope> {
        let tmp1 = curry(CheckoutHotelCustomerEnvelope.init)
            <^> json <| "diagnostic"
            <*> json <|? "currProfileArr"
            <*> json <| "currProfileId"
            <*> json <| "travellerProfileArr"
        
        let tmp2 = tmp1
            <*> json <| "contactProfileArr"
            <*> json <| "statusClass"
            <*> json <| "next"
            <*> json <| ["SideArr", "currBookingArr"]
        
        return tmp2
            <*> json <| "login_status"
            <*> json <| "guest_id"
    }
}
