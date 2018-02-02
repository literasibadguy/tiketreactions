//
//  FlightSamples.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 27/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation

extension FlightInfo {
    
    internal static let sample = FlightInfo(flightNumber: "GA-400", classFlight: "H", departureCity: "CGK", departureCityName: "Jakarta", arrivalCity: "DPS", arrivalCityName: "Denpasar", airlinesName: "GARUDA", timing: .sample, condAirport: .sample)
}

extension FlightInfo.Timing {
    
    internal static let sample = FlightInfo.Timing(departureDateTime: "2018-01-21 05:40:00", stringDepartureDate: "Minggu, 21 Jan 2018", stringDepartureDateShort: "Min, 21 Jan 2018", simpleDepartureTime: "05:40", arrivalDateTime: "2018-01-21 08:40:00", stringArrivalDate: "Minggu, 21 Jan 2018", stringArrivalDateShort: "Min, 21 Jan 2018", arrivalDepartureTime: "08:40", imageSrc: "https://sandbox.tiket.com/images/flight/logo/icon_garuda.png", durationTime: 7200, durationHour: "2j", durationMinute: "")
}

extension FlightInfo.CondAirport {
    
    internal static let sample = FlightInfo.CondAirport(checkInBaggage: 20, checkInBaggageUnit: "Kg", terminal: "", transitDurationHour: 0, transitDurationMinute: 0, transitArrivalTextCity: "", transitArrivalTextTime: "")
}

