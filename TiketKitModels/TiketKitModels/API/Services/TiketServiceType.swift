//
//  TiketServicesType.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 10/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result

// Make a Protocol Name 'SuiteServiceType' like functions
public protocol TiketServiceType {
    var language: String { get }
    var serverConfig: TiketServerConfigType { get }
    var tiketToken: TiketTokenType? { get }
    var currency: String { get }
    var buildVersion: String { get }
    
    init(serverConfig: TiketServerConfigType, tiketToken: TiketTokenType?, language: String, currency: String, buildVersion: String)
    
    func getToken(_ tiketToken: TiketTokenType) -> Self
    
    func selectedCurrency(_ currency: String) -> Self
   
    func getTokenEnvelope(clientAuth: ClientAuthType) -> SignalProducer<GetTokenEnvelope, ErrorEnvelope>
    
    func listCurrencyEnvelope() -> SignalProducer<CurrencyListEnvelope, ErrorEnvelope>
    
    func listCountryEnvelope() -> SignalProducer<CountryListEnvelope, ErrorEnvelope>

    func fetchAirports(query: String) -> SignalProducer<SearchAirportsEnvelope, ErrorEnvelope>
    func fetchFlightResults(params: SearchFlightParams) -> SignalProducer<SearchFlightEnvelope, ErrorEnvelope>
    func fetchSingleFlightResults(params: SearchSingleFlightParams) -> SignalProducer<SearchSingleFlightEnvelope, ErrorEnvelope>
    
    func getFlightData(params: GetFlightDataParams) -> SignalProducer<GetFlightDataEnvelope, ErrorEnvelope>
    
    func addOrderFlight(params: GroupPassengersParam) -> SignalProducer<AddOrderFlightEnvelope, ErrorEnvelope>
    
    func fetchHotelResults(paginationUrl: String) -> SignalProducer<SearchHotelEnvelopes, ErrorEnvelope>
    
    func fetchHotelResults(params: SearchHotelParams) -> SignalProducer<SearchHotelEnvelopes, ErrorEnvelope>
    
    func fetchHotelResultsPagination(_ page: Int, params: SearchHotelParams) -> SignalProducer<SearchHotelEnvelopes, ErrorEnvelope>
    
    func fetchResultsHotelByArea(uid: String) -> SignalProducer<SearchHotelAreaEnvelope, ErrorEnvelope>
    
    func fetchAutocompleteHotel(query: String) -> SignalProducer<AutocompleteHotelEnvelope, ErrorEnvelope>
    
    func fetchHotelDetail(url: String, params: SearchHotelParams) -> SignalProducer<HotelDirect, ErrorEnvelope>
    
    func addOrder(url: String) -> SignalProducer<AddOrderEnvelope, ErrorEnvelope>
    
    func checkoutPageRequest(url: String) -> SignalProducer<CheckoutPageRequestEnvelope, ErrorEnvelope>
    
    func checkoutLogin(url: String, params: CheckoutLoginParams) -> SignalProducer<CheckoutLoginEnvelope, ErrorEnvelope>
    
    func checkoutFlightLogin(url: String, params: CheckoutLoginParams) -> SignalProducer<CheckoutFlightLoginEnvelope, ErrorEnvelope>
    
    func checkoutHotelCustomer(url: String, params: CheckoutGuestParams) -> SignalProducer<CheckoutHotelCustomerEnvelope, ErrorEnvelope>
    
    func availablePaymentsHotel() -> SignalProducer<AvailablePaymentEnvelope, ErrorEnvelope>
    
    func fetchHotelOrder() -> SignalProducer<HotelOrderEnvelope, ErrorEnvelope>
    
    func fetchFlightOrder() -> SignalProducer<FlightOrderEnvelope, ErrorEnvelope>
    
    func payCheckout(url: String) -> SignalProducer<CheckoutPayEnvelope, ErrorEnvelope>
    
    func deleteOrder(url: String) -> SignalProducer<DeleteOrderEnvelope, ErrorEnvelope>
    
    func deleteFlightOrder(url: String) -> SignalProducer<FlightOrderDeleteEnvelope, ErrorEnvelope>
    
    func checkHistoryOrder(_ orderId: String, email: String) -> SignalProducer<CheckHistoryOrderEnvelope, ErrorEnvelope>
    
    // Payment Methods
    
    func bankTransferRequest() -> SignalProducer<BankTransferPaymentEnvelope, ErrorEnvelope>
    
