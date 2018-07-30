//
//  FakeTiketServices.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 10/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
#if DEBUG
import Foundation
import Prelude
import ReactiveSwift
import Result
    
    internal struct FakeTiketServices: TiketServiceType {
        internal let language: String
        internal let serverConfig: TiketServerConfigType
        
        fileprivate let fetchHotelResultsResponse: SearchHotelEnvelopes?
        fileprivate let fetchHotelResultsError: ErrorEnvelope?
        
        internal init(serverConfig: TiketServerConfigType, language: String) {
            self.init(serverConfig: serverConfig, language: language)
        }
        
        internal init(serverConfig: TiketServerConfigType = TiketServerConfig.production, language: String = "en", fetchHotelResultsResponse: SearchHotelEnvelopes? = nil, fetchHotelResultsError: ErrorEnvelope? = nil) {
            self.serverConfig = serverConfig
            self.language = language
            self.fetchHotelResultsResponse = fetchHotelResultsResponse
            self.fetchHotelResultsError = fetchHotelResultsError
        }
        
        func fetchHotelResults(paginationUrl: String) -> SignalProducer<SearchHotelEnvelopes, ErrorEnvelope> {
            if let error = fetchHotelResultsError {
                return SignalProducer(error: error)
            }
            
            
        }
        
        func fetchHotelResults(params: SearchHotelParams) -> SignalProducer<SearchHotelEnvelopes, ErrorEnvelope> {
            if let error = fetchHotelResultsError {
                return SignalProducer(error: error)
            }

        }
        
        
    }
    
#endif
