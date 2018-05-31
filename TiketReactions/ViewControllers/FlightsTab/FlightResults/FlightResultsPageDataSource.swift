//
//  FlightResultsPageDataSource.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 31/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import TiketKitModels
import UIKit

class FlightResultsPageDataSource: NSObject, UIPageViewControllerDataSource {
    
    fileprivate let viewControllers: [UIViewController]
    fileprivate let trips: [SearchFlightParams]
    
    internal init(sorts: [SearchFlightParams]) {
        self.trips = sorts
        self.viewControllers = sorts.map(FlightResultsContentVC.instantiate(sort:))
    }
    
    func indexFor(controller: UIViewController) -> Int? {
        return self.viewControllers.index(of: controller)
    }
    
    func delegate(controller: FlightResultsContentVC) {
        controller.delegate = self as? FlightResultsContentViewDelegate
    }
    
    internal func controllerFor(index: Int) -> UIViewController? {
        guard index >= 0 && index < self.viewControllers.count else { return nil }
        return self.viewControllers[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageIdx = self.viewControllers.index(of: viewController) else {
            fatalError("Couldn't find \(viewController) in \(self.viewControllers)")
        }
        
        let nextPageIdx = pageIdx + 1
        guard nextPageIdx < self.viewControllers.count else {
            return nil
        }
        
        return self.viewControllers[nextPageIdx]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageIdx = self.viewControllers.index(of: viewController) else {
            fatalError("Couldn't find \(viewController) in \(self.viewControllers)")
        }
        
        let beforePageIdx = pageIdx - 1
        guard beforePageIdx < self.viewControllers.count else {
            return nil
        }
        
        return self.viewControllers[beforePageIdx]
    }
    
    
}
