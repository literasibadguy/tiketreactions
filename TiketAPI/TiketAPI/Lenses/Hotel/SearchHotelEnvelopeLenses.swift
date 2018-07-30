//
//  SearchHotelEnvelopeLenses.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 10/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude

/*
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
 */

extension SearchHotelEnvelopes {
    public enum lens {
        public static let diagnostic = Lens<SearchHotelEnvelopes, Diagnostic>(
            view: { $0.diagnostic },
            set: { view, set in SearchHotelEnvelopes(diagnostic: view, searchQueries: set.searchQueries, searchHotelResults: set.searchHotelResults, pagination: set.pagination) }
        )
        
        public static let searchQueries = Lens<SearchHotelEnvelopes, SearchHotelParams>(
            view: { $0.searchQueries },
            set: { view, set in SearchHotelEnvelopes(diagnostic: set.diagnostic, searchQueries: view, searchHotelResults: set.searchHotelResults, pagination: set.pagination) }
        )
        
        public static let searchHotelResults = Lens<SearchHotelEnvelopes, [HotelResult]>(
            view: { $0.searchHotelResults },
            set: { view, set in SearchHotelEnvelopes(diagnostic: set.diagnostic, searchQueries: set.searchQueries, searchHotelResults: view, pagination: set.pagination) }
        )
        
        public static let pagination = Lens<SearchHotelEnvelopes, HotelPagination>(
            view: { $0.pagination },
            set: { view, set in SearchHotelEnvelopes(diagnostic: set.diagnostic, searchQueries: set.searchQueries, searchHotelResults: set.searchHotelResults, pagination: view) }
        )
    }
}
