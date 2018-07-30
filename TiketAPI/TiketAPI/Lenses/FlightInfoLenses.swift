//
//  FlightInfoLenses.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 27/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude

/*
public struct FlightInfo {
 
    // READABLE
 
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
 */

extension FlightInfo {
    public enum lens {
        public static let flightNumber = Lens<FlightInfo, String>(
            view: { view in view.flightNumber },
            set: { view, set in FlightInfo(flightNumber: view, classFlight: set.classFlight, departureCity: set.departureCity, departureCityName: set.departureCityName, arrivalCity: set.arrivalCity, arrivalCityName: set.arrivalCityName, airlinesName: set.airlinesName, timing: set.timing, condAirport: set.condAirport) }
        )
        
        public static let classFlight = Lens<FlightInfo, String>(
            view: { view in view.classFlight },
            set: { view, set in FlightInfo(flightNumber: set.flightNumber, classFlight: view, departureCity: set.departureCity, departureCityName: set.departureCityName, arrivalCity: set.arrivalCity, arrivalCityName: set.arrivalCityName, airlinesName: set.airlinesName, timing: set.timing, condAirport: set.condAirport) }
        )
        
        public static let departureCity = Lens<FlightInfo, String>(
            view: { view in view.departureCity },
            set: { view, set in FlightInfo(flightNumber: set.flightNumber, classFlight: set.classFlight, departureCity: view, departureCityName: set.departureCityName, arrivalCity: set.arrivalCity, arrivalCityName: set.arrivalCityName, airlinesName: set.airlinesName, timing: set.timing, condAirport: set.condAirport) }
        )
        
        public static let departureCityName = Lens<FlightInfo, String>(
            view: { view in view.departureCityName },
            set: { view, set in FlightInfo(flightNumber: set.flightNumber, classFlight: set.classFlight, departureCity: set.departureCity, departureCityName: view, arrivalCity: set.arrivalCity, arrivalCityName: set.arrivalCityName, airlinesName: set.airlinesName, timing: set.timing, condAirport: set.condAirport) }
        )
        
        //
        
        public static let arrivalCity = Lens<FlightInfo, String>(
            view: { view in view.flightNumber },
            set: { view, set in FlightInfo(flightNumber: view, classFlight: set.classFlight, departureCity: set.departureCity, departureCityName: set.departureCityName, arrivalCity: view, arrivalCityName: set.arrivalCityName, airlinesName: set.airlinesName, timing: set.timing, condAirport: set.condAirport) }
        )
        
        public static let arrivalCityName = Lens<FlightInfo, String>(
            view: { view in view.arrivalCityName },
            set: { view, set in FlightInfo(flightNumber: set.flightNumber, classFlight: set.classFlight, departureCity: set.departureCity, departureCityName: set.departureCityName, arrivalCity: set.arrivalCity, arrivalCityName: view, airlinesName: set.airlinesName, timing: set.timing, condAirport: set.condAirport) }
        )
        
        public static let airlinesName = Lens<FlightInfo, String>(
            view: { view in view.airlinesName },
            set: { view, set in FlightInfo(flightNumber: set.flightNumber, classFlight: set.classFlight, departureCity: set.departureCity, departureCityName: set.departureCityName, arrivalCity: set.arrivalCity, arrivalCityName: set.arrivalCityName, airlinesName: view, timing: set.timing, condAirport: set.condAirport) }
        )
        
        public static let timing = Lens<FlightInfo, Timing>(
            view: { view in view.timing },
            set: { view, set in FlightInfo(flightNumber: set.flightNumber, classFlight: set.classFlight, departureCity: set.departureCity, departureCityName: set.departureCityName, arrivalCity: set.arrivalCity, arrivalCityName: set.arrivalCityName, airlinesName: set.airlinesName, timing: view, condAirport: set.condAirport) }
        )
        
        public static let condAirport = Lens<FlightInfo, CondAirport>(
            view: { view in view.condAirport },
            set: { view, set in FlightInfo(flightNumber: set.flightNumber, classFlight: set.classFlight, departureCity: set.departureCity, departureCityName: set.departureCityName, arrivalCity: set.arrivalCity, arrivalCityName: set.arrivalCityName, airlinesName: set.airlinesName, timing: set.timing, condAirport: view) }
        )
    }
}

