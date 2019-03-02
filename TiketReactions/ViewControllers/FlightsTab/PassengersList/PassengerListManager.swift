//
//  PassengerListManager.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 26/11/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import TiketKitModels
import Prelude

class PassengerListManager {
    public static let prefKeyPassenger = "prefKeyPassenger"
    public static let prefKeyCustomPassengers = "prefKeyCustomPassengers"
    
    var passengers = [AdultPassengerParam]()
    private var groupParam: GroupPassengersParam
    
    init(group: GroupPassengersParam) {
        self.groupParam = group
    }
    
    func addPassenger(title: String, firstName: String, lastName: String, nationality: String? = "", birthdate: String? = "") -> AdultPassengerParam {
        
        let passenger = AdultPassengerParam.defaults
            |> AdultPassengerParam.lens.firstname .~ firstName
            |> AdultPassengerParam.lens.lastname .~ lastName
            |> AdultPassengerParam.lens.title .~ title
            |> AdultPassengerParam.lens.birthdate .~ birthdate
            |> AdultPassengerParam.lens.passportNationality .~ nationality
        
        passengers.append(passenger)
        
        return passenger
    }
}
