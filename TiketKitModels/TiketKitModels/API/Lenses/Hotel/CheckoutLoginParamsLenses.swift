//
//  CheckoutLoginParamsLenses.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 14/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude

extension CheckoutLoginParams {
    
    public enum lens {
        public static let salutation = Lens<CheckoutLoginParams, String?>(
            view: { $0.salutation },
            set: { some, thing in CheckoutLoginParams(salutation: some, firstName: thing.firstName, lastName: thing.lastName, email: thing.email, phone: thing.phone, saveContinue: thing.saveContinue) }
        )
        
        public static let firstName = Lens<CheckoutLoginParams, String?>(
            view: { $0.firstName },
            set: { some, thing in CheckoutLoginParams(salutation: thing.salutation, firstName: some, lastName: thing.lastName, email: thing.email, phone: thing.phone, saveContinue: thing.saveContinue) }
        )
        
        public static let lastName = Lens<CheckoutLoginParams, String?>(
            view: { $0.lastName },
            set: { some, thing in CheckoutLoginParams(salutation: thing.salutation, firstName: thing.firstName, lastName: some, email: thing.email, phone: thing.phone, saveContinue: thing.saveContinue) }
        )
        
        public static let email = Lens<CheckoutLoginParams, String?>(
            view: { $0.email },
            set: { some, thing in CheckoutLoginParams(salutation: thing.salutation, firstName: thing.firstName, lastName: thing.lastName, email: some, phone: thing.phone, saveContinue: thing.saveContinue) }
        )
        
        public static let phone = Lens<CheckoutLoginParams, String?>(
            view: { $0.phone },
            set: { some, thing in CheckoutLoginParams(salutation: thing.salutation, firstName: thing.firstName, lastName: thing.lastName, email: thing.email, phone: some, saveContinue: thing.saveContinue) }
        )
        
        public static let saveContinue = Lens<CheckoutLoginParams, String?>(
            view: { $0.saveContinue },
            set: { some, thing in CheckoutLoginParams(salutation: thing.salutation, firstName: thing.firstName, lastName: thing.lastName, email: thing.email, phone: thing.phone, saveContinue: some) }
        )
    }
}
