//
//  Decodable.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 10/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo

public extension Argo.Decodable {
    
    static func decodeJSONDictionary(_ json: [String: Any]) -> Decoded<DecodedType> {
        return Self.decode(JSON(json))
    }
}

