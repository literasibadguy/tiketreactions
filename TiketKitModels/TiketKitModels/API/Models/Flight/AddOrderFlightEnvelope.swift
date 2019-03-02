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
import Prelude

public struct AddOrderFlightEnvelope {
    public let diagnostic: Diagnostic
}

extension AddOrderFlightEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<AddOrderFlightEnvelope> {
        return curry(AddOrderFlightEnvelope.init)
            <^> json <| "diagnostic"
    }
}

public struct PassengerListParam {
    public private(set) var adults: [AdultPassengerParam]?
    public private(set) var childs: [AdultPassengerParam]?
    public private(set) var infants: [AdultPassengerParam]?

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
    public let groupPassengers: [String: AdultPassengerParam]?
    
    public static let defaults = GroupPassengersParam(flightId: nil, returnFlightId: nil, lionCaptcha: nil, lionSessionId: nil, adult: nil, child: nil, conSalutation: nil, conFirstName: nil, conLastName: nil, conPhone: nil, conEmailAddress: nil, groupPassengers: nil)
    
    /*
    public var passengerParams: [String: Any] {
        var params: [String: Any] = [:]
        
        guard let passengerList = self.groupPassengers else { return [:] }
        
        guard let passA1 = passengerList["Penumpang Dewasa 1"] else { return [:] }
        guard let passA2 = passengerList["Penumpang Dewasa 2"] else { return [:] }
        guard let passA3 = passengerList["Penumpang Dewasa 3"] else { return [:] }
        guard let passA4 = passengerList["Penumpang Dewasa 4"] else { return [:] }
        guard let passA5 = passengerList["Penumpang Dewasa 5"] else { return [:] }
        guard let passA6 = passengerList["Penumpang Dewasa 6"] else { return [:] }
        
        guard let passC1 = passengerList["Penumpang Anak 1"] else { return [:] }
        guard let passC2 = passengerList["Penumpang Anak 2"] else { return [:] }
        guard let passC3 = passengerList["Penumpang Anak 3"] else { return [:] }
        guard let passC4 = passengerList["Penumpang Anak 4"] else { return [:] }
        guard let passC5 = passengerList["Penumpang Anak 5"] else { return [:] }
        guard let passC6 = passengerList["Penumpang Anak 6"] else { return [:] }
        
        guard let passI1 = passengerList["Penumpang Bayi 1"] else { return [:] }
        guard let passI2 = passengerList["Penumpang Bayi 2"] else { return [:] }
        guard let passI3 = passengerList["Penumpang Bayi 3"] else { return [:] }
        guard let passI4 = passengerList["Penumpang Bayi 4"] else { return [:] }
        guard let passI5 = passengerList["Penumpang Bayi 5"] else { return [:] }
        guard let passI6 = passengerList["Penumpang Bayi 6"] else { return [:] }
        
        
        params["titlea1"] = passA1.title
        params["firstnamea1"] = passA1.firstname
        params["lastnamea1"] = passA1.lastname
        params["birthdatea1"] = passA1.birthdate
        
        params["titlea2"] = passA2.title
        params["firstnamea2"] = passA2.firstname
        params["lastnamea2"] = passA2.lastname
        params["birthdatea2"] = passA2.birthdate
        params["titlea3"] = passA3.title
        params["firstnamea3"] = passA3.firstname
        params["lastnamea3"] = passA3.lastname
        params["birthdatea3"] = passA3.birthdate
        params["titlea4"] = passA4.title
        params["firstnamea4"] = passA4.firstname
        params["lastnamea4"] = passA4.lastname
        params["birthdatea4"] = passA4.birthdate
        params["titlea5"] = passA5.title
        params["firstnamea5"] = passA5.firstname
        params["lastnamea5"] = passA5.lastname
        params["birthdatea5"] = passA5.birthdate
        params["titlea6"] = passA6.title
        params["firstnamea6"] = passA6.firstname
        params["lastnamea6"] = passA6.lastname
        params["birthdatea6"] = passA6.birthdate
        
        params["titlec1"] = passC1.title
        params["firstnamec1"] = passC1.firstname
        params["lastnamec1"] = passC1.lastname
        params["birthdatec1"] = passC1.birthdate
        params["titlec2"] = passC2.title
        params["firstnamec2"] = passC2.firstname
        params["lastnamec2"] = passC2.lastname
        params["birthdatec2"] = passC2.birthdate
        params["titlec3"] = passC3.title
        params["firstnamec3"] = passC3.firstname
        params["lastnamec3"] = passC3.lastname
        params["birthdatec3"] = passC3.birthdate
        params["titlec4"] = passC4.title
        params["firstnamea4"] = passC4.firstname
        params["lastnamea4"] = passC4.lastname
        params["birthdatea4"] = passC4.birthdate
        params["titlec5"] = passC5.title
        params["firstnamec5"] = passC5.firstname
        params["lastnamec5"] = passC5.lastname
        params["birthdatec5"] = passC5.birthdate
        params["titlec6"] = passC6.title
        params["firstnamec6"] = passC6.firstname
        params["lastnamec6"] = passC6.lastname
        params["birthdatec6"] = passC6.birthdate
        
        params["titlei1"] = passI1.title
        params["firstnamei1"] = passI1.firstname
        params["lastnamei1"] = passI1.lastname
        params["birthdatei1"] = passI1.birthdate
        params["titlei2"] = passI2.title
        params["firstnamei2"] = passI2.firstname
        params["lastnamei2"] = passI2.lastname
        params["birthdatei2"] = passI2.birthdate
        params["titlei3"] = passI3.title
        params["firstnamei3"] = passI3.firstname
        params["lastnamei3"] = passI3.lastname
        params["birthdatei3"] = passI3.birthdate
        params["titlei4"] = passI4.title
        params["firstnamei4"] = passC4.firstname
        params["lastnamei4"] = passC4.lastname
        params["birthdatei4"] = passC4.birthdate
        params["titlei5"] = passI5.title
        params["firstnamei5"] = passI5.firstname
        params["lastnamei5"] = passI5.lastname
        params["birthdatei5"] = passI5.birthdate
        params["titlei6"] = passI6.title
        params["firstnamei6"] = passI6.firstname
        params["lastnamei6"] = passI6.lastname
        params["birthdatei6"] = passI6.birthdate
        
        
        return params
    }
    */
    