extension FlightInfo.Timing {
    public enum lens {
        public static let departureDateTime = Lens<FlightInfo.Timing, String>(
            view: { view in view.departureDateTime },
            set: { view, set in FlightInfo.Timing(departureDateTime: view, stringDepartureDate: set.stringDepartureDate, stringDepartureDateShort: set.stringDepartureDateShort, simpleDepartureTime: set.simpleDepartureTime, arrivalDateTime: set.arrivalDateTime, stringArrivalDate: set.stringArrivalDate, stringArrivalDateShort: set.stringDepartureDateShort, arrivalDepartureTime: set.arrivalDepartureTime, imageSrc: set.imageSrc, durationTime: set.durationTime, durationHour: set.durationHour, durationMinute: set.durationMinute) }
        )
        public static let stringDepartureDate = Lens<FlightInfo.Timing, String>(
            view: { view in view.departureDateTime },
            set: { view, set in FlightInfo.Timing(departureDateTime: set.departureDateTime, stringDepartureDate: view, stringDepartureDateShort: set.stringDepartureDateShort, simpleDepartureTime: set.simpleDepartureTime, arrivalDateTime: set.arrivalDateTime, stringArrivalDate: set.stringArrivalDate, stringArrivalDateShort: set.stringDepartureDateShort, arrivalDepartureTime: set.arrivalDepartureTime, imageSrc: set.imageSrc, durationTime: set.durationTime, durationHour: set.durationHour, durationMinute: set.durationMinute) }
        )
        public static let stringDepartureDateShort = Lens<FlightInfo.Timing, String>(
            view: { view in view.stringDepartureDateShort },
            set: { view, set in FlightInfo.Timing(departureDateTime: set.departureDateTime, stringDepartureDate: set.stringDepartureDate, stringDepartureDateShort: view, simpleDepartureTime: set.simpleDepartureTime, arrivalDateTime: set.arrivalDateTime, stringArrivalDate: set.stringArrivalDate, stringArrivalDateShort: set.stringDepartureDateShort, arrivalDepartureTime: set.arrivalDepartureTime, imageSrc: set.imageSrc, durationTime: set.durationTime, durationHour: set.durationHour, durationMinute: set.durationMinute) }
        )
        public static let simpleDepartureTime = Lens<FlightInfo.Timing, String>(
            view: { view in view.departureDateTime },
            set: { view, set in FlightInfo.Timing(departureDateTime: set.departureDateTime, stringDepartureDate: set.stringDepartureDate, stringDepartureDateShort: set.stringDepartureDateShort, simpleDepartureTime: view, arrivalDateTime: set.arrivalDateTime, stringArrivalDate: set.stringArrivalDate, stringArrivalDateShort: set.stringDepartureDateShort, arrivalDepartureTime: set.arrivalDepartureTime, imageSrc: set.imageSrc, durationTime: set.durationTime, durationHour: set.durationHour, durationMinute: set.durationMinute) }
        )
        
        //
        
