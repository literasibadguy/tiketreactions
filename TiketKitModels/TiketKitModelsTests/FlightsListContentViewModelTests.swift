//
//  FlightsListContentViewModelTests.swift
//  TiketKitModelsTests
//
//  Created by Firas Rafislam on 18/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
@testable import TiketAPI
@testable import TiketKitModels
import Prelude
import ReactiveSwift
import Result
import UIKit
import XCTest

internal final class FlightsListContentViewModelTests: XCTestCase {
    fileprivate let vm: FlightsListContentViewModelType = FlightsListContentViewModel()
    
    fileprivate let isOrderRounds = TestObserver<Bool, NoError>()
    fileprivate let flights = TestObserver<[Flight], NoError>()
    fileprivate let returnFlights = TestObserver<[Flight], NoError>()
    fileprivate let pickReturnFlights = TestObserver<Flight, NoError>()
    fileprivate let goToFlight = TestObserver<Flight, NoError>()
    fileprivate let flightsAreLoading = TestObserver<Bool, NoError>()
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.vm.outputs.isOrderRounds.observe(self.isOrderRounds.observer)
        self.vm.outputs.flights.observe(self.flights.observer)
        self.vm.outputs.returnFlights.observe(self.returnFlights.observer)
        self.vm.outputs.pickReturnFlights.observe(self.pickReturnFlights.observer)
        self.vm.outputs.goToFlight.observe(self.goToFlight.observer)
        self.vm.outputs.flightsAreLoading.observe(self.flightsAreLoading.observer)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
