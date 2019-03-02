//
//  Route.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 10/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude

internal enum Route {
    case getToken(ClientAuthType)
    case listCurrency()
    case listCountry()
    case searchFlights(SearchFlightParams)
    case searchSingleFlights(SearchSingleFlightParams)
    case searchAirport(String)
    case checkUpdate
    case getFlightData(GetFlightDataParams)
    case forceUpdateFlight(GetFlightDataParams, String)
    case addOrderFlight(contact: GroupPassengersParam)
    case orderFlight
    case searchHotel(SearchHotelParams)
    case searchHotelPage(String, SearchHotelParams)
    case searchHotelByArea(String)
    case searchHotelPromo
    case searchHotelAutocomplete(String)
    case viewDetailHotel(String)
    case addOrderHotel(String)
    case orderHotel
    case deleteOrderHotel(String)
    case checkoutPageRequest(String)
    case checkoutLogin(CheckoutLoginParams)
    case checkoutHotelCustomer(CheckoutGuestParams)
    case checkoutGuestSample(String)
    case payCheckout(String)
    case availablePayment
    case bankTransfer(String)
    case instantBankTransfer(String)
    case klikBCA(String)
    case creditCard(String)
    case bcaKlikpay(String)
    case cimbClicks(String)
    case epayBri(String)
    case checkHistoryOrder(String, String)
    
    /*
    // Bank Transfer https://api-sandbox.tiket.com/checkout/checkout_payment/2?token=2ee91e32f9113e863da4c57e235098d1&currency=IDR&btn_booking=1&output=json
    
    // Bank Transfer (Instant Confirmation) http://api-sandbox.tiket.com/checkout/checkout_payment/35?token=4c71d60d367bbffa1b293cb663afc4e9&btn_booking=1&currency=IDR&output=json
    
    // KlikBCA https://api-sandbox.tiket.com/checkout/checkout_payment/3?token=2ee91e32f9113e863da4c57e235098d1&btn_booking=1&user_bca=examplee1810&currency=IDR&output=json
    
    // Credit Card http://sandbox.tiket.com/payment/checkout_payment?checkouttoken=84ab8cba79dace1eef8edc708114
    // BCA KlikPay http://sandbox.tiket.com/payment/checkout_payment?checkouttoken=84ab8cba79dace1eef8edc7081147b49&payment_type=4
    // CIMB Clicks http://sandbox.tiket.com/payment/checkout_payment?checkouttoken=84ab8cba79dace1eef8edc7081147b49&payment_type=31
    // ePay BRI http://sandbox.tiket.com/payment/checkout_payment?checkouttoken=84ab8cba79dace1eef8edc7081147b49&payment_type=33
    */
    
