//
//  CheckoutGuestParamsLenses.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 20/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude

/*
public let salutation: String
public let firstName: String
public let lastName: String
public let phone: String
// Contact Person
public let conSalutation: String
public let conFirstName: String
public let conLastName: String
public let conEmailAddress: String
public let conPhone: String
public let detailId: String
public let country: String
 */

extension CheckoutGuestParams {
    
    public enum lens {
        public static let salutation = Lens<CheckoutGuestParams, String?>(
            view: { $0.salutation },
            set: { some, thing in CheckoutGuestParams(salutation: some, firstName: thing.firstName, lastName: thing.lastName, phone: thing.phone, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conEmailAddress: thing.conEmailAddress, conPhone: thing.conPhone, detailId: thing.detailId, country: thing.country) }
        )
        
        public static let firstName = Lens<CheckoutGuestParams, String?>(
            view: { $0.firstName },
            set: { some, thing in CheckoutGuestParams(salutation: thing.salutation, firstName: some, lastName: thing.lastName, phone: thing.phone, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conEmailAddress: thing.conEmailAddress, conPhone: thing.conPhone, detailId: thing.detailId, country: thing.country) }
        )
        
        public static let lastName = Lens<CheckoutGuestParams, String?>(
            view: { $0.lastName },
            set: { some, thing in CheckoutGuestParams(salutation: thing.salutation, firstName: thing.firstName, lastName: some, phone: thing.phone, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conEmailAddress: thing.conEmailAddress, conPhone: thing.conPhone, detailId: thing.detailId, country: thing.country) }
        )
        
        public static let phone = Lens<CheckoutGuestParams, String?>(
            view: { $0.phone },
            set: { some, thing in CheckoutGuestParams(salutation: thing.salutation, firstName: thing.firstName, lastName: thing.lastName, phone: some, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conEmailAddress: thing.conEmailAddress, conPhone: thing.conPhone, detailId: thing.detailId, country: thing.country) }
        )
        
        public static let conSalutation = Lens<CheckoutGuestParams, String?>(
            view: { $0.conSalutation },
            set: { some, thing in CheckoutGuestParams(salutation: thing.salutation, firstName: thing.firstName, lastName: thing.lastName, phone: thing.phone, conSalutation: some, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conEmailAddress: thing.conEmailAddress, conPhone: thing.conPhone, detailId: thing.detailId, country: thing.country) }
        )
        
        public static let conFirstName = Lens<CheckoutGuestParams, String?>(
            view: { $0.conFirstName },
            set: { some, thing in CheckoutGuestParams(salutation: thing.salutation, firstName: thing.firstName, lastName: thing.lastName, phone: thing.phone, conSalutation: thing.conSalutation, conFirstName: some, conLastName: thing.conLastName, conEmailAddress: thing.conEmailAddress, conPhone: thing.conPhone, detailId: thing.detailId, country: thing.country) }
        )
        
        public static let conLastName = Lens<CheckoutGuestParams, String?>(
            view: { $0.conLastName },
            set: { some, thing in CheckoutGuestParams(salutation: thing.salutation, firstName: thing.firstName, lastName: thing.lastName, phone: thing.phone, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: some, conEmailAddress: thing.conEmailAddress, conPhone: thing.conPhone, detailId: thing.detailId, country: thing.country) }
        )
        
        public static let conEmailAddress = Lens<CheckoutGuestParams, String?>(
            view: { $0.conEmailAddress },
            set: { some, thing in CheckoutGuestParams(salutation: thing.salutation, firstName: thing.firstName, lastName: thing.lastName, phone: thing.phone, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conEmailAddress: some, conPhone: thing.conPhone, detailId: thing.detailId, country: thing.country) }
        )
        
        public static let conPhone = Lens<CheckoutGuestParams, String?>(
            view: { $0.conPhone },
            set: { some, thing in CheckoutGuestParams(salutation: thing.salutation, firstName: thing.firstName, lastName: thing.lastName, phone: thing.phone, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conEmailAddress: thing.conEmailAddress, conPhone: some, detailId: thing.detailId, country: thing.country) }
        )
        
        public static let detailId = Lens<CheckoutGuestParams, String?>(
            view: { $0.detailId },
            set: { some, thing in CheckoutGuestParams(salutation: thing.salutation, firstName: thing.firstName, lastName: thing.lastName, phone: thing.phone, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conEmailAddress: thing.conEmailAddress, conPhone: thing.conPhone, detailId: some, country: thing.country) }
        )
        
        public static let country = Lens<CheckoutGuestParams, String?>(
            view: { $0.country },
            set: { some, thing in CheckoutGuestParams(salutation: thing.salutation, firstName: thing.firstName, lastName: thing.lastName, phone: thing.phone, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conEmailAddress: thing.conEmailAddress, conPhone: thing.conPhone, detailId: thing.detailId, country: some) }
        )
    }
}
