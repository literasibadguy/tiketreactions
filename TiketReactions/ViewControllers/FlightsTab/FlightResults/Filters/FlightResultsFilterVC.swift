//
//  FlightResultsFilterVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 31/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit

class FlightResultsFilterVC: UITableViewController {
    
    fileprivate let dataSource = FlightResultsFilterDataSource()
    
    static func instantiate() -> FlightResultsFilterVC {
        let vc = Storyboard.FlightResults.instantiate(FlightResultsFilterVC.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        let cancelButton = UIButton(type: .custom)
        cancelButton.setImage(UIImage(named: "cancel-button-saved"), for: .normal)
        
        let plainCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        
        self.navigationItem.leftBarButtonItem = plainCancel
        
//        let cancelButton = UIBarButtonItem(image: image(named: "cancel-button-saved"), style: .custom, target: self, action: #selector(cancelButtonTapped))
        self.navigationItem.rightBarButtonItem = self.editButtonItem
//        self.navigationItem.rightBarButtonItem = cancelButton

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.dataSource = dataSource
        self.dataSource.load()
    }
    
    @objc fileprivate func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }

}
