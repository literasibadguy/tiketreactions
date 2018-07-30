//
//  FlightLenses.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 27/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude

/*
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
*/
 
extension Flight {
    
    public enum lens {
        public static let flightId = Lens<Flight, String>(
            view: { view in view.flightId },
            set: { view, set in Flight(flightId: view, airlinesName: set.airlinesName, flightNumber: set.flightNumber, departureCity: set.departureCity, arrivalCity: set.arrivalCity, stopTimes: set.stopTimes, priceValue: set.priceValue, priceAdult: set.priceAdult, priceChild: set.priceChild, priceInfant: set.priceInfant, timestamp: set.timestamp, hasFood: set.hasFood, flightDetail: set.flightDetail, inner: set.inner, flightInfos: set.flightInfos) }
        )
        
        public static let airlinesName = Lens<Flight, String>(
            view: { view in view.airlinesName },
            set: { view, set in Flight(flightId: set.flightId, airlinesName: view, flightNumber: set.flightNumber, departureCity: set.departureCity, arrivalCity: set.arrivalCity, stopTimes: set.stopTimes, priceValue: set.priceValue, priceAdult: set.priceAdult, priceChild: set.priceChild, priceInfant: set.priceInfant, timestamp: set.timestamp, hasFood: set.hasFood, flightDetail: set.flightDetail, inner: set.inner, flightInfos: set.flightInfos) }
        )
        
        public static let flightNumber = Lens<Flight, String>(
            view: { view in view.flightNumber },
            set: { view, set in Flight(flightId: set.flightId, airlinesName: set.airlinesName, flightNumber: view, departureCity: set.departureCity, arrivalCity: set.arrivalCity, stopTimes: set.stopTimes, priceValue: set.priceValue, priceAdult: set.priceAdult, priceChild: set.priceChild, priceInfant: set.priceInfant, timestamp: set.timestamp, hasFood: set.hasFood, flightDetail: set.flightDetail, inner: set.inner, flightInfos: set.flightInfos) }
        )
        
        public static let departureCity = Lens<Flight, String>(
            view: { view in view.flightNumber },
            set: { view, set in Flight(flightId: set.flightId, airlinesName: set.airlinesName, flightNumber: set.flightNumber, departureCity: view, arrivalCity: set.arrivalCity, stopTimes: set.stopTimes, priceValue: set.priceValue, priceAdult: set.priceAdult, priceChild: set.priceChild, priceInfant: set.priceInfant, timestamp: set.timestamp, hasFood: set.hasFood, flightDetail: set.flightDetail, inner: set.inner, flightInfos: set.flightInfos) }
        )
        
        public static let arrivalCity = Lens<Flight, String>(
            view: { view in view.arrivalCity },
            set: { view, set in Flight(flightId: set.flightId, airlinesName: set.airlinesName, flightNumber: set.flightNumber, departureCity: set.departureCity, arrivalCity: view, stopTimes: set.stopTimes, priceValue: set.priceValue, priceAdult: set.priceAdult, priceChild: set.priceChild, priceInfant: set.priceInfant, timestamp: set.timestamp, hasFood: set.hasFood, flightDetail: set.flightDetail, inner: set.inner, flightInfos: set.flightInfos) }
        )
        
        public static let stopTimes = Lens<Flight, String>(
            view: { view in view.arrivalCity },
            set: { view, set in Flight(flightId: set.flightId, airlinesName: set.airlinesName, flightNumber: set.flightNumber, departureCity: set.departureCity, arrivalCity: set.arrivalCity, stopTimes: view, priceValue: set.priceValue, priceAdult: set.priceAdult, priceChild: set.priceChild, priceInfant: set.priceInfant, timestamp: set.timestamp, hasFood: set.hasFood, flightDetail: set.flightDetail, inner: set.inner, flightInfos: set.flightInfos) }
        )
        