        public static let arrivalDateTime = Lens<FlightInfo.Timing, String>(
            view: { view in view.arrivalDateTime },
            set: { view, set in FlightInfo.Timing(departureDateTime: set.departureDateTime, stringDepartureDate: set.stringDepartureDate, stringDepartureDateShort: set.stringDepartureDateShort, simpleDepartureTime: set.simpleDepartureTime, arrivalDateTime: view, stringArrivalDate: set.stringArrivalDate, stringArrivalDateShort: set.stringArrivalDateShort, arrivalDepartureTime: set.arrivalDepartureTime, imageSrc: set.imageSrc, durationTime: set.durationTime, durationHour: set.durationHour, durationMinute: set.durationMinute) }
        )
        public static let stringArrivalDate = Lens<FlightInfo.Timing, String>(
            view: { view in view.stringArrivalDate },
            set: { view, set in FlightInfo.Timing(departureDateTime: set.departureDateTime, stringDepartureDate: set.stringDepartureDate, stringDepartureDateShort: set.stringDepartureDateShort, simpleDepartureTime: set.simpleDepartureTime, arrivalDateTime: set.arrivalDateTime, stringArrivalDate: view, stringArrivalDateShort: set.stringArrivalDateShort, arrivalDepartureTime: set.arrivalDepartureTime, imageSrc: set.imageSrc, durationTime: set.durationTime, durationHour: set.durationHour, durationMinute: set.durationMinute) }
        )
        public static let stringArrivalDateShort = Lens<FlightInfo.Timing, String>(
            view: { view in view.stringArrivalDateShort },
            set: { view, set in FlightInfo.Timing(departureDateTime: set.departureDateTime, stringDepartureDate: set.stringDepartureDate, stringDepartureDateShort: set.stringDepartureDateShort, simpleDepartureTime: set.simpleDepartureTime, arrivalDateTime: set.arrivalDateTime, stringArrivalDate: set.stringArrivalDate, stringArrivalDateShort: view, arrivalDepartureTime: set.arrivalDepartureTime, imageSrc: set.imageSrc, durationTime: set.durationTime, durationHour: set.durationHour, durationMinute: set.durationMinute) }
        )
        public static let arrivalDepartureTime = Lens<FlightInfo.Timing, String>(
            view: { view in view.arrivalDepartureTime },
            set: { view, set in FlightInfo.Timing(departureDateTime: set.departureDateTime, stringDepartureDate: set.stringDepartureDate, stringDepartureDateShort: set.stringDepartureDateShort, simpleDepartureTime: set.simpleDepartureTime, arrivalDateTime: set.arrivalDateTime, stringArrivalDate: set.stringArrivalDate, stringArrivalDateShort: set.stringArrivalDateShort, arrivalDepartureTime: view, imageSrc: set.imageSrc, durationTime: set.durationTime, durationHour: set.durationHour, durationMinute: set.durationMinute) }
        )
        
        //
        
        public static let imageSrc = Lens<FlightInfo.Timing, String>(
            view: { view in view.imageSrc },
            set: { view, set in FlightInfo.Timing(departureDateTime: set.departureDateTime, stringDepartureDate: set.stringDepartureDate, stringDepartureDateShort: set.stringDepartureDateShort, simpleDepartureTime: set.simpleDepartureTime, arrivalDateTime: set.arrivalDateTime, stringArrivalDate: set.stringArrivalDate, stringArrivalDateShort: set.stringDepartureDateShort, arrivalDepartureTime: set.arrivalDepartureTime, imageSrc: view, durationTime: set.durationTime, durationHour: set.durationHour, durationMinute: set.durationMinute) }
        )
        public static let durationTime = Lens<FlightInfo.Timing, Int>(
            view: { view in view.durationTime },
            set: { view, set in FlightInfo.Timing(departureDateTime: set.departureDateTime, stringDepartureDate: set.stringDepartureDate, stringDepartureDateShort: set.stringDepartureDateShort, simpleDepartureTime: set.simpleDepartureTime, arrivalDateTime: set.arrivalDateTime, stringArrivalDate: set.stringArrivalDate, stringArrivalDateShort: set.stringDepartureDateShort, arrivalDepartureTime: set.arrivalDepartureTime, imageSrc: set.imageSrc, durationTime: view, durationHour: set.durationHour, durationMinute: set.durationMinute) }
        )
        public static let durationHour = Lens<FlightInfo.Timing, String>(
            view: { view in view.durationHour },
            set: { view, set in FlightInfo.Timing(departureDateTime: set.departureDateTime, stringDepartureDate: set.stringDepartureDate, stringDepartureDateShort: set.stringDepartureDateShort, simpleDepartureTime: set.simpleDepartureTime, arrivalDateTime: set.arrivalDateTime, stringArrivalDate: set.stringArrivalDate, stringArrivalDateShort: set.stringDepartureDateShort, arrivalDepartureTime: set.arrivalDepartureTime, imageSrc: set.imageSrc, durationTime: set.durationTime, durationHour: view, durationMinute: set.durationMinute) }
        )
        public static let durationMinute = Lens<FlightInfo.Timing, String>(
            view: { view in view.durationMinute },
            set: { view, set in FlightInfo.Timing(departureDateTime: set.departureDateTime, stringDepartureDate: set.stringDepartureDate, stringDepartureDateShort: set.stringDepartureDateShort, simpleDepartureTime: set.simpleDepartureTime, arrivalDateTime: set.arrivalDateTime, stringArrivalDate: set.stringArrivalDate, stringArrivalDateShort: set.stringDepartureDateShort, arrivalDepartureTime: set.arrivalDepartureTime, imageSrc: set.imageSrc, durationTime: set.durationTime, durationHour: set.durationHour, durationMinute: view) }
        )
    }
}

