//
//  AddOrderEnvelope.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 18/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct AddOrderEnvelope {
    public let diagnostic: Diagnostic
}

extension AddOrderEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<AddOrderEnvelope> {
        return curry(AddOrderEnvelope.init)
            <^> json <| "diagnostic"
    }
}
