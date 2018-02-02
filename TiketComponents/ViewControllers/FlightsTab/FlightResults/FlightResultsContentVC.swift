//
//  FlightResultsContentVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 30/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit

class FlightResultsContentVC: UITableViewController {

    fileprivate let dataSource = FlightResultsDataSource()
    
    static func instantiate(sort: String) -> FlightResultsContentVC {
        let vc = Storyboard.FlightResults.instantiate(FlightResultsContentVC.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = dataSource
        
        self.tableView.register(nib: .FlightResultViewCell)
        
        self.dataSource.load()
    }

}
