//
//  SearchHotelEnvelope.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 05/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

// https://api-sandbox.tiket.com/search/hotel?q=Jakarta&startdate=2018-01-14&night=1&enddate=2012-01-18&room=1&adult=2&child=0&token=7365ed11f6e27d02328686cdaa1a69e4bf804aa5&output=json

public struct SearchHotelEnvelopes {
    public let diagnostic: Diagnostic
    public let searchQueries: SearchHotelParams
    public let searchHotelResults: [HotelResult]
    public let pagination: HotelPagination
    
    public struct SearchHotelResults {
        public let results: [HotelResult]
        /*
        public let urls: PaginateEnvelope
        
        public struct PaginateEnvelope {
            public let moreHotels: String
            
            public init(more_hotels: String) {
                moreHotels = more_hotels
            }
        }
        */
    }
}

extension SearchHotelEnvelopes: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<SearchHotelEnvelopes> {
        return curry(SearchHotelEnvelopes.init)
            <^> json <| "diagnostic"
            <*> json <| "search_queries"
            <*> json <|| ["results", "result"]
            <*> json <| "pagination"
    }
}

extension SearchHotelEnvelopes.SearchHotelResults: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<SearchHotelEnvelopes.SearchHotelResults> {
        return curry(SearchHotelEnvelopes.SearchHotelResults.init)
            <^> json <|| "result"
    }
}


