//
//  FlightLiveFormVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 05/10/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Backpack
import UIKit

internal final class FlightLiveFormVC: UIViewController {
    
    @IBOutlet private weak var departurePanel: BPKPanel!
    @IBOutlet private weak var arrivalPanel: BPKPanel!
    @IBOutlet private weak var startDatePanel: BPKPanel!
    @IBOutlet private weak var endDatePanel: BPKPanel!
    @IBOutlet private weak var startDateTitleLabel: Label!
    @IBOutlet private weak var departureButton: Button!
    @IBOutlet private weak var endDateTitleLabel: Label!
    @IBOutlet private weak var arrivalTitleLabel: Label!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.arrivalTitleLabel.fontStyle = .textBaseEmphasized
        self.startDateTitleLabel.fontStyle = .textBaseEmphasized
        self.endDateTitleLabel.fontStyle = .textBaseEmphasized
        
        self.departureButton.style = .secondary
    }
    
    internal static func instantiate() -> FlightLiveFormVC {
        let vc = Storyboard.FlightForm.instantiate(FlightLiveFormVC.self)
        return vc
    }
}
