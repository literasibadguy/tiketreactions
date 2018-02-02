//
//  FlightResultsNavVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 31/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit

class FlightResultsNavVC: UIViewController {
    
    @IBOutlet fileprivate weak var navResultsStackView: UIStackView!
    
    @IBOutlet fileprivate weak var cancelButton: UIButton!
    
    @IBOutlet fileprivate weak var headStackView: UIStackView!
    @IBOutlet fileprivate weak var routeTitleLabel: UILabel!
    @IBOutlet fileprivate weak var dateTitleLabel: UILabel!
    
    @IBOutlet fileprivate weak var filterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self.filterButton
            |> UIButton.lens.titleColor(forState: .normal) .~ .tk_official_green
    }
}
