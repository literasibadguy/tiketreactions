//
//  RoundFlightResultsVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 30/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit

class RoundFlightResultsVC: UIViewController {
    
    fileprivate var dataSource: FlightResultsPageDataSource!
    
    private weak var navigationFlightVC: FlightResultsNavVC!
    private weak var pageViewController: UIPageViewController!
    private weak var sortRoundTripVC: RoundTripSortVC!
    
    static func instantiate() -> RoundFlightResultsVC {
        let vc = Storyboard.FlightResults.instantiate(RoundFlightResultsVC.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.pageViewController = self.childViewControllers.flatMap { $0 as? UIPageViewController }.first
        self.pageViewController.setViewControllers([.init()], direction: .forward, animated: true, completion: nil)
        self.pageViewController.delegate = self
        
        self.navigationFlightVC = self.childViewControllers.flatMap { $0 as? FlightResultsNavVC }.first
        
        self.sortRoundTripVC = self.childViewControllers.flatMap { $0 as? RoundTripSortVC }.first
        
        configurePagerDataSource()
    }
    
    fileprivate func configurePagerDataSource() {
        self.dataSource = FlightResultsPageDataSource(sorts: ["Berangkat", "Kembali"])
        
        self.pageViewController.dataSource = self.dataSource
        
        DispatchQueue.main.async {
            self.pageViewController.setViewControllers([self.dataSource.controllerFor(index: 0)].compact(), direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func setPageViewControllerScrollEnabled(_ enabled: Bool) {
        self.pageViewController.dataSource = enabled == false ? nil : self.dataSource
    }
}

extension RoundFlightResultsVC: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
    }
}

