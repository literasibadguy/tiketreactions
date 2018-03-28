//
//  HotelDirectsVCTests.swift
//  TiketComponentsTests
//
//  Created by Firas Rafislam on 07/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import FBSnapshotTestCase
import XCTest
@testable import TiketComponents

class HotelDirectsVCTests: TestCase {
    
    override func setUp() {
        super.setUp()
        
        UIView.setAnimationsEnabled(false)
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        UIView.setAnimationsEnabled(true)
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        /*
        combos(Language.allLanguages, [Device.phone4_7inch, Device.phone5_8inch]).forEach { language, device in
            withEnvironment(language: language, locale: .init(identifier: language.rawValue)) {
                let vc = HotelDirectsVC.instantiate()
                let (parent, _) = traitControllers(device: device, orientation: .portrait, child: vc)
                parent.view.frame.size.height = 2_200
                
                FBSnapshotVerifyView(vc.view, identifier: "lang_\(language)_device_\(device)")
            }
        }
        */
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
