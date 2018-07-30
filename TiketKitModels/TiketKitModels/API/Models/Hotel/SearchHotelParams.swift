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
    public let sort: Sort?
    public let minStar: Int?
    public let maxStar: Int?
    public let minPrice: String?
    public let maxPrice: String?
    public let distance: Int?
    public let page: Int?
    
    public enum Sort: String, Argo.Decodable {
        case defaulted
        case popular = "popular"
        case priceLowToHigh = "priceasc"
        case priceHighToLow = "pricedesc"
        case starLowToHigh = "starasc"
        case starHighToLow = "stardesc"
    }
    
    public static let defaults = SearchHotelParams(mainCountry: nil, uid: nil, startDate: nil, endDate: nil, night: nil, room: nil, adult: nil, child: nil, sort: nil, minStar: nil, maxStar: nil, minPrice: nil, maxPrice: nil, distance: nil, page: nil)
    
    /*
    public static let customized = SearchHotelParams(mainCountry: "Indonesia", uid: "", startDate: "2018-02-13", endDate: "2018-02-18", night: 1, room: 1, adult: "1", child: 0, sort: .popular, minStar: 0, maxStar: "5", minPrice: "", maxPrice: "", distance:
        "100000", page: 1)
    */
    
    public var queryParams: [String: Any] {
        var params: [String: Any] = [:]
        params["q"] = self.mainCountry
        params["uid"] = self.uid
        params["startdate"] = self.startDate
        params["enddate"] = self.endDate
        params["night"] = self.night?.description
        params["room"] = self.room?.description
        params["adult"] = self.adult
        params["child"] = self.child
        
        params["sort"] = self.sort?.rawValue
        params["minstar"] = self.minStar?.description
        params["maxstar"] = self.maxStar?.description
        params["minprice"] = self.minPrice
        params["maxprice"] = self.maxPrice
        params["distance"] = self.distance?.description
        params["page"] = self.page?.description
        
        return params
    }
}

private func boolToString(_ bool: Bool?) -> Decoded<SearchHotelParams.Sort?> {
    let sort = SearchHotelParams.Sort.init(rawValue: bool?.description ?? "<none>")
    return .success(sort)
}

private func stringToInt(_ string: String?) -> Decoded<Int?> {
    guard let string = string else { return .success(nil) }
    return Int(string).map(Decoded.success) ?? .failure(.custom("Could not parse string into int."))
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
        
        // ((json <|? "sort" >>- boolToString) as Decoded<SearchHotelParams.Sort?>)
        return tmp2
            <*> json <|? "sort"
            <*> json <|? "minstar"
            <*> json <|? "maxstar"
            <*> json <|? "minprice"
            <*> json <|? "maxprice"
            <*> (json <|? "distance" <|> .success(nil))
            <*> .success(nil)
    }
}

