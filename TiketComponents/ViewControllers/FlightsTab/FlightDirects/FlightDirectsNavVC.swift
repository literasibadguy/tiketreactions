//
//  FlightDirectsNavVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 30/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import Spring
import UIKit

class FlightDirectsNavVC: UIViewController {
    
    @IBOutlet fileprivate weak var totalTitleLabel: UILabel!
    @IBOutlet fileprivate weak var totalValuePriceLabel: UILabel!
    
    @IBOutlet fileprivate weak var bookingButton: DesignableButton!
    
    static func instantiate() -> FlightDirectsNavVC {
        let vc = Storyboard.FlightDirects.instantiate(FlightDirectsNavVC.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func bindStyles() {
        super.bindStyles()
        
        _ = self.totalTitleLabel
            |> UILabel.lens.textColor .~ .gray
        
        _ = self.bookingButton
            |> UIButton.lens.backgroundColor .~ .tk_official_green
            |> UIButton.lens.titleColor(forState: .normal) .~ .white
    }

}
