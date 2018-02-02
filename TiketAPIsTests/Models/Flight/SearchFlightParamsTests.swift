//
//  SearchFlightParamsTests.swift
//  TiketAPIsTests
//
//  Created by Firas Rafislam on 31/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Argo
import Prelude
import XCTest
@testable import TiketAPIs

class SearchFlightParamsTests: XCTestCase {
    
    func testDefaults() {
        let params = SearchFlightParams.defaults
        XCTAssertNil(params.sort)
    }
    
    func testQueryParams() {
        XCTAssertEqual([:], SearchFlightParams.defaults.queryParams)
        
        let params = SearchFlightParams.defaults
            |> SearchFlightParams.lens.fromAirport .~ "CGK"
            |> SearchFlightParams.lens.toAirport .~ "DPS"
            |> SearchFlightParams.lens.departDate .~ "2018-02-02"
            |> SearchFlightParams.lens.returnDate .~ "2018-02-03"
            |> SearchFlightParams.lens.adult .~ 1
            |> SearchFlightParams.lens.child .~ 0
            |> SearchFlightParams.lens.infant .~ 0
            |> SearchFlightParams.lens.sort .~ false
        
        let queryParams: [String: String] = [
            "from": "CGK",
            "to": "DPS",
            "date": "2018-02-02",
            "ret_date": "2018-01-22",
            "adult": "1",
            "child": "0",
            "infant": "0",
            "sort": "false"
        ]
        
        XCTAssertEqual(queryParams, params.queryParams)
    }
    
    func testEquatable() {
        let params = SearchFlightParams.defaults
        XCTAssertEqual(params, params)
    }
    
    func testStringConvertible() {
        let params = SearchFlightParams.defaults
        XCTAssertNotNil(params.description)
        XCTAssertNotNil(params.debugDescription)
    }
}
