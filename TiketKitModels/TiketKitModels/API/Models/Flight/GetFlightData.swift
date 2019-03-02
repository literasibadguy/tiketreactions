//
//  GetFlightData.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 28/08/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct GetFlightData {
    public let flightId: String
    public let airlinesName: String
    public let flightNumber: String
    public let flightDate: String
    
    public let departureCity: String
    public let arrivalCity: String
    public let stopTimes: String
    public let priceValue: String
    
    public let priceAdult: String
    public let priceChild: String
    public let priceInfant: String
    public let countAdult: String
    public let countChild: String
    public let countInfant: String
    public let timestamp: String
    
    public let flightDetail: FlightDetail
    public let inner: Inner
    public let flightInfos: FlightInfos
    
    
    public struct FlightDetail {
        public let checkInBaggage: Int
        public let checkInBaggageUnit: String
        
        public let simpleDepartureTime: String
        public let simpleArrivalTime: String
        public let longVia: String
        
        public let departureCityName: String
        public let arrivalCityName: String
        public let departureAirportName: String
        public let arrivalAirportName: String
        
        public let fullVia: String
        public let markupPriceString: String
    }
    
    public struct Inner {
        public let needBaggage: Int
        
        public let departureFlightDate: String
        public let departureFlightDateStr: String
        public let departureFlightDateStrShort: String
        public let arrivalFlightDate: String
        
        public let arrivalFlightDateStr: String
        public let arrivalFlightDateStrShort: String
        
        public let duration: String
        public let image: String
    }
    
    public struct FlightInfos {
        public let flightInfo: [FlightInfo]
    }
}



extension GetFlightData: Equatable {}
public func == (lhs: GetFlightData, rhs: GetFlightData) -> Bool {
    return lhs.flightId == rhs.flightId
}

extension GetFlightData: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<GetFlightData> {
        let tmp1 = curry(GetFlightData.init)
            <^> json <| "flight_id"
            <*> json <| "airlines_name"
            <*> json <| "flight_number"
            <*> json <| "flight_date"
            <*> json <| "departure_city"
        
        let tmp2 = tmp1
            <*> json <| "arrival_city"
            <*> json <| "stop"
            <*> json <| "price_value"
            <*> json <| "price_adult"
        
        let tmp3 = tmp2
            <*> json <| "price_child"
            <*> json <| "price_infant"
            <*> json <| "count_adult"
            <*> json <| "count_child"
            <*> json <| "count_infant"
            <*> json <| "timestamp"
        
        return tmp3
            <*> FlightDetail.decode(json)
            <*> Inner.decode(json)
            <*> json <| "flight_infos"
    }
}

extension GetFlightData.FlightDetail: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<GetFlightData.FlightDetail> {
        let tmp1 = curry(GetFlightData.FlightDetail.init)
            <^> json <| "check_in_baggage"
            <*> json <| "check_in_baggage_unit"
            <*> json <| "simple_departure_time"
            <*> json <| "simple_arrival_time"
        
        return tmp1
            <*> json <| "long_via"
            <*> json <| "departure_city_name"
            <*> json <| "arrival_city_name"
            <*> json <| "departure_airport_name"
            <*> json <| "arrival_airport_name"
            <*> json <| "full_via"
            <*> json <| "markup_price_string"
    }
}

extension GetFlightData.Inner: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<GetFlightData.Inner> {
        let tmp1 = curry(GetFlightData.Inner.init)
            <^> json <| "need_baggage"
            <*> json <| "departure_flight_date"
            <*> json <| "departure_flight_date_str"
        
        let tmp2 = tmp1
            <*> json <| "departure_flight_date_str_short"
            <*> json <| "arrival_flight_date"
        
        return tmp2
            <*> json <| "arrival_flight_date_str"
            <*> json <| "arrival_flight_date_str_short"
            <*> json <| "duration"
            <*> json <| "image"
    }
}

extension GetFlightData.FlightInfos: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<GetFlightData.FlightInfos> {
        return curry(GetFlightData.FlightInfos.init)
            <^> json <|| "flight_info"
    }
}


