//
//  OrderListVCTests.swift
//  TiketReactionsTests
//
//  Created by Firas Rafislam on 08/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
@testable import TiketKitModels
import Prelude
import Result
import XCTest

internal final class OrderListVCTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        AppEnvironment.pushEnvironment(mainBundle: Bundle.framework)
        UIView.setAnimationsEnabled(false)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        AppEnvironment.popEnvironment()
        UIView.setAnimationsEnabled(true)
        super.tearDown()
    }
    
    func testOrdersList_All() {
        
    }
    
}
