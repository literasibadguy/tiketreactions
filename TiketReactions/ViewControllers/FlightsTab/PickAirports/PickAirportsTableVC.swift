//
//  PickAirportsTableVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 28/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit
import Prelude

class PickAirportsTableVC: UIViewController {
    
    fileprivate let dataSource = PickAirportsDataSource()
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var cancelButton: UIButton!
    @IBOutlet fileprivate weak var statusDestinationLabel: UILabel!
    @IBOutlet fileprivate weak var searchBarAirport: UISearchBar!
    
    static func instantiate() -> PickAirportsTableVC {
        let vc = Storyboard.PickAirports.instantiate(PickAirportsTableVC.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = dataSource
        dataSource.load()
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self.statusDestinationLabel
            |> UILabel.lens.textColor .~ .tk_official_green
    }
}
