//
//  EmptyStatesVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 25/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit

public final class EmptyStatesVC: UIViewController {
    
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var subtitleLabel: UILabel!
    
    public static func instantiate() -> EmptyStatesVC {
        let vc = Storyboard.EmptyStates.instantiate(EmptyStatesVC.self)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
