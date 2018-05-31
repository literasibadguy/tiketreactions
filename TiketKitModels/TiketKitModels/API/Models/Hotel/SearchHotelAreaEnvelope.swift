//
//  SearchHotelAreaEnvelope.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 30/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct SearchHotelAreaEnvelope {
    public let diagnostic: Diagnostic
    public let hotelResults: [HotelResult]
}

extension SearchHotelAreaEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<SearchHotelAreaEnvelope> {
        return curry(SearchHotelAreaEnvelope.init)
            <^> json <| "diagnostic"
            <*> json <|| ["results", "result"]
    }
}
