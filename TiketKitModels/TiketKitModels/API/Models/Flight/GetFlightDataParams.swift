//
//  GetFlightDataParams.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 28/08/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct GetFlightDataEnvelope {
    public let diagnostic: Diagnostic
    public let adultPassengerList: RequiredPassengers
    public let departures: GetFlightData
    public let returns: GetFlightData?
    public let guestId: String?
}

public struct RequiredPassengers {
    public let adult1: AdultPassengerFirst
    public let adult2: Adult2
    public let adult3: Adult3
    public let adult4: Adult4
    public let adult5: Adult5
    public let adult6: Adult6
    
    public let child1: Child1
    public let child2: Child2
    public let child3: Child3
    public let child4: Child4
    public let child5: Child5
    public let child6: Child6
    
    public let infant1: Infant1
    public let infant2: Infant2
    public let infant3: Infant3
    public let infant4: Infant4
    public let infant5: Infant5
    public let infant6: Infant6
    
    public struct AdultPassengerFirst {
        
        public let separator: FormatDataForm
        public let title: FormatDataForm
        public let firstname: FormatDataForm
        public let lastname: FormatDataForm
        
        public let birtdate: FormatDataForm?
        public let passportNo: FormatDataForm?
//        public let passportExpiryDate: FormatDataForm?
//        public let passportIssuing: FormatDataForm?
        public let departBaggage: FormatDataForm?
        public let transitDepartBaggage: FormatDataForm?
        public let returnBaggage: FormatDataForm?
        public let transitReturnBaggage: FormatDataForm?
    }
    
    public struct Adult2 {
        public let separtor: FormatDataForm?
        public let birtdate: FormatDataForm?
        public let passportNo: FormatDataForm?
//        public let passportExpiryDate: FormatDataForm?
//        public let passportIssuing: FormatDataForm?
        public let departBaggage: FormatDataForm?
        public let transitDepartBaggage: FormatDataForm?
        public let returnBaggage: FormatDataForm?
        public let transitReturnBaggage: FormatDataForm?
    }
    
    public struct Adult3 {
        public let separtor: FormatDataForm?
        public let title: FormatDataForm?
        public let firstname: FormatDataForm?
        public let lastname: FormatDataForm?
        public let birtdate: FormatDataForm?
        public let passportNationality: FormatDataForm?
        public let passportNo: FormatDataForm?
//        public let passportExpiryDate: FormatDataForm?
//        public let passportIssuing: FormatDataForm?
        public let checkinBaggage: FormatDataForm?
    }
    
    public struct Adult4 {
        public let separtor: FormatDataForm?
        public let title: FormatDataForm?
        public let firstname: FormatDataForm?
        public let lastname: FormatDataForm?
        public let birtdate: FormatDataForm?
        public let passportNationality: FormatDataForm?
        public let passportNo: FormatDataForm?
//        public let passportExpiryDate: FormatDataForm?
//        public let passportIssuing: FormatDataForm?
        public let checkinBaggage: FormatDataForm?
    }
    
    public struct Adult5 {
        public let separtor: FormatDataForm?
        public let title: FormatDataForm?
        public let firstname: FormatDataForm?
        public let lastname: FormatDataForm?
        public let birtdate: FormatDataForm?
        public let passportNationality: FormatDataForm?
        public let passportNo: FormatDataForm?
//        public let passportExpiryDate: FormatDataForm?
//        public let passportIssuing: FormatDataForm?
        public let checkinBaggage: FormatDataForm?
    }
    
    public struct Adult6 {
        public let separtor: FormatDataForm?
        public let title: FormatDataForm?
        public let firstname: FormatDataForm?
        public let lastname: FormatDataForm?
        public let birtdate: FormatDataForm?
        public let passportNationality: FormatDataForm?
        public let passportNo: FormatDataForm?
//        public let passportExpiryDate: FormatDataForm?
//        public let passportIssuing: FormatDataForm?
        public let checkinBaggage: FormatDataForm?
    }
    
