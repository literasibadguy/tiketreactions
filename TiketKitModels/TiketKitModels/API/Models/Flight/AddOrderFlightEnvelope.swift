//
//  AddOrderFlightEnvelope.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 02/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes


public struct AddOrderFlightEnvelope {
    public let diagnostic: Diagnostic
}

extension AddOrderFlightEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<AddOrderFlightEnvelope> {
        return curry(AddOrderFlightEnvelope.init)
            <^> json <| "diagnostic"
    }
}

public struct GroupPassengersParam {
    public let flightId: String?
    public let returnFlightId: String?
    public let lionCaptcha: String?
    public let lionSessionId: String?
    public let adult: Int?
    public let child: Int?
    public let conSalutation: String?
    public let conFirstName: String?
    public let conLastName: String?
    public let conPhone: String?
    public let conEmailAddress: String?
    public let adults: [AdultPassengerParam]?
    public let childs: [ChildPassengerParam]?
    public let infants: [InfantPassengerParam]?
    
    public static let defaults = GroupPassengersParam(flightId: "", returnFlightId: "", lionCaptcha: "", lionSessionId: "", adult: 0, child: 0, conSalutation: "", conFirstName: "", conLastName: "", conPhone: "", conEmailAddress: "", adults: [], childs: [], infants: [])
    
    public var queryParams: [String: Any] {
        var params: [String: Any] = [:]
        params["flight_id"] = self.flightId
        params["ret_flight_id"] = self.returnFlightId
        params["lioncaptcha"] = self.lionCaptcha
        params["lionsessionid"] = self.lionSessionId
        params["adult"] = self.adult
        params["child"] = self.child
        params["passportExpiryDatea)"] = self.conSalutation
        params["passportissueddatea"] = self.conFirstName
        params["passportissuinga"] = self.conLastName
        params["passportnationalitya"] = self.conPhone
        
        return params
    }
}

public struct AdultPassengerParam {
    public let title: String?
    public let firstname: String?
    public let lastname: String?
    public let birthdate: String?
    public let id: String?
    public let count: String?
    
    public let passportNo: String?
    public let passportExpiryDate: String?
    public let passportIssuedDate: String?
    public let passportIssue: String?
    public let passportNationality: String?
    
    /*
    public static let defaults = AddOrderParams(startDate: "", endDate: "", night: 0, room: 0, adult: 0, child: 0, minStar: 0, minPrice: 0, hotelName: "", roomId: "", hasPromo: "")
    */
    
    public static let defaults = AdultPassengerParam(title: "", firstname: "", lastname: "", birthdate: "", id: "", count: "", passportNo: "", passportExpiryDate: "", passportIssuedDate: "", passportIssue: "", passportNationality: "")
    
    public var queryParams: [String: Any] {
        var params: [String: Any] = [:]
        let counting = String(describing: count)
        params["titlea\(counting)"] = self.title
        params["firstnamea\(counting)"] = self.firstname
        params["lastnamea\(counting)"] = self.lastname
        params["birthdatea\(counting)"] = self.birthdate
        params["ida\(counting)"] = self.id
        params["passportnoa\(counting)"] = self.passportNo
        params["passportExpiryDatea\(counting)"] = self.passportExpiryDate
        params["passportissueddatea\(counting)"] = self.passportIssuedDate
        params["passportissuinga\(counting)"] = self.passportIssue
        params["passportnationalitya\(counting)"] = self.passportNationality
        
        return params
    }
}

public struct ChildPassengerParam {
    public let title: String?
    public let firstname: String?
    public let lastname: String?
    public let birthdate: String?
    public let id: String?
    public let count: String?
    
    public let passportNo: String?
    public let passportExpiryDate: String?
    public let passportIssuedDate: String?
    public let passportIssue: String?
    public let passportNationality: String?
    
    public static let defaults = ChildPassengerParam(title: "", firstname: "", lastname: "", birthdate: "", id: "", count: "", passportNo: "", passportExpiryDate: "", passportIssuedDate: "", passportIssue: "", passportNationality: "")
    
    public var queryParams: [String: Any] {
        var params: [String: Any] = [:]
        let counting = String(describing: count)
        params["firstnamec\(counting)"] = self.firstname
        params["lastnamec\(counting)"] = self.lastname
        params["birthdatec\(counting)"] = self.birthdate
        params["idc\(counting)"] = self.id
        params["passportnoc\(counting)"] = self.passportNo
        params["passportExpiryDatec\(counting)"] = self.passportExpiryDate
        params["passportissueddatec\(counting)"] = self.passportIssuedDate
        params["passportissuingc\(counting)"] = self.passportIssue
        params["passportnationalityc\(counting)"] = self.passportNationality
        
        return params
    }
}

public struct InfantPassengerParam {
    public let title: String?
    public let parent: String?
    public let firstname: String?
    public let lastname: String?
    public let birthdate: String?
    public let id: String?
    public let count: String?
    
    public let passportNo: String?
    public let passportExpiryDate: String?
    public let passportIssuedDate: String?
    public let passportIssue: String?
    public let passportNationality: String?
    
    public static let defaults = InfantPassengerParam(title: "", parent: "", firstname: "", lastname: "", birthdate: "", id: "", count: "", passportNo: "", passportExpiryDate: "", passportIssuedDate: "", passportIssue: "", passportNationality: "")
    
    public var queryParams: [String: Any] {
        var params: [String: Any] = [:]
        let counting = String(describing: count)
        params["titlei\(counting)"] = self.title
        params["parenti\(counting)"] = self.parent
        params["firstnamei\(counting)"] = self.firstname
        params["lastnamei\(counting)"] = self.lastname
        params["birthdatei\(counting)"] = self.birthdate
        params["idi\(counting)"] = self.id
        params["passportnoi\(counting)"] = self.passportNo
        params["passportExpiryDatei\(counting)"] = self.passportExpiryDate
        params["passportissueddatei\(counting)"] = self.passportIssuedDate
        params["passportissuingi\(counting)"] = self.passportIssue
        params["passportnationalityi\(counting)"] = self.passportNationality
        
        return params
    }
}
