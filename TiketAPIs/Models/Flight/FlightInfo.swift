//
//  FlightInfo.swift
//  TiketSignal
//
//  Created by Firas Rafislam on 30/12/17.
//  Copyright © 2017 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct FlightInfo {
    public let flightNumber: String
    public let classFlight: String
    public let departureCity: String
    public let departureCityName: String
    
    public let arrivalCity: String
    public let arrivalCityName: String
    public let airlinesName: String
    public let timing: Timing
    public let condAirport: CondAirport
    
    public struct Timing {
        public let departureDateTime: String
        public let stringDepartureDate: String
        public let stringDepartureDateShort: String
        public let simpleDepartureTime: String
        
        public let arrivalDateTime: String
        public let stringArrivalDate: String
        public let stringArrivalDateShort: String
        public let arrivalDepartureTime: String
        
        public let imageSrc: String
        public let durationTime: Int
        public let durationHour: String
        public let durationMinute: String
    }
    
    public struct CondAirport {
        public let checkInBaggage: Int
        public let checkInBaggageUnit: String
        public let terminal: String
        public let transitDurationHour: Int
        public let transitDurationMinute: Int
        
        public let transitArrivalTextCity: String
        public let transitArrivalTextTime: String
    }
}

extension FlightInfo: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<FlightInfo> {
        
        let tmp1 = curry(FlightInfo.init)
            <^> json <| "flight_number"
            <*> json <| "class"
            <*> json <| "departure_city"
            <*> json <| "departure_city_name"
        
        return tmp1
            <*> json <| "arrival_city"
            <*> json <| "arrival_city_name"
            <*> json <| "airlines_name"
            <*> Timing.decode(json)
            <*> CondAirport.decode(json)
    }
}

extension FlightInfo.Timing: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<FlightInfo.Timing> {
        let tmp1 = curry(FlightInfo.Timing.init)
            <^> json <| "departure_date_time"
            <*> json <| "string_departure_date"
            <*> json <| "string_departure_date_short"
            <*> json <| "simple_departure_time"
        
        let tmp2 = tmp1
            <*> json <| "arrival_date_time"
            <*> json <| "string_arrival_date"
            <*> json <| "string_arrival_date_short"
            <*> json <| "simple_arrival_time"
        
        return tmp2
            <*> json <| "img_src"
            <*> json <| "duration_time"
            <*> json <| "duration_hour"
            <*> json <| "duration_minute"
    }
}

extension FlightInfo.CondAirport: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<FlightInfo.CondAirport> {
        let tmp1 = curry(FlightInfo.CondAirport.init)
            <^> json <| "check_in_baggage"
            <*> json <| "check_in_baggage_unit"
            <*> json <| "terminal"
            <*> json <| "transit_duration_hour"
        
        return tmp1
            <*> json <| "transit_duration_minute"
            <*> json <| "transit_arrival_text_city"
            <*> json <| "transit_arrival_text_time"
    }
}




