//
//  CheckoutLoginCustomerEnvelope.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 14/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct CheckoutLoginParams {
    public let salutation: String?
    public let firstName: String?
    public let lastName: String?
    public let email: String?
    public let phone: String?
    public let saveContinue: String?
    
    public static let defaults = CheckoutLoginParams(salutation: "", firstName: "", lastName: "", email: "", phone: "", saveContinue: "2")
    
    public var queryParams: [String: String] {
        var params: [String: String] = [:]
        params["salutation"] = self.salutation
        params["firstName"] = self.firstName
        params["lastName"] = self.lastName
        params["emailAddress"] = self.email
        params["phone"] = self.phone
        params["saveContinue"] = "2"
 
        return params
    }
}

public struct CheckoutLoginEnvelope {
    public let diagnostic: Diagnostic
    public let loginStatus: String
}


extension CheckoutLoginEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<CheckoutLoginEnvelope> {
        return curry(CheckoutLoginEnvelope.init)
            <^> json <| "diagnostic"
            <*> json <| "login_status"
    }
}
