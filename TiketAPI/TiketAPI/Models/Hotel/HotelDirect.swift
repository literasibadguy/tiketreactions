//
//  HotelDirect.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 05/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct HotelDirect {
    public let diagnostic: Diagnostic
    public let primaryPhotos: String
    public let breadcrumb: Breadcrumb
    public let availableRooms: HotelRoomResult
    
    public struct HotelRoomResult {
        public let roomResults: [AvailableRoom]
    }
    
    public let addInfo: [String]
    public let photos: [Photo]
    public let largePhotos: String
    public let availFacilities: [AvailableFacility]
    public let nearbyAttraction: [NearbyAttraction]
    
    public struct Photo {
        public let fileName: String
        public let photoType: String?
    }
    
    public struct Breadcrumb {
        public let businessURI: String
        public let businessName: String
        public let kelurahanName: String
        public let kecamatanName: String
        
        public let cityName: String
        public let provinceName: String
        public let countryName: String
        public let continentName: String
        
        public let kelurahanURI: String
        public let kecamatanURI: String
        public let provinceURI: String
        public let countryURI: String
        
        public let contentURI: String
        public let starRating: String
    }
    
    public struct NearbyAttraction {
        public let distance: Int
        public let businessPrimaryPhoto: String
        public let businessName: String
        public let businessURI: String
    }
    
    public struct AdditionalInfo {
        public let airportTransferFee: String
        public let checkout: String
        public let distanceFromCity: String
    }
    
    public struct AvailableFacility {
        public let facilityType: String
        public let facilityName: String
    }
}

extension HotelDirect: Equatable {}
public func == (lhs: HotelDirect, rhs: HotelDirect) -> Bool {
    return lhs.primaryPhotos == rhs.primaryPhotos
}


extension HotelDirect: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<HotelDirect> {
        let tmp1 = curry(HotelDirect.init)
            <^> json <| "diagnostic"
            <*> json <| "primaryPhotos"
            <*> json <| "breadcrumb"
            <*> json <| "results"
            <*> json <|| ["addinfos", "addinfo"]
        
        
        return tmp1
            <*> json <|| ["all_photo", "photo"]
            <*> json <| "primaryPhotos_large"
            <*> json <|| ["avail_facilities", "avail_facilitiy"]
            <*> json <|| ["nearby_attractions", "nearby_attraction"]
    }
}

extension HotelDirect.HotelRoomResult: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<HotelDirect.HotelRoomResult> {
        return curry(HotelDirect.HotelRoomResult.init)
            <^> json <|| "result"
    }
}

extension HotelDirect.Photo: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<HotelDirect.Photo> {
        
        let photoType = curry(HotelDirect.Photo.init)
            <^> json <| "file_name"
            <*> json <| "photo_type"
        
        let photoErrorType = curry(HotelDirect.Photo.init)
            <^> json <| "file_name"
            <*> .success(nil)
        
        return photoType <|> photoErrorType
    }
}

extension HotelDirect.Photo: Equatable {
    static public func == (lhs: HotelDirect.Photo, rhs: HotelDirect.Photo) -> Bool {
        return lhs.photoType == rhs.photoType
    }
}

extension HotelDirect.Breadcrumb: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<HotelDirect.Breadcrumb> {
        let tmp1 = curry(HotelDirect.Breadcrumb.init)
            <^> json <| "business_uri"
            <*> json <| "business_name"
            <*> json <| "kelurahan_name"
            <*> json <| "kecamatan_name"
        
        let tmp2 = tmp1
            <*> json <| "city_name"
            <*> json <| "province_name"
            <*> json <| "country_name"
            <*> json <| "continent_name"
        
        let tmp3 = tmp2
            <*> json <| "kelurahan_name"
            <*> json <| "kecamatan_name"
            <*> json <| "province_uri"
            <*> json <| "country_uri"
        
        return tmp3
            <*> json <| "continent_uri"
            <*> json <| "star_rating"
    }
}

extension HotelDirect.NearbyAttraction: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<HotelDirect.NearbyAttraction> {
        return curry(HotelDirect.NearbyAttraction.init)
            <^> json <| "distance"
            <*> json <| "business_primary_photo"
            <*> json <| "business_name"
            <*> json <| "business_uri"
    }
}

extension HotelDirect.AdditionalInfo: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<HotelDirect.AdditionalInfo> {
        return curry(HotelDirect.AdditionalInfo.init)
            <^> json <| "airport_transfer_fee"
            <*> json <| "checkout"
            <*> json <| "distance_from_city"
    }
}

extension HotelDirect.AvailableFacility: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<HotelDirect.AvailableFacility> {
        return curry(HotelDirect.AvailableFacility.init)
            <^> json <| "facility_type"
            <*> json <| "facility_name"
    }
}