    public struct Child1 {
        public let separtor: FormatDataForm?
        public let title: FormatDataForm?
        public let firstname: FormatDataForm?
        public let lastname: FormatDataForm?
        public let birtdate: FormatDataForm?
        public let passportNationality: FormatDataForm?
        public let passportNo: FormatDataForm?
//        public let passportExpiryDate: FormatDataForm?
//        public let passportIssuing: FormatDataForm?
        public let checkinBaggage: FormatDataForm?
    }
    
    public struct Child2 {
        public let separtor: FormatDataForm?
        public let title: FormatDataForm?
        public let firstname: FormatDataForm?
        public let lastname: FormatDataForm?
        public let birtdate: FormatDataForm?
        public let passportNationality: FormatDataForm?
        public let passportNo: FormatDataForm?
//        public let passportExpiryDate: FormatDataForm?
//        public let passportIssuing: FormatDataForm?
        public let checkinBaggage: FormatDataForm?
    }
    
    public struct Child3 {
        public let separtor: FormatDataForm?
        public let title: FormatDataForm?
        public let firstname: FormatDataForm?
        public let lastname: FormatDataForm?
        public let birtdate: FormatDataForm?
        public let passportNationality: FormatDataForm?
        public let passportNo: FormatDataForm?
//        public let passportExpiryDate: FormatDataForm?
//        public let passportIssuing: FormatDataForm?
        public let checkinBaggage: FormatDataForm?
    }
    
    public struct Child4 {
        public let separtor: FormatDataForm?
        public let title: FormatDataForm?
        public let firstname: FormatDataForm?
        public let lastname: FormatDataForm?
        public let birtdate: FormatDataForm?
        public let passportNationality: FormatDataForm?
        public let passportNo: FormatDataForm?
//        public let passportExpiryDate: FormatDataForm?
//        public let passportIssuing: FormatDataForm?
        public let checkinBaggage: FormatDataForm?
    }
    
    public struct Child5 {
        public let separtor: FormatDataForm?
        public let title: FormatDataForm?
        public let firstname: FormatDataForm?
        public let lastname: FormatDataForm?
        public let birtdate: FormatDataForm?
        public let passportNationality: FormatDataForm?
        public let passportNo: FormatDataForm?
//        public let passportExpiryDate: FormatDataForm?
//        public let passportIssuing: FormatDataForm?
        public let checkinBaggage: FormatDataForm?
    }
    
    public struct Child6 {
        public let separtor: FormatDataForm?
        public let title: FormatDataForm?
        public let firstname: FormatDataForm?
        public let lastname: FormatDataForm?
        public let birtdate: FormatDataForm?
        public let passportNationality: FormatDataForm?
        public let passportNo: FormatDataForm?
//        public let passportExpiryDate: FormatDataForm?
//        public let passportIssuing: FormatDataForm?
        public let checkinBaggage: FormatDataForm?
    }
    
    public struct Infant1 {
        public let separtor: FormatDataForm?
        public let title: FormatDataForm?
        public let firstname: FormatDataForm?
        public let lastname: FormatDataForm?
        public let birtdate: FormatDataForm?
        public let passportNationality: FormatDataForm?
        public let passportNo: FormatDataForm?
//        public let passportExpiryDate: FormatDataForm?
//        public let passportIssuing: FormatDataForm?
    }
    
    public struct Infant2 {
        public let separtor: FormatDataForm?
        public let title: FormatDataForm?
        public let firstname: FormatDataForm?
        public let lastname: FormatDataForm?
        public let birtdate: FormatDataForm?
        public let passportNationality: FormatDataForm?
        public let passportNo: FormatDataForm?
//        public let passportExpiryDate: FormatDataForm?
//        public let passportIssuing: FormatDataForm?
    }
    
    
    public struct Infant3 {
        public let separtor: FormatDataForm?
        public let title: FormatDataForm?
        public let firstname: FormatDataForm?
        public let lastname: FormatDataForm?
        public let birtdate: FormatDataForm?
        public let passportNationality: FormatDataForm?
        public let passportNo: FormatDataForm?
//        public let passportExpiryDate: FormatDataForm?
//        public let passportIssuing: FormatDataForm?
    }
    
    
    public struct Infant4 {
        public let separtor: FormatDataForm?
        public let title: FormatDataForm?
        public let firstname: FormatDataForm?
        public let lastname: FormatDataForm?
        public let birtdate: FormatDataForm?
        public let passportNationality: FormatDataForm?
        public let passportNo: FormatDataForm?
//        public let passportExpiryDate: FormatDataForm?
//        public let passportIssuing: FormatDataForm?
    }
    
