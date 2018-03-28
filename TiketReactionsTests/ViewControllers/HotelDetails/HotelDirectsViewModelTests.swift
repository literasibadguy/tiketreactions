//
//  HotelDirectsViewModelTests.swift
//  TiketComponentsTests
//
//  Created by Firas Rafislam on 07/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import Result
import XCTest
@testable import TiketAPIs
@testable import TiketComponents

class HotelDirectsViewModelTests: XCTestCase {
    fileprivate let vm: HotelDirectsViewModelType = HotelDirectsViewModel()
    
    fileprivate let loadSampleHotelDirect = TestObserver<HotelDirect, NoError>()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.vm.outputs.loadHotelDirect.observe(self.loadSampleHotelDirect.observer)
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
    
    func testLoadHotelDirectIntoDataSource_WhenPresentingHotelDirect() {
        let hotelDirect = HotelDirect.sample
        
        self.vm.inputs.configureWith(hotelDirect: hotelDirect)
        self.vm.inputs.viewDidLoad()
        
        self.loadSampleHotelDirect.assertValues([], "Nothing emits immediately")
        
        self.vm.inputs.viewWillAppear(animated: false)
        self.vm.inputs.viewDidAppear(animated: false)
        
        self.loadSampleHotelDirect.assertValues([hotelDirect], "Load the full Hotel Direct into the data source")
        
        self.vm.inputs.viewWillAppear(animated: false)
        self.vm.inputs.viewDidAppear(animated: false)
    }
    
    func testLoadHotelDirectIntoDataSource_Swiping() {
        let hotelDirect = HotelDirect.sample
        
        self.vm.inputs.configureWith(hotelDirect: hotelDirect)
        self.vm.inputs.viewDidLoad()
        
        self.loadSampleHotelDirect.assertValues([], "Nothing emits immediately")
        
        self.vm.inputs.viewWillAppear(animated: true)
        self.vm.inputs.viewDidAppear(animated: true)
        
        self.loadSampleHotelDirect.assertValues([hotelDirect], "Load the full hotel Direct into the data source")
    }
}