        public static let priceValue = Lens<Flight, String>(
            view: { view in view.priceValue },
            set: { view, set in Flight(flightId: set.flightId, airlinesName: set.airlinesName, flightNumber: set.flightNumber, departureCity: set.departureCity, arrivalCity: set.arrivalCity, stopTimes: set.stopTimes, priceValue: view, priceAdult: set.priceAdult, priceChild: set.priceChild, priceInfant: set.priceInfant, timestamp: set.timestamp, hasFood: set.hasFood, flightDetail: set.flightDetail, inner: set.inner, flightInfos: set.flightInfos) }
        )
        
        public static let priceAdult = Lens<Flight, String>(
            view: { view in view.priceAdult },
            set: { view, set in Flight(flightId: set.flightId, airlinesName: set.airlinesName, flightNumber: set.flightNumber, departureCity: set.departureCity, arrivalCity: set.arrivalCity, stopTimes: set.stopTimes, priceValue: set.priceValue, priceAdult: view, priceChild: set.priceChild, priceInfant: set.priceInfant, timestamp: set.timestamp, hasFood: set.hasFood, flightDetail: set.flightDetail, inner: set.inner, flightInfos: set.flightInfos) }
        )
        
        public static let priceChild = Lens<Flight, String>(
            view: { view in view.priceChild },
            set: { view, set in Flight(flightId: set.flightId, airlinesName: set.airlinesName, flightNumber: set.flightNumber, departureCity: set.departureCity, arrivalCity: set.arrivalCity, stopTimes: set.stopTimes, priceValue: set.priceValue, priceAdult: set.priceAdult, priceChild: view, priceInfant: set.priceInfant, timestamp: set.timestamp, hasFood: set.hasFood, flightDetail: set.flightDetail, inner: set.inner, flightInfos: set.flightInfos) }
        )
        
        public static let priceInfant = Lens<Flight, String>(
            view: { view in view.priceInfant },
            set: { view, set in Flight(flightId: set.flightId, airlinesName: set.airlinesName, flightNumber: set.flightNumber, departureCity: set.departureCity, arrivalCity: set.arrivalCity, stopTimes: set.stopTimes, priceValue: set.priceValue, priceAdult: set.priceAdult, priceChild: set.priceChild, priceInfant: view, timestamp: set.timestamp, hasFood: set.hasFood, flightDetail: set.flightDetail, inner: set.inner, flightInfos: set.flightInfos) }
        )
        
        public static let timestamp = Lens<Flight, String>(
            view: { view in view.timestamp },
            set: { view, set in Flight(flightId: set.flightId, airlinesName: set.airlinesName, flightNumber: set.flightNumber, departureCity: set.departureCity, arrivalCity: set.arrivalCity, stopTimes: set.stopTimes, priceValue: set.priceValue, priceAdult: set.priceAdult, priceChild: set.priceChild, priceInfant: set.priceInfant, timestamp: view, hasFood: set.hasFood, flightDetail: set.flightDetail, inner: set.inner, flightInfos: set.flightInfos) }
        )
        
        public static let hasFood = Lens<Flight, String>(
            view: { view in view.hasFood },
            set: { view, set in Flight(flightId: set.flightId, airlinesName: set.airlinesName, flightNumber: set.flightNumber, departureCity: set.departureCity, arrivalCity: set.arrivalCity, stopTimes: set.stopTimes, priceValue: set.priceValue, priceAdult: set.priceAdult, priceChild: set.priceChild, priceInfant: set.priceInfant, timestamp: set.timestamp, hasFood: view, flightDetail: set.flightDetail, inner: set.inner, flightInfos: set.flightInfos) }
        )
        
        public static let flightDetail = Lens<Flight, FlightDetail>(
            view: { view in view.flightDetail },
            set: { view, set in Flight(flightId: set.flightId, airlinesName: set.airlinesName, flightNumber: set.flightNumber, departureCity: set.departureCity, arrivalCity: set.arrivalCity, stopTimes: set.stopTimes, priceValue: set.priceValue, priceAdult: set.priceAdult, priceChild: set.priceChild, priceInfant: set.priceInfant, timestamp: set.timestamp, hasFood: set.hasFood, flightDetail: view, inner: set.inner, flightInfos: set.flightInfos) }
        )
        
