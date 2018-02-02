//
//  Airport.swift
//  TiketSignal
//
//  Created by Firas Rafislam on 30/12/17.
//  Copyright © 2017 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct Airport {
    public let airportCode: String
    public let international: String
    public let transNameId: String?
    public let bannerImage: String
    
    public let shortNameTransId: String?
    public let businessName: String
    public let businessNameTransId: String?
    public let businessCountry: String
    
    public let businessId: String?
    public let countryName: String
    public let cityName: String
    public let provinceName: String
    
    public let shortName: String
    public let locationName: String
}

extension Airport: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<Airport> {
        let tmp1 = curry(Airport.init)
            <^> json <| "airport_code"
            <*> json <| "international"
            <*> json <|? "trans_name_id"
            <*> json <| "banner_image"
        
        let tmp2 = tmp1
            <*> json <|? "short_name_trans_id"
            <*> json <| "business_name"
            <*> json <|? "business_name_trans_id"
            <*> json <| "business_country"
        
        let tmp3 = tmp2
            <*> json <|? "business_id"
            <*> json <| "country_name"
            <*> json <| "city_name"
            <*> json <| "province_name"
        
        return tmp3
            <*> json <| "short_name"
            <*> json <| "location_name"
        
    }
}


