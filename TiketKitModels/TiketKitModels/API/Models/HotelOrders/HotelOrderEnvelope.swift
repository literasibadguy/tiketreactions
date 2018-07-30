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
    public let myOrder: MyOrder?
    public let checkout: String?
    public let loginStatus: String
}


extension HotelOrderEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<HotelOrderEnvelope> {
        let create = curry(HotelOrderEnvelope.init)
        let temp = create
            <^> json <| "diagnostic"
            <*> (json <|? "myorder" <|> .success(nil))
            <*> (json <|? "checkout" <|> .success(nil))
            <*> json <| "login_status"
        
        return temp
    }
}
