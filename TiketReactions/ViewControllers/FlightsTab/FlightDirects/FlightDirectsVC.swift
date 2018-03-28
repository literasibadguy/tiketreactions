//
//  FlightDirectsVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 26/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit

class FlightDirectsVC: UIViewController {
    
    static func instantiate() -> FlightDirectsVC {
        let vc = Storyboard.FlightDirects.instantiate(FlightDirectsVC.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    

}
