//
//  ErrorEnvelope.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 10/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes


import Argo
import Curry
import Runes

public struct ErrorEnvelope {
    public let errorMessages: [String]
    public let tiketCode: TiketCode?
    public let httpCode: Int
    
    public init(errorMessages: [String], tiketCode: TiketCode?, httpCode: Int) {
        self.errorMessages = errorMessages
        self.tiketCode = tiketCode
        self.httpCode = httpCode
    }
    
    public enum TiketCode: String {
        case UnknownCode = "__internal_unknown_code"
        
        // Codes defined by the client
        case JSONParsingFailed = "json_parsing_failed"
        case ErrorEnvelopeJSONParsingFailed = "error_json_parsing_failed"
        case DecodingJSONFailed = "decoding_json_failed"
        case InvalidPaginationUrl = "invalid_pagination_url"
    }
    
    internal static let couldNotParseJSON = ErrorEnvelope(errorMessages: [], tiketCode: .JSONParsingFailed, httpCode: 400)
    
    internal static let couldNotParseErrorEnvelopeJSON = ErrorEnvelope(errorMessages: [], tiketCode: .ErrorEnvelopeJSONParsingFailed, httpCode: 400)
    
    internal static func couldNotDecodeJSON(_ decodeError: DecodeError) -> ErrorEnvelope {
        return ErrorEnvelope(errorMessages: ["Argo decoding error: \(decodeError.description)"], tiketCode: .DecodingJSONFailed, httpCode: 400)
    }
    
    internal static let invalidPaginationUrl = ErrorEnvelope(errorMessages: [], tiketCode: .InvalidPaginationUrl, httpCode: 400)
}

extension ErrorEnvelope: Error {}

extension ErrorEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<ErrorEnvelope> {
        let standardErrorEnvelope = curry(ErrorEnvelope.init)
            <^> json <|| "error_messages"
            <*> json <|? "tiket_code"
            <*> json <| "http_code"
        
        return standardErrorEnvelope
    }
}

extension ErrorEnvelope.TiketCode: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<ErrorEnvelope.TiketCode> {
        switch json {
        case let .string(s):
            return pure(ErrorEnvelope.TiketCode(rawValue: s) ?? ErrorEnvelope.TiketCode.UnknownCode)
        default:
            return .typeMismatch(expected: "ErrorEnvelope.TiketCode", actual: json)
        }
    }
}

private func concatSuccesses<A>(_ decodeds: [Decoded<[A]>]) -> Decoded<[A]> {
    return decodeds.reduce(Decoded.success([])) { accum, decoded in
        .success( (accum.value ?? []) + (decoded.value ?? []) )
    }
}
