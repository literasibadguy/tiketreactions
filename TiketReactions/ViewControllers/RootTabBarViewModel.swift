//
//  RootTabBarViewModel.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 08/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import Result
import TiketKitModels
import UIKit

internal struct TabBarItemsData {
    internal let items: [TabBarItem]
}

internal enum TabBarItem {
    case flightForm(index: Int)
    case hotelForm(index: Int)
    case order(index: Int)
    case lounge(index: Int)
    case about(index: Int)
}

internal protocol RootViewModelInputs {
    func didSelectIndex(_ index: Int)
    
    func switchToFlight()
    
    func switchToHotelForm()
    
    func switchToOrder()
    
    func switchToIssues()
    
    func switchToAbout()
    
    func userSessionEnded()
    
    func userSessionStarted()
    
    func viewDidLoad()
}

internal protocol RootViewModelOutputs {
//    var tokenIntoEnvironment: Signal<String, NoError> { get }
    var selectedIndex: Signal<Int, NoError> { get }
    var setViewControllers: Signal<[UIViewController], NoError> { get }
    var tabBarItemsData: Signal<TabBarItemsData, NoError> { get }
}

internal protocol RootViewModelType {
    var inputs: RootViewModelInputs { get }
    var outputs: RootViewModelOutputs { get }
}

internal final class RootViewModel: RootViewModelType, RootViewModelInputs, RootViewModelOutputs {
    
    internal init() {
//        let standardViewControllers = self.view
        let standardViewControllers = self.viewDidLoadProperty.signal.map { _ in
            [ChooseFlightVC.instantiate(), HotelLiveFormVC.instantiate(), ManagedOrderListVC.instantiate(), IssuedListVC.instantiate(), GeneralAboutVC.instantiate()]
        }

        self.setViewControllers = standardViewControllers.map { $0.map(UINavigationController.init(rootViewController:)) }

        self.selectedIndex = Signal.combineLatest(
            .merge(
                self.didSelectIndexProperty.signal,
                self.switchToFlightProperty.signal.mapConst(0),
                self.switchToHotelFormProperty.signal.mapConst(1),
                self.switchToOrderProperty.signal.mapConst(2),
                self.switchToLoungeProperty.signal.mapConst(3),
                self.switchToAboutProperty.signal.mapConst(4)),
            self.setViewControllers, self.viewDidLoadProperty.signal).map { idx, vcs, _ in clamp(0, vcs.count - 1)(idx) }
        
        /*
        let selectedTabAgain = self.selectedIndex.combinePrevious()
            .map { prev, next -> Int? in prev == next ? next : nil }
            .skipNil()
        */
        
        self.tabBarItemsData = self.viewDidLoadProperty.signal.mapConst(tabData())
    }
    
    
    fileprivate let didSelectIndexProperty = MutableProperty(0)
    func didSelectIndex(_ index: Int) {
        self.didSelectIndexProperty.value = index
    }
    
    fileprivate let switchToFlightProperty = MutableProperty(())
    func switchToFlight() {
        self.switchToFlightProperty.value = ()
    }

    fileprivate let switchToHotelFormProperty = MutableProperty(())
    func switchToHotelForm() {
        self.switchToHotelFormProperty.value = ()
    }
    
    fileprivate let switchToOrderProperty = MutableProperty(())
    func switchToOrder() {
        self.switchToOrderProperty.value = ()
    }
    
    fileprivate let switchToLoungeProperty = MutableProperty(())
    func switchToIssues() {
        self.switchToLoungeProperty.value = ()
    }
    
    fileprivate let switchToAboutProperty = MutableProperty(())
    func switchToAbout() {
        self.switchToAboutProperty.value = ()
    }
    
    fileprivate let userSessionEndedProperty = MutableProperty(())
    func userSessionEnded() {
        self.userSessionEndedProperty.value = ()
    }
    
    fileprivate let userSessionStartedProperty = MutableProperty(())
    func userSessionStarted() {
        self.userSessionStartedProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
//    internal let tokenIntoEnvironment: Signal<String, NoError>
    internal let selectedIndex: Signal<Int, NoError>
    internal let setViewControllers: Signal<[UIViewController], NoError>
    internal let tabBarItemsData: Signal<TabBarItemsData, NoError>
    
    internal var inputs: RootViewModelInputs { return self }
    internal var outputs: RootViewModelOutputs { return self }
}

private func tabData() -> TabBarItemsData {
    let items: [TabBarItem] = [.flightForm(index: 0), .hotelForm(index: 1), .order(index: 2), .lounge(index: 3), .about(index: 4)]
    return TabBarItemsData(items: items)
}

extension TabBarItemsData: Equatable {
    static func == (lhs: TabBarItemsData, rhs: TabBarItemsData) -> Bool {
        return lhs.items == rhs.items
    }
}

extension TabBarItem: Equatable {
    static func == (lhs: TabBarItem, rhs: TabBarItem) -> Bool {
        switch (lhs, rhs) {
        case let (.flightForm(lhs), .flightForm(rhs)):
            return lhs == rhs
        case let (.hotelForm(lhs), .hotelForm(rhs)):
            return lhs == rhs
        case let (.order(lhs), .order(rhs)):
            return lhs == rhs
        case let (.lounge(lhs), .lounge(rhs)):
            return lhs == rhs
        case let (.about(lhs), .about(rhs)):
            return lhs == rhs
        default: return false
        }
    }
}

private func first<VC: UIViewController>(_ viewController: VC.Type) -> ([UIViewController]) -> VC? {
    return { viewControllers in
        viewControllers
            .index { $0 is VC }
            .flatMap { viewControllers[$0] as? VC }
    }
}