    public struct Infant5 {
        public let separtor: FormatDataForm?
        public let title: FormatDataForm?
        public let firstname: FormatDataForm?
        public let lastname: FormatDataForm?
        public let birtdate: FormatDataForm?
        public let passportNationality: FormatDataForm?
        public let passportNo: FormatDataForm?
//        public let passportExpiryDate: FormatDataForm?
//        public let passportIssuing: FormatDataForm?
    }
    
    public struct Infant6 {
        public let separtor: FormatDataForm?
        public let title: FormatDataForm?
        public let firstname: FormatDataForm?
        public let lastname: FormatDataForm?
        public let birtdate: FormatDataForm?
        public let passportNationality: FormatDataForm?
        public let passportNo: FormatDataForm?
//        public let passportExpiryDate: FormatDataForm?
//        public let passportIssuing: FormatDataForm?
    }
}

public struct FormatDataForm {
    public let mandatory: Int
    public let type: String
    public let fieldText: String
    public let category: String
    public let isDisabled: String
    public let resBaggage: [ResourceBaggage]?
}

extension GetFlightDataEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<GetFlightDataEnvelope> {
        return curry(GetFlightDataEnvelope.init)
            <^> json <| "diagnostic"
            <*> json <| "required"
            <*> json <| "departures"
            <*> json <|? "returns"
            <*> json <|? "guest_id"
    }
}

public struct ResourceBaggage {
    public let id: String
    public let name: String
}

extension ResourceBaggage: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<ResourceBaggage> {
        return curry(ResourceBaggage.init)
            <^> json <| "id"
            <*> json <| "name"
    }
}

public struct AdultPassenger1 {
    public let separatorAdult: FormatDataForm?
    public let titleAdult: FormatDataForm?
    public let firstnameAdult: FormatDataForm?
    public let lastnameAdult: FormatDataForm?
}

/*
extension GetFlightDataEnvelope.PassengerList: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<GetFlightDataEnvelope.PassengerList> {
        let create = curry(GetFlightDataEnvelope.PassengerList.init)
        
        let adult1 = create
            <^> json <| "separator_adult1"
        
        return adult1
    }
}
*/

extension RequiredPassengers: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<RequiredPassengers> {
        let create = curry(RequiredPassengers.init)
        
        let adults = create
            <^> AdultPassengerFirst.decode(json)
            <*> Adult2.decode(json)
            <*> Adult3.decode(json)
            <*> Adult4.decode(json)
            <*> Adult5.decode(json)
            <*> Adult6.decode(json)
        
        let childs = adults
            <*> Child1.decode(json)
            <*> Child2.decode(json)
            <*> Child3.decode(json)
            <*> Child4.decode(json)
            <*> Child5.decode(json)
            <*> Child6.decode(json)
        
        let infants = childs
            <*> Infant1.decode(json)
            <*> Infant2.decode(json)
            <*> Infant3.decode(json)
            <*> Infant4.decode(json)
            <*> Infant5.decode(json)
            <*> Infant6.decode(json)
        
        return infants
    }
}

 
extension RequiredPassengers.AdultPassengerFirst: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<RequiredPassengers.AdultPassengerFirst> {
        let create = curry(RequiredPassengers.AdultPassengerFirst.init)

        let required2 = create
            <^> json <| "separator_adult1"
            <*> json <| "titlea1"
            <*> json <| "firstnamea1"
            <*> json <| "lastnamea1"
 
