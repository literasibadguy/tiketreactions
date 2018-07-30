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

public struct DeleteOrderEnvelope {
    public let diagnostic: Diagnostic
    public let updateStatus: String
    public let loginStatus: String
    public let guestId: String
    public let loginEmail: String
}

extension DeleteOrderEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<DeleteOrderEnvelope> {
        return curry(DeleteOrderEnvelope.init)
            <^> json <| "diagnostic"
            <*> json <| "updateStatus"
            <*> json <| "login_status"
            <*> json <| "guest_id"
            <*> json <| "login_email"
    }
}

extension AddOrderEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<AddOrderEnvelope> {
        return curry(AddOrderEnvelope.init)
            <^> json <| "diagnostic"
    }
}
