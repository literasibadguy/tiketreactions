//
//  AddOrderFlightLenses.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 02/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude

extension GroupPassengersParam {
    public enum lens {
        
        public static let flightId = Lens<GroupPassengersParam, String?>(
            view: { $0.flightId },
            set: { some, thing in GroupPassengersParam(flightId: some, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adults: thing.adults, childs: thing.childs, infants: thing.infants) }
        )
        
        public static let returnFlightId = Lens<GroupPassengersParam, String?>(
            view: { $0.returnFlightId },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: some, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adults: thing.adults, childs: thing.childs, infants: thing.infants) }
        )
        
        public static let lionCaptcha = Lens<GroupPassengersParam, String?>(
            view: { $0.lionCaptcha },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: some, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adults: thing.adults, childs: thing.childs, infants: thing.infants) }
        )
        
        public static let lionSessionId = Lens<GroupPassengersParam, String?>(
            view: { $0.lionSessionId },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: some, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adults: thing.adults, childs: thing.childs, infants: thing.infants) }
        )
        
        public static let adult = Lens<GroupPassengersParam, Int?>(
            view: { $0.adult },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: some, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adults: thing.adults, childs: thing.childs, infants: thing.infants) }
        )
        
        public static let child = Lens<GroupPassengersParam, Int?>(
            view: { $0.child },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: some, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adults: thing.adults, childs: thing.childs, infants: thing.infants) }
        )
        
        public static let conSalutation = Lens<GroupPassengersParam, String?>(
            view: { $0.conSalutation },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: some, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adults: thing.adults, childs: thing.childs, infants: thing.infants) }
        )
        
        public static let conFirstName = Lens<GroupPassengersParam, String?>(
            view: { $0.conFirstName },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: some, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adults: thing.adults, childs: thing.childs, infants: thing.infants) }
        )
        
        public static let conLastName = Lens<GroupPassengersParam, String?>(
            view: { $0.conLastName },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: some, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adults: thing.adults, childs: thing.childs, infants: thing.infants) }
        )
        
        public static let conPhone = Lens<GroupPassengersParam, String?>(
            view: { $0.conPhone },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: some, conEmailAddress: thing.conEmailAddress, adults: thing.adults, childs: thing.childs, infants: thing.infants) }
        )
        
        public static let conEmailAddress = Lens<GroupPassengersParam, String?>(
            view: { $0.conEmailAddress },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: some, adults: thing.adults, childs: thing.childs, infants: thing.infants) }
        )
        
        public static let adults = Lens<GroupPassengersParam, [AdultPassengerParam]?>(
            view: { $0.adults },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adults: some, childs: thing.childs, infants: thing.infants) }
        )
        
        public static let childs = Lens<GroupPassengersParam, [ChildPassengerParam]?>(
            view: { $0.childs },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adults: thing.adults, childs: some, infants: thing.infants) }
        )
        
        public static let infants = Lens<GroupPassengersParam, [InfantPassengerParam]?>(
            view: { $0.infants },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adults: thing.adults, childs: thing.childs, infants: some) }
        )
    }
}

extension AdultPassengerParam {
    public enum lens {
        