        return required2
            <*> json <|? "birthdatea1"
            <*> json <|? "passportnoa1"
//            <*> json <|? "passportExpiryDatea1"
//            <*> json <|? "passportissuinga1"
            <*> json <|? "dcheckinbaggagea11"
            <*> json <|? "dcheckinbaggagea21"
            <*> json <|? "rcheckinbaggagea11"
            <*> json <|? "rcheckinbaggagea21"
    }
}

extension RequiredPassengers.Adult2: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<RequiredPassengers.Adult2> {
        let create = curry(RequiredPassengers.Adult2.init)
        
        let adult1 = create
            <^> json <|? "separator_adult2"
        
        return adult1
            <*> json <|? "birthdatea2"
            <*> json <|? "passportnoa2"
//            <*> json <|? "passportExpiryDatea2"
//            <*> json <|? "passportissuinga2"
            <*> json <|? "dcheckinbaggagea12"
            <*> json <|? "dcheckinbaggagea22"
            <*> json <|? "rcheckinbaggagea12"
            <*> json <|? "rcheckinbaggagea12"
    }
}


extension RequiredPassengers.Adult3: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<RequiredPassengers.Adult3> {
        let create = curry(RequiredPassengers.Adult3.init)
        
        let adult1 = create
            <^> json <|? "separator_adult3"
            <*> json <|? "titlea3"
            <*> json <|? "firstnamea3"
            <*> json <|? "lastnamea3"
        
        return adult1
            <*> json <|? "birthdatea3"
            <*> json <|? "passportnationalitya3"
            <*> json <|? "passportnoa3"
//            <*> json <|? "passportExpiryDatea3"
//            <*> json <|? "passportissuinga3"
            <*> json <|? "rcheckinbaggagec11"
    }
}

extension RequiredPassengers.Adult4: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<RequiredPassengers.Adult4> {
        let create = curry(RequiredPassengers.Adult4.init)
        
        let adult1 = create
            <^> json <|? "separator_adult4"
            <*> json <|? "titlea4"
            <*> json <|? "firstnamea4"
            <*> json <|? "lastnamea4"
        
        return adult1
            <*> json <|? "birthdatea4"
            <*> json <|? "passportnationalitya4"
            <*> json <|? "passportnoa4"
//            <*> json <|? "passportExpiryDatea4"
//            <*> json <|? "passportissuinga4"
            <*> json <|? "rcheckinbaggagec11"
    }
}

extension RequiredPassengers.Adult5: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<RequiredPassengers.Adult5> {
        let create = curry(RequiredPassengers.Adult5.init)
        
        let adult1 = create
            <^> json <|? "separator_adult5"
            <*> json <|? "titlea5"
            <*> json <|? "firstnamea5"
            <*> json <|? "lastnamea5"
        
        return adult1
            <*> json <|? "birthdatea5"
            <*> json <|? "passportnationalitya5"
            <*> json <|? "passportnoa5"
//            <*> json <|? "passportExpiryDatea5"
//            <*> json <|? "passportissuinga5"
            <*> json <|? "rcheckinbaggagec11"
    }
}

extension RequiredPassengers.Adult6: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<RequiredPassengers.Adult6> {
        let create = curry(RequiredPassengers.Adult6.init)
        
        let adult1 = create
            <^> json <|? "separator_adult6"
            <*> json <|? "titlea6"
            <*> json <|? "firstnamea6"
            <*> json <|? "lastnamea6"
        
        return adult1
            <*> json <|? "birthdatea6"
            <*> json <|? "passportnationalitya6"
            <*> json <|? "passportnoa6"
//            <*> json <|? "passportExpiryDatea6"
//            <*> json <|? "passportissuinga6"
            <*> json <|? "rcheckinbaggagec11"
    }
}

extension RequiredPassengers.Child1: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<RequiredPassengers.Child1> {
        let create = curry(RequiredPassengers.Child1.init)
        
        let child1 = create
            <^> json <|? "separator_child1"
            <*> json <|? "titlec1"
            <*> json <|? "firstnamec1"
            <*> json <|? "lastnamec1"
        