        public static let inner = Lens<Flight, Inner>(
            view: { view in view.inner },
            set: { view, set in Flight(flightId: set.flightId, airlinesName: set.airlinesName, flightNumber: set.flightNumber, departureCity: set.departureCity, arrivalCity: set.arrivalCity, stopTimes: set.stopTimes, priceValue: set.priceValue, priceAdult: set.priceAdult, priceChild: set.priceChild, priceInfant: set.priceInfant, timestamp: set.timestamp, hasFood: set.hasFood, flightDetail: set.flightDetail, inner: view, flightInfos: set.flightInfos) }
        )
        
        public static let flightInfos = Lens<Flight, FlightInfos>(
            view: { view in view.flightInfos },
            set: { view, set in Flight(flightId: set.flightId, airlinesName: set.airlinesName, flightNumber: set.flightNumber, departureCity: set.departureCity, arrivalCity: set.arrivalCity, stopTimes: set.stopTimes, priceValue: set.priceValue, priceAdult: set.priceAdult, priceChild: set.priceChild, priceInfant: set.priceInfant, timestamp: set.timestamp, hasFood: set.hasFood, flightDetail: set.flightDetail, inner: set.inner, flightInfos: view) }
        )
    }
}

extension Flight.FlightDetail {
    public enum lens {
        public static let multiplier = Lens<Flight.FlightDetail, Int>(
            view: { view in view.multiplier },
            set: { view, set in Flight.FlightDetail(multiplier: view, checkInBaggage: set.checkInBaggage, showPromoTag: set.showPromoTag, isPromo: set.isPromo, airportTax: set.airportTax, checkInBaggageUnit: set.checkInBaggageUnit, simpleDepartureTime: set.simpleDepartureTime, simpleArrivalTime: set.simpleArrivalTime, longVia: set.longVia, departureCityName: set.departureCityName, arrivalCityName: set.arrivalCityName, fullVia: set.fullVia, markupPriceString: set.markupPriceString) }
        )
        
        public static let checkInBaggage = Lens<Flight.FlightDetail, String>(
            view: { view in view.checkInBaggage },
            set: { view, set in Flight.FlightDetail(multiplier: set.multiplier, checkInBaggage: view, showPromoTag: set.showPromoTag, isPromo: set.isPromo, airportTax: set.airportTax, checkInBaggageUnit: set.checkInBaggageUnit, simpleDepartureTime: set.simpleDepartureTime, simpleArrivalTime: set.simpleArrivalTime, longVia: set.longVia, departureCityName: set.departureCityName, arrivalCityName: set.arrivalCityName, fullVia: set.fullVia, markupPriceString: set.markupPriceString) }
        )
        
        public static let showPromoTag = Lens<Flight.FlightDetail, Bool>(
            view: { view in view.showPromoTag },
            set: { view, set in Flight.FlightDetail(multiplier: set.multiplier, checkInBaggage: set.checkInBaggage, showPromoTag: view, isPromo: set.isPromo, airportTax: set.airportTax, checkInBaggageUnit: set.checkInBaggageUnit, simpleDepartureTime: set.simpleDepartureTime, simpleArrivalTime: set.simpleArrivalTime, longVia: set.longVia, departureCityName: set.departureCityName, arrivalCityName: set.arrivalCityName, fullVia: set.fullVia, markupPriceString: set.markupPriceString) }
        )
        
        public static let isPromo = Lens<Flight.FlightDetail, Int>(
            view: { view in view.isPromo },
            set: { view, set in Flight.FlightDetail(multiplier: set.multiplier, checkInBaggage: set.checkInBaggage, showPromoTag: set.showPromoTag, isPromo: view, airportTax: set.airportTax, checkInBaggageUnit: set.checkInBaggageUnit, simpleDepartureTime: set.simpleDepartureTime, simpleArrivalTime: set.simpleArrivalTime, longVia: set.longVia, departureCityName: set.departureCityName, arrivalCityName: set.arrivalCityName, fullVia: set.fullVia, markupPriceString: set.markupPriceString) }
        )
        
