//
//  RootTabBarViewModel.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 08/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import TiketAPIs
import Prelude
import ReactiveSwift
import Result
import UIKit

internal struct TabBarItemsData {
    internal let items: [TabBarItem]
}

internal enum TabBarItem {
    case flight(index: Int)
    case hotel(index: Int)
    case hotelForm(index: Int)
    case order(index: Int)
    case about(index: Int)
}

internal protocol RootViewModelInputs {
    func didSelectIndex(_ index: Int)
    
    func switchToFlight()
    
    func switchToHotel(params: SearchHotelParams?)
    
    func switchToHotelForm()
    
    func switchToOrder()
    
    func switchToAbout()
    
    func userSessionEnded()
    
    func userSessionStarted()
    
    func viewDidLoad()
}

internal protocol RootViewModelOutputs {
    
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
        let currentUser = Signal.merge(self.viewDidLoadProperty.signal, self.userSessionStartedProperty.signal, self.userSessionEndedProperty.signal)
        
        let standardViewControllers = self.viewDidLoadProperty.signal.map { _ in
            [FlightFormVC.instantiate(), HotelDiscoveryVC.instantiate(), HotelFormVC.instantiate(), OrderListVC.instantiate(), GeneralAboutVC.instantiate()]
        }
        
        self.setViewControllers = standardViewControllers.map { $0.map(UINavigationController.init(rootViewController:)) }
        
//        self.selectedIndex = .empty
//        self.tabBarItemsData = .empty
        
//        let vcCount = self.setViewControllers.map { $0.count }
        self.selectedIndex = Signal.combineLatest(
            .merge(
                self.didSelectIndexProperty.signal,
                self.switchToFlightProperty.signal.mapConst(0),
                self.switchToHotelProperty.signal.mapConst(1),
                self.switchToHotelFormProperty.signal.mapConst(2),
                self.switchToAboutProperty.signal.mapConst(3)),
            self.setViewControllers, self.viewDidLoadProperty.signal).map { idx, vcs, _ in clamp(0, vcs.count - 1)(idx) }
        
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
    
    fileprivate let switchToHotelProperty = MutableProperty<SearchHotelParams?>(nil)
    func switchToHotel(params: SearchHotelParams?) {
        self.switchToHotelProperty.value = params
    }
    
    fileprivate let switchToHotelFormProperty = MutableProperty(())
    func switchToHotelForm() {
        self.switchToHotelFormProperty.value = ()
    }
    
    fileprivate let switchToOrderProperty = MutableProperty(())
    func switchToOrder() {
        self.switchToOrderProperty.value = ()
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
    
    internal let selectedIndex: Signal<Int, NoError>
    internal let setViewControllers: Signal<[UIViewController], NoError>
    internal let tabBarItemsData: Signal<TabBarItemsData, NoError>
    
    internal var inputs: RootViewModelInputs { return self }
    internal var outputs: RootViewModelOutputs { return self }
}

private func tabData() -> TabBarItemsData {
    let items: [TabBarItem] = [.flight(index: 0), .hotel(index: 1), .hotelForm(index: 2), .order(index: 3), .about(index: 4)]
    
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
        case let (.flight(lhs), .flight(rhs)):
            return lhs == rhs
        case let (.hotel(lhs), .hotel(rhs)):
            return lhs == rhs
        case let (.hotelForm(lhs), .hotelForm(rhs)):
            return lhs == rhs
        case let (.order(lhs), .order(rhs)):
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


