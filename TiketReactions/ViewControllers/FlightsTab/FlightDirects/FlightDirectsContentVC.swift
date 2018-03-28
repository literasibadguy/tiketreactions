//
//  FlightDirectsContentVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 26/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit

class FlightDirectsContentVC: UITableViewController {
    
    
    fileprivate let dataSource = FlightDirectsContentDataSource()
    
    static func instantiate() -> FlightDirectsContentVC {
        let vc = Storyboard.FlightDirects.instantiate(FlightDirectsContentVC.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Booking"
        
        self.tableView.dataSource = dataSource
        
        self.tableView.register(nib: .FlightDirectViewCell)
        self.tableView.register(nib: .PassengerSummaryViewCell)
        
        dataSource.load()

    }
}
