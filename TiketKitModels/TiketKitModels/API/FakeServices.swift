//
//  FakeServices.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 27/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result

internal struct FakeServices: TiketServiceType {
    
    internal let appId: String
    internal let serverConfig: TiketServerConfigType
    internal let tiketToken: TiketTokenType?
    internal let language: String
    internal let currency: String
    internal let buildVersion: String
    
    fileprivate let listPaymentMethodResult: Result<AvailablePaymentEnvelope, ErrorEnvelope>?
    
    fileprivate let hotelResultsResponse: [HotelResult]?
    fileprivate let hotelResultsError: ErrorEnvelope?
    
    fileprivate let hotelDirectResponse: HotelDirect?
    fileprivate let hotelDirectError: ErrorEnvelope?
    
    fileprivate let fetchAddOrderHotelResponse: AddOrderEnvelope?
    fileprivate let fetchAddOrderHotelError: ErrorEnvelope?
    
    fileprivate let fetchHotelLoginCheckoutResponse: CheckoutLoginEnvelope?
    fileprivate let fetchHotelLoginCheckoutError: ErrorEnvelope?
    
    fileprivate let fetchHotelCheckoutResponse: CheckoutHotelCustomerEnvelope?
    fileprivate let fetchHotelCheckoutError: ErrorEnvelope?
    
    fileprivate let fetchMyOrderResponse: MyOrder?
    fileprivate let fetchOrdersListError: ErrorEnvelope?
    
    fileprivate let fetchOrderDataResponse: [OrderData]?
    fileprivate let fetchOrderDataError: ErrorEnvelope?
    
    init(appId: String = "firasrafislam.TiketReactions.TiketReactions.fake", serverConfig: TiketServerConfigType, tiketToken: TiketTokenType?, language: String, currency: String, buildVersion: String = "1") {
        self.init(appId: appId, serverConfig: serverConfig, tiketToken: tiketToken, language: language, currency: currency, buildVersion: buildVersion)
    }
    
    internal init(appId: String, serverConfig: TiketServerConfigType, tiketToken: TiketTokenType?, language: String, currency: String, buildVersion: String,
                  listPaymentMethodResult: Result<AvailablePaymentEnvelope, ErrorEnvelope>? = nil,
                  hotelResultsResponse: [HotelResult]? = nil,
                  hotelResultsError: ErrorEnvelope? = nil,
                  hotelDirectResponse: HotelDirect? = nil,
                  hotelDirectError: ErrorEnvelope? = nil,
                  fetchAddOrderHotelResponse: AddOrderEnvelope? = nil,
                  fetchAddOrderHotelError: ErrorEnvelope? = nil,
                  fetchHotelLoginCheckoutResponse: CheckoutLoginEnvelope? = nil,
                  fetchHotelLoginCheckoutError: ErrorEnvelope? = nil,
                  fetchHotelCheckoutResponse: CheckoutHotelCustomerEnvelope? = nil,
                  fetchHotelCheckoutError: ErrorEnvelope? = nil,
                  fetchMyOrderResponse: MyOrder? = nil,
                  fetchOrdersListError: ErrorEnvelope? = nil,
                  fetchOrderDataResponse: [OrderData]? = nil,
                  fetchOrderDataError: ErrorEnvelope? = nil) {
        
        self.appId = appId
        self.serverConfig = serverConfig
        self.tiketToken = tiketToken
        self.language = language
        self.currency = currency
        self.buildVersion = buildVersion
        
        self.listPaymentMethodResult = listPaymentMethodResult
        
        self.hotelResultsResponse = hotelResultsResponse
        
    }
    
    func getToken(_ tiketToken: TiketTokenType) -> FakeServices {
        
    }
    
    func getTokenEnvelope(clientAuth: ClientAuthType) -> SignalProducer<GetTokenEnvelope, ErrorEnvelope> {
        
    }
    
    func fetchAirports(query: String) -> SignalProducer<SearchAirportsEnvelope, ErrorEnvelope> {
        
    }
    
    func fetchFlightResults(params: SearchFlightParams) -> SignalProducer<SearchFlightEnvelope, ErrorEnvelope> {
        <#code#>
    }
    
    func fetchSingleFlightResults(params: SearchSingleFlightParams) -> SignalProducer<SearchSingleFlightEnvelope, ErrorEnvelope> {
        <#code#>
    }
    
    func addOrderFlight(params: GroupPassengersParam) -> SignalProducer<AddOrderFlightEnvelope, ErrorEnvelope> {
        <#code#>
    }
    
    func fetchHotelResults(paginationUrl: String) -> SignalProducer<SearchHotelEnvelopes, ErrorEnvelope> {
        <#code#>
    }
    
    func fetchHotelResults(params: SearchHotelParams) -> SignalProducer<SearchHotelEnvelopes, ErrorEnvelope> {
        <#code#>
    }
    
    func fetchResultsHotelByArea(uid: String) -> SignalProducer<SearchHotelAreaEnvelope, ErrorEnvelope> {
        <#code#>
    }
    
    func fetchAutocompleteHotel(query: String) -> SignalProducer<AutocompleteHotelEnvelope, ErrorEnvelope> {
        <#code#>
    }
    
    func fetchHotelDetail(url: String, params: SearchHotelParams) -> SignalProducer<HotelDirect, ErrorEnvelope> {
        <#code#>
    }
    
    func addOrder(url: String) -> SignalProducer<AddOrderEnvelope, ErrorEnvelope> {
        <#code#>
    }
    
    func checkoutPageRequest(url: String) -> SignalProducer<CheckoutPageRequestEnvelope, ErrorEnvelope> {
        <#code#>
    }
    
    func checkoutLogin(url: String, params: CheckoutLoginParams) -> SignalProducer<CheckoutLoginEnvelope, ErrorEnvelope> {
        <#code#>
    }
    
    func checkoutHotelCustomer(url: String, params: CheckoutGuestParams) -> SignalProducer<CheckoutHotelCustomerEnvelope, ErrorEnvelope> {
        <#code#>
    }
    
    func availablePaymentsHotel() -> SignalProducer<AvailablePaymentEnvelope, ErrorEnvelope> {
        <#code#>
    }
    
    func fetchHotelOrder() -> SignalProducer<HotelOrderEnvelope, ErrorEnvelope> {
        <#code#>
    }
    
    func fetchFlightOrder() -> SignalProducer<FlightOrderEnvelope, ErrorEnvelope> {
        <#code#>
    }
    
    func payCheckout(url: String) -> SignalProducer<CheckoutPayEnvelope, ErrorEnvelope> {
        <#code#>
    }
    
    func deleteOrder(url: String) -> SignalProducer<AddOrderEnvelope, ErrorEnvelope> {
        <#code#>
    }
}
