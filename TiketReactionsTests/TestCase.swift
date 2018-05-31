//
//  TestCase.swift
//  TiketReactionsTests
//
//  Created by Firas Rafislam on 08/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import AVFoundation
import FBSnapshotTestCase
import Prelude
import ReactiveSwift
import Result
import XCTest
@testable import TiketKitModels

internal class TestCase: FBSnapshotTestCase {
    
    internal let config = Config.config
    internal let cookieStorage = MockCookieStorage()
    internal let dateType = MockDate.self
    internal let mainBundle = MockBundle()
    internal let reachability = MutableProperty(Reachability.wifi)
    internal let scheduler = TestScheduler(startDate: MockDate().date)
    internal let ubiquitousStore = FakeKeyValueStore()
    internal let userDefaults = FakeKeyValueStore()
    
    override func setUp() {
        super.setUp()
        
        UIView.doBadSwizzleStuff()
        UIViewController.doBadSwizzleStuff()
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "GMT")!
        
        AppEnvironment.pushEnvironment(apiService: self.apiService, apiDelayInterval: <#T##DispatchTimeInterval#>, calendar: <#T##Calendar#>, cookieStorage: <#T##HTTPCookieStorageProtocol#>, countryCode: <#T##String#>, dateType: <#T##DateProtocol.Type#>, debounceInterval: <#T##DispatchTimeInterval#>, device: <#T##UIDeviceType#>, isVoiceOverRunning: <#T##(() -> Bool)##(() -> Bool)##() -> Bool#>, language: <#T##Language#>, locale: <#T##Locale#>, mainBundle: <#T##NSBundleType#>, reachability: <#T##SignalProducer<Reachability, NoError>#>, scheduler: <#T##DateScheduler#>, ubiquitousStore: <#T##KeyValueStoreType#>, userDefaults: <#T##KeyValueStoreType#>)
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