        public static let title = Lens<AdultPassengerParam, String?>(
            view: { $0.title },
            set: { some, thing in AdultPassengerParam(title: some!, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let firstname = Lens<AdultPassengerParam, String?>(
            view: { $0.firstname },
            set: { some, thing in AdultPassengerParam(title: thing.title, firstname: some, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let lastname = Lens<AdultPassengerParam, String?>(
            view: { $0.lastname },
            set: { some, thing in AdultPassengerParam(title: thing.title, firstname: thing.firstname, lastname: some, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let birthdate = Lens<AdultPassengerParam, String?>(
            view: { $0.birthdate },
            set: { some, thing in AdultPassengerParam(title: thing.title, firstname: thing.firstname, lastname: thing.lastname, birthdate: some, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let id = Lens<AdultPassengerParam, String?>(
            view: { $0.id },
            set: { some, thing in AdultPassengerParam(title: thing.title, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let count = Lens<AdultPassengerParam, String?>(
            view: { $0.count },
            set: { some, thing in AdultPassengerParam(title: thing.title, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let passportNo = Lens<AdultPassengerParam, String?>(
            view: { $0.passportNo },
            set: { some, thing in AdultPassengerParam(title: thing.title, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: some, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let passportExpiryDate = Lens<AdultPassengerParam, String?>(
            view: { $0.passportExpiryDate},
            set: { some, thing in AdultPassengerParam(title: thing.title, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: some, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let passportIssuedDate = Lens<AdultPassengerParam, String?>(
            view: { $0.passportIssuedDate },
            set: { some, thing in AdultPassengerParam(title: thing.title, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: some, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let passportIssue = Lens<AdultPassengerParam, String?>(
            view: { $0.passportIssue},
            set: { some, thing in AdultPassengerParam(title: thing.title, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: some, passportNationality: thing.passportNationality) }
        )
        
        public static let passportNationality = Lens<AdultPassengerParam, String?>(
            view: { $0.passportIssue},
            set: { some, thing in AdultPassengerParam(title: thing.title, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: some) }
        )
    }
}

extension ChildPassengerParam {
    public enum lens {
        
        public static let title = Lens<ChildPassengerParam, String?>(
            view: { $0.title },
            set: { some, thing in ChildPassengerParam(title: some!, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let firstname = Lens<ChildPassengerParam, String?>(
            view: { $0.firstname },
            set: { some, thing in ChildPassengerParam(title: thing.title, firstname: some, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let lastname = Lens<ChildPassengerParam, String?>(
            view: { $0.lastname },
            set: { some, thing in ChildPassengerParam(title: thing.title, firstname: thing.firstname, lastname: some, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let birthdate = Lens<ChildPassengerParam, String?>(
            view: { $0.birthdate },
            set: { some, thing in ChildPassengerParam(title: thing.title, firstname: thing.firstname, lastname: thing.lastname, birthdate: some, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let id = Lens<ChildPassengerParam, String?>(
            view: { $0.id },
            set: { some, thing in ChildPassengerParam(title: thing.title, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: some, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let count = Lens<ChildPassengerParam, String?>(
            view: { $0.count },
            set: { some, thing in ChildPassengerParam(title: thing.title, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: some, count: some, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let passportNo = Lens<ChildPassengerParam, String?>(
            view: { $0.passportNo },
            set: { some, thing in ChildPassengerParam(title: thing.title, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: some, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let passportExpiryDate = Lens<ChildPassengerParam, String?>(
            view: { $0.passportExpiryDate},
            set: { some, thing in ChildPassengerParam(title: thing.title, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: some, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let passportIssuedDate = Lens<ChildPassengerParam, String?>(
            view: { $0.passportIssuedDate },
            set: { some, thing in ChildPassengerParam(title: thing.title, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: some, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let passportIssue = Lens<ChildPassengerParam, String?>(
            view: { $0.passportIssue},
            set: { some, thing in ChildPassengerParam(title: thing.title, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: some, passportNationality: thing.passportNationality) }
        )
        
        public static let passportNationality = Lens<ChildPassengerParam, String?>(
            view: { $0.passportIssue},
            set: { some, thing in ChildPassengerParam(title: thing.title, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: some) }
        )
    }
}

extension InfantPassengerParam {
    public enum lens {
        
        public static let title = Lens<InfantPassengerParam, String?>(
            view: { $0.title },
            set: { some, thing in InfantPassengerParam(title: some! ,parent: thing.parent, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let parent = Lens<InfantPassengerParam, String?>(
            view: { $0.parent },
            set: { some, thing in InfantPassengerParam(title: thing.title ,parent: some, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let firstname = Lens<InfantPassengerParam, String?>(
            view: { $0.firstname },
            set: { some, thing in InfantPassengerParam(title: thing.title, parent: thing.parent, firstname: some, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let lastname = Lens<InfantPassengerParam, String?>(
            view: { $0.lastname },
            set: { some, thing in InfantPassengerParam(title: thing.title, parent: thing.parent, firstname: thing.firstname, lastname: some, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let birthdate = Lens<InfantPassengerParam, String?>(
            view: { $0.birthdate },
            set: { some, thing in InfantPassengerParam(title: thing.title, parent: thing.parent, firstname: thing.firstname, lastname: thing.lastname, birthdate: some, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let id = Lens<InfantPassengerParam, String?>(
            view: { $0.id },
            set: { some, thing in InfantPassengerParam(title: thing.title, parent: thing.parent, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: some, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let count = Lens<InfantPassengerParam, String?>(
            view: { $0.count },
            set: { some, thing in InfantPassengerParam(title: thing.title, parent: thing.parent, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: some, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let passportNo = Lens<InfantPassengerParam, String?>(
            view: { $0.passportNo },
            set: { some, thing in InfantPassengerParam(title: thing.title, parent: thing.parent, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: some, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let passportExpiryDate = Lens<InfantPassengerParam, String?>(
            view: { $0.passportExpiryDate},
            set: { some, thing in InfantPassengerParam(title: thing.title, parent: thing.parent, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: some, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let passportIssuedDate = Lens<InfantPassengerParam, String?>(
            view: { $0.passportIssuedDate },
            set: { some, thing in InfantPassengerParam(title: thing.title, parent: thing.parent, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: some, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
        )
        
        public static let passportIssue = Lens<InfantPassengerParam, String?>(
            view: { $0.passportIssue},
            set: { some, thing in InfantPassengerParam(title: thing.title, parent: thing.parent, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: some, passportNationality: thing.passportNationality) }
        )
        
        public static let passportNationality = Lens<InfantPassengerParam, String?>(
            view: { $0.passportNationality },
            set: { some, thing in InfantPassengerParam(title: thing.title, parent: thing.parent, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: some) }
        )
    }
}
