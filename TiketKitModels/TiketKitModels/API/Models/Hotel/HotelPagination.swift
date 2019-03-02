//
//  HotelPagination.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 06/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct HotelPagination {
    public let totalFound: Int
    public let currentPage: Int
    public let offset: String
    public let lastPage: Int
}

extension HotelPagination: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<HotelPagination> {
        return curry(HotelPagination.init)
            <^> json <| "total_found"
            <*> ((json <| "current_page" >>- stringToInt) <|> (json <| "current_page"))
            <*> json <| "offset"
            <*> json <| "lastPage"
    }
}

private func stringToInt(_ string: String) -> Decoded<Int> {
    return Int(string).map(Decoded.success) ?? .success(0)
}

