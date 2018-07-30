//
//  SearchHotelParams.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 06/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Argo
import Curry
import Runes
import Prelude

public struct SearchHotelParams {
    public let mainCountry: String?
    public let uid: String?
    public let startDate: String?
    public let endDate: String?
    public let night: Int?
    public let room: Int?
    public let adult: String?
    public let child: Int?
    public let sort: String?
    public let minStar: Int?
    public let maxStar: String?
    public let minPrice: String?
    public let maxPrice: String?
    public let distance: String?
    
    public enum Sort: String, Argo.Decodable {
        case recommended
        case priceLowToHigh
        case priceHighToLow
        case starLowToHigh
        case starHighToLow
    }
    
    public static let defaults = SearchHotelParams(mainCountry: "", uid: "", startDate: "", endDate: "", night: 1, room: 1, adult: "1", child: 0, sort: "false", minStar: 0, maxStar: "5", minPrice: "", maxPrice: "", distance: "100000")
    
    public static let customized = SearchHotelParams(mainCountry: "Indonesia", uid: "", startDate: "2018-02-13", endDate: "2018-02-18", night: 1, room: 1, adult: "1", child: 0, sort: "false", minStar: 0, maxStar: "5", minPrice: "", maxPrice: "", distance:
        "100000")
    
    public var queryParams: [String: Any] {
        var params: [String: Any] = [:]
        params["q"] = self.mainCountry
        params["uid"] = self.uid
        params["startdate"] = self.startDate
        params["enddate"] = self.endDate
        params["night"] = self.night
        params["room"] = self.room
        params["adult"] = self.adult
        params["child"] = self.child
        
        params["sort"] = "false"
        params["minstar"] = 0
        params["maxstar"] = "5"
        params["minprice"] = self.minPrice
        params["maxprice"] = self.maxPrice
        params["distance"] = "100000"
        
        return params
    }
}

extension SearchHotelParams: Equatable {}
public func == (a: SearchHotelParams, b: SearchHotelParams) -> Bool {
    return a.mainCountry == b.mainCountry
}

extension SearchHotelParams: Hashable {
    public var hashValue: Int {
        return self.description.hash
    }
}

extension SearchHotelParams: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return self.queryParams.description
    }
    
    public var debugDescription: String {
        return self.queryParams.debugDescription
    }
}


extension SearchHotelParams: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<SearchHotelParams> {
        let tmp1 = curry(SearchHotelParams.init)
            <^> json <|? "q"
            <*> json <|? "uid"
            <*> json <|? "startdate"
            <*> json <|? "enddate"
        
        let tmp2 = tmp1
            <*> json <|? "night"
            <*> json <|? "room"
            <*> json <|? "adult"
            <*> json <|? "child"
        
        return tmp2
            <*> json <|? "sort"
            <*> json <|? "minstar"
            <*> json <|? "maxstar"
            <*> json <|? "minprice"
            <*> json <|? "maxprice"
            <*> json <|? "distance"
        
    }
}