        return child1
            <*> json <|? "birthdatec1"
            <*> json <|? "passportnationalityc1"
            <*> json <|? "passportnoc1"
//            <*> json <|? "passportExpiryDatec1"
//            <*> json <|? "passportissuingc1"
            <*> json <|? "rcheckinbaggagec11"
    }
}

extension RequiredPassengers.Child2: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<RequiredPassengers.Child2> {
        let create = curry(RequiredPassengers.Child2.init)
        
        let child1 = create
            <^> json <|? "separator_child2"
            <*> json <|? "titlec2"
            <*> json <|? "firstnamec2"
            <*> json <|? "lastnamec2"
        
        return child1
            <*> json <|? "birthdatec2"
            <*> json <|? "passportnationalityc2"
            <*> json <|? "passportnoc2"
//            <*> json <|? "passportExpiryDatec2"
//            <*> json <|? "passportissuingc2"
            <*> json <|? "rcheckinbaggagec12"
    }
}

extension RequiredPassengers.Child3: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<RequiredPassengers.Child3> {
        let create = curry(RequiredPassengers.Child3.init)
        
        let child1 = create
            <^> json <|? "separator_child3"
            <*> json <|? "titlec3"
            <*> json <|? "firstnamec3"
            <*> json <|? "lastnamec3"
        
        return child1
            <*> json <|? "birthdatec3"
            <*> json <|? "passportnationalityc3"
            <*> json <|? "passportnoc3"
//            <*> json <|? "passportExpiryDatec3"
//            <*> json <|? "passportissuingc3"
            <*> json <|? "rcheckinbaggagec11"
    }
}

extension RequiredPassengers.Child4: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<RequiredPassengers.Child4> {
        let create = curry(RequiredPassengers.Child4.init)
        
        let child1 = create
            <^> json <|? "separator_child4"
            <*> json <|? "titlec4"
            <*> json <|? "firstnamec4"
            <*> json <|? "lastnamec4"
        
        return child1
            <*> json <|? "birthdatec4"
            <*> json <|? "passportnationalityc4"
            <*> json <|? "passportnoc4"
//            <*> json <|? "passportExpiryDatec4"
//            <*> json <|? "passportissuingc4"
            <*> json <|? "rcheckinbaggagec12"
    }
}

extension RequiredPassengers.Child5: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<RequiredPassengers.Child5> {
        let create = curry(RequiredPassengers.Child5.init)
        
        let child1 = create
            <^> json <|? "separator_child5"
            <*> json <|? "titlec5"
            <*> json <|? "firstnamec5"
            <*> json <|? "lastnamec5"
        
        return child1
            <*> json <|? "birthdatec5"
            <*> json <|? "passportnationalityc5"
            <*> json <|? "passportnoc5"
//            <*> json <|? "passportExpiryDatec5"
//            <*> json <|? "passportissuingc5"
            <*> json <|? "rcheckinbaggagec11"
    }
}

extension RequiredPassengers.Child6: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<RequiredPassengers.Child6> {
        let create = curry(RequiredPassengers.Child6.init)
        
        let child1 = create
            <^> json <|? "separator_child6"
            <*> json <|? "titlec6"
            <*> json <|? "firstnamec6"
            <*> json <|? "lastnamec6"
        
        return child1
            <*> json <|? "birthdatec6"
            <*> json <|? "passportnationalityc6"
            <*> json <|? "passportnoc6"
//            <*> json <|? "passportExpiryDatec6"
//            <*> json <|? "passportissuingc6"
            <*> json <|? "rcheckinbaggagec12"
    }
}

extension RequiredPassengers.Infant1: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<RequiredPassengers.Infant1> {
        let create = curry(RequiredPassengers.Infant1.init)
        
        let infant1 = create
            <^> json <|? "separator_infant1"
            <*> json <|? "titlei1"
            <*> json <|? "firstnamei1"
            <*> json <|? "lastnamei1"
        
        return infant1
            <*> json <|? "birthdatei1"
            <*> json <|? "passportnationalityi1"
            <*> json <|? "passportnoi1"
//            <*> json <|? "passportExpiryDatei1"
//            <*> json <|? "passportissuingi1"
    }
}

