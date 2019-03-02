//
//  SearchFlightEnvelopeSamples.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 27/08/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation

extension SearchFlightEnvelope {
    
    public static let sample = SearchFlightEnvelope.init(diagnostic: .sample, roundTrip: true, paramSearchFlight: .sample, departResuts: [Flight.departGA722, Flight.departGA788, Flight.departGA795, Flight.departJT745, Flight.departQG680], returnResults: [Flight.returnGA650, Flight.returnGA745, Flight.returnGA788, Flight.returnGA650, Flight.returnGA795, Flight.returnQG910])
}
