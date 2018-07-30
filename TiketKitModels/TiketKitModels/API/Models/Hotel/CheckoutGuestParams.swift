//
//  CheckoutGuestParams.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 18/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct CheckoutGuestParams {
    public let salutation: String?
    public let firstName: String?
    public let lastName: String?
    public let phone: String?
    // Contact Person
    public let conSalutation: String?
    public let conFirstName: String?
    public let conLastName: String?
    public let conEmailAddress: String?
    
    public let conPhone: String?
    public let detailId: String?
    public let country: String?
    
    public static let defaults = CheckoutGuestParams(salutation:
        "", firstName: "", lastName: "", phone: "", conSalutation: "", conFirstName: "", conLastName: "", conEmailAddress: "", conPhone: "", detailId: "", country: "")
    
    public var queryParams: [String: String] {
        var params: [String: String] = [:]
        params["salutation"] = self.salutation
        params["firstName"] = self.firstName
        params["lastName"] = self.lastName
        params["phone"] = self.phone
        params["conSalutation"] = self.conSalutation
        params["conFirstName"] = self.conFirstName
        params["conLastName"] = self.conLastName
        params["conEmailAddress"] = self.conEmailAddress
        params["conPhone"] = self.conPhone
        params["detailId"] = self.detailId
        params["country"] = self.country
        
        return params
    }
}

extension CheckoutGuestParams: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<CheckoutGuestParams> {
        let tmp1 = curry(CheckoutGuestParams.init)
            <^> json <|? "salutation"
            <*> json <|? "firstName"
            <*> json <|? "lastName"
            <*> json <|? "phone"
        
        let tmp2 = tmp1
            <*> json <|? "conSalutation"
            <*> json <|? "conFirstName"
            <*> json <|? "conLastName"
            <*> json <|? "conEmailAddress"
        
        return tmp2
            <*> json <|? "conPhone"
            <*> json <|? "detailId"
            <*> json <|? "country"
    }
}
