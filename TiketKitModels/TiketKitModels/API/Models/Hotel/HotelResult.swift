//
//  HotelResult.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 06/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct HotelResult {
    
    public let provinceName: String
    public let kecamatanName: String
    public let kelurahanName: String
    public let businessURI: String
    
    public let photoPrimary: String
    public let starRating: String
    public let id: String
    public let roomAvailable: String
    
    public let latitude: Double
    public let longitude: Double
    public let roomMaxOccupancies: String
    public let rating: String
    
    public let metadataHotel: MetadataHotel
    public let name: String?
    public let hotelId: String
    
    public struct MetadataHotel {
        public let roomFacilityName: String
        public let oldPrice: String
        public let address: String
        public let wifi: String
        
        public let promoName: String
        public let price: Double
        public let totalPrice: Double
        public let regional: String
    }
}

extension HotelResult: Equatable {}
public func == (lhs: HotelResult, rhs: HotelResult) -> Bool {
    return lhs.id == rhs.id
}


extension HotelResult: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<HotelResult> {
        let tmp1 = curry(HotelResult.init)
            <^> json <| "province_name"
            <*> json <| "kecamatan_name"
            <*> json <| "kelurahan_name"
            <*> json <| "business_uri"
        
        let tmp2 = tmp1
            <*> json <| "photo_primary"
            <*> json <| "star_rating"
            <*> json <| "id"
            <*> json <| "room_available"
        
        let tmp3 = tmp2
            <*> (json <| "latitude" >>- stringToDouble)
            <*> (json <| "longitude" >>- stringToDouble)
            <*> json <| "room_max_occupancies"
            <*> json <| "rating"
        
        return tmp3
            <*> MetadataHotel.decode(json)
            <*> (json <|? "name" <|> .success(nil))
            <*> json <| "hotel_id"
    }
}

extension HotelResult.MetadataHotel: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<HotelResult.MetadataHotel> {
        let tmp1 = curry(HotelResult.MetadataHotel.init)
            <^> json <| "room_facility_name"
            <*> json <| "oldprice"
            <*> json <| "address"
            <*> json <| "wifi"
        
        return tmp1
            <*> json <| "promo_name"
            <*> (json <| "price" >>- stringToDouble)
            <*> (json <| "total_price" >>- stringToDouble)
            <*> json <| "regional"
    }
}

private func stringToDouble(_ string: String) -> Decoded<Double> {
    return Double(string).map(Decoded.success) ?? .success(0)
}

