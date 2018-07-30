//
//  HotelOrderEnvelope.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 25/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct HotelOrderEnvelope {
    public let diagnostic: Diagnostic
    public let myOrder: MyOrder
    public let checkout: String
    public let loginStatus: String
}


extension HotelOrderEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<HotelOrderEnvelope> {
        return curry(HotelOrderEnvelope.init)
            <^> json <| "diagnostic"
            <*> json <| "myorder"
            <*> json <| "checkout"
            <*> json <| "login_status"
    }
}