        public static let airportTax = Lens<Flight.FlightDetail, Bool>(
            view: { view in view.airportTax },
            set: { view, set in Flight.FlightDetail(multiplier: set.multiplier, checkInBaggage: set.checkInBaggage, showPromoTag: set.showPromoTag, isPromo: set.isPromo, airportTax: view, checkInBaggageUnit: set.checkInBaggageUnit, simpleDepartureTime: set.simpleDepartureTime, simpleArrivalTime: set.simpleArrivalTime, longVia: set.longVia, departureCityName: set.departureCityName, arrivalCityName: set.arrivalCityName, fullVia: set.fullVia, markupPriceString: set.markupPriceString) }
        )
        
        //
        
        public static let checkInBaggageUnit = Lens<Flight.FlightDetail, String>(
            view: { view in view.checkInBaggageUnit },
            set: { view, set in Flight.FlightDetail(multiplier: set.multiplier, checkInBaggage: set.checkInBaggage, showPromoTag: set.showPromoTag, isPromo: set.isPromo, airportTax: set.airportTax, checkInBaggageUnit: view, simpleDepartureTime: set.simpleDepartureTime, simpleArrivalTime: set.simpleArrivalTime, longVia: set.longVia, departureCityName: set.departureCityName, arrivalCityName: set.arrivalCityName, fullVia: set.fullVia, markupPriceString: set.markupPriceString) }
        )
        
        public static let simpleDepartureTime = Lens<Flight.FlightDetail, String>(
            view: { view in view.simpleDepartureTime },
            set: { view, set in Flight.FlightDetail(multiplier: set.multiplier, checkInBaggage: set.checkInBaggage, showPromoTag: set.showPromoTag, isPromo: set.isPromo, airportTax: set.airportTax, checkInBaggageUnit: set.checkInBaggageUnit, simpleDepartureTime: view, simpleArrivalTime: set.simpleArrivalTime, longVia: set.longVia, departureCityName: set.departureCityName, arrivalCityName: set.arrivalCityName, fullVia: set.fullVia, markupPriceString: set.markupPriceString) }
        )
        
        public static let simpleArrivalTime = Lens<Flight.FlightDetail, String>(
            view: { view in view.simpleArrivalTime },
            set: { view, set in Flight.FlightDetail(multiplier: set.multiplier, checkInBaggage: set.checkInBaggage, showPromoTag: set.showPromoTag, isPromo: set.isPromo, airportTax: set.airportTax, checkInBaggageUnit: set.checkInBaggageUnit, simpleDepartureTime: set.simpleDepartureTime, simpleArrivalTime: view, longVia: set.longVia, departureCityName: set.departureCityName, arrivalCityName: set.arrivalCityName, fullVia: set.fullVia, markupPriceString: set.markupPriceString) }
        )
        
        public static let longVia = Lens<Flight.FlightDetail, String>(
            view: { view in view.longVia },
            set: { view, set in Flight.FlightDetail(multiplier: set.multiplier, checkInBaggage: set.checkInBaggage, showPromoTag: set.showPromoTag, isPromo: set.isPromo, airportTax: set.airportTax, checkInBaggageUnit: set.checkInBaggageUnit, simpleDepartureTime: set.simpleDepartureTime, simpleArrivalTime: set.simpleArrivalTime, longVia: view, departureCityName: set.departureCityName, arrivalCityName: set.arrivalCityName, fullVia: set.fullVia, markupPriceString: set.markupPriceString) }
        )
        
        //
        
        public static let departureCityName = Lens<Flight.FlightDetail, String>(
            view: { view in view.departureCityName },
            set: { view, set in Flight.FlightDetail(multiplier: set.multiplier, checkInBaggage: set.checkInBaggage, showPromoTag: set.showPromoTag, isPromo: set.isPromo, airportTax: set.airportTax, checkInBaggageUnit: set.checkInBaggageUnit, simpleDepartureTime: set.simpleDepartureTime, simpleArrivalTime: set.simpleArrivalTime, longVia: set.longVia, departureCityName: view, arrivalCityName: set.arrivalCityName, fullVia: set.fullVia, markupPriceString: set.markupPriceString) }
        )
        