    func atmTransferRequest(currency: String) -> SignalProducer<InstantTransferPaymentEnvelope, ErrorEnvelope>
    
    func virtualAccountTransfer() -> SignalProducer<VirtualAccountTransfersEnvelope, ErrorEnvelope>
    
    func klikBCARequest(_ user: String) -> SignalProducer<KlikBCAPaymentEnvelope, ErrorEnvelope>
    
    func createCreditCardRequest(token: String) -> SignalProducer<URLRequest, NoError>
    
    func sandboxCreditCard(_ token: String) -> SignalProducer<URLRequest, NoError>
    
    func bcaKlikpayRequest(_ token: String) -> SignalProducer<URLRequest, NoError>
    
    func cimbClicksRequest(_ token: String) -> SignalProducer<URLRequest, NoError>
    
    func epayBRIRequest(_ token: String) -> SignalProducer<URLRequest, NoError>
}

public func == (lhs: TiketServiceType, rhs: TiketServiceType) -> Bool {
    return type(of: lhs) == type(of: rhs) &&
        lhs.serverConfig == rhs.serverConfig &&
        lhs.tiketToken == rhs.tiketToken &&
        lhs.language == rhs.language
}

public func != (lhs: TiketServiceType, rhs: TiketServiceType) -> Bool {
    return !(lhs == rhs)
}

public enum ArrayEncoding {
    case brackets, noBrackets
    
    func encode(key: String) -> String {
        switch self {
        case .brackets:
            return "\(key)[]"
        case .noBrackets:
            return key
        }
    }
}

extension TiketServiceType {

    
    fileprivate var defaultHeaders: [String: String] {
        var headers: [String: String] = [:]
        headers["User-Agent"] = "twh:27029614;Jajanan Online;"
        return headers
    }
    
    fileprivate var defaultQueryParams: [String: String] {
        var query: [String: String] = [:]
        query["token"] = self.tiketToken?.token
        query["currency"] = self.currency
        query["output"] = "json"
        return query
    }
    
    fileprivate func queryComponents(_ key: String, _ value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", escapePhone("\(value)"))
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents("\(key)[]", value)
            }
        } else {
            components.append((key, escapePhone("\(value)")))
        }
        
        return components
    }
    
    public func preparedRequest(forRequest originalRequest: URLRequest, query: [String: Any] = [:]) -> URLRequest {
        var request = originalRequest
        guard let URL = request.url else {
            return originalRequest
        }
        var headers = self.defaultHeaders
        
        let method = request.httpMethod?.uppercased()
        var components = URLComponents(url: URL, resolvingAgainstBaseURL: false)!
        var queryItems = components.queryItems ?? []
        queryItems.append(contentsOf: self.defaultQueryParams.map(URLQueryItem.init(name:value:)))
        
        if method == .some("POST") || method == .some("PUT") {
            if request.httpBody == nil {
                headers["Content-Type"] = "application/json; charset=utf-8"
                request.httpBody = try? JSONSerialization.data(withJSONObject: query, options: [])
            }
        } else {
            queryItems.append(contentsOf: query.flatMap(queryComponents).map(URLQueryItem.init(name:value:))
            )
//            print("WHATS IN QUERY ITEMS: \(queryItems)")
        }
        components.queryItems = queryItems.sorted { $0.name < $1.name }
        request.url = components.url
        
        let currentHeaders = request.allHTTPHeaderFields ?? [:]
        request.allHTTPHeaderFields = currentHeaders.withAllValuesFrom(headers)
        
        return request
    }
    
    public func preparedRequest(forURL url: URL, method: Method = .GET, query: [String: Any] = [:]) ->  URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return self.preparedRequest(forRequest: request, query: query)
    }
    
    public func preparedTokenRequest(forTokenRequest tokenRequest: URLRequest, method: Method = .GET) -> URLRequest {
        var request = tokenRequest
        request.httpMethod = method.rawValue
        /*
        guard let URL = request.url else {
            return tokenRequest
        }
        
        var components = URLComponents(url: URL, resolvingAgainstBaseURL: false)!
        var queryItems = components.queryItems ?? []
        
        request.url = components.url
        */
        
        return request
    }
    
    public func escapePhone(_ value: String) -> String {
        let customAllowedSet =  NSCharacterSet(charactersIn:"+").inverted
        let escapedString = value.addingPercentEncoding(withAllowedCharacters: customAllowedSet)
        
        return escapedString!
    }
}
