//
//  TiketToken.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 12/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

// A Token that agree with Tiket API in every requests

public protocol TiketTokenType {
    var token: String { get }
}

public func == (lhs: TiketTokenType, rhs: TiketTokenType) -> Bool {
    return type(of: lhs) == type(of: rhs) &&
        lhs.token == rhs.token
}

public func == (lhs: TiketTokenType?, rhs: TiketTokenType?) -> Bool {
    return type(of: lhs) == type(of: rhs) &&
        lhs?.token == rhs?.token
}

public struct TiketToken: TiketTokenType {
    public let token: String
    
    public init(token: String) {
        self.token = token
    }
}
