//
//  BetweenFormsVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 04/11/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit

internal final class BetweenFormsVC: UIViewController {
    
    var visibleViewController: UIViewController?
    var flightVC: FlightFormVC!
    var hotelVC: HotelFormVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupFormControllers()
    }
    
    private func showFlightVC() {
        self.showController(self.flightVC)
    }
    
    private func showHotelVC() {
        self.showController(self.hotelVC)
    }

    private func setupFormControllers() {
        let flightViewController = FlightFormVC.instantiate()
        addChildViewController(flightViewController)
        flightViewController.didMove(toParentViewController: self)
        self.flightVC = flightViewController
        
        let hotelViewController = HotelFormVC.instantiate()
        addChildViewController(hotelViewController)
        hotelViewController.didMove(toParentViewController: self)
        self.hotelVC = hotelViewController
        
        self.showController(self.flightVC)
    }
    
    
    private func showController(_ viewController: UIViewController) {
        guard visibleViewController != viewController else { return }
        
        viewController.view.frame = self.view.bounds
        viewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        viewController.view.layoutIfNeeded()
        
        if let visibleViewController = visibleViewController {
//            screen.controllerContainer.insertSubview(viewController.view, aboveSubview: visibleViewController.view)
            visibleViewController.view.removeFromSuperview()
        }
        else {
            self.view.addSubview(viewController.view)
        }
    }
}
