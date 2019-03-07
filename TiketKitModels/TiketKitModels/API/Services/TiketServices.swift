//
//  TiketServices.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 10/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Foundation
import Prelude
import ReactiveSwift
import Result

public extension Bundle {
    var _buildVersion: String {
        return (self.infoDictionary?["CFBundleVersion"] as? String) ?? "1"
    }
}

public struct TiketServices: TiketServiceType {
    public let language: String
    public let serverConfig: TiketServerConfigType
    public let tiketToken: TiketTokenType?
    public let currency: String
    public let buildVersion: String
    
    public init(serverConfig: TiketServerConfigType = TiketServerConfig.staging, tiketToken: TiketTokenType? = nil, language: String = "id", currency: String = "IDR", buildVersion: String = Bundle.main._buildVersion) {
        self.serverConfig = serverConfig
        self.tiketToken = tiketToken
        self.language = language
        self.currency = currency
        self.buildVersion = buildVersion
    }
    
    public func getToken(_ tiketToken: TiketTokenType) -> TiketServices {
        return TiketServices(serverConfig: self.serverConfig, tiketToken: tiketToken, language: self.language)
    }
    
    public func selectedCurrency(_ currency: String) -> TiketServices {
        return TiketServices(serverConfig: self.serverConfig, tiketToken: self.tiketToken, language: self.language, currency: currency)
    }
    
    public func listCurrencyEnvelope() -> SignalProducer<CurrencyListEnvelope, ErrorEnvelope> {
        return request(.listCurrency())
    }
    
    public func listCountryEnvelope() -> SignalProducer<CountryListEnvelope, ErrorEnvelope> {
        return request(.listCountry())
    }
    
    public func getTokenEnvelope(clientAuth: ClientAuthType) -> SignalProducer<GetTokenEnvelope, ErrorEnvelope> {
        return requestToken(.getToken(clientAuth))
    }
    
    public func fetchAirports(query: String) -> SignalProducer<SearchAirportsEnvelope, ErrorEnvelope> {
        return request(.searchAirport(query))
    }
    
    public func fetchFlightResults(params: SearchFlightParams) -> SignalProducer<SearchFlightEnvelope, ErrorEnvelope> {
        return request(.searchFlights(params))
    }
    
    public func fetchSingleFlightResults(params: SearchSingleFlightParams) -> SignalProducer<SearchSingleFlightEnvelope, ErrorEnvelope> {
        return request(.searchSingleFlights(params))
    }
    
    public func getFlightData(params: GetFlightDataParams) -> SignalProducer<GetFlightDataEnvelope, ErrorEnvelope> {
        return request(.getFlightData(params))
    }
    
    public func forceUpdate(params: GetFlightDataParams) -> SignalProducer<URLRequest, NoError> {
        return getRequestPayment(.forceUpdateFlight(params, "3"))
    }
    
    public func addOrderFlight(params: GroupPassengersParam) -> SignalProducer<AddOrderFlightEnvelope, ErrorEnvelope> {
        return request(.addOrderFlight(contact: params))
    }
    
    public func fetchHotelResults(paginationUrl: String) -> SignalProducer<SearchHotelEnvelopes, ErrorEnvelope> {
        return requestPagination(paginationUrl)
    }
    
    public func fetchHotelResults(params: SearchHotelParams) -> SignalProducer<SearchHotelEnvelopes, ErrorEnvelope> {
        return request(.searchHotel(params))
    }
    
    public func fetchHotelResultsPagination(_ page: Int, params: SearchHotelParams) -> SignalProducer<SearchHotelEnvelopes, ErrorEnvelope> {
        return request(.searchHotelPage(String(page), params))
    }
    
    public func fetchAutocompleteHotel(query: String) -> SignalProducer<AutocompleteHotelEnvelope, ErrorEnvelope> {
        return request(.searchHotelAutocomplete(query))
    }
    
    public func fetchResultsHotelByArea(uid: String) -> SignalProducer<SearchHotelAreaEnvelope, ErrorEnvelope> {
        return request(.searchHotelByArea(uid))
    }
    
    public func fetchHotelDetail(url: String, params: SearchHotelParams) -> SignalProducer<HotelDirect, ErrorEnvelope> {
        return request(.viewDetailHotel(url))
    }
    
    public func addOrder(url: String) -> SignalProducer<AddOrderEnvelope, ErrorEnvelope> {
        return request(.addOrderHotel(url))
    }
    
    public func checkoutPageRequest(url: String) -> SignalProducer<CheckoutPageRequestEnvelope, ErrorEnvelope> {
        return request(.checkoutPageRequest(url))
    }
    
