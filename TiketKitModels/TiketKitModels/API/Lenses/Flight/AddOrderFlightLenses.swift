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
            set: { some, thing in GroupPassengersParam(flightId: some, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, groupPassengers: thing.groupPassengers) }
        )
        
        public static let returnFlightId = Lens<GroupPassengersParam, String?>(
            view: { $0.returnFlightId },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: some, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, groupPassengers: thing.groupPassengers) }
        )
        
        public static let lionCaptcha = Lens<GroupPassengersParam, String?>(
            view: { $0.lionCaptcha },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: some, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, groupPassengers: thing.groupPassengers) }
        )
        
        public static let lionSessionId = Lens<GroupPassengersParam, String?>(
            view: { $0.lionSessionId },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: some, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, groupPassengers: thing.groupPassengers) }
        )
        
        public static let adult = Lens<GroupPassengersParam, Int?>(
            view: { $0.adult },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: some, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, groupPassengers: thing.groupPassengers) }
        )
        
        public static let child = Lens<GroupPassengersParam, Int?>(
            view: { $0.child },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: some, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, groupPassengers: thing.groupPassengers) }
        )
        
        public static let conSalutation = Lens<GroupPassengersParam, String?>(
            view: { $0.conSalutation },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: some, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, groupPassengers: thing.groupPassengers) }
        )
        
        public static let conFirstName = Lens<GroupPassengersParam, String?>(
            view: { $0.conFirstName },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: some, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, groupPassengers: thing.groupPassengers) }
        )
        
        public static let conLastName = Lens<GroupPassengersParam, String?>(
            view: { $0.conLastName },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: some, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, groupPassengers: thing.groupPassengers) }
        )
        
        public static let conPhone = Lens<GroupPassengersParam, String?>(
            view: { $0.conPhone },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: some, conEmailAddress: thing.conEmailAddress, groupPassengers: thing.groupPassengers) }
        )
        
        public static let conEmailAddress = Lens<GroupPassengersParam, String?>(
            view: { $0.conEmailAddress },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: some , groupPassengers: thing.groupPassengers) }
        )
        
        public static let groupPassengers = Lens<GroupPassengersParam, [String: AdultPassengerParam]?>(
            view: { $0.groupPassengers },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, groupPassengers: some) }
        )
        
        // Adults List
        
        /*
        public static let adult1 = Lens<GroupPassengersParam, AdultPassengerParam?>(
            view: { $0.adult1 },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adult1: some, adult2: thing.adult2, adult3: thing.adult3, adult4: thing.adult4, adult5: thing.adult5, adult6: thing.adult6, child1: thing.child1, child2: thing.child2, child3: thing.child3, child4: thing.child4, child5: thing.child5, child6: thing.child6, infant1: thing.infant1, infant2: thing.infant2, infant3: thing.infant3, infant4: thing.infant4, infant5: thing.infant5, infant6: thing.infant6) }
        )
        
        public static let adult2 = Lens<GroupPassengersParam, AdultPassengerParam?>(
            view: { $0.adult2 },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adult1: thing.adult1, adult2: some, adult3: thing.adult3, adult4: thing.adult4, adult5: thing.adult5, adult6: thing.adult6, child1: thing.child1, child2: thing.child2, child3: thing.child3, child4: thing.child4, child5: thing.child5, child6: thing.child6, infant1: thing.infant1, infant2: thing.infant2, infant3: thing.infant3, infant4: thing.infant4, infant5: thing.infant5, infant6: thing.infant6) }
        )
        
        public static let adult3 = Lens<GroupPassengersParam, AdultPassengerParam?>(
            view: { $0.adult3 },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adult1: thing.adult1, adult2: thing.adult2, adult3: some, adult4: thing.adult4, adult5: thing.adult5, adult6: thing.adult6, child1: thing.child1, child2: thing.child2, child3: thing.child3, child4: thing.child4, child5: thing.child5, child6: thing.child6, infant1: thing.infant1, infant2: thing.infant2, infant3: thing.infant3, infant4: thing.infant4, infant5: thing.infant5, infant6: thing.infant6) }
        )
        
        public static let adult4 = Lens<GroupPassengersParam, AdultPassengerParam?>(
            view: { $0.adult4 },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adult1: thing.adult1, adult2: thing.adult2, adult3: thing.adult3, adult4: some, adult5: thing.adult5, adult6: thing.adult6, child1: thing.child1, child2: thing.child2, child3: thing.child3, child4: thing.child4, child5: thing.child5, child6: thing.child6, infant1: thing.infant1, infant2: thing.infant2, infant3: thing.infant3, infant4: thing.infant4, infant5: thing.infant5, infant6: thing.infant6) }
        )
        
        public static let adult5 = Lens<GroupPassengersParam, AdultPassengerParam?>(
            view: { $0.adult5 },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adult1: thing.adult1, adult2: thing.adult2, adult3: thing.adult3, adult4: thing.adult4, adult5: some, adult6: thing.adult6, child1: thing.child1, child2: thing.child2, child3: thing.child3, child4: thing.child4, child5: thing.child5, child6: thing.child6, infant1: thing.infant1, infant2: thing.infant2, infant3: thing.infant3, infant4: thing.infant4, infant5: thing.infant5, infant6: thing.infant6) }
        )
        
        public static let adult6 = Lens<GroupPassengersParam, AdultPassengerParam?>(
            view: { $0.adult6 },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adult1: thing.adult1, adult2: thing.adult2, adult3: thing.adult3, adult4: thing.adult4, adult5: thing.adult5, adult6: some, child1: thing.child1, child2: thing.child2, child3: thing.child3, child4: thing.child4, child5: thing.child5, child6: thing.child6, infant1: thing.infant1, infant2: thing.infant2, infant3: thing.infant3, infant4: thing.infant4, infant5: thing.infant5, infant6: thing.infant6) }
        )
        
        
        
        // Childs List
        
        public static let child1 = Lens<GroupPassengersParam, AdultPassengerParam?>(
            view: { $0.child1 },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adult1: thing.adult1, adult2: thing.adult2, adult3: thing.adult3, adult4: thing.adult4, adult5: thing.adult5, adult6: thing.adult6, child1: some, child2: thing.child2, child3: thing.child3, child4: thing.child4, child5: thing.child5, child6: thing.child6, infant1: thing.infant1, infant2: thing.infant2, infant3: thing.infant3, infant4: thing.infant4, infant5: thing.infant5, infant6: thing.infant6) }
        )
        
        public static let child2 = Lens<GroupPassengersParam, AdultPassengerParam?>(
            view: { $0.child2 },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adult1: thing.adult1, adult2: thing.adult2, adult3: thing.adult3, adult4: thing.adult4, adult5: thing.adult5, adult6: thing.adult6, child1: thing.child1, child2: some, child3: thing.child3, child4: thing.child4, child5: thing.child5, child6: thing.child6, infant1: thing.infant1, infant2: thing.infant2, infant3: thing.infant3, infant4: thing.infant4, infant5: thing.infant5, infant6: thing.infant6) }
        )
        
        public static let child3 = Lens<GroupPassengersParam, AdultPassengerParam?>(
            view: { $0.child3 },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adult1: thing.adult1, adult2: thing.adult2, adult3: thing.adult3, adult4: thing.adult4, adult5: thing.adult5, adult6: thing.adult6, child1: thing.child1, child2: thing.child2, child3: some, child4: thing.child4, child5: thing.child5, child6: thing.child6, infant1: thing.infant1, infant2: thing.infant2, infant3: thing.infant3, infant4: thing.infant4, infant5: thing.infant5, infant6: thing.infant6) }
        )
        
        public static let child4 = Lens<GroupPassengersParam, AdultPassengerParam?>(
            view: { $0.child4 },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adult1: thing.adult1, adult2: thing.adult2, adult3: thing.adult3, adult4: thing.adult4, adult5: thing.adult5, adult6: thing.adult6, child1: thing.child1, child2: thing.child2, child3: thing.child3, child4: some, child5: thing.child5, child6: thing.child6, infant1: thing.infant1, infant2: thing.infant2, infant3: thing.infant3, infant4: thing.infant4, infant5: thing.infant5, infant6: thing.infant6) }
        )
        
        public static let child5 = Lens<GroupPassengersParam, AdultPassengerParam?>(
            view: { $0.child5 },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adult1: thing.adult1, adult2: thing.adult2, adult3: thing.adult3, adult4: thing.adult4, adult5: thing.adult5, adult6: thing.adult6, child1: thing.child1, child2: thing.child2, child3: thing.child3, child4: thing.child4, child5: some, child6: thing.child6, infant1: thing.infant1, infant2: thing.infant2, infant3: thing.infant3, infant4: thing.infant4, infant5: thing.infant5, infant6: thing.infant6) }
        )
        
        public static let child6 = Lens<GroupPassengersParam, AdultPassengerParam?>(
            view: { $0.child6 },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adult1: thing.adult1, adult2: thing.adult2, adult3: thing.adult3, adult4: thing.adult4, adult5: thing.adult5, adult6: thing.adult6, child1: thing.child1, child2: thing.child2, child3: thing.child3, child4: thing.child4, child5: thing.child5, child6: some, infant1: thing.infant1, infant2: thing.infant2, infant3: thing.infant3, infant4: thing.infant4, infant5: thing.infant5, infant6: thing.infant6) }
        )
        
        // Infants List
        
        public static let infant1 = Lens<GroupPassengersParam, AdultPassengerParam?>(
            view: { $0.infant1 },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adult1: thing.adult1, adult2: thing.adult2, adult3: thing.adult3, adult4: thing.adult4, adult5: thing.adult5, adult6: thing.adult6, child1: thing.child1, child2: thing.child2, child3: thing.child3, child4: thing.child4, child5: thing.child5, child6: thing.child6, infant1: some, infant2: thing.infant2, infant3: thing.infant3, infant4: thing.infant4, infant5: thing.infant5, infant6: thing.infant6) }
        )
        
        public static let infant2 = Lens<GroupPassengersParam, AdultPassengerParam?>(
            view: { $0.infant2 },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adult1: thing.adult1, adult2: thing.adult2, adult3: thing.adult3, adult4: thing.adult4, adult5: thing.adult5, adult6: thing.adult6, child1: thing.child1, child2: thing.child2, child3: thing.child3, child4: thing.child4, child5: thing.child5, child6: thing.child6, infant1: thing.infant1, infant2: some, infant3: thing.infant3, infant4: thing.infant4, infant5: thing.infant5, infant6: thing.infant6) }
        )
        
        public static let infant3 = Lens<GroupPassengersParam, AdultPassengerParam?>(
            view: { $0.infant3 },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adult1: thing.adult1, adult2: thing.adult2, adult3: thing.adult3, adult4: thing.adult4, adult5: thing.adult5, adult6: thing.adult6, child1: thing.child1, child2: thing.child2, child3: thing.child3, child4: thing.child4, child5: thing.child5, child6: thing.child6, infant1: thing.infant1, infant2: thing.infant2, infant3: some, infant4: thing.infant4, infant5: thing.infant5, infant6: thing.infant6) }
        )
        
        public static let infant4 = Lens<GroupPassengersParam, AdultPassengerParam?>(
            view: { $0.infant4 },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adult1: thing.adult1, adult2: thing.adult2, adult3: thing.adult3, adult4: thing.adult4, adult5: thing.adult5, adult6: thing.adult6, child1: thing.child1, child2: thing.child2, child3: thing.child3, child4: thing.child4, child5: thing.child5, child6: thing.child6, infant1: thing.infant1, infant2: thing.infant2, infant3: thing.infant3, infant4: some, infant5: thing.infant5, infant6: thing.infant6) }
        )
        
        public static let infant5 = Lens<GroupPassengersParam, AdultPassengerParam?>(
            view: { $0.infant5 },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adult1: thing.adult1, adult2: thing.adult2, adult3: thing.adult3, adult4: thing.adult4, adult5: thing.adult5, adult6: thing.adult6, child1: thing.child1, child2: thing.child2, child3: thing.child3, child4: thing.child4, child5: thing.child5, child6: thing.child6, infant1: thing.infant1, infant2: thing.infant2, infant3: thing.infant3, infant4: thing.infant4, infant5: some, infant6: thing.infant6) }
        )
        
        public static let infant6 = Lens<GroupPassengersParam, AdultPassengerParam?>(
            view: { $0.infant6 },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adult1: thing.adult1, adult2: thing.adult2, adult3: thing.adult3, adult4: thing.adult4, adult5: thing.adult5, adult6: thing.adult6, child1: thing.child1, child2: thing.child2, child3: thing.child3, child4: thing.child4, child5: thing.child5, child6: thing.child6, infant1: thing.infant1, infant2: thing.infant2, infant3: thing.infant3, infant4: thing.infant4, infant5: thing.infant5, infant6: some) }
        )
        
        
        
        public static let adults = Lens<GroupPassengersParam, [AdultPassengerParam]>(
            view: { $0.adults },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adults: some, childs: thing.childs, infants: thing.infants) }
        )
        
        public static let childs = Lens<GroupPassengersParam, [ChildPassengerParam]>(
            view: { $0.childs },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adults: thing.adults, childs: some, infants: thing.infants) }
        )
        
        public static let infants = Lens<GroupPassengersParam, [InfantPassengerParam]>(
            view: { $0.infants },
            set: { some, thing in GroupPassengersParam(flightId: thing.flightId, returnFlightId: thing.returnFlightId, lionCaptcha: thing.lionCaptcha, lionSessionId: thing.lionSessionId, adult: thing.adult, child: thing.child, conSalutation: thing.conSalutation, conFirstName: thing.conFirstName, conLastName: thing.conLastName, conPhone: thing.conPhone, conEmailAddress: thing.conEmailAddress, adults: thing.adults, childs: thing.childs, infants: some) }
        )
        */
    }
}

extension AdultPassengerParam {
    public enum lens {
        
        public static let title = Lens<AdultPassengerParam, String?>(
            view: { $0.title },
            set: { some, thing in AdultPassengerParam(title: some, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
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
            set: { some, thing in AdultPassengerParam(title: thing.title, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: some, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
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
