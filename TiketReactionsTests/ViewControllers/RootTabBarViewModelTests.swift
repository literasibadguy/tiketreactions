//
//  RootTabBarViewModelTests.swift
//  TiketComponentsTests
//
//  Created by Firas Rafislam on 08/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import XCTest
import UIKit
@testable import TiketAPIs
@testable import TiketComponents
import TiketAPIs
import Result
import ReactiveSwift
import Prelude

class RootTabBarViewModelTests: XCTestCase {
    let vm: RootViewModelType = RootViewModel()
    let viewControllerNames = TestObserver<[String], NoError>()
    let selectedIndex = TestObserver<Int, NoError>()
    let tabBarItemsData = TestObserver<TabBarItemsData, NoError>()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.vm.outputs.setViewControllers.map(extractRootNames).observe(self.viewControllerNames.observer)
        self.vm.outputs.selectedIndex.observe(self.selectedIndex.observer)
        self.vm.outputs.tabBarItemsData.observe(self.tabBarItemsData.observer)
    }
    
    func testViewControllersDontOverEmit() {
        let viewControllerNames = TestObserver<[String], NoError>()
    vm.outputs.setViewControllers.map(extractRootNames).observe(viewControllerNames.observer)
        
        self.vm.inputs.viewDidLoad()
        
        self.viewControllerNames.assertValueCount(1)
    }
    
    func testSelectedIndex() {
        self.selectedIndex.assertValues([], "No Index selected before view loads.")
        
        self.vm.inputs.viewDidLoad()
        
        self.selectedIndex.assertValues([], "No index selected immediately")
        
        self.vm.inputs.didSelectIndex(1)
        
        self.selectedIndex.assertValues([1], "Selects index immediately")
        
        self.vm.inputs.didSelectIndex(0)
        
        self.selectedIndex.assertValues([1, 0], "Selects index immediately")
        
        self.vm.inputs.didSelectIndex(10)
        
        self.selectedIndex.assertValues([1, 0, 3], "Selecting index out of range safely clamps to bounds")
    }
    
    func testSwitchingTabs() {
        self.vm.inputs.viewDidLoad()
        self.selectedIndex.assertValues([])
        self.vm.inputs.switchToFlight()
        self.selectedIndex.assertValues([0])
        self.vm.inputs.switchToHotel()
        self.selectedIndex.assertValues([0, 1])
        self.vm.inputs.switchToOrder()
        self.selectedIndex.assertValues([0, 1])
        self.vm.inputs.switchToAbout()
        self.selectedIndex.assertValues([0, 1, 2])
    }
    
    func testSetViewControllers() {
        let viewControllerNames = TestObserver<[String], NoError>()
        vm.outputs.setViewControllers.map(extractRootNames)
            .observe(viewControllerNames.observer)
        
        vm.inputs.viewDidLoad()
        
        viewControllerNames.assertValues([["FlightForm", "HotelDiscovery", "OrderList", "GeneralAbout"]], "Show the logged out tabs")
        
        vm.inputs.userSessionStarted()
        
    }
    
    func testTabBarItemStyles() {
        let items: [TabBarItem] = [.flight(index: 0), .hotel(index: 1), .order(index: 2), .about(index: 3)]
        
        let tabData = TabBarItemsData(items: items)
        
        self.tabBarItemsData.assertValueCount(0)
        
        self.vm.inputs.viewDidLoad()
        
        self.tabBarItemsData.assertValues([tabData])
    }
    
    func testSetViewControllers_DoesNotHotelDiscovery() {
        
        
    }
}

private func extractRootNames(_ vcs: [UIViewController]) -> [String] {
    return vcs.flatMap(extractRootName)
}

private func extractRootName(_ vc: UIViewController) -> String? {
    return (vc as? UINavigationController)?
        .viewControllers
        .first
        .map { root in
            "\(type(of: root))"
                .replacingOccurrences(of: "VC", with: "")
    }
}
