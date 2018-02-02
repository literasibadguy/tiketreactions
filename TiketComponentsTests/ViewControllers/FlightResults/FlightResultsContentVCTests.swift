//
//  FlightResultsContentVCTests.swift
//  TiketComponentsTests
//
//  Created by Firas Rafislam on 31/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import XCTest
@testable import TiketComponents
@testable import TiketAPIs

class FlightResultsContentVCTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        AppEnvironment.pushEnvironment(mainBundle: Bundle.framework)
        UIView.setAnimationsEnabled(false)
    }
    
    override func tearDown() {
        UIView.setAnimationsEnabled(true)
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
