//
//  NSURLSession.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 10/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes
import Foundation
import ReactiveSwift
import Result
import TiketKitModels

private func parseJSONData(_ data: Data) -> Any? {
    return (try? JSONSerialization.jsonObject(with: data, options: []))
}

private let defaultSessionError = NSError(domain: "firasrafislam.TiketReactions.rac_dataWithRequest", code: 1, userInfo: nil)
private let boundary = "TiketReactions"

private let scheduler = QueueScheduler(qos: .background, name: "firasrafislam.TiketReactions", targeting: nil)

internal extension URLSession {
    
    internal func rac_dataResponse(_ request: URLRequest, uploading file: (url: URL, name: String)? = nil) -> SignalProducer<Data, ErrorEnvelope> {
        
        let producer = file.map { self.rac_dataWithRequest(request, uploading: $0, named: $1) } ?? self.reactive.data(with: request)
        
        return producer
            .start(on: scheduler)
            .flatMapError { _ in SignalProducer(error: .couldNotParseErrorEnvelopeJSON) }
            .flatMap(.concat) { data, response -> SignalProducer<Data, ErrorEnvelope> in
                guard let response = response as? HTTPURLResponse else { fatalError() }
                
                guard
                    (200..<300).contains(response.statusCode),
                    let headers = response.allHeaderFields as? [String: String],
                    let contentType = headers["Content-Type"], contentType.hasPrefix("application/json")
                    else {
                        
                        print("[TiketReactions] Failure \(self.sanitized(request))")
                        
                        if let json = parseJSONData(data) {
                            switch decode(json) as Decoded<ErrorEnvelope> {
                            case let .success(envelope):
                                return SignalProducer(error: envelope)
                            case let .failure(error):
                                return SignalProducer(error: .couldNotDecodeJSON(error))
                            }
                        } else {
                            return SignalProducer(error: .couldNotParseErrorEnvelopeJSON)
                        }
                }
                
                return SignalProducer(value: data)
        }
    }
    
    internal func rac_JSONResponse(_ request: URLRequest) -> SignalProducer<Any, ErrorEnvelope> {
        
        return self.rac_dataResponse(request)
            .map(parseJSONData)
            .flatMap { json -> SignalProducer<Any, ErrorEnvelope> in
                guard let json = json else {
                    return .init(error: .couldNotParseJSON)
                }
                return .init(value: json)
        }
    }
    
    fileprivate static let sanitationRules = [
        "client_id=[REDACTED]":
            try! NSRegularExpression(pattern: "client_id=([a-zA-Z0-9]*)", options: .caseInsensitive),
        "access_token=[REDACTED]":
            try! NSRegularExpression(pattern: "access_token=([a-zA-Z0-9]*)", options: .caseInsensitive),
        ]
    
    fileprivate func sanitized(_ request: URLRequest) -> String {
        guard let urlString = request.url?.absoluteString else { return "" }
        
        return URLSession.sanitationRules.reduce(urlString) { accum, templateAndRule in
            let (template, rule) = templateAndRule
            let range = NSRange(location: 0, length: accum.count)
            return rule.stringByReplacingMatches(in: accum,
                                                 options: .withTransparentBounds,
                                                 range: range,
                                                 withTemplate: template)
        }
    }
}

extension URLSession {
    fileprivate func rac_dataWithRequest(_ request: URLRequest, uploading file: URL, named name: String) -> SignalProducer<(Data, URLResponse), AnyError> {
        
        var mutableRequest = request
        
        mutableRequest.setValue("multipart/fortm-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        return SignalProducer { observer, _ in
            let task = self.dataTask(with: mutableRequest) {data , response , error in
                guard let data = data, let response = response else {
                    observer.send(error: AnyError(error ?? defaultSessionError))
                    return
                }
                observer.send(value: (data, response))
                observer.sendCompleted()
            }
            task.resume()
        }
    }
}
