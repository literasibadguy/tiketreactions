//
//  FlightOrderData.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 26/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct FlightOrderData {
    public let expire: Int
    public let uri: String
    public let orderDetailId: String
    public let orderExpireDatetime: String
    public let orderType: String
    public let customerPrice: String
    public let orderName: String
    public let orderNameDetail: String
    public let orderDetailStatus: String
    public let detail: FlightOrderDataDetail
    public let orderPhoto: String
    public let tax: String
    public let subtotalAndCharge: String
    public let deleteUri: String
    public let businessId: String
}

public struct FlightOrderDataDetail {
    public let orderDetailId: String
    public let flightStatus: FlightStatus
    
    public struct FlightStatus {
        public let airlinesName: String
        public let flightNumber: String
        public let priceAdult: String
        
        public let priceChild: String
        public let priceInfant: String
        public let flightDate: String
        public let departureTime: String
        
        public let arrivalTime: String
        public let baggageFee: Int?
        
        public let departureAirportName: String
        public let departureCityName: String
        public let arrivalAirportName: String
        public let arrivalCityName: String
    }
    
    public let passengers: [AdultPassenger]
    public let priceTotal: Int
//    public let breakDownPrice: [SeparatePrice]
    
    public struct AdultPassenger {
        public let orderPassengerId: String
        public let orderDetailId: String
        public let type: String
        public let firstName: String
        
        public let lastName: String
        public let title: String
        public let idNumber: String
        // Passengers International
        public let internationalPassenger: InternationalPassenger
        public let ticketNumber: String?
        public let typeText: String
        public let checkInBaggageUnit: String
        public let titleTranslate: String

        
        public struct InternationalPassenger {
            public let birthDate: String?
            public let adultIndex: String?
            public let passportNo: String?
            public let passportExpiry: String?
            
            public let passportIssuingCountry: String?
            public let passportNationality: String?
            public let checkInBaggage: String?
            public let checkInBaggageReturn: String?
            public let checkInBaggageSize: String?
            public let checkInBaggageSizeReturn: String?
            
            public let passportIssuedDate: String?
            public let birthCountry: String?
        }
        
    }
    
    public struct SeparatePrice {
        public let category: String
        public let type: String
        public let value: Int
        public let currency: String
        public let text: String
    }
}

extension FlightOrderData: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<FlightOrderData> {
        let tmp1 = curry(FlightOrderData.init)
            <^> json <| "expire"
            <*> json <| "uri"
            <*> json <| "order_detail_id"
            <*> json <| "order_expire_datetime"
            <*> json <| "order_type"
            <*> json <| "customer_price"
        
        let tmp2 = tmp1
            <*> json <| "order_name"
            <*> json <| "order_name_detail"
            <*> json <| "order_detail_status"
            <*> json <| "detail"
            <*> json <| "order_photo"
        
        return tmp2
            <*> json <| "tax_and_charge"
            <*> json <| "subtotal_and_charge"
            <*> json <| "delete_uri"
            <*> json <| "business_id"
    }
}

extension FlightOrderDataDetail: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<FlightOrderDataDetail> {
        let tmp1 = curry(FlightOrderDataDetail.init)
            <^> json <| "order_detail_id"
            <*> FlightStatus.decode(json)
            <*> json <|| ["passengers", "adult"]
        
        return tmp1
            <*> json <| "price"
//            <*> json <|| "breakdown_price"
    }
}

extension FlightOrderDataDetail.FlightStatus: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<FlightOrderDataDetail.FlightStatus> {
        let tmp1 = curry(FlightOrderDataDetail.FlightStatus.init)
            <^> json <| "airlines_name"
            <*> json <| "flight_number"
            <*> json <| "price_adult"
        
        let tmp2 = tmp1
            <*> json <| "price_child"
            <*> json <| "price_infant"
            <*> json <| "flight_date"
            <*> json <| "departure_time"
        
        return tmp2
            <*> json <| "arrival_time"
            <*> json <|? "baggage_fee"
            <*> json <| "departure_airport_name"
            <*> json <| "departure_city_name"
            <*> json <| "arrival_airport_name"
            <*> json <| "arrival_city_name"
    }
}

extension FlightOrderDataDetail.AdultPassenger: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<FlightOrderDataDetail.AdultPassenger> {
        let tmp1 = curry(FlightOrderDataDetail.AdultPassenger.init)
            <^> json <| "order_passenger_id"
            <*> json <| "order_detail_id"
            <*> json <| "type"
            <*> json <| "first_name"
        
        return tmp1
            <*> json <| "last_name"
            <*> json <| "title"
            <*> json <| "id_number"
            <*> InternationalPassenger.decode(json)
            <*> json <|? "ticket_number"
            <*> json <| "type_text"
            <*> json <| "check_in_baggage_unit"
            <*> json <| "title_translate"
    }
}

extension FlightOrderDataDetail.AdultPassenger.InternationalPassenger: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<FlightOrderDataDetail.AdultPassenger.InternationalPassenger> {
        
        let create = curry(FlightOrderDataDetail.AdultPassenger.InternationalPassenger.init)
        
        let nil1 = create
            <^> .success(nil)
            <*> .success(nil)
            <*> .success(nil)
            <*> .success(nil)
        
        let nil2 = nil1
            <*> .success(nil)
            <*> .success(nil)
            <*> .success(nil)
            <*> .success(nil)
            <*> .success(nil)
            <*> .success(nil)
        
        let nil3 = nil2
            <*> .success(nil)
            <*> .success(nil)
        
        let tmp1 = create
            <^> json <|? "birth_date"
            <*> json <|? "adult_index"
            <*> json <|? "passport_no"
            <*> json <|? "passport_expiry"
        
        let tmp2 = tmp1
            <*> json <|? "passport_issuing_country"
            <*> json <|? "passport_nationality"
            <*> json <|? "check_in_baggage"
            <*> json <|? "check_in_baggage_return"
            <*> json <|? "check_in_baggage_size"
            <*> json <|? "check_in_baggage_size_return"
        
        let tmp3 = tmp2
            <*> json <|? "passport_issued_Date"
            <*> json <|? "birth_country"
        
        return nil3 <|> tmp3
    }
}

extension FlightOrderDataDetail.SeparatePrice: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<FlightOrderDataDetail.SeparatePrice> {
        return curry(FlightOrderDataDetail.SeparatePrice.init)
            <^> json <| "category"
            <*> json <| "type"
            <*> json <| "value"
            <*> json <| "currency"
            <*> json <| "text"
    }
}