    public var queryParams: [String: Any] {
        var params: [String: Any] = [:]
        params["flight_id"] = self.flightId
        params["ret_flight_id"] = self.returnFlightId
        params["lioncaptcha"] = self.lionCaptcha
        params["lionsessionid"] = self.lionSessionId
        params["adult"] = self.adult?.description
        params["child"] = self.child?.description
        params["conSalutation"] = self.conSalutation
        params["conFirstName"] = self.conFirstName
        params["conLastName"] = self.conLastName
        params["conPhone"] = self.conPhone
        params["conEmailAddress"] = self.conEmailAddress
        
//        guard let passengerList = self.groupPassengers else { return [:] }
        /*
        guard let passA1 = passengerList["Penumpang Dewasa 1"] else { return [:] }
        guard let passA2 = passengerList["Penumpang Dewasa 2"] else { return [:] }
        guard let passA3 = passengerList["Penumpang Dewasa 3"] else { return [:] }
        guard let passA4 = passengerList["Penumpang Dewasa 4"] else { return [:] }
        guard let passA5 = passengerList["Penumpang Dewasa 5"] else { return [:] }
        guard let passA6 = passengerList["Penumpang Dewasa 6"] else { return [:] }
        
        guard let passC1 = passengerList["Penumpang Anak 1"] else { return [:] }
        guard let passC2 = passengerList["Penumpang Anak 2"] else { return [:] }
        guard let passC3 = passengerList["Penumpang Anak 3"] else { return [:] }
        guard let passC4 = passengerList["Penumpang Anak 4"] else { return [:] }
        guard let passC5 = passengerList["Penumpang Anak 5"] else { return [:] }
        guard let passC6 = passengerList["Penumpang Anak 6"] else { return [:] }
        
        guard let passI1 = passengerList["Penumpang Bayi 1"] else { return [:] }
        guard let passI2 = passengerList["Penumpang Bayi 2"] else { return [:] }
        guard let passI3 = passengerList["Penumpang Bayi 3"] else { return [:] }
        guard let passI4 = passengerList["Penumpang Bayi 4"] else { return [:] }
        guard let passI5 = passengerList["Penumpang Bayi 5"] else { return [:] }
        guard let passI6 = passengerList["Penumpang Bayi 6"] else { return [:] }
        */
        
        params["titlea1"] = self.groupPassengers?["Penumpang Dewasa 1"]?.title
        params["firstnamea1"] = self.groupPassengers?["Penumpang Dewasa 1"]?.firstname
        params["lastnamea1"] = self.groupPassengers?["Penumpang Dewasa 1"]?.lastname
        params["birthdatea1"] = self.groupPassengers?["Penumpang Dewasa 1"]?.birthdate
        params["passportnationalitya1"] = self.groupPassengers?["Penumpang Dewasa 1"]?.passportNationality
        params["passportnoa1"] = self.groupPassengers?["Penumpang Dewasa 1"]?.passportNo
        params["passportExpiryDatea1"] = self.groupPassengers?["Penumpang Dewasa 1"]?.passportExpiryDate
        params["passportissuinga1"] = self.groupPassengers?["Penumpang Dewasa 1"]?.passportIssue
        
        params["titlea2"] = self.groupPassengers?["Penumpang Dewasa 2"]?.title
        params["firstnamea2"] = self.groupPassengers?["Penumpang Dewasa 2"]?.firstname
        params["lastnamea2"] = self.groupPassengers?["Penumpang Dewasa 2"]?.lastname
        params["birthdatea2"] = self.groupPassengers?["Penumpang Dewasa 2"]?.birthdate
        params["passportnationalitya2"] = self.groupPassengers?["Penumpang Dewasa 2"]?.passportNationality
        params["passportnoa2"] = self.groupPassengers?["Penumpang Dewasa 2"]?.passportNo
        params["passportExpiryDatea2"] = self.groupPassengers?["Penumpang Dewasa 2"]?.passportExpiryDate
        params["passportissuinga2"] = self.groupPassengers?["Penumpang Dewasa 2"]?.passportIssue
        
        params["titlea3"] = self.groupPassengers?["Penumpang Dewasa 3"]?.title
        params["firstnamea3"] = self.groupPassengers?["Penumpang Dewasa 3"]?.firstname
        params["lastnamea3"] = self.groupPassengers?["Penumpang Dewasa 3"]?.lastname
        params["birthdatea3"] = self.groupPassengers?["Penumpang Dewasa 3"]?.birthdate
        params["passportnationalitya3"] = self.groupPassengers?["Penumpang Dewasa 3"]?.passportNationality
        params["passportnoa3"] = self.groupPassengers?["Penumpang Dewasa 3"]?.passportNo
        params["passportExpiryDatea3"] = self.groupPassengers?["Penumpang Dewasa 3"]?.passportExpiryDate
        params["passportissuinga3"] = self.groupPassengers?["Penumpang Dewasa 3"]?.passportIssue
        
        params["titlea4"] = self.groupPassengers?["Penumpang Dewasa 4"]?.title
        params["firstnamea4"] = self.groupPassengers?["Penumpang Dewasa 4"]?.firstname
        params["lastnamea4"] = self.groupPassengers?["Penumpang Dewasa 4"]?.lastname
        params["birthdatea4"] = self.groupPassengers?["Penumpang Dewasa 4"]?.birthdate
        params["passportnationalitya4"] = self.groupPassengers?["Penumpang Dewasa 4"]?.passportNationality
        params["passportnoa4"] = self.groupPassengers?["Penumpang Dewasa 4"]?.passportNo
        params["passportExpiryDatea4"] = self.groupPassengers?["Penumpang Dewasa 4"]?.passportExpiryDate
        params["passportissuinga4"] = self.groupPassengers?["Penumpang Dewasa 4"]?.passportIssue
        
        params["titlea5"] = self.groupPassengers?["Penumpang Dewasa 5"]?.title
        params["firstnamea5"] = self.groupPassengers?["Penumpang Dewasa 5"]?.firstname
        params["lastnamea5"] = self.groupPassengers?["Penumpang Dewasa 5"]?.lastname
        params["birthdatea5"] = self.groupPassengers?["Penumpang Dewasa 5"]?.birthdate
        params["passportnationalitya5"] = self.groupPassengers?["Penumpang Dewasa 5"]?.passportNationality
        params["passportnoa5"] = self.groupPassengers?["Penumpang Dewasa 5"]?.passportNo
        params["passportExpiryDatea5"] = self.groupPassengers?["Penumpang Dewasa 5"]?.passportExpiryDate
        params["passportissuinga5"] = self.groupPassengers?["Penumpang Dewasa 5"]?.passportIssue
        
        params["titlea6"] = self.groupPassengers?["Penumpang Dewasa 6"]?.title
        params["firstnamea6"] = self.groupPassengers?["Penumpang Dewasa 6"]?.firstname
        params["lastnamea6"] = self.groupPassengers?["Penumpang Dewasa 6"]?.lastname
        params["birthdatea6"] = self.groupPassengers?["Penumpang Dewasa 6"]?.birthdate
        params["passportnationalitya6"] = self.groupPassengers?["Penumpang Dewasa 6"]?.passportNationality
        params["passportnoa6"] = self.groupPassengers?["Penumpang Dewasa 6"]?.passportNo
        params["passportExpiryDatea6"] = self.groupPassengers?["Penumpang Dewasa 6"]?.passportExpiryDate
        params["passportissuinga6"] = self.groupPassengers?["Penumpang Dewasa 6"]?.passportIssue
        
        params["titlec1"] = self.groupPassengers?["Penumpang Anak 1"]?.title
        params["firstnamec1"] = self.groupPassengers?["Penumpang Anak 1"]?.firstname
        params["lastnamec1"] = self.groupPassengers?["Penumpang Anak 1"]?.lastname
        params["birthdatec1"] = self.groupPassengers?["Penumpang Anak 1"]?.birthdate
        params["passportnationalityc1"] = self.groupPassengers?["Penumpang Anak 1"]?.passportNationality
        params["passportnoc1"] = self.groupPassengers?["Penumpang Anak 1"]?.passportNo
        params["passportExpiryDatec1"] = self.groupPassengers?["Penumpang Anak 1"]?.passportExpiryDate
        params["passportissuingc1"] = self.groupPassengers?["Penumpang Anak 1"]?.passportIssue
        
        params["titlec2"] = self.groupPassengers?["Penumpang Anak 1"]?.title
        params["firstnamec2"] = self.groupPassengers?["Penumpang Anak 2"]?.firstname
        params["lastnamec2"] = self.groupPassengers?["Penumpang Anak 2"]?.lastname
        params["birthdatec2"] = self.groupPassengers?["Penumpang Anak 2"]?.birthdate
        params["passportnationalityc2"] = self.groupPassengers?["Penumpang Anak 2"]?.passportNationality
        params["passportnoc2"] = self.groupPassengers?["Penumpang Anak 2"]?.passportNo
        params["passportExpiryDatec2"] = self.groupPassengers?["Penumpang Anak 2"]?.passportExpiryDate
        params["passportissuingc2"] = self.groupPassengers?["Penumpang Anak 2"]?.passportIssue
        
        params["titlec3"] = self.groupPassengers?["Penumpang Anak 3"]?.title
        params["firstnamec3"] = self.groupPassengers?["Penumpang Anak 3"]?.firstname
        params["lastnamec3"] = self.groupPassengers?["Penumpang Anak 3"]?.lastname
        params["birthdatec3"] = self.groupPassengers?["Penumpang Anak 3"]?.birthdate
        params["passportnationalityc3"] = self.groupPassengers?["Penumpang Anak 3"]?.passportNationality
        params["passportnoc3"] = self.groupPassengers?["Penumpang Anak 3"]?.passportNo
        params["passportExpiryDatec3"] = self.groupPassengers?["Penumpang Anak 3"]?.passportExpiryDate
        params["passportissuingc3"] = self.groupPassengers?["Penumpang Anak 3"]?.passportIssue
        
        params["titlec4"] = self.groupPassengers?["Penumpang Anak 4"]?.title
        params["firstnamec4"] = self.groupPassengers?["Penumpang Anak 4"]?.firstname
        params["lastnamec4"] = self.groupPassengers?["Penumpang Anak 4"]?.lastname
        params["birthdatec4"] = self.groupPassengers?["Penumpang Anak 4"]?.birthdate
        params["passportnationalityc4"] = self.groupPassengers?["Penumpang Anak 4"]?.passportNationality
        params["passportnoc4"] = self.groupPassengers?["Penumpang Anak 4"]?.passportNo
        params["passportExpiryDatec4"] = self.groupPassengers?["Penumpang Anak 4"]?.passportExpiryDate
        params["passportissuingc4"] = self.groupPassengers?["Penumpang Anak 4"]?.passportIssue
        
        params["titlec5"] = self.groupPassengers?["Penumpang Anak 5"]?.title
        params["firstnamec5"] = self.groupPassengers?["Penumpang Anak 5"]?.firstname
        params["lastnamec5"] = self.groupPassengers?["Penumpang Anak 5"]?.lastname
        params["birthdatec5"] = self.groupPassengers?["Penumpang Anak 5"]?.birthdate
        params["passportnationalityc5"] = self.groupPassengers?["Penumpang Anak 5"]?.passportNationality
        params["passportnoc5"] = self.groupPassengers?["Penumpang Anak 5"]?.passportNo
        params["passportExpiryDatec5"] = self.groupPassengers?["Penumpang Anak 5"]?.passportExpiryDate
        params["passportissuingc5"] = self.groupPassengers?["Penumpang Anak 5"]?.passportIssue
        
        params["titlec6"] = self.groupPassengers?["Penumpang Anak 6"]?.title
        params["firstnamec6"] = self.groupPassengers?["Penumpang Anak 6"]?.firstname
        params["lastnamec6"] = self.groupPassengers?["Penumpang Anak 6"]?.lastname
        params["birthdatec6"] = self.groupPassengers?["Penumpang Anak 6"]?.birthdate
        params["passportnationalityc6"] = self.groupPassengers?["Penumpang Anak 6"]?.passportNationality
        params["passportnoc6"] = self.groupPassengers?["Penumpang Anak 6"]?.passportNo
        params["passportExpiryDatec6"] = self.groupPassengers?["Penumpang Anak 6"]?.passportExpiryDate
        params["passportissuingc6"] = self.groupPassengers?["Penumpang Anak 6"]?.passportIssue
        
        params["titlei1"] = self.groupPassengers?["Penumpang Bayi 1"]?.title
        params["firstnamei1"] = self.groupPassengers?["Penumpang Bayi 1"]?.firstname
        params["lastnamei1"] = self.groupPassengers?["Penumpang Bayi 1"]?.lastname
        params["birthdatei1"] = self.groupPassengers?["Penumpang Bayi 1"]?.birthdate
        params["passportnationalityi1"] = self.groupPassengers?["Penumpang Bayi 1"]?.passportNationality
        params["passportnoi1"] = self.groupPassengers?["Penumpang Bayi 1"]?.passportNo
        params["passportExpiryDatei1"] = self.groupPassengers?["Penumpang Bayi 1"]?.passportExpiryDate
        params["passportissuingi1"] = self.groupPassengers?["Penumpang Bayi 1"]?.passportIssue
        
        params["titlei2"] = self.groupPassengers?["Penumpang Bayi 2"]?.title
        params["firstnamei2"] = self.groupPassengers?["Penumpang Bayi 2"]?.firstname
        params["lastnamei2"] = self.groupPassengers?["Penumpang Bayi 2"]?.lastname
        params["birthdatei2"] = self.groupPassengers?["Penumpang Bayi 2"]?.birthdate
        params["passportnationalityi2"] = self.groupPassengers?["Penumpang Bayi 2"]?.passportNationality
        params["passportnoi2"] = self.groupPassengers?["Penumpang Bayi 2"]?.passportNo
        params["passportExpiryDatei2"] = self.groupPassengers?["Penumpang Bayi 2"]?.passportExpiryDate
        params["passportissuingi2"] = self.groupPassengers?["Penumpang Bayi 2"]?.passportIssue
        
        params["titlei3"] = self.groupPassengers?["Penumpang Bayi 3"]?.title
        params["firstnamei3"] = self.groupPassengers?["Penumpang Bayi 3"]?.firstname
        params["lastnamei3"] = self.groupPassengers?["Penumpang Bayi 3"]?.lastname
        params["birthdatei3"] = self.groupPassengers?["Penumpang Bayi 3"]?.birthdate
        params["passportnationalityi3"] = self.groupPassengers?["Penumpang Bayi 3"]?.passportNationality
        params["passportnoi3"] = self.groupPassengers?["Penumpang Bayi 3"]?.passportNo
        params["passportExpiryDatei3"] = self.groupPassengers?["Penumpang Bayi 3"]?.passportExpiryDate
        params["passportissuingi3"] = self.groupPassengers?["Penumpang Bayi 3"]?.passportIssue
        
        params["titlei4"] = self.groupPassengers?["Penumpang Bayi 4"]?.title
        params["firstnamei4"] = self.groupPassengers?["Penumpang Bayi 4"]?.firstname
        params["lastnamei4"] = self.groupPassengers?["Penumpang Bayi 4"]?.lastname
        params["birthdatei4"] = self.groupPassengers?["Penumpang Bayi 4"]?.birthdate
        params["passportnationalityi4"] = self.groupPassengers?["Penumpang Bayi 4"]?.passportNationality
        params["passportnoi4"] = self.groupPassengers?["Penumpang Bayi 4"]?.passportNo
        params["passportExpiryDatei4"] = self.groupPassengers?["Penumpang Bayi 4"]?.passportExpiryDate
        params["passportissuingi4"] = self.groupPassengers?["Penumpang Bayi 4"]?.passportIssue
        
        params["titlei5"] = self.groupPassengers?["Penumpang Bayi 5"]?.title
        params["firstnamei5"] = self.groupPassengers?["Penumpang Bayi 5"]?.firstname
        params["lastnamei5"] = self.groupPassengers?["Penumpang Bayi 5"]?.lastname
        params["birthdatei5"] = self.groupPassengers?["Penumpang Bayi 5"]?.birthdate
        params["passportnationalityi5"] = self.groupPassengers?["Penumpang Bayi 5"]?.passportNationality
        params["passportnoi5"] = self.groupPassengers?["Penumpang Bayi 5"]?.passportNo
        params["passportExpiryDatei5"] = self.groupPassengers?["Penumpang Bayi 5"]?.passportExpiryDate
        params["passportissuingi5"] = self.groupPassengers?["Penumpang Bayi 5"]?.passportIssue
        
        params["titlei6"] = self.groupPassengers?["Penumpang Bayi 6"]?.title
        params["firstnamei6"] = self.groupPassengers?["Penumpang Bayi 6"]?.firstname
        params["lastnamei6"] = self.groupPassengers?["Penumpang Bayi 6"]?.lastname
        params["birthdatei6"] = self.groupPassengers?["Penumpang Bayi 6"]?.birthdate
        params["passportnationalityi6"] = self.groupPassengers?["Penumpang Bayi 6"]?.passportNationality
        params["passportnoi6"] = self.groupPassengers?["Penumpang Bayi 6"]?.passportNo
        params["passportExpiryDatei6"] = self.groupPassengers?["Penumpang Bayi 6"]?.passportExpiryDate
        params["passportissuingi6"] = self.groupPassengers?["Penumpang Bayi 6"]?.passportIssue
        
        /*
        params["titlea2"] = passA2.title
        params["firstnamea2"] = passA2.firstname
        params["lastnamea2"] = passA2.lastname
        params["birthdatea2"] = passA2.birthdate
        params["titlea3"] = passA3.title
        params["firstnamea3"] = passA3.firstname
        params["lastnamea3"] = passA3.lastname
        params["birthdatea3"] = passA3.birthdate
        params["titlea4"] = passA4.title
        params["firstnamea4"] = passA4.firstname
        params["lastnamea4"] = passA4.lastname
        params["birthdatea4"] = passA4.birthdate
        params["titlea5"] = passA5.title
        params["firstnamea5"] = passA5.firstname
        params["lastnamea5"] = passA5.lastname
        params["birthdatea5"] = passA5.birthdate
        params["titlea6"] = passA6.title
        params["firstnamea6"] = passA6.firstname
        params["lastnamea6"] = passA6.lastname
        params["birthdatea6"] = passA6.birthdate
        
        params["titlec1"] = passC1.title
        params["firstnamec1"] = passC1.firstname
        params["lastnamec1"] = passC1.lastname
        params["birthdatec1"] = passC1.birthdate
        params["titlec2"] = passC2.title
        params["firstnamec2"] = passC2.firstname
        params["lastnamec2"] = passC2.lastname
        params["birthdatec2"] = passC2.birthdate
        params["titlec3"] = passC3.title
        params["firstnamec3"] = passC3.firstname
        params["lastnamec3"] = passC3.lastname
        params["birthdatec3"] = passC3.birthdate
        params["titlec4"] = passC4.title
        params["firstnamea4"] = passC4.firstname
        params["lastnamea4"] = passC4.lastname
        params["birthdatea4"] = passC4.birthdate
        params["titlec5"] = passC5.title
        params["firstnamec5"] = passC5.firstname
        params["lastnamec5"] = passC5.lastname
        params["birthdatec5"] = passC5.birthdate
        params["titlec6"] = passC6.title
        params["firstnamec6"] = passC6.firstname
        params["lastnamec6"] = passC6.lastname
        params["birthdatec6"] = passC6.birthdate
        
        params["titlei1"] = passI1.title
        params["firstnamei1"] = passI1.firstname
        params["lastnamei1"] = passI1.lastname
        params["birthdatei1"] = passI1.birthdate
        params["titlei2"] = passI2.title
        params["firstnamei2"] = passI2.firstname
        params["lastnamei2"] = passI2.lastname
        params["birthdatei2"] = passI2.birthdate
        params["titlei3"] = passI3.title
        params["firstnamei3"] = passI3.firstname
        params["lastnamei3"] = passI3.lastname
        params["birthdatei3"] = passI3.birthdate
        params["titlei4"] = passI4.title
        params["firstnamei4"] = passC4.firstname
        params["lastnamei4"] = passC4.lastname
        params["birthdatei4"] = passC4.birthdate
        params["titlei5"] = passI5.title
        params["firstnamei5"] = passI5.firstname
        params["lastnamei5"] = passI5.lastname
        params["birthdatei5"] = passI5.birthdate
        params["titlei6"] = passI6.title
        params["firstnamei6"] = passI6.firstname
        params["lastnamei6"] = passI6.lastname
        params["birthdatei6"] = passI6.birthdate
        */
        
        return params
    }
    
}