extension RequiredPassengers.Infant2: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<RequiredPassengers.Infant2> {
        let create = curry(RequiredPassengers.Infant2.init)
        
        let infant1 = create
            <^> json <|? "separator_infant2"
            <*> json <|? "titlei2"
            <*> json <|? "firstnamei2"
            <*> json <|? "lastnamei2"
        
        return infant1
            <*> json <|? "birthdatei2"
            <*> json <|? "passportnationalityi2"
            <*> json <|? "passportnoi2"
//            <*> json <|? "passportExpiryDatei2"
//            <*> json <|? "passportissuingi2"
    }
}

extension RequiredPassengers.Infant3 : Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<RequiredPassengers.Infant3> {
        let create = curry(RequiredPassengers.Infant3.init)
        
        let infant1 = create
            <^> json <|? "separator_infant3"
            <*> json <|? "titlei3"
            <*> json <|? "firstnamei3"
            <*> json <|? "lastnamei3"
        
        return infant1
            <*> json <|? "birthdatei3"
            <*> json <|? "passportnationalityi3"
            <*> json <|? "passportnoi3"
//            <*> json <|? "passportExpiryDatei3"
//            <*> json <|? "passportissuingi3"
    }
}

extension RequiredPassengers.Infant4 : Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<RequiredPassengers.Infant4> {
        let create = curry(RequiredPassengers.Infant4.init)
        
        let infant1 = create
            <^> json <|? "separator_infant4"
            <*> json <|? "titlei4"
            <*> json <|? "firstnamei4"
            <*> json <|? "lastnamei4"
        
        return infant1
            <*> json <|? "birthdatei4"
            <*> json <|? "passportnationalityi4"
            <*> json <|? "passportnoi4"
//            <*> json <|? "passportExpiryDatei4"
//            <*> json <|? "passportissuingi4"
    }
}

extension RequiredPassengers.Infant5 : Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<RequiredPassengers.Infant5> {
        let create = curry(RequiredPassengers.Infant5.init)
        
        let infant1 = create
            <^> json <|? "separator_infant5"
            <*> json <|? "titlei5"
            <*> json <|? "firstnamei5"
            <*> json <|? "lastnamei5"
        
        return infant1
            <*> json <|? "birthdatei5"
            <*> json <|? "passportnationalityi5"
            <*> json <|? "passportnoi5"
//            <*> json <|? "passportExpiryDatei5"
//            <*> json <|? "passportissuingi5"
    }
}

extension RequiredPassengers.Infant6 : Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<RequiredPassengers.Infant6> {
        let create = curry(RequiredPassengers.Infant6.init)
        
        let infant1 = create
            <^> json <|? "separator_infant6"
            <*> json <|? "titlei6"
            <*> json <|? "firstnamei6"
            <*> json <|? "lastnamei6"
        
        return infant1
            <*> json <|? "birthdatei6"
            <*> json <|? "passportnationalityi6"
            <*> json <|? "passportnoi6"
//            <*> json <|? "passportExpiryDatei6"
//            <*> json <|? "passportissuingi6"
    }
}


extension FormatDataForm: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<FormatDataForm> {
        return curry(FormatDataForm.init)
            <^> json <| "mandatory"
            <*> json <| "type"
            <*> json <| "FieldText"
            <*> json <| "category"
            <*> json <| "disabled"
            <*> json <||? "resource"
    }
}

public struct GetFlightDataParams {
    public let flightId: String?
    public let date: String?
    public let returnFlightId: String?
    public let returnDate: String?
    
    public static let defaults = GetFlightDataParams(flightId: nil, date: nil, returnFlightId: nil, returnDate: nil)
    
    public var queryParams: [String: String] {
        var params: [String: String] = [:]
        params["flight_id"] = self.flightId
        params["date"] = self.date
        params["ret_flight_id"] = self.returnFlightId
        params["ret_date"] = self.returnDate
        
        return params
    }
}

