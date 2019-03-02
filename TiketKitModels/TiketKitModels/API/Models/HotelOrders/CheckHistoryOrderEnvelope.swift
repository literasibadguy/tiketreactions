//
//  CheckHistoryOrderEnvelope.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 11/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct CheckHistoryOrderEnvelope {
    public let diagnostic: Diagnostic
    public let result: HistoryOrderResult
    public let loginStatus: String
    public let guestId: String
    public let loginEmail: String
}

public struct HistoryOrderResult {
    public let orderId: String
    public let orderTimestamp: String
    public let paymentTimestamp: String?
    public let paymentStatus: String
    public let totalCustomerPrice: String
    public let customerCurrency: String
    public let mobilePhone: String?
    public let allOrderType: String
    public let orderCardDetail: [OrderCartDetail]
    public let orderPayment: [OrderPayment]
    public let paymentCharge: String?
}

public struct OrderCartDetail {
    public let orderDetailId: String
    public let orderType: String
    public let orderName: String
    public let orderNameDetail: String
    public let customerCurrency: String
    public let customerPrice: String
    public let totalTiket: String
    public let hotelDetail: HotelBaseDetail
    public let flightDetail: FlightBaseDetail
    public let sendUri: String
    public let printUri: String
    public let passenger: [Passenger]
    
    public struct ResultDetail {
        public let orderTimestamp: String
        public let mobilePhone: String
        public let currencyExchangeRate: String
        public let orderExpireDateTime: String
        
        public let hotelDetail: HotelBaseDetail
        public let flightDetail: FlightBaseDetail
    }
    
    public struct HotelBaseDetail {
        public let rooms: String?
        public let roomAdult: String?
        public let roomChild: String?
        public let checkin: String?
        
        public let breakfast: String?
        public let reservationCode: String?
        public let nights: String?
        
        public let beddingRequest: String?
        public let smokingRequest: String?
        public let specialRequest: String?
    }
    
    public struct FlightBaseDetail {
        
        public let flightNumber: String?
        public let trip: String?
        public let airlinesName: String?
        
        public let departureCity: String?
        public let departureTime: String?
        public let arrivalCity: String?
        public let arrivalTime: String?
        
        public let ticketClass: String?
        public let bookingCode: String?
        public let countAdult: String?
        public let countChild: String?
        public let countInfant: String?
        
        public let contact: Passenger
        
        public let ticketStatus: String?
        public let departAirport: String?
        public let arrivalAirport: String?
    }
    
    public struct Passenger {
        public let accountSalutationName: String?
        public let accountFirstName: String?
        public let accountLastName: String?
        public let addressCountry: String?
        public let accountPhone: String?
    }
}

public struct OrderPayment {
    public let paymentCurrency: String
    public let paymentAmount: String
    public let transferDate: String?
    public let paymentSource: String
    public let cardNumber: String
    public let expiryMonth: String
    public let expiryYear: String
    public let cardHolderName: String
}


extension CheckHistoryOrderEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<CheckHistoryOrderEnvelope> {
        return curry(CheckHistoryOrderEnvelope.init)
            <^> json <| "diagnostic"
            <*> json <| "result"
            <*> json <| "login_status"
            <*> (json <| "guest_id" <|> json <| "id")
            <*> json <| "login_email"
    }
}

extension HistoryOrderResult: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<HistoryOrderResult> {
        let create = curry(HistoryOrderResult.init)
        
        let tmp1 = create
            <^> json <| "order_id"
            <*> json <| "order_timestamp"
            <*> (json <|? "payment_timestamp" <|> .success(nil))
            <*> json <| "payment_status"
        
        let tmp2 = tmp1
            <*> json <| "total_customer_price"
            <*> json <| "customer_currency"
            <*> (json <|? "mobile_phone" <|> .success(nil))
            <*> json <| "all_order_type"
        
