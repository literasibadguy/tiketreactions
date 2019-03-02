//
//  CountryListEnvelope.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 28/01/19.
//  Copyright © 2019 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct CountryListEnvelope {
    public let diagnostic: Diagnostic
    public let listCountries: [ListCountry]
    
    public struct ListCountry {
        public let countryId: String
        public let countryName: String
        public let countryAreaCode: String
    }
}

extension CountryListEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<CountryListEnvelope> {
        return curry(CountryListEnvelope.init)
            <^> json <| "diagnostic"
            <*> json <|| "listCountry"
    }
}

extension CountryListEnvelope.ListCountry: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<CountryListEnvelope.ListCountry> {
        return curry(CountryListEnvelope.ListCountry.init)
            <^> json <| "country_id"
            <*> json <| "country_name"
            <*> json <| "country_areacode"
    }
}
