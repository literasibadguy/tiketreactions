//
//  CurrentBookingHotel.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 19/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct CurrentBookingHotel {
    public let detailId: String
    public let type: String
    public let bookPerson: BookPerson
    public let bookSummary: BookSummary
    public let bookProperty: BookProperty
    
    public struct BookPerson {
        public let masterName: String
        public let detailName: String
        public let contactPerson: String
        public let lastUpdateContactPerson: String
        public let orderType: String
    }
    
    public struct BookSummary {
        public let hotelName: String
        public let nights: String
        public let checkInFirst: String
        public let checkInLast: String
        public let adult: String
        public let child: String
        public let rooms: String
    }
    
    public struct BookProperty {
        public let fileName: String?
        public let lastUpdateCp: String
        public let masterId: String
        public let roomId: String
        public let needProcess: Int
    }
}

extension CurrentBookingHotel: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<CurrentBookingHotel> {
        return curry(CurrentBookingHotel.init)
            <^> json <| "detail_id"
            <*> json <| "type"
            <*> BookPerson.decode(json)
            <*> BookSummary.decode(json)
            <*> BookProperty.decode(json)
    }
}

extension CurrentBookingHotel.BookPerson: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<CurrentBookingHotel.BookPerson> {
        return curry(CurrentBookingHotel.BookPerson.init)
            <^> json <| "master_name"
            <*> json <| "detail_name"
            <*> json <| "contact_person"
            <*> json <| "last_update_contact_person"
            <*> json <| "order_type"
    }
}

extension CurrentBookingHotel.BookSummary: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<CurrentBookingHotel.BookSummary> {
        let tmp1 = curry(CurrentBookingHotel.BookSummary.init)
            <^> json <| "hotel_name"
            <*> json <| "nights"
            <*> json <| "check_in_first"
        
        return tmp1
            <*> json <| "check_in_last"
            <*> json <| "adult"
            <*> json <| "child"
            <*> json <| "rooms"
    }
}

extension CurrentBookingHotel.BookProperty: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<CurrentBookingHotel.BookProperty> {
        let tmp1 = curry(CurrentBookingHotel.BookProperty.init)
            <^> json <|? "file_name"
            <*> json <| "last_update_cp"
            <*> json <| "master_id"
        
        return tmp1
            <*> json <| "room_id"
            <*> json <| "need_process"
    }
}
