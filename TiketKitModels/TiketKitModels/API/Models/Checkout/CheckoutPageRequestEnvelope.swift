//
//  CheckoutPageRequestEnvelope.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 14/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct CheckoutPageRequestEnvelope {
    public let diagnostic: Diagnostic
    public let nextCheckoutURI: String
}

extension CheckoutPageRequestEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<CheckoutPageRequestEnvelope> {
        return curry(CheckoutPageRequestEnvelope.init)
            <^> json <| "diagnostic"
            <*> (json <| "next_checkout_uri" <|> .success(""))
    }
}
