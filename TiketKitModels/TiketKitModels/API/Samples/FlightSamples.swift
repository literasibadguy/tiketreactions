//
//  FlightSamples.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 27/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude

extension Flight {
    
    internal static let departGA722 = Flight(flightId: "", airlinesName: "Garuda Indonesia", flightNumber: "GA-732", departureCity: "CGK", arrivalCity: "DPS", stopTimes: "Langsung", priceValue: "965043.00", priceAdult: "965043.00", priceChild: "0", priceInfant: "0", timestamp: "", hasFood: "", flightDetail: .sample, inner: .sample, flightInfos: .sampleFlightInfo)
    
    internal static let departJT745 = departGA722
        |> Flight.lens.flightNumber .~ "GA-744"
        |> Flight.lens.priceValue .~ "943030.00"
        |> Flight.lens.flightDetail .~ .detailJT745
    
    internal static let departGA788 = departGA722
        |> Flight.lens.flightNumber .~ "GA-800"
        |> Flight.lens.priceValue .~ "925020.00"
        |> Flight.lens.flightDetail .~ .detailGA788
    
    internal static let departGA795 = departGA722
        |> Flight.lens.flightNumber .~ "GA-975"
        |> Flight.lens.priceValue .~ "912011.00"
        |> Flight.lens.flightDetail .~ .detailGA795
    
    internal static let departQG680 = departGA722
        |> Flight.lens.airlinesName .~ "Citilink"
        |> Flight.lens.flightNumber .~ "QG-680"
        |> Flight.lens.priceValue .~ "911040.00"
        |> Flight.lens.flightDetail .~ .detailQG680
    
    internal static let returnQG910 = departGA722
        |> Flight.lens.priceValue .~ "930040.00"
        |> Flight.lens.flightNumber .~ "QG-910"
        |> Flight.lens.airlinesName .~ "Citilink"
        |> Flight.lens.flightDetail .~ .detailReturnQG910
    
    internal static let returnGA745 = departGA722
        |> Flight.lens.priceValue .~ "750122.00"
        |> Flight.lens.flightNumber .~ "GA-711"
        |> Flight.lens.flightDetail .~ .detailReturnGA745
    
    internal static let returnGA788 = departGA722
        |> Flight.lens.priceValue .~ "651000.00"
        |> Flight.lens.flightNumber .~ "GA-981"
        |> Flight.lens.flightDetail .~ .detailReturnGA788
    
    internal static let returnGA795 = departGA722
        |> Flight.lens.priceValue .~ "810000.00"
        |> Flight.lens.flightNumber .~ "GA-455"
        |> Flight.lens.flightDetail .~ .detailReturnGA795
    
    internal static let returnGA650 = departGA722
        |> Flight.lens.priceValue .~ "877120.00"
        |> Flight.lens.flightNumber .~ "GA-650"
        |> Flight.lens.flightDetail .~ .detailReturnQG680
}

extension Flight.FlightDetail {
    
    internal static let sample = Flight.FlightDetail(multiplier: 1, checkInBaggage: "20", showPromoTag: false, isPromo: 1, airportTax: true, checkInBaggageUnit: "Kg", simpleDepartureTime: "05:40", simpleArrivalTime: "08:40", longVia: "", departureCityName: "Jakarta", arrivalCityName: "Denpasar", fullVia: "CGK - DPS (05:40 - 08:40)", markupPriceString: "")
    
    internal static let detailGA788 = .sample
        |> Flight.FlightDetail.lens.simpleDepartureTime .~ "04:55"
        |> Flight.FlightDetail.lens.simpleArrivalTime .~ "07:55"
        |> Flight.FlightDetail.lens.fullVia .~ "CGK - DPS (04:55 - 07:55)"
    
    internal static let detailGA795 = .sample
        |> Flight.FlightDetail.lens.simpleDepartureTime .~ "07:35"
        |> Flight.FlightDetail.lens.simpleArrivalTime .~ "09:35"
        |> Flight.FlightDetail.lens.fullVia .~ "CGK - DPS (07:35 - 09:35)"
    
    internal static let detailQG680 = .sample
        |> Flight.FlightDetail.lens.simpleDepartureTime .~ "11:40"
        |> Flight.FlightDetail.lens.simpleArrivalTime .~ "13:35"
        |> Flight.FlightDetail.lens.fullVia .~ "CGK - DPS (11:40 - 13:35)"
    
    internal static let detailJT745 = .sample
        |> Flight.FlightDetail.lens.simpleDepartureTime .~ "13:20"
        |> Flight.FlightDetail.lens.simpleArrivalTime .~ "15:35"
        |> Flight.FlightDetail.lens.fullVia .~ "CGK - DPS (13:20 - 15:35)"
    
    internal static let detailReturnQG910 = .sample
        |> Flight.FlightDetail.lens.simpleDepartureTime .~ "16:40"
        |> Flight.FlightDetail.lens.simpleArrivalTime .~ "18:35"
        |> Flight.FlightDetail.lens.fullVia .~ "CGK - DPS (16:40 - 18:35)"
    
    internal static let detailReturnGA745 = .sample
        |> Flight.FlightDetail.lens.simpleDepartureTime .~ "18:25"
        |> Flight.FlightDetail.lens.simpleArrivalTime .~ "20:35"
        |> Flight.FlightDetail.lens.fullVia .~ "CGK - DPS (18:25 - 20:35)"
    
    internal static let detailReturnGA788 = .sample
        |> Flight.FlightDetail.lens.simpleDepartureTime .~ "09:45"
        |> Flight.FlightDetail.lens.simpleArrivalTime .~ "11:45"
        |> Flight.FlightDetail.lens.fullVia .~ "CGK - DPS (09:45 - 11:45)"
    
    internal static let detailReturnGA795 = .sample
        |> Flight.FlightDetail.lens.simpleDepartureTime .~ "18:25"
        |> Flight.FlightDetail.lens.simpleArrivalTime .~ "20:35"
        |> Flight.FlightDetail.lens.fullVia .~ "CGK - DPS (18:25 - 20:35)"
    
    internal static let detailReturnQG680 = .sample
        |> Flight.FlightDetail.lens.simpleDepartureTime .~ "06:15"
        |> Flight.FlightDetail.lens.simpleArrivalTime .~ "08:35"
        |> Flight.FlightDetail.lens.fullVia .~ "CGK - DPS (06:15 - 08:35)"
    
    internal static let detailReturnGA650 = .sample
        |> Flight.FlightDetail.lens.simpleDepartureTime .~ "10:10"
        |> Flight.FlightDetail.lens.simpleArrivalTime .~ "12:35"
        |> Flight.FlightDetail.lens.fullVia .~ "CGK - DPS (10:10 - 12:35)"
    
}

extension Flight.Inner {
    
    internal static let sample = Flight.Inner(needBaggage: 1, bestDeal: false, duration: "2 j 0 m", image: "https://sandbox.tiket.com/images/flight/logo/icon_garuda.png", departureFlightDate: "2018-01-21 05:40:00", departureFlightDateStr: "Minggu, 21 Jan 2018", departureFlightDateStrShort: "Min, 21 Jan 2018", arrivalFlightDate: "2018-01-21 08:40:00", arrivalFlightDateStr: "Minggu, 21 Jan 2018", arrivalFlightDateStrShort: "Min, 21 Jan 2018")
}

extension Flight.FlightInfos {
    
    internal static let sampleFlightInfo = Flight.FlightInfos(flightInfo: [.sample])
}
