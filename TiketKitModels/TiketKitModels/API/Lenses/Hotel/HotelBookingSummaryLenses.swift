//
//  HotelBookingSummaryLenses.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 01/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude

extension HotelBookingSummary {
    public enum lens {
        public static let hotelName = Lens<HotelBookingSummary, String>(
            view: { $0.hotelName },
            set: { some, thing in HotelBookingSummary(hotelName: some, dateRange: thing.dateRange, guestCount: thing.guestCount, roomCount: thing.roomCount, roomType: thing.roomType) }
        )
        
        public static let dateRange = Lens<HotelBookingSummary, String>(
            view: { $0.dateRange },
            set: { some, thing in HotelBookingSummary(hotelName: thing.hotelName, dateRange: some, guestCount: thing.guestCount, roomCount: thing.roomCount, roomType: thing.roomType) }
        )
        
        public static let guestCount = Lens<HotelBookingSummary, String>(
            view: { $0.guestCount },
            set: { some, thing in HotelBookingSummary(hotelName: thing.hotelName, dateRange: thing.dateRange, guestCount: some, roomCount: thing.roomCount, roomType: thing.roomType) }
        )
        
        public static let roomCount = Lens<HotelBookingSummary, String>(
            view: { $0.guestCount },
            set: { some, thing in HotelBookingSummary(hotelName: thing.hotelName, dateRange: thing.dateRange, guestCount: some, roomCount: some, roomType: thing.roomType) }
        )
        
        public static let roomType = Lens<HotelBookingSummary, String>(
            view: { $0.roomType },
            set: { some, thing in HotelBookingSummary(hotelName: thing.hotelName, dateRange: thing.dateRange, guestCount: thing.guestCount, roomCount: thing.roomCount, roomType: some) }
        )
    }
}