        public static let arrivalCityName = Lens<Flight.FlightDetail, String>(
            view: { view in view.arrivalCityName },
            set: { view, set in Flight.FlightDetail(multiplier: set.multiplier, checkInBaggage: set.checkInBaggage, showPromoTag: set.showPromoTag, isPromo: set.isPromo, airportTax: set.airportTax, checkInBaggageUnit: set.checkInBaggageUnit, simpleDepartureTime: set.simpleDepartureTime, simpleArrivalTime: set.simpleArrivalTime, longVia: set.longVia, departureCityName: set.departureCityName, arrivalCityName: view, fullVia: set.fullVia, markupPriceString: set.markupPriceString) }
        )
        
        public static let fullVia = Lens<Flight.FlightDetail, String>(
            view: { view in view.fullVia },
            set: { view, set in Flight.FlightDetail(multiplier: set.multiplier, checkInBaggage: set.checkInBaggage, showPromoTag: set.showPromoTag, isPromo: set.isPromo, airportTax: set.airportTax, checkInBaggageUnit: set.checkInBaggageUnit, simpleDepartureTime: set.simpleDepartureTime, simpleArrivalTime: set.simpleArrivalTime, longVia: set.longVia, departureCityName: set.departureCityName, arrivalCityName: set.arrivalCityName, fullVia: view, markupPriceString: set.markupPriceString) }
        )
        
        public static let markupPriceString = Lens<Flight.FlightDetail, String>(
            view: { view in view.markupPriceString },
            set: { view, set in Flight.FlightDetail(multiplier: set.multiplier, checkInBaggage: set.checkInBaggage, showPromoTag: set.showPromoTag, isPromo: set.isPromo, airportTax: set.airportTax, checkInBaggageUnit: set.checkInBaggageUnit, simpleDepartureTime: set.simpleDepartureTime, simpleArrivalTime: set.simpleArrivalTime, longVia: set.longVia, departureCityName: set.departureCityName, arrivalCityName: set.arrivalCityName, fullVia: set.fullVia, markupPriceString: view) }
        )
    }
}

extension Flight.Inner {
    public enum lens {
        public static let needBaggage = Lens<Flight.Inner, Int>(
            view: { view in view.needBaggage },
            set: { view, set in Flight.Inner(needBaggage: view, bestDeal: set.bestDeal, duration: set.duration, image: set.image, departureFlightDate: set.departureFlightDate, departureFlightDateStr: set.departureFlightDateStr, departureFlightDateStrShort: set.departureFlightDateStrShort, arrivalFlightDate: set.arrivalFlightDate, arrivalFlightDateStr: set.arrivalFlightDateStr, arrivalFlightDateStrShort: set.arrivalFlightDateStrShort) }
        )
        
        public static let bestDeal = Lens<Flight.Inner, Bool>(
            view: { view in view.bestDeal },
            set: { view, set in Flight.Inner(needBaggage: set.needBaggage, bestDeal: view, duration: set.duration, image: set.image, departureFlightDate: set.departureFlightDate, departureFlightDateStr: set.departureFlightDateStr, departureFlightDateStrShort: set.departureFlightDateStrShort, arrivalFlightDate: set.arrivalFlightDate, arrivalFlightDateStr: set.arrivalFlightDateStr, arrivalFlightDateStrShort: set.arrivalFlightDateStrShort) }
        )
        
        public static let duration = Lens<Flight.Inner, String>(
            view: { view in view.duration },
            set: { view, set in Flight.Inner(needBaggage: set.needBaggage, bestDeal: set.bestDeal, duration: view, image: set.image, departureFlightDate: set.departureFlightDate, departureFlightDateStr: set.departureFlightDateStr, departureFlightDateStrShort: set.departureFlightDateStrShort, arrivalFlightDate: set.arrivalFlightDate, arrivalFlightDateStr: set.arrivalFlightDateStr, arrivalFlightDateStrShort: set.arrivalFlightDateStrShort) }
        )
        
