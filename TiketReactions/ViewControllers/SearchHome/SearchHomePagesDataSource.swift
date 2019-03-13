//
//  SearchHomePagesDataSource.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 09/03/19.
//  Copyright © 2019 Firas Rafislam. All rights reserved.
//

import UIKit

public final class SearchHomePagesDataSource: NSObject, UIPageViewControllerDataSource {
    private let viewControllers: [UIViewController]
    
    internal init(delegate: UIViewController) {
        let flightController = ChooseFlightVC.instantiate()
        let hotelController = HotelLiveFormVC.instantiate()
        
        self.viewControllers = SearchHomeTab.allTabs.map { tab in
            switch tab {
            case .hotel: return hotelController
            case .flight: return flightController
            }
        }
    }
    
    internal func controllerFor(tab: SearchHomeTab) -> UIViewController? {
        guard let index = indexFor(tab: tab) else { return nil }
        return self.viewControllers[index]
    }
    
    internal func indexFor(controller: UIViewController) -> Int? {
        return self.viewControllers.index(of: controller)
    }
    
    internal func indexFor(tab: SearchHomeTab) -> Int? {
        return SearchHomeTab.allTabs.index(of: tab)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageIdx = self.viewControllers.index(of: viewController) else {
            fatalError("Couldnt find \(viewController) in \(self.viewControllers)")
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
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageIdx = self.viewControllers.index(of: viewController) else {
            fatalError("Couldnt find \(viewController) in \(self.viewControllers)")
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
    
    
    
    private func tabFor(controller: UIViewController) -> SearchHomeTab? {
        guard let index = self.viewControllers.index(of: controller) else { return nil }
        
        return SearchHomeTab.allTabs[index]
    }
    
}
