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
    
    public let generalAccount: GeneralAccount
    public let profileId: String
    public let name: String
    public let address: Address
    public let detailAccount: DetailAccount
    
    public struct GeneralAccount {
        public let accountId: String
        public let accountFirstName: String
        public let accountLastName: String
        public let accountMobile: String
        public let accountSalutationName: String
        public let accountPhone: String
        public let accountUsername: String
    }
    
    public struct Address {
        public let addressCountry: String
        public let addressAddress1: String
        public let addressAddress2: String
        public let addressKabupaten: String
        public let addressProvince: String
        public let addressZipcode: String
    }
    
    public struct DetailAccount {
        public let accountCreated: String
        public let accountPassword: String
        public let accountSource: String
        public let photo: String
        public let accountPhotoModified: String
        public let accountBirthdate: String
        public let accountGender: String
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
            <^> GeneralAccount.decode(json)
            <*> json <| "profile_id"
            <*> json <| "Name"
        
        return tmp1
            <*> Address.decode(json)
            <*> DetailAccount.decode(json)
    }
}

extension CurrentProfile.GeneralAccount: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<CurrentProfile.GeneralAccount> {
        let tmp1 = curry(CurrentProfile.GeneralAccount.init)
            <^> json <| "account_id"
            <*> json <| "account_first_name"
            <*> json <| "account_last_name"
            <*> json <| "account_mobile"
        
        let tmp2 = tmp1
            <*> json <| "account_Salutation_name"
            <*> json <| "account_phone"
            <*> json <| "account_username"
        
        return tmp2
    }
}

extension CurrentProfile.Address: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<CurrentProfile.Address> {
        let tmp1 = curry(CurrentProfile.Address.init)
            <^> json <| "address_country"
            <*> json <| "address_address1"
            <*> json <| "address_address2"
            <*> json <| "address_kabupaten"
        
        return tmp1
            <*> json <| "address_province"
            <*> json <| "address_zipcode"
    }
}

extension CurrentProfile.DetailAccount: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<CurrentProfile.DetailAccount> {
        let tmp1 = curry(CurrentProfile.DetailAccount.init)
            <^> json <| "account_created"
            <*> json <| "account_password"
            <*> json <| "account_source"
            <*> json <| "photo"
        
        return tmp1
            <*> json <| "account_profile_modified"
            <*> json <| "account_birthdate"
            <*> json <| "account_gender"
    }
}

