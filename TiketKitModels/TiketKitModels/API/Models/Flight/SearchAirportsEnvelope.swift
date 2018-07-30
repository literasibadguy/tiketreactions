//
//  SearchAirportsEnvelope.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 03/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes


public struct SearchAirportsEnvelope {
    public let diagnostic: Diagnostic
    public let airportResults: [AirportResult]
}

public struct AirportResult {
    public let airportName: String
    public let airportCode: String
    public let locationName: String
    public let countryId: String
    public let countryName: String
    
    public static let defaults = AirportResult(airportName: "", airportCode: "", locationName: "", countryId: "", countryName: "")
}

extension SearchAirportsEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<SearchAirportsEnvelope> {
        return curry(SearchAirportsEnvelope.init )
            <^> json <| "diagnostic"
            <*> json <|| ["all_airport", "airport"]
    }
}

extension AirportResult: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<AirportResult> {
        return curry(AirportResult.init)
            <^> json <| "airport_name"
            <*> json <| "airport_code"
            <*> json <| "location_name"
            <*> json <| "country_id"
            <*> json <| "country_name"
    }
}
