//
//  SearchHotelParamsLenses.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 07/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude

extension SearchHotelParams {
    
    //    let samping = SearchHotelParams(mainCountry: $0, uid: $1.uid, startDate: $1.startDate, endDate: $1.startDate, night: $1.night, room: $1.room, adult: $1.adult, child: $1.child, sort: $1.sort, minPrice: $1.minPrice, maxPrice: $1.maxPrice, distance: $1.distance)
    
    public enum lens {
        public static let query = Lens<SearchHotelParams, String?>(
            view: { $0.mainCountry },
            set: { some, thing in SearchHotelParams(mainCountry: some, uid: thing.uid, startDate: thing.startDate, endDate: thing.startDate, night: thing.night, room: thing.room, adult: thing.adult, child: thing.child,  sort: thing.sort,minStar: thing.minStar,maxStar: thing.maxStar, minPrice: thing.minPrice, maxPrice: thing.maxPrice, distance: thing.distance, page: thing.page) }
        )
        
        public static let uid = Lens<SearchHotelParams, String?>(
            view: { $0.uid },
            set: { some, thing in SearchHotelParams(mainCountry: thing.mainCountry, uid: some, startDate: thing.startDate, endDate: thing.startDate, night: thing.night, room: thing.room, adult: thing.adult, child: thing.child,  sort: thing.sort, minStar: thing.minStar,maxStar: thing.maxStar, minPrice: thing.minPrice, maxPrice: thing.maxPrice, distance: thing.distance, page: thing.page) }
        )
        
        public static let startDate = Lens<SearchHotelParams, String?>(
            view: { $0.startDate },
            set: { some, thing in SearchHotelParams(mainCountry: thing.mainCountry, uid: thing.uid, startDate: some, endDate: thing.endDate, night: thing.night, room: thing.room, adult: thing.adult, child: thing.child,  sort: thing.sort, minStar: thing.minStar,maxStar: thing.maxStar, minPrice: thing.minPrice, maxPrice: thing.maxPrice, distance: thing.distance, page: thing.page) }
        )
        
        public static let endDate = Lens<SearchHotelParams, String?>(
            view: { $0.endDate },
            set: { some, thing in SearchHotelParams(mainCountry: thing.mainCountry, uid: thing.uid, startDate: thing.startDate, endDate: some, night: thing.night, room: thing.room, adult: thing.adult, child: thing.child,  sort: thing.sort, minStar: thing.minStar,maxStar: thing.maxStar, minPrice: thing.minPrice, maxPrice: thing.maxPrice, distance: thing.distance, page: thing.page) }
        )
        
        public static let night = Lens<SearchHotelParams, Int?>(
            view: { $0.night },
            set: { some, thing in SearchHotelParams(mainCountry: thing.mainCountry, uid: thing.uid, startDate: thing.startDate, endDate: thing.endDate, night: some, room: thing.room, adult: thing.adult, child: thing.child,  sort: thing.sort, minStar: thing.minStar,maxStar: thing.maxStar, minPrice: thing.minPrice, maxPrice: thing.maxPrice, distance: thing.distance, page: thing.page) }
        )
        
        public static let room = Lens<SearchHotelParams, Int?>(
            view: { $0.room },
            set: { some, thing in SearchHotelParams(mainCountry: thing.mainCountry, uid: thing.uid, startDate: thing.startDate, endDate: thing.endDate, night: thing.night, room: some, adult: thing.adult, child: thing.child,  sort: thing.sort, minStar: thing.minStar,maxStar: thing.maxStar, minPrice: thing.minPrice, maxPrice: thing.maxPrice, distance: thing.distance, page: thing.page) }
        )
        
        public static let adult = Lens<SearchHotelParams, String?>(
            view: { $0.adult },
            set: { some, thing in SearchHotelParams(mainCountry: thing.mainCountry, uid: thing.uid, startDate: thing.startDate, endDate: thing.endDate, night: thing.night, room: thing.room, adult: some, child: thing.child,  sort: thing.sort, minStar: thing.minStar,maxStar: thing.maxStar, minPrice: thing.minPrice, maxPrice: thing.maxPrice, distance: thing.distance, page: thing.page) }
        )
        