extension FlightInfo.CondAirport {
    public enum lens {
        public static let checkInBaggage = Lens<FlightInfo.CondAirport, Int>(
            view: { view in view.checkInBaggage },
            set: { view, set in FlightInfo.CondAirport(checkInBaggage: view, checkInBaggageUnit: set.checkInBaggageUnit, terminal: set.terminal, transitDurationHour: set.transitDurationHour, transitDurationMinute: set.transitDurationMinute, transitArrivalTextCity: set.transitArrivalTextCity, transitArrivalTextTime: set.transitArrivalTextTime) }
        )
        
        public static let checkInBaggageUnit = Lens<FlightInfo.CondAirport, String>(
            view: { view in view.checkInBaggageUnit },
            set: { view, set in FlightInfo.CondAirport(checkInBaggage: set.checkInBaggage, checkInBaggageUnit: view, terminal: set.terminal, transitDurationHour: set.transitDurationHour, transitDurationMinute: set.transitDurationMinute, transitArrivalTextCity: set.transitArrivalTextCity, transitArrivalTextTime: set.transitArrivalTextTime) }
        )
        
        public static let terminal = Lens<FlightInfo.CondAirport, String>(
            view: { view in view.terminal },
            set: { view, set in FlightInfo.CondAirport(checkInBaggage: set.checkInBaggage, checkInBaggageUnit: set.checkInBaggageUnit, terminal: view, transitDurationHour: set.transitDurationHour, transitDurationMinute: set.transitDurationMinute, transitArrivalTextCity: set.transitArrivalTextCity, transitArrivalTextTime: set.transitArrivalTextTime) }
        )
        
        public static let transitDirationHour = Lens<FlightInfo.CondAirport, Int>(
            view: { view in view.transitDurationHour },
            set: { view, set in FlightInfo.CondAirport(checkInBaggage: set.checkInBaggage, checkInBaggageUnit: set.checkInBaggageUnit, terminal: set.terminal, transitDurationHour: view, transitDurationMinute: set.transitDurationMinute, transitArrivalTextCity: set.transitArrivalTextCity, transitArrivalTextTime: set.transitArrivalTextTime) }
        )
        
        public static let transitDurationMinute = Lens<FlightInfo.CondAirport, Int>(
            view: { view in view.transitDurationMinute },
            set: { view, set in FlightInfo.CondAirport(checkInBaggage: set.checkInBaggage, checkInBaggageUnit: set.checkInBaggageUnit, terminal: set.terminal, transitDurationHour: set.transitDurationHour, transitDurationMinute: view, transitArrivalTextCity: set.transitArrivalTextCity, transitArrivalTextTime: set.transitArrivalTextTime) }
        )
        
        //
        
        public static let transitArrivalTextCity = Lens<FlightInfo.CondAirport, String>(
            view: { view in view.transitArrivalTextCity },
            set: { view, set in FlightInfo.CondAirport(checkInBaggage: set.checkInBaggage, checkInBaggageUnit: set.checkInBaggageUnit, terminal: set.terminal, transitDurationHour: set.transitDurationHour, transitDurationMinute: set.transitDurationMinute, transitArrivalTextCity: view, transitArrivalTextTime: set.transitArrivalTextTime) }
        )
        
        public static let transitArrivalTextTime = Lens<FlightInfo.CondAirport, String>(
            view: { view in view.transitArrivalTextTime },
            set: { view, set in FlightInfo.CondAirport(checkInBaggage: set.checkInBaggage, checkInBaggageUnit: set.checkInBaggageUnit, terminal: set.terminal, transitDurationHour: set.transitDurationHour, transitDurationMinute: set.transitDurationMinute, transitArrivalTextCity: set.transitArrivalTextCity, transitArrivalTextTime: view) }
        )
    }
}
