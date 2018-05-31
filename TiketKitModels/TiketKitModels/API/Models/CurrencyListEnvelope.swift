//
//  CurrencyListEnvelope.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 24/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct CurrencyListEnvelope {
    public let diagnostic: Diagnostic
    public let currencies: [Currency]
    
    public struct Currency {
        public let code: String
        public let name: String
    }
}

public struct CurrencyChangeEnvelope {
    
}

extension CurrencyListEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<CurrencyListEnvelope> {
        return curry(CurrencyListEnvelope.init)
            <^> json <| "diagnostic"
            <*> json <|| "result"
    }
}

extension CurrencyListEnvelope.Currency: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<CurrencyListEnvelope.Currency> {
        return curry(CurrencyListEnvelope.Currency.init)
            <^> json <| "code"
            <*> json <| "name"
    }
}
