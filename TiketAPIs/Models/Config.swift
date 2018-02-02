//
//  Config.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 31/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct Config {
    public private(set) var countryCode: String
    public private(set) var iTunesLink: String
    public private(set) var locale: String
}

extension Config: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<Config> {
        return curry(Config.init)
            <^> json <| "country_code"
            <*> json <| "itunes_link"
            <*> json <| "locale"
    }
}

extension Config: Equatable {
}
public func == (lhs: Config, rhs: Config) -> Bool {
    return lhs.countryCode == rhs.countryCode &&
        lhs.iTunesLink == rhs.iTunesLink &&
        lhs.locale == rhs.locale
}

extension Config: EncodableType {
    public func encode() -> [String : Any] {
        var result: [String: Any] = [:]
        result["country_code"] = self.countryCode
        result["itunes_link"] = self.iTunesLink
        result["locale"] = self.locale
        return result
    }
}


