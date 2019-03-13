//
//  ManagedOrderListPagesVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 10/03/19.
//  Copyright © 2019 Firas Rafislam. All rights reserved.
//

import UIKit

class ManagedOrderListPagesVC: UIPageViewController {

    private var ordersViewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        print("Trick Pages View Controller called")
        
        dataSource = self
        delegate = self
        
        let hotelController = OrderListVC.instantiate()
        let flightController = FlightOrderListVC.instantiate()
        
        orderedViewControllers.append(firstPage)
        orderedViewControllers.append(secondPage)
        orderedViewControllers.append(thirdPage)
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true,completion: nil)
        }
        
        print("What ordered here: \(orderedViewControllers)")
        
        // Do any additional setup after loading the view.
        trickPagesDelegate?.trickPageController(scrollViewController: self, didUpdatePageCount: orderedViewControllers.count)
        */
    }

}
