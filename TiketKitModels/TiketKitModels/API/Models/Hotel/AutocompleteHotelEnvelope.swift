//
//  AutocompleteHotelEnvelope.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 13/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct AutocompleteHotelEnvelope {
//    public let diagnostic: Diagnostic
    public let autoResults: [AutoHotelResult]
}


public struct AutoHotelResult {
    
    public let id: String
    public let labelHotel: String
    public let labelLocation: String
    public let countLocation: String
    public let category: String
    
    public static let defaults = AutoHotelResult(id: "", labelHotel: "", labelLocation: "", countLocation: "", category: "")
}


extension AutocompleteHotelEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<AutocompleteHotelEnvelope> {
        return curry(AutocompleteHotelEnvelope.init)
            <^> json <|| ["results", "result"]
    }
}

extension AutoHotelResult: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<AutoHotelResult> {
        return curry(AutoHotelResult.init)
            <^> json <| "id"
            <*> json <| "label"
            <*> json <| "label_location"
            <*> json <| "count_location"
            <*> json <| "value"
    }
}