        return tmp2
            <*> json <|| "order__cart_detail"
            <*> json <|| "order__payment"
            <*> (json <|? "payment_charge" <|> .success(nil))
    }
}

extension OrderCartDetail: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<OrderCartDetail> {
        let create = curry(OrderCartDetail.init)
        
        let tmp1 = create
            <^> json <| "order_detail_id"
            <*> json <| "order_type"
            <*> json <| "order_name"
            <*> json <| "order_name_detail"
        
        let tmp2 = tmp1
            <*> json <| "customer_currency"
            <*> json <| "customer_price"
            <*> json <| "total_ticket"
            <*> json <| "detail"
            <*> json <| "detail"
        
        return tmp2
            <*> json <| "send_uri"
            <*> json <| "print_uri"
            <*> json <|| "passanger"
    }
}

extension OrderCartDetail.ResultDetail: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<OrderCartDetail.ResultDetail> {
        let create = curry(OrderCartDetail.ResultDetail.init)
        
        let tmp1 = create
            <^> json <| "order_timestamp"
            <*> json <| "mobile_phone"
            <*> json <| "order_detail_status"
            <*> json <| "order_expire_datetime"
        
        return tmp1
            <*> OrderCartDetail.HotelBaseDetail.decode(json)
            <*> OrderCartDetail.FlightBaseDetail.decode(json)
    }
}

extension OrderCartDetail.HotelBaseDetail: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<OrderCartDetail.HotelBaseDetail> {
        let create = curry(OrderCartDetail.HotelBaseDetail.init)
        
        let tmp1 = create
            <^> json <|? "rooms"
            <*> json <|? "room_adult"
            <*> json <|? "room_child"
            <*> json <|? "checkin"
        
        let tmp2 = tmp1
            <*> json <|? "breakfast"
            <*> json <|? "reservation_code"
            <*> json <|? "nights"
            <*> (json <|? "bedding_request" <|> .success(nil))
        
        return tmp2
            <*> (json <|? "smoking_request" <|> .success(nil))
            <*> (json <|? "special_request" <|> .success(nil))
    }
}

extension OrderCartDetail.FlightBaseDetail: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<OrderCartDetail.FlightBaseDetail> {
        let create = curry(OrderCartDetail.FlightBaseDetail.init)
        
        let tmp1 = create
            <^> json <|? "flight_number"
            <*> json <|? "trip"
            <*> json <|? "airlines_name"
        
        let tmp2 = tmp1
            <*> json <|? "departure_city"
            <*> json <|? "departure_time"
            <*> json <|? "arrival_city"
            <*> json <|? "arrival_time"
        
        let tmp3 = tmp2
            <*> json <|? "ticket_class"
            <*> json <|? "booking_code"
            <*> json <|? "count_adult"
            <*> json <|? "count_child"
            <*> json <|? "count_infant"
        
        let tmp4 = tmp3
            <*> OrderCartDetail.Passenger.decode(json)
            <*> json <|? "ticket_status"
            <*> json <|? "depart_airport"
            <*> json <|? "arrival_airport"
        
        return tmp4
    }
    
}

extension OrderCartDetail.Passenger: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<OrderCartDetail.Passenger> {
        let create = curry(OrderCartDetail.Passenger.init)
        
        return create
            <^> json <|? "account_salutation_name"
            <*> json <|? "account_first_name"
            <*> json <|? "account_last_name"
            <*> json <|? "address_country"
            <*> json <|? "account_phone"
    }
}

extension OrderPayment: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<OrderPayment> {
        let create = curry(OrderPayment.init)
        
        let tmp1 = create
            <^> json <| "payment_currency"
            <*> json <| "payment_amount"
            <*> json <|? "transfer_date"
            <*> json <| "payment_source"
        
        return tmp1
            <*> json <| "card_number"
            <*> json <| "expiry_month"
            <*> json <| "expiry_year"
            <*> json <| "card_holder_name"
    }
}



