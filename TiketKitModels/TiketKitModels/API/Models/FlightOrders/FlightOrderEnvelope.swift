//
//  FlightOrderEnvelope.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 26/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct FlightOrderEnvelope {
    public let diagnostic: Diagnostic
    public let myOrder: FlightMyOrder?
    public let checkout: String?
    public let loginStatus: String
}

extension FlightOrderEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<FlightOrderEnvelope> {
        return curry(FlightOrderEnvelope.init)
            <^> json <| "diagnostic"
            <*> (json <|? "myorder" <|> .success(nil))
            <*> (json <|? "checkout" <|> .success(nil))
            <*> json <| "login_status"
    }
}
