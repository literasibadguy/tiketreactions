//
//  GetFlightData.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 30/08/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation

extension GetFlightData {
    
    internal static let sample = GetFlightData(flightId: "", airlinesName: "", flightNumber: "", flightDate: "", departureCity: "", arrivalCity: "", stopTimes: "", priceValue: "", priceAdult: "", priceChild: "", priceInfant: "", countAdult: "", countChild: "", countInfant: "", timestamp: "", flightDetail: .sample, inner: .sample, flightInfos: .sampleFlightInfo)
}

extension GetFlightData.FlightDetail {
    
    internal static let sample = GetFlightData.FlightDetail.init(checkInBaggage: 20, checkInBaggageUnit: "Kg", simpleDepartureTime: "05:40", simpleArrivalTime: "08:40", longVia: "", departureCityName: "Jakarta", arrivalCityName: "Denpasar", departureAirportName: "Soekarno Hatta", arrivalAirportName: "Ngurah Rai", fullVia: "CGK - DPS (05:40 - 08:40)", markupPriceString: "")
}


extension GetFlightData.Inner {
    
    
    internal static let sample = GetFlightData.Inner.init(needBaggage: 1, departureFlightDate: "2018-01-21 05:40:00", departureFlightDateStr: "Minggu, 21 Jan 2018", departureFlightDateStrShort:
        "Min, 21 Jan 2018", arrivalFlightDate: "2018-01-21 08:40:00", arrivalFlightDateStr: "Minggu, 21 Jan 2018", arrivalFlightDateStrShort: "Min, 21 Jan 2018", duration: "2 j 0 m", image: "https://sandbox.tiket.com/images/flight/logo/icon_garuda.png")
}

extension GetFlightData.FlightInfos {
    
    internal static let sampleFlightInfo = GetFlightData.FlightInfos(flightInfo: [.sample])
}
