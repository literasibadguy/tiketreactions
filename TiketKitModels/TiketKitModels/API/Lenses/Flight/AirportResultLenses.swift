//
//  AirportResultLenses.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 09/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude

extension AirportResult {
    public enum lens {
        
        
        public static let airportName = Lens<AirportResult, String>(
            view: { $0.airportName },
            set: { some, thing in AirportResult(airportName: some, airportCode: thing.airportCode, locationName: thing.locationName, countryId: thing.countryId, countryName: thing.countryName) }
        )
    }
}
