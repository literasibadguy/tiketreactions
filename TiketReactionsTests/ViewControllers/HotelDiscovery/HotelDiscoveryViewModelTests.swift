//
//  HotelDiscoveryViewModelTests.swift
//  TiketComponentsTests
//
//  Created by Firas Rafislam on 10/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
@testable import TiketAPIs
@testable import TiketComponents
import Prelude
import ReactiveSwift
import Result
import UIKit
import XCTest

class HotelDiscoveryViewModelTests: XCTestCase {
    fileprivate let vm: HotelDiscoveryViewModelType = HotelDiscoveryViewModel()
    
    fileprivate let asyncReloadData = TestObserver<(), NoError>()
    fileprivate let hideEmptyState = TestObserver<(), NoError>()
    fileprivate let hasAddedHotels = TestObserver<Bool, NoError>()
    fileprivate let hasRemovedHotels = TestObserver<Bool, NoError>()
    fileprivate let hotelsAreLoading = TestObserver<Bool, NoError>()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.vm.outputs.hotels
            .map { $0.count }
            .combinePrevious(0)
            .map { prev, next in next > prev }
            .observe(self.hasAddedHotels.observer)
        self.vm.outputs.hotels
            .map { $0.count }
            .combinePrevious(0)
            .map { prev, next in next < prev }
            .observe(self.hasRemovedHotels.observer)
    }
    
    func testPaginating() {
        self.vm.inputs.selectedFilter(.defaults)
        self.vm.inputs.viewDidAppear()
        
        self.asyncReloadData.assertValueCount(1, message: "Reload Data when hotels are first added.")
        self.hasAddedHotels.assertValues([true], "Hotels are added")
        self.hasRemovedHotels.assertValues([false], "Hotels are not removed")
        self.hotelsAreLoading.assertValues([true, false], "Loading indicator toggle on/off")
        
        // Scroll down a bit and advance scheduler
        self.vm.inputs.willDisplayRow(2, outOf: 10)
        
        self.hasAddedHotels.assertValues([true], "No hotels are added")
        self.hasRemovedHotels.assertValues([false], "No hotels are removed")
        
        self.vm.inputs.willDisplayRow(9, outOf: 10)
        
        self.hasAddedHotels.assertValues([true, false], "More hotels are added from paginations")
        self.hasRemovedHotels.assertValues([false, false], "No hotels are removed")
        self.hotelsAreLoading.assertValues([true, false, true, false], "Loading indicator toggle on/off")
        
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
