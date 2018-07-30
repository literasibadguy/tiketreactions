//
//  FlightSamples.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 27/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation

extension Flight.FlightDetail {
    
    internal static let sample = Flight.FlightDetail(multiplier: 1, checkInBaggage: "20", showPromoTag: false, isPromo: 1, airportTax: true, checkInBaggageUnit: "Kg", simpleDepartureTime: "05:40", simpleArrivalTime: "08:40", longVia: "", departureCityName: "Jakarta", arrivalCityName: "Denpasar", fullVia: "CGK - DPS (05:40 - 08:40)", markupPriceString: "")
}

extension Flight.Inner {
    
    internal static let sample = Flight.Inner(needBaggage: 1, bestDeal: false, duration: "2 j 0 m", image: "https://sandbox.tiket.com/images/flight/logo/icon_garuda.png", departureFlightDate: "2018-01-21 05:40:00", departureFlightDateStr: "Minggu, 21 Jan 2018", departureFlightDateStrShort: "Min, 21 Jan 2018", arrivalFlightDate: "2018-01-21 08:40:00", arrivalFlightDateStr: "Minggu, 21 Jan 2018", arrivalFlightDateStrShort: "Min, 21 Jan 2018")
}


