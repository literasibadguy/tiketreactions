//
//  CurrentProfile.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 19/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct SummaryProfile {
    public let accountSalutationName: String
    public let accountFirstName: String
    public let accountLastName: String
    public let accountPhone: String
}

public struct CurrentProfile {
    
    public let accountId: String
    public let accountFirstName: String
    public let accountLastName: String
    public let accountMobile: String
    
    public let accountSalutationName: String
    public let accountPhone: String
    public let profileId: String
    public let name: String
    
    public let optionalDetail: OptionalProfileDetail
    
    public struct OptionalProfileDetail {
        public let accBirthDate: String?
        public let accGender: String?
        public let accIdCard: String?
        public let accIdCardType: String?
        public let accPassport: String?
        public let areaCode: String?
        public let passportExpiryDate: String?
        public let passportIssuedDate: String?
        public let passportIssuingCountry: String?
        public let passportNationality: String?
    }
}

extension SummaryProfile: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<SummaryProfile> {
        return curry(SummaryProfile.init)
            <^> json <| "account_salutation_name"
            <*> json <| "account_first_name"
            <*> json <| "account_last_name"
            <*> json <| "account_phone"
    }
}

extension CurrentProfile: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<CurrentProfile> {
        let tmp1 = curry(CurrentProfile.init)
            <^> json <| "account_id"
            <*> json <| "account_first_name"
            <*> json <| "account_last_name"
            <*> json <| "account_mobile"
        
        let tmp2 = tmp1
            <*> json <| "account_salutation_name"
            <*> json <| "account_phone"
            <*> json <| "profile_id"
            <*> json <| "Name"
        
        return tmp2
            <*> OptionalProfileDetail.decode(json)
        
    }
}

extension CurrentProfile.OptionalProfileDetail: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<CurrentProfile.OptionalProfileDetail> {
        
        let create = curry(CurrentProfile.OptionalProfileDetail.init)
        
        let nil1 = create
            <^> .success(nil)
            <*> .success(nil)
            <*> .success(nil)
            <*> .success(nil)
        
        let nil2 = nil1
            <*> .success(nil)
            <*> .success(nil)
            <*> .success(nil)
            <*> .success(nil)
        
        let nil3 = nil2
            <*> .success(nil)
            <*> .success(nil)
        
        let tmp1 = create
            <^> json <|? "account_birthdate"
            <*> json <|? "account_gender"
            <*> json <|? "account_id_card"
            <*> json <|? "account_id_card_type"
        
        let tmp2 = tmp1
            <*> json <|? "account_passport"
            <*> json <|? "area_code"
            <*> json <|? "passport_expiry_date"
            <*> json <|? "passport_issued_date"
        
        let tmp3 = tmp2
            <*> json <|? "passport_issuing_country"
            <*> json <|? "passport_nationality"
        
        return nil3 <|> tmp3
    }
}