    internal var requestProperties:
        (method: Method, path: String, query: [String: Any]) {
        
        switch self {
        case let .getToken(client):
            return (.GET, "/apiv1/payexpress?method=getToken&secretkey=\(client.clientId)&output=json", [:])
        case .listCurrency():
            return (.GET, "/general_api/listCurrency?", [:])
        case .listCountry():
            return (.GET, "/general_api/listCountry?", [:])
        case let .searchFlights(params):
            return (.GET, "/search/flight?", params.queryParams)
        case let .searchSingleFlights(params):
            return (.GET, "/search/flight?", params.queryParams)
        case let .searchAirport(query):
            return (.GET, "/flight_api/all_airport?", ["q": query])
        case .checkUpdate:
            return (.GET, "/ajax/mCheckFlightUpdated?", [:])
        case let .getFlightData(params):
            return (.GET, "/flight_api/get_flight_data?", params.queryParams)
        case let .forceUpdateFlight(params, adult):
            return (.GET, "/fl/fu/CGK/DPS/\(params.date ?? "")/\(adult)/0/0/GARUDA?Preview", [:])
        case let .addOrderFlight(params):
            return (.GET, "/order/add/flight?", params.queryParams)
        case .orderFlight:
            return (.GET, "/order?", [:])
        case let .searchHotel(params):
            return (.GET, "/search/hotel?", params.queryParams)
        case let .searchHotelPage(page, params):
            return (.GET, "/search/hotel?page=\(page)", params.queryParams)
        case let .searchHotelByArea(uid):
            return (.GET, "/search/search_area?", ["uid": uid])
        case .searchHotelPromo:
            return (.GET, "/home/hotelDeals?", [:])
        case let .searchHotelAutocomplete(query):
            return (.GET, "/search/autocomplete/hotel?", ["q": query])
        case let .viewDetailHotel(urlBusiness):
            return (.GET, urlBusiness, [:])
        case let .addOrderHotel(urlOrder):
            return (.PUT, urlOrder, [:])
        case .orderHotel:
            return (.GET, "/order?", [:])
        case let .deleteOrderHotel(urlOrder):
            return (.GET, urlOrder, [:])
        case let .checkoutPageRequest(url):
            return (.GET, url, [:])
        case let .checkoutLogin(params):
            return (.GET, "/checkout/checkout_customer?", params.queryParams)
        case let .checkoutHotelCustomer(params):
            return (.GET, "/checkout/checkout_customer?", params.queryParams)
        case let .checkoutGuestSample(urlCheckout):
            return (.POST, urlCheckout, [:])
        case let .payCheckout(url):
            return (.GET, url, [:])
        case .availablePayment:
            return (.GET, "/checkout/checkout_payment?", [:])
        case let .bankTransfer(currency):
            return (.GET, "/checkout/checkout_payment/2?btn_booking=1", [:])
        case let .instantBankTransfer(currency):
            return (.GET, "/checkout/checkout_payment/35?btn_booking=1", ["currency": currency])
        case let .klikBCA(userBCA):
            return (.GET, "/checkout/checkout_payment/3?btn_booking=1", ["user_bca": userBCA])
        case let .creditCard(checkouttoken):
            return (.GET, "/payment/checkout_payment?checkouttoken=\(checkouttoken)", [:])
        case let .bcaKlikpay(checkouttoken):
            return (.GET, "/payment/checkout_payment?checkouttoken=\(checkouttoken)&payment_type=4", [:])
        case let .cimbClicks(checkouttoken):
            return (.GET, "/payment/checkout_payment?checkouttoken=\(checkouttoken)&payment_type=31", [:])
        case let .epayBri(checkouttoken):
            return (.GET, "/payment/checkout_payment?checkouttoken=\(checkouttoken)&payment_type=33", [:])
        case let .checkHistoryOrder(orderId, email):
            return (.GET, "/check_order?", ["order_id": orderId, "email": email])
        }
        
        /*
         
         /*
         // Bank Transfer https://api-sandbox.tiket.com/checkout/checkout_payment/2?token=2ee91e32f9113e863da4c57e235098d1&currency=IDR&btn_booking=1&output=json
         
         // Bank Transfer (Instant Confirmation) http://api-sandbox.tiket.com/checkout/checkout_payment/35?token=4c71d60d367bbffa1b293cb663afc4e9&btn_booking=1&currency=IDR&output=json
         
         // KlikBCA https://api-sandbox.tiket.com/checkout/checkout_payment/3?token=2ee91e32f9113e863da4c57e235098d1&btn_booking=1&user_bca=examplee1810&currency=IDR&output=json
         
         // Credit Card http://sandbox.tiket.com/payment/checkout_payment?checkouttoken=84ab8cba79dace1eef8edc708114
         // BCA KlikPay http://sandbox.tiket.com/payment/checkout_payment?checkouttoken=84ab8cba79dace1eef8edc7081147b49&payment_type=4
         // CIMB Clicks http://sandbox.tiket.com/payment/checkout_payment?checkouttoken=84ab8cba79dace1eef8edc7081147b49&payment_type=31
         // ePay BRI http://sandbox.tiket.com/payment/checkout_payment?checkouttoken=84ab8cba79dace1eef8edc7081147b49&payment_type=33
         */
         
        case bankTransfer(String)
        case instantBankTransfer(String)
        case klikBCA(String)
        case creditCard(String)
        case bcaKlikpay(String)
        case cimbClicks(String)
        case epayBri(String)
        */
    }
}