        public static let child = Lens<SearchHotelParams, Int?>(
            view: { $0.child },
            set: { some, thing in SearchHotelParams(mainCountry: thing.mainCountry, uid: thing.uid, startDate: thing.startDate, endDate: thing.endDate, night: thing.night, room: thing.room, adult: thing.adult, child: some,  sort: thing.sort, minStar: thing.minStar, maxStar: thing.maxStar, minPrice: thing.minPrice, maxPrice: thing.maxPrice, distance: thing.distance, page: thing.page) }
        )
        
        public static let sort = Lens<SearchHotelParams, Sort?>(
            view: { $0.sort },
            set: { some, thing in SearchHotelParams(mainCountry: thing.mainCountry, uid: thing.uid, startDate: thing.startDate, endDate: thing.endDate, night: thing.night, room: thing.room, adult: thing.adult, child: thing.child,  sort: some, minStar: thing.minStar,maxStar: thing.maxStar, minPrice: thing.minPrice, maxPrice: thing.maxPrice, distance: thing.distance, page: thing.page) }
        )
        
        public static let minStar = Lens<SearchHotelParams, Int?>(
            view: { $0.minStar },
            set: { some, thing in SearchHotelParams(mainCountry: thing.mainCountry, uid: thing.uid, startDate: thing.startDate, endDate: thing.endDate, night: thing.night, room: thing.room, adult: thing.adult, child: thing.child, sort: thing.sort, minStar: some, maxStar: thing.maxStar, minPrice: thing.minPrice, maxPrice: thing.maxPrice, distance: thing.distance, page: thing.page) }
        )
        
        public static let maxStar = Lens<SearchHotelParams, Int?>(
            view: { $0.maxStar },
            set: { some, thing in SearchHotelParams(mainCountry: thing.mainCountry, uid: thing.uid, startDate: thing.startDate, endDate: thing.endDate, night: thing.night, room: thing.room, adult: thing.adult, child: thing.child,  sort: thing.sort, minStar: thing.minStar, maxStar: some, minPrice: thing.minPrice, maxPrice: thing.maxPrice, distance: thing.distance, page: thing.page) }
        )
        
        public static let minPrice = Lens<SearchHotelParams, String>(
            view: { $0.minPrice },
            set: { some, thing in SearchHotelParams(mainCountry: thing.mainCountry, uid: thing.uid, startDate: thing.startDate, endDate: thing.endDate, night: thing.night, room: thing.room, adult: thing.adult, child: thing.child,  sort: thing.sort, minStar: thing.minStar,maxStar: thing.maxStar, minPrice: some, maxPrice: thing.maxPrice, distance: thing.distance, page: thing.page) }
        )
        
        public static let maxPrice = Lens<SearchHotelParams, String>(
            view: { $0.maxPrice },
            set: { some, thing in SearchHotelParams(mainCountry: thing.mainCountry, uid: thing.uid, startDate: thing.startDate, endDate: thing.endDate, night: thing.night, room: thing.room, adult: thing.adult, child: thing.child,  sort: thing.sort, minStar: thing.minStar,maxStar: thing.maxStar, minPrice: thing.minPrice, maxPrice: some, distance: thing.distance, page: thing.page) }
        )
        
        public static let distance = Lens<SearchHotelParams, Int?>(
            view: { $0.distance },
            set: { some, thing in SearchHotelParams(mainCountry: thing.mainCountry, uid: thing.uid, startDate: thing.startDate, endDate: thing.endDate, night: thing.night, room: thing.room, adult: thing.adult, child: thing.child,  sort: thing.sort, minStar: thing.minStar,maxStar: thing.maxStar, minPrice: thing.minPrice, maxPrice: thing.maxPrice, distance: some, page: thing.page) }
        )
        
        
        public static let page = Lens<SearchHotelParams, Int?>(
            view: { $0.page },
            set: { some, thing in SearchHotelParams(mainCountry: thing.mainCountry, uid: thing.uid, startDate: thing.startDate, endDate: thing.endDate, night: thing.night, room: thing.room, adult: thing.adult, child: thing.child,  sort: thing.sort, minStar: thing.minStar,maxStar: thing.maxStar, minPrice: thing.minPrice, maxPrice: thing.maxPrice, distance: thing.distance, page: some) }
        )
    }
}