    public func checkoutLogin(url: String, params: CheckoutLoginParams) -> SignalProducer<CheckoutLoginEnvelope, ErrorEnvelope> {
        return request(.checkoutLogin(params))
    }
    
    public func checkoutFlightLogin(url: String, params: CheckoutLoginParams) -> SignalProducer<CheckoutFlightLoginEnvelope, ErrorEnvelope> {
        return request(.checkoutLogin(params))
    }
    
    public func checkoutHotelCustomer(url: String, params: CheckoutGuestParams) -> SignalProducer<CheckoutHotelCustomerEnvelope, ErrorEnvelope> {
        return requestCheckoutCustomer(.checkoutHotelCustomer(params))
    }
    
    public func availablePaymentsHotel() -> SignalProducer<AvailablePaymentEnvelope, ErrorEnvelope> {
        return request(.availablePayment)
    }
    
    public func fetchHotelOrder() -> SignalProducer<HotelOrderEnvelope, ErrorEnvelope> {
        return request(.orderHotel)
    }
    
    public func fetchFlightOrder() -> SignalProducer<FlightOrderEnvelope, ErrorEnvelope> {
        return request(.orderFlight)
    }
    
    public func payCheckout(url: String) -> SignalProducer<CheckoutPayEnvelope, ErrorEnvelope> {
        return request(.payCheckout(url))
    }
    
    public func deleteOrder(url: String) -> SignalProducer<DeleteOrderEnvelope, ErrorEnvelope> {
        return request(.deleteOrderHotel(url))
    }
    
    public func deleteFlightOrder(url: String) -> SignalProducer<FlightOrderDeleteEnvelope, ErrorEnvelope> {
        return request(.deleteOrderHotel(url))
    }
    
    public func checkHistoryOrder(_ orderId: String, email: String) -> SignalProducer<CheckHistoryOrderEnvelope, ErrorEnvelope> {
        return request(.checkHistoryOrder(orderId, email))
    }
    
    public func bankTransferRequest(currency: String) -> SignalProducer<BankTransferPaymentEnvelope, ErrorEnvelope> {
        return request(.bankTransfer(currency))
    }
    
    public func atmTransferRequest(currency: String) -> SignalProducer<InstantTransferPaymentEnvelope, ErrorEnvelope> {
        return request(.instantBankTransfer(currency))
    }
    
    public func klikBCARequest(_ user: String) -> SignalProducer<KlikBCAPaymentEnvelope, ErrorEnvelope> {
        return request(.klikBCA(user))
    }
    
    public func createCreditCardRequest(token: String) -> SignalProducer<URLRequest, NoError> {
        return getRequestPayment(.creditCard(token))
    }
    
    public func bcaKlikpayRequest(_ token: String) -> SignalProducer<URLRequest, NoError> {
        return getRequestPayment(.bcaKlikpay(token))
    }
    
    public func cimbClicksRequest(_ token: String) -> SignalProducer<URLRequest, NoError> {
        return getRequestPayment(.cimbClicks(token))
    }
    
    public func epayBRIRequest(_ token: String) -> SignalProducer<URLRequest, NoError> {
        return getRequestPayment(.epayBri(token))
    }
    
    public func sandboxCreditCard(_ token: String) -> SignalProducer<URLRequest, NoError> {
        guard let url = URL(string: "https://sandbox.tiket.com/payment/checkout_payment?checkouttoken=\(token)") else {
            fatalError()
        }
        
        let request = URLRequest(url: url)
        return SignalProducer(value: request)
    }
    
    private func getRequestPayment(_ route: Route) -> SignalProducer<URLRequest, NoError> {
        let properties = route.requestProperties
        
        let sandboxRelative = URL(string: "https://tiket.com/")!
        
        guard let url = URL(string: properties.path, relativeTo: sandboxRelative as URL) else {
            fatalError(
                "URL(string: \(properties.path), relativeToURL: \(sandboxRelative)) == nil"
            )
        }
        
        let request = URLRequest(url: url)
        return SignalProducer(value: request)
    }
    
    private static let session = URLSession(configuration: .default)
    
    private func decodeModel<M: Argo.Decodable>(_ json: Any) -> SignalProducer<M, ErrorEnvelope> where M == M.DecodedType {
        return SignalProducer(value: json)
            .map { json in decode(json) as Decoded<M> }
            .flatMap(.concat) { (decoded: Decoded<M>) -> SignalProducer<M, ErrorEnvelope> in
                switch decoded {
                case let .success(value):
                    return .init(value: value)
                case let .failure(error):
                    print("Argo decoding model \(M.self) error: \(error)")
                    return .init(error: .couldNotDecodeJSON(error))
                }
        }
    }
    
