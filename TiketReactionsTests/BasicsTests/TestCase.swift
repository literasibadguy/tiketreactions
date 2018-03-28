//
//  TestCase.swift
//  TiketComponentsTests
//
//  Created by Firas Rafislam on 07/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import FBSnapshotTestCase
import Prelude
import Result
import XCTest
@testable import TiketAPIs
@testable import TiketComponents


internal class TestCase: FBSnapshotTestCase {
    internal static let interval = DispatchTimeInterval.milliseconds(1)
    
    internal let config = Config.config
    internal let cookieStorage = MockCookieStorage()
    internal let dateType = MockDate.self
    internal let mainBundle = MockBundle()
    internal let reachability = Reachability.wifi
    internal let ubiquitousStore = FakeKeyValueStore()
    internal let userDefaults = FakeKeyValueStore()
    
    override func setUp() {
        super.setUp()
        
        UIView.doBadSwizzleStuff()
        UIViewController.doBadSwizzleStuff()
        
        var calendarTest = Calendar(identifier: .gregorian)
        calendarTest.timeZone = TimeZone(identifier: "GMT")!
        
    }
    
    override func tearDown() {
        super.tearDown()
        AppEnvironment.popEnvironment()
    }
}
