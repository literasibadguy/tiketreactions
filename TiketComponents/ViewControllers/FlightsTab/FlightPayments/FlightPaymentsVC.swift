//
//  FlightPaymentsVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 26/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit

class FlightPaymentsVC: UIViewController {
    
    static func instantiate() -> FlightPaymentsVC {
        let vc = Storyboard.FlightPayments.instantiate(FlightPaymentsVC.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
