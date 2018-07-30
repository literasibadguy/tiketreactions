//
//  SearchFlightParamsLenses.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 31/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
/*
public let fromAirport: String?
public let toAirport: String?
public let departDate: String?
public let returnDate: String?
public let adult: Int?
public let child: Int?
public let infant: Int?
public let sort: Bool?
*/
 
extension SearchFlightParams {
    public enum lens {
        public static let fromAirport = Lens<SearchFlightParams, String?>(
            view: { view in view.fromAirport },
            set: { view, set in SearchFlightParams(fromAirport: view, toAirport: set.toAirport, departDate: set.departDate, returnDate: set.returnDate, adult: set.adult, child: set.child, infant: set.infant, sort: set.sort) }
        )
        
        public static let toAirport = Lens<SearchFlightParams, String?>(
            view: { view in view.toAirport },
            set: { view, set in SearchFlightParams(fromAirport: set.fromAirport, toAirport: view, departDate: set.departDate, returnDate: set.returnDate, adult: set.adult, child: set.child, infant: set.infant, sort: set.sort) }
        )
        
        public static let departDate = Lens<SearchFlightParams, String?>(
            view: { view in view.departDate },
            set: { view, set in SearchFlightParams(fromAirport: set.fromAirport, toAirport: set.toAirport, departDate: view, returnDate: set.returnDate, adult: set.adult, child: set.child, infant: set.infant, sort: set.sort) }
        )
        
        public static let returnDate = Lens<SearchFlightParams, String?>(
            view: { view in view.returnDate },
            set: { view, set in SearchFlightParams(fromAirport: set.fromAirport, toAirport: set.toAirport, departDate: set.departDate, returnDate: view, adult: set.adult, child: set.child, infant: set.infant, sort: set.sort) }
        )
        
        public static let adult = Lens<SearchFlightParams, Int?>(
            view: { view in view.adult },
            set: { view, set in SearchFlightParams(fromAirport: set.fromAirport, toAirport: set.toAirport, departDate: set.departDate, returnDate: set.returnDate, adult: view, child: set.child, infant: set.infant, sort: set.sort) }
        )
        
        public static let child = Lens<SearchFlightParams, Int?>(
            view: { view in view.child },
            set: { view, set in SearchFlightParams(fromAirport: set.fromAirport, toAirport: set.toAirport, departDate: set.departDate, returnDate: set.returnDate, adult: set.adult, child: view, infant: set.infant, sort: set.sort) }
        )
        
        public static let infant = Lens<SearchFlightParams, Int?>(
            view: { view in view.infant },
            set: { view, set in SearchFlightParams(fromAirport: set.fromAirport, toAirport: set.toAirport, departDate: set.departDate, returnDate: set.returnDate, adult: set.adult, child: set.child, infant: view, sort: set.sort) }
        )
        
        public static let sort = Lens<SearchFlightParams, Bool?>(
            view: { view in view.sort },
            set: { view, set in SearchFlightParams(fromAirport: set.fromAirport, toAirport: set.toAirport, departDate: set.departDate, returnDate: set.returnDate, adult: set.adult, child: set.child, infant: set.infant, sort: view) }
        )
    }
}

extension SearchSingleFlightParams {
    public enum lens {
        public static let fromAirport = Lens<SearchSingleFlightParams, String?>(
            view: { view in view.fromAirport },
            set: { view, set in SearchSingleFlightParams(fromAirport: view, toAirport: set.toAirport, departDate: set.departDate, returnDate: set.returnDate, adult: set.adult, child: set.child, infant: set.infant, sort: set.sort) }
        )
        
        public static let toAirport = Lens<SearchSingleFlightParams, String?>(
            view: { view in view.toAirport },
            set: { view, set in SearchSingleFlightParams(fromAirport: set.fromAirport, toAirport: view, departDate: set.departDate, returnDate: set.returnDate, adult: set.adult, child: set.child, infant: set.infant, sort: set.sort) }
        )
        
        public static let departDate = Lens<SearchSingleFlightParams, String?>(
            view: { view in view.departDate },
            set: { view, set in SearchSingleFlightParams(fromAirport: set.fromAirport, toAirport: set.toAirport, departDate: view, returnDate: set.returnDate, adult: set.adult, child: set.child, infant: set.infant, sort: set.sort) }
        )
        
        public static let returnDate = Lens<SearchSingleFlightParams, Bool?>(
            view: { view in view.returnDate },
            set: { view, set in SearchSingleFlightParams(fromAirport: set.fromAirport, toAirport: set.toAirport, departDate: set.departDate, returnDate: view, adult: set.adult, child: set.child, infant: set.infant, sort: set.sort) }
        )
        
        public static let adult = Lens<SearchSingleFlightParams, Int?>(
            view: { view in view.adult },
            set: { view, set in SearchSingleFlightParams(fromAirport: set.fromAirport, toAirport: set.toAirport, departDate: set.departDate, returnDate: set.returnDate, adult: view, child: set.child, infant: set.infant, sort: set.sort) }
        )
        
        public static let child = Lens<SearchSingleFlightParams, Int?>(
            view: { view in view.child },
            set: { view, set in SearchSingleFlightParams(fromAirport: set.fromAirport, toAirport: set.toAirport, departDate: set.departDate, returnDate: set.returnDate, adult: set.adult, child: view, infant: set.infant, sort: set.sort) }
        )
        
        public static let infant = Lens<SearchSingleFlightParams, Int?>(
            view: { view in view.infant },
            set: { view, set in SearchSingleFlightParams(fromAirport: set.fromAirport, toAirport: set.toAirport, departDate: set.departDate, returnDate: set.returnDate, adult: set.adult, child: set.child, infant: view, sort: set.sort) }
        )
        
        public static let sort = Lens<SearchSingleFlightParams, Bool?>(
            view: { view in view.sort },
            set: { view, set in SearchSingleFlightParams(fromAirport: set.fromAirport, toAirport: set.toAirport, departDate: set.departDate, returnDate: set.returnDate, adult: set.adult, child: set.child, infant: set.infant, sort: view) }
        )
    }
}
