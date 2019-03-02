//
//  GetFlightDataParamsLenses.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 05/09/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude

/*
 public let flightId: String?
 public let date: String?
 public let returnFlightId: String?
 public let returnDate: String?
 public static let title = Lens<AdultPassengerParam, String?>(
 view: { $0.title },
 set: { some, thing in AdultPassengerParam(title: some, firstname: thing.firstname, lastname: thing.lastname, birthdate: thing.birthdate, id: thing.id, count: thing.count, passportNo: thing.passportNo, passportExpiryDate: thing.passportExpiryDate, passportIssuedDate: thing.passportIssuedDate, passportIssue: thing.passportIssue, passportNationality: thing.passportNationality) }
 )
*/

extension GetFlightDataParams {
    public enum lens {
        public static let flightId = Lens<GetFlightDataParams, String?>(view: { $0.flightId }, set: { some, thing in
            GetFlightDataParams(flightId: some, date: thing.date, returnFlightId: thing.returnFlightId, returnDate: thing.returnDate)
        })
        
        public static let date = Lens<GetFlightDataParams, String?>(view: { $0.date }, set: { some, thing in
            GetFlightDataParams(flightId: thing.flightId, date: some, returnFlightId: thing.returnFlightId, returnDate: thing.returnDate)
        })
        
        public static let returnFlightId = Lens<GetFlightDataParams, String?>(view: { $0.returnFlightId }, set: { some, thing in
            GetFlightDataParams(flightId: thing.flightId, date: thing.date, returnFlightId: some, returnDate: thing.returnDate)
        })
        
        public static let returnDate = Lens<GetFlightDataParams, String?>(view: { $0.returnDate }, set: { some, thing in
            GetFlightDataParams(flightId: thing.flightId, date: thing.date, returnFlightId: thing.returnFlightId, returnDate: some)
        })
    }
}
