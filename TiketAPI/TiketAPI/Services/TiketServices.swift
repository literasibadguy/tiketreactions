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

private extension Bundle {
    var _buildVersion: String {
        return (self.infoDictionary?["CFBundleVersion"] as? String) ?? "1"
    }
}

public struct TiketServices: TiketServiceType {
    
    public let language: String
    public let serverConfig: TiketServerConfigType
    public let tiketToken: TiketTokenType?
    
    public init(serverConfig: TiketServerConfigType = TiketServerConfig.staging, tiketToken: TiketTokenType? = nil, language: String = "id") {
        self.serverConfig = serverConfig
        self.tiketToken = tiketToken
        self.language = language
    }
    
    public func getToken(_ tiketToken: TiketTokenType) -> TiketServices {
        return TiketServices(serverConfig: self.serverConfig, tiketToken: tiketToken, language: self.language)
    }
    
    public func getTokenEnvelope(clientAuth: ClientAuthType) -> SignalProducer<GetTokenEnvelope, ErrorEnvelope> {
        return requestToken(.getToken(clientAuth))
    }
    
    public func fetchAirports(query: String) -> SignalProducer<SearchAirportsEnvelope, ErrorEnvelope> {
        return request(.searchAirport(query))
    }
    
    public func fetchFlighResults(params: SearchFlightParams) -> SignalProducer<SearchFlightEnvelope, ErrorEnvelope> {
        return request(.searchFlights(params))
    }
    
    public func addOrderFlight(params: GroupPassengersParam) -> SignalProducer<AddOrderFlightEnvelope, ErrorEnvelope> {
        return request(.addOrderFlight(params))
    }
    
    public func fetchHotelResults(paginationUrl: String) -> SignalProducer<SearchHotelEnvelopes, ErrorEnvelope> {
        return requestPagination(paginationUrl)
    }
    
    public func fetchHotelResults(params: SearchHotelParams) -> SignalProducer<SearchHotelEnvelopes, ErrorEnvelope> {
        return request(.searchHotel(params))
    }
    
    public func fetchAutocompleteHotel(query: String) -> SignalProducer<AutocompleteHotelEnvelope, ErrorEnvelope> {
        return request(.searchHotelAutocomplete(query))
    }
    
    public func fetchHotelDetail(url: String, params: SearchHotelParams) -> SignalProducer<HotelDirect, ErrorEnvelope> {
        return request(.viewDetailHotel(url))
    }
    
    public func addOrder(url: String) -> SignalProducer<AddOrderEnvelope, ErrorEnvelope> {
        return request(.addOrderHotel(url))
    }
    
    public func checkoutHotelGuest(url: String, params: CheckoutGuestParams) -> SignalProducer<CheckoutHotelCustomerEnvelope, ErrorEnvelope> {
        return request(.checkoutHotelGuest(params))
        
    }
    
    public func checkoutTempHotel(params: CheckoutGuestParams) -> SignalProducer<CheckoutHotelTemporary, ErrorEnvelope> {
        return request(.checkoutHotelGuest(params))
    }
    
    public func fetchHotelOrder() -> SignalProducer<HotelOrderEnvelope, ErrorEnvelope> {
        return request(.orderHotel)
    }
    
    public func deleteOrder(url: String) -> SignalProducer<AddOrderEnvelope, ErrorEnvelope> {
        return request(.deleteOrderHotel(url))
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
    
    /*
    private func fetch<A: Swift.Decodable>(query: NonEmptySet<Query>) -> SignalProducer<A, ErrorEnvelope> {
        
        return SignalProducer<A, ErrorEnvelope> { observer, disposable in
            
            let request = self.preparedRequest(forURL: self.serverConfig.graphQLEndpointUrl,
                                               queryString: Query.build(query))
            let task = URLSession.shared.dataTask(with: request) {  data, response, error in
                if let error = error {
                    observer.send(error: .requestError(error, response))
                    return
                }
                
                guard let data = data else {
                    observer.send(error: .emptyResponse(response))
                    return
                }
                
                do {
                    let decodedObject = try JSONDecoder().decode(GraphResponse<A>.self, from: data)
                    if let value = decodedObject.data {
                        observer.send(value: value)
                    }
                } catch let error {
                    observer.send(error: .jsonDecodingError(responseString: String(data: data, encoding: .utf8),
                                                            error: error))
                }
                observer.sendCompleted()
            }
            disposable.add(task.cancel)
            task.resume()
        }
    }
    */
    
    private func requestPagination<M: Argo.Decodable>(_ paginationUrl: String) -> SignalProducer<M, ErrorEnvelope> where M == M.DecodedType {
        guard let paginationUrl = URL(string: paginationUrl) else {
            return .init(error: .invalidPaginationUrl)
        }
        

        return TiketServices.session.rac_JSONResponse(preparedRequest(forURL: paginationUrl)).flatMap(decodeModel)
    }
    
    private func request<M: Argo.Decodable>(_ route: Route)
        -> SignalProducer<M, ErrorEnvelope> where M == M.DecodedType {
            
            let properties = route.requestProperties
            
            guard let URL = URL(string: properties.path, relativeTo: self.serverConfig.apiBaseUrl as URL) else {
                fatalError(
                    "URL(string: \(properties.path), relativeToURL: \(self.serverConfig.apiBaseUrl)) == nil"
                )
            }
            
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
