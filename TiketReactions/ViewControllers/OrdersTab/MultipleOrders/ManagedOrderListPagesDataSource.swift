//
//  ManagedOrderListPagesDataSource.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 02/10/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit

internal final class ManagedOrderListPagesDataSource: NSObject, UIPageViewControllerDataSource {
    private let viewControllers: [UIViewController]
    
    internal init(delegate: UIViewController) {
        let hotelController = OrderListVC.instantiate()
        let flightController = FlightOrderListVC.instantiate()
        
        self.viewControllers = [hotelController, flightController]
    }
    
    internal func controllerFor(tab: ManagedOrderTab) -> UIViewController? {
        guard let index = indexFor(tab: tab) else { return nil }
        return self.viewControllers[index]
    }
    
    internal func indexFor(controller: UIViewController) -> Int? {
        return self.viewControllers.index(of: controller)
    }
    
    internal func indexFor(tab: ManagedOrderTab) -> Int? {
        return ManagedOrderTab.allTabs.index(of: tab)
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageIdx = self.viewControllers.index(of: viewController) else {
            fatalError("Couldn't find \(viewController) in \(self.viewControllers)")
        }
        
        let previousPageIdx = pageIdx - 1
        
        guard previousPageIdx >= 0 else {
            return nil
        }
        
        guard previousPageIdx < self.viewControllers.count else {
            return nil
        }
        
        return self.viewControllers[previousPageIdx]
    }
    
    internal func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageIdx = self.viewControllers.index(of: viewController) else {
            fatalError("Couldn't find \(viewController) in \(self.viewControllers)")
        }
        
        let nextPageIdx = pageIdx + 1
        
        let vcCount = self.viewControllers.count
        
        guard vcCount != nextPageIdx else {
            return nil
        }
        
        guard vcCount > nextPageIdx else {
            return nil
        }
        
        return self.viewControllers[nextPageIdx]
    }
    
    private func tabFor(controller: UIViewController) -> ManagedOrderTab? {
        guard let index = self.viewControllers.index(of: controller) else { return nil }
        
        return ManagedOrderTab.allTabs[index]
    }
}
