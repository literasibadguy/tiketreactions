//
//  TestingPickDatesVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 09/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit

public final class TestingPickDatesVC: UIViewController {
    
    internal static func instantiate() -> TestingPickDatesVC {
        let vc = Storyboard.PickDatesHotel.instantiate(TestingPickDatesVC.self)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
