//
//  AddOrderParams.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 18/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct AddOrderParams {
    public let startDate: String
    public let endDate: String
    public let night: Int
    public let room: Int
    public let adult: Int
    public let child: Int
    public let minStar: Int
    public let minPrice: Int
    public let hotelName: String
    public let roomId: String
    public let hasPromo: String
    
    public static let defaults = AddOrderParams(startDate: "", endDate: "", night: 0, room: 0, adult: 0, child: 0, minStar: 0, minPrice: 0, hotelName: "", roomId: "", hasPromo: "")
    
    public var queryParams: [String: Any] {
        var params: [String: Any] = [:]
        params["startdate"] = self.startDate
        params["enddate"] = self.endDate
        params["night"] = self.night
        params["room"] = self.room
        params["adult"] = self.adult
        params["child"] = self.child
        params["minstar"] = self.minStar
        params["minprice"] = self.minPrice
        params["hotelname"] = self.hotelName
        params["room_id"] = self.roomId
        params["hasPromo"] = self.hasPromo
        
        return params
    }
}

extension AddOrderParams: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<AddOrderParams> {
        let tmp1 = curry(AddOrderParams.init)
            <^> json <| "startdate"
            <*> json <| "enddate"
            <*> json <| "night"
            <*> json <| "room"
        
        let tmp2 = tmp1
            <*> json <| "adult"
            <*> json <| "child"
            <*> json <| "minstar"
            <*> json <| "minprice"
        
        return tmp2
            <*> json <| "hotelname"
            <*> json <| "room_id"
            <*> json <| "hasPromo"
    }
}

