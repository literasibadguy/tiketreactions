//
//  Route.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 10/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation

internal enum Route {
    case getToken(ClientAuthType)
    case searchFlights(SearchFlightParams)
    case searchAirport(String)
    case checkUpdate
    case getFlightData
    case addOrderFlight(GroupPassengersParam)
    case searchHotel(SearchHotelParams)
    case searchHotelByArea
    case searchHotelPromo
    case searchHotelAutocomplete(String)
    case viewDetailHotel(String)
    case addOrderHotel(String)
    case orderHotel
    case deleteOrderHotel(String)
    case checkoutPageRequest
    case checkoutLogin
    case checkoutHotelGuest(CheckoutGuestParams)
    case checkoutGuestSample(String)
    case availablePayment
    
    internal var requestProperties:
        (method: Method, path: String, query: [String: Any]) {
        
        switch self {
        case let .getToken(client):
            return (.GET, "/apiv1/payexpress?method=getToken&secretkey=\(client.clientId)&output=json", [:])
        case let .searchFlights(params):
            return (.GET, "/search/flight?", params.queryParams)
        case let .searchAirport(query):
            return (.GET, "/flight_api/all_airport?", ["q": query])
        case .checkUpdate:
            return (.GET, "/ajax/mCheckFlightUpdated?", [:])
        case .getFlightData:
            return (.GET, "/flight_api/get_flight_data?", [:])
        case let .addOrderFlight(params):
            return (.POST, "/order/add/flight?", params.queryParams)
        case let .searchHotel(params):
            return (.GET, "/search/hotel?", params.queryParams)
        case .searchHotelByArea:
            return (.GET, "/search/search_area?", [:])
        case .searchHotelPromo:
            return (.GET, "/home/hotelDeals?", [:])
        case let .searchHotelAutocomplete(query):
            return (.GET, "/search/autocomplete/hotel?", ["q": query])
        case let .viewDetailHotel(urlBusiness):
            return (.GET, urlBusiness, [:])
        case let .addOrderHotel(urlOrder):
            return (.POST, urlOrder, [:])
        case .orderHotel:
            return (.GET, "/order?", [:])
        case let .deleteOrderHotel(urlOrder):
            return (.POST, urlOrder, [:])
        case .checkoutPageRequest:
            return (.GET, "/order/checkout/119978/IDR?", [:])
        case .checkoutLogin:
            return (.GET, "/checkout/checkout_customer?", [:])
        case let .checkoutHotelGuest(params):
            return (.GET, "/checkout/checkout_customer?", params.queryParams)
        case let .checkoutGuestSample(urlCheckout):
            return (.POST, urlCheckout, [:])
        case .availablePayment:
            return (.GET, "/checkout/checkout_payment?", [:])
        }
        
    }
}
