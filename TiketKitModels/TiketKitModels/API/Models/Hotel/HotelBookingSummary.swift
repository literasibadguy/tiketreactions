//
//  HotelBookingSummary.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 01/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation

public struct HotelBookingSummary {
    public let hotelName: String
    public let dateRange: String
    public let guestCount: String
    public let roomType: String
    
    public static let defaults = HotelBookingSummary(hotelName: "", dateRange: "", guestCount: "", roomType: "")
}