public struct AdultPassengerParam {
    public private(set) var title: String?
    public let firstname: String?
    public let lastname: String?
    public let birthdate: String?
    public let id: String?
    public var count: String?
    
    public let passportNo: String?
    public let passportExpiryDate: String?
    public let passportIssuedDate: String?
    public let passportIssue: String?
    public let passportNationality: String?
    
    /*
    public static let defaults = AddOrderParams(startDate: "", endDate: "", night: 0, room: 0, adult: 0, child: 0, minStar: 0, minPrice: 0, hotelName: "", roomId: "", hasPromo: "")
    */
    
    static func == (lhs: AdultPassengerParam, rhs: AdultPassengerParam) -> Bool {
        return lhs.count == rhs.count
    }
    
    public static let defaults = AdultPassengerParam(title: nil, firstname: nil, lastname: nil, birthdate: nil, id: nil, count: nil, passportNo: nil, passportExpiryDate: nil, passportIssuedDate: nil, passportIssue: nil, passportNationality: nil)
    
    public var queryParams: [String: String] {
        var params: [String: String] = [:]
        params["title\(count!)"] = self.title
        params["firstname\(count!)"] = self.firstname
        params["lastname\(count!)"] = self.lastname
        params["birthdate\(count!)"] = self.birthdate
        params["id\(count!)"] = self.id
        params["passportno\(count!)"] = self.passportNo
        params["passportExpiryDate\(count!)"] = self.passportExpiryDate
        params["passportissueddate\(count!)"] = self.passportIssuedDate
        params["passportissuing\(count!)"] = self.passportIssue
        params["passportnationality\(count!)"] = self.passportNationality
        
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
