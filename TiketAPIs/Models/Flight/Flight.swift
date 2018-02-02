//
//  Flight.swift
//  TiketSignal
//
//  Created by Firas Rafislam on 30/12/17.
//  Copyright © 2017 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct Flight {
    public let flightId: String
    public let airlinesName: String
    public let flightNumber: String
    public let departureCity: String
    
    public let arrivalCity: String
    public let stopTimes: String
    public let priceValue: String
    public let priceAdult: String
    
    public let priceChild: String
    public let priceInfant: String
    public let timestamp: String
    public let hasFood: String
    
    public let flightDetail: FlightDetail
    public let inner: Inner
    public let flightInfos: FlightInfos
    
    public struct FlightDetail {
        public let multiplier: Int
        public let checkInBaggage: String
        public let showPromoTag: Bool
        public let isPromo: Int
        public let airportTax: Bool
        
        public let checkInBaggageUnit: String
        public let simpleDepartureTime: String
        public let simpleArrivalTime: String
        public let longVia: String
        
        public let departureCityName: String
        public let arrivalCityName: String
        public let fullVia: String
        public let markupPriceString: String
    }
    
    public struct Inner {
        public let needBaggage: Int
        public let bestDeal: Bool
        public let duration: String
        public let image: String
        
        public let departureFlightDate: String
        public let departureFlightDateStr: String
        public let departureFlightDateStrShort: String
        public let arrivalFlightDate: String
        
        public let arrivalFlightDateStr: String
        public let arrivalFlightDateStrShort: String
    }
    
    public struct FlightInfos {
        public let flightInfo: [FlightInfo]
    }
}

extension Flight: Equatable {}
public func == (lhs: Flight, rhs: Flight) -> Bool {
    return lhs.flightId == rhs.flightId
}

extension Flight: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<Flight> {
        let tmp1 = curry(Flight.init)
            <^> json <| "flight_id"
            <*> json <| "airlines_name"
            <*> json <| "flight_number"
            <*> json <| "departure_city"
        
        let tmp2 = tmp1
            <*> json <| "arrival_city"
            <*> json <| "stop"
            <*> json <| "price_value"
            <*> json <| "price_adult"
        
        let tmp3 = tmp2
            <*> json <| "price_child"
            <*> json <| "price_infant"
            <*> json <| "timestamp"
            <*> json <| "has_food"
        
        return tmp3
            <*> FlightDetail.decode(json)
            <*> Inner.decode(json)
            <*> json <| "flight_infos"
    }
}

extension Flight.FlightDetail: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<Flight.FlightDetail> {
        let tmp1 = curry(Flight.FlightDetail.init)
            <^> json <| "multiplier"
            <*> json <| "check_in_baggage"
            <*> json <| "show_promo_tag"
            <*> json <| "is_promo"
        
        let tmp2 = tmp1
            <*> json <| "airport_tax"
            <*> json <| "check_in_baggage_unit"
            <*> json <| "simple_departure_time"
            <*> json <| "simple_arrival_time"
        
        return tmp2
            <*> json <| "long_via"
            <*> json <| "departure_city_name"
            <*> json <| "arrival_city_name"
            <*> json <| "full_via"
            <*> json <| "markup_price_string"
    }
}

extension Flight.Inner: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<Flight.Inner> {
        let tmp1 = curry(Flight.Inner.init)
            <^> json <| "need_baggage"
            <*> json <| "best_deal"
            <*> json <| "duration"
            <*> json <| "image"
        
        let tmp2 = tmp1
            <*> json <| "departure_flight_date"
            <*> json <| "departure_flight_date_str"
            <*> json <| "departure_flight_date_str_short"
            <*> json <| "arrival_flight_date"
        
        return tmp2
            <*> json <| "arrival_flight_date_str"
            <*> json <| "arrival_flight_date_str_short"
    }
}

extension Flight.FlightInfos: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<Flight.FlightInfos> {
        return curry(Flight.FlightInfos.init)
            <^> json <|| "flight_info"
    }
}