        public static let image = Lens<Flight.Inner, String>(
            view: { view in view.image },
            set: { view, set in Flight.Inner(needBaggage: set.needBaggage, bestDeal: set.bestDeal, duration: set.duration, image: view, departureFlightDate: set.departureFlightDate, departureFlightDateStr: set.departureFlightDateStr, departureFlightDateStrShort: set.departureFlightDateStrShort, arrivalFlightDate: set.arrivalFlightDate, arrivalFlightDateStr: set.arrivalFlightDateStr, arrivalFlightDateStrShort: set.arrivalFlightDateStrShort) }
        )
        
        //
        
        public static let departureFlightDate = Lens<Flight.Inner, String>(
            view: { view in view.departureFlightDate },
            set: { view, set in Flight.Inner(needBaggage: set.needBaggage, bestDeal: set.bestDeal, duration: set.duration, image: set.image, departureFlightDate: view, departureFlightDateStr: set.departureFlightDateStr, departureFlightDateStrShort: set.departureFlightDateStrShort, arrivalFlightDate: set.arrivalFlightDate, arrivalFlightDateStr: set.arrivalFlightDateStr, arrivalFlightDateStrShort: set.arrivalFlightDateStrShort) }
        )
        
        public static let departureFlightDateStr = Lens<Flight.Inner, String>(
            view: { view in view.departureFlightDateStr },
            set: { view, set in Flight.Inner(needBaggage: set.needBaggage, bestDeal: set.bestDeal, duration: set.duration, image: set.image, departureFlightDate: set.departureFlightDate, departureFlightDateStr: view, departureFlightDateStrShort: set.departureFlightDateStrShort, arrivalFlightDate: set.arrivalFlightDate, arrivalFlightDateStr: set.arrivalFlightDateStr, arrivalFlightDateStrShort: set.arrivalFlightDateStrShort) }
        )
        
        public static let departureFlightDateStrShort = Lens<Flight.Inner, String>(
            view: { view in view.departureFlightDateStrShort },
            set: { view, set in Flight.Inner(needBaggage: set.needBaggage, bestDeal: set.bestDeal, duration: set.duration, image: set.image, departureFlightDate: set.departureFlightDate, departureFlightDateStr: set.departureFlightDateStr, departureFlightDateStrShort: view, arrivalFlightDate: set.arrivalFlightDate, arrivalFlightDateStr: set.arrivalFlightDateStr, arrivalFlightDateStrShort: set.arrivalFlightDateStrShort) }
        )
        
        public static let arrivalFlightDate = Lens<Flight.Inner, String>(
            view: { view in view.arrivalFlightDate },
            set: { view, set in Flight.Inner(needBaggage: set.needBaggage, bestDeal: set.bestDeal, duration: set.duration, image: set.image, departureFlightDate: set.departureFlightDate, departureFlightDateStr: set.departureFlightDateStr, departureFlightDateStrShort: set.departureFlightDateStrShort, arrivalFlightDate: view, arrivalFlightDateStr: set.arrivalFlightDateStr, arrivalFlightDateStrShort: set.arrivalFlightDateStrShort) }
        )
        
        //
        
        public static let arrivalFlightDateStr = Lens<Flight.Inner, String>(
            view: { view in view.arrivalFlightDateStr },
            set: { view, set in Flight.Inner(needBaggage: set.needBaggage, bestDeal: set.bestDeal, duration: set.duration, image: set.image, departureFlightDate: set.departureFlightDate, departureFlightDateStr: set.departureFlightDateStr, departureFlightDateStrShort: set.departureFlightDateStrShort, arrivalFlightDate: set.arrivalFlightDate, arrivalFlightDateStr: view, arrivalFlightDateStrShort: set.arrivalFlightDateStrShort) }
        )
        
        public static let arrivalFlightDateStrShort = Lens<Flight.Inner, String>(
            view: { view in view.arrivalFlightDateStrShort },
            set: { view, set in Flight.Inner(needBaggage: set.needBaggage, bestDeal: set.bestDeal, duration: set.duration, image: set.image, departureFlightDate: set.departureFlightDate, departureFlightDateStr: set.departureFlightDateStr, departureFlightDateStrShort: set.departureFlightDateStrShort, arrivalFlightDate: set.arrivalFlightDate, arrivalFlightDateStr: set.arrivalFlightDateStr, arrivalFlightDateStrShort: view) }
        )
    }
}

