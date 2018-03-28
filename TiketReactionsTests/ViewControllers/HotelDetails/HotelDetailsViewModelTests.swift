//
//  HotelDetailsViewModelTests.swift
//  TiketComponentsTests
//
//  Created by Firas Rafislam on 09/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import Result
import XCTest
@testable import TiketAPIs
@testable import TiketComponents

final class HotelDetailsViewModelTests: XCTestCase {
    fileprivate var vm: HotelDetailsViewModelType!
    
    fileprivate let configureChildViewControllerWithHotelDirect = TestObserver<HotelDirect, NoError>()
    fileprivate let setNavigationBarHidden = TestObserver<Bool, NoError>()
    fileprivate let setNavigationBarAnimated = TestObserver<Bool, NoError>()
    fileprivate let setNeedsStatusBarAppearanceUpdate = TestObserver<(), NoError>()
    fileprivate let topLayoutConstraintConstant = TestObserver<CGFloat, NoError>()
    
    internal override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.vm = HotelDetailsViewModel()
        self.vm.outputs.configureChildVCHotelDirect.observe(self.configureChildViewControllerWithHotelDirect.observer)
        
        
    }
    
    func testConfigureChildVCWithHotelDirect() {
        let hotelDirect = HotelDirect.sample
        self.vm.inputs.configureWith(hotelDirect: hotelDirect)
        self.vm.inputs.viewDidLoad()
        self.vm.inputs.viewWillAppear(animated: false)
        self.vm.inputs.viewDidAppear(animated: false)
        
        self.configureChildViewControllerWithHotelDirect.assertValues([hotelDirect])
        
        
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