    private func decodeModels<M: Argo.Decodable>(_ json: Any) ->
        SignalProducer<[M], ErrorEnvelope> where M == M.DecodedType {
            
            return SignalProducer(value: json)
                .map { json in decode(json) as Decoded<[M]> }
                .flatMap(.concat) { (decoded: Decoded<[M]>) -> SignalProducer<[M], ErrorEnvelope> in
                    switch decoded {
                    case let .success(value):
                        return .init(value: value)
                    case let .failure(error):
                        print("Argo decoding model error: \(error)")
                        return .init(error: .couldNotDecodeJSON(error))
                    }
            }
    }
    
    private func requestPagination<M: Argo.Decodable>(_ paginationUrl: String) -> SignalProducer<M, ErrorEnvelope> where M == M.DecodedType {
        guard let paginationUrl = URL(string: paginationUrl) else {
            return .init(error: .invalidPaginationUrl)
        }
        

        return TiketServices.session.rac_JSONResponse(preparedRequest(forURL: paginationUrl)).flatMap(decodeModel)
    }
    
    private func requestCheckoutCustomer<M: Argo.Decodable>(_ route: Route) -> SignalProducer<M, ErrorEnvelope> where M == M.DecodedType {
        
        let properties = route.requestProperties
        
        guard let URL = URL(string: properties.path, relativeTo: self.serverConfig.apiBaseUrl as URL) else {
            fatalError(
                "URL(string: \(properties.path), relativeToURL: \(self.serverConfig.apiBaseUrl)) == nil"
            )
        }
        
        return TiketServices.session.rac_JSONResponse(preparedRequest(forURL: URL, method: properties.method, query: properties.query)).flatMap(decodeModel)
    }
    
    private func request<M: Argo.Decodable>(_ route: Route)
        -> SignalProducer<M, ErrorEnvelope> where M == M.DecodedType {
            
            let properties = route.requestProperties
            
            guard let URL = URL(string: properties.path, relativeTo: self.serverConfig.apiBaseUrl as URL) else {
                fatalError(
                    "URL(string: \(properties.path), relativeToURL: \(self.serverConfig.apiBaseUrl)) == nil"
                )
            }
            
            print("Whats Final URL here: \(URL.description)")
            return TiketServices.session.rac_JSONResponse(preparedRequest(forURL: URL, method: properties.method, query: properties.query)).flatMap(decodeModel)
    }
    
    private func requestToken<M: Argo.Decodable>(_ route: Route)
        -> SignalProducer<M, ErrorEnvelope> where M == M.DecodedType {
            
            let properties = route.requestProperties
            
            guard let URL = URL(string: properties.path, relativeTo: self.serverConfig.apiBaseUrl as URL) else {
                fatalError(
                    "URL(string: \(properties.path), relativeToURL: \(self.serverConfig.apiBaseUrl)) == nil"
                )
            }
            
            let urlRequest = URLRequest(url: URL)
            
            return TiketServices.session.rac_JSONResponse(preparedTokenRequest(forTokenRequest: urlRequest)).flatMap(decodeModel)
    }
    
    private func request<M: Argo.Decodable>(_ route: Route)
        -> SignalProducer<[M], ErrorEnvelope> where M == M.DecodedType {
            
            let properties = route.requestProperties
            
            let url = self.serverConfig.apiBaseUrl.appendingPathComponent(properties.path)
            
            return TiketServices.session.rac_JSONResponse(preparedRequest(forURL: url)).flatMap(decodeModels)
    }
    
    private func request<M: Argo.Decodable>(_ route: Route)
        -> SignalProducer<M?, ErrorEnvelope> where M == M.DecodedType {
            
            let properties = route.requestProperties
            
            guard let URL = URL(string: properties.path, relativeTo: self.serverConfig.apiBaseUrl as URL) else {
                fatalError(
                    "URL(string: \(properties.path), relativeToURL: \(self.serverConfig.apiBaseUrl)) == nil"
                )
            }
            
            print("WHATS SO URL: \(URL.absoluteString)")
            return TiketServices.session.rac_JSONResponse(preparedRequest(forURL: URL, method: properties.method, query: properties.query)).flatMap(decodeModel)
    }
    
    
    private func decodeModel<M: Argo.Decodable>(_ json: Any) -> SignalProducer<M?, ErrorEnvelope> where M == M.DecodedType {
        
        return SignalProducer(value: json)
            .map { json in decode(json) as M? }
    }
    

}
