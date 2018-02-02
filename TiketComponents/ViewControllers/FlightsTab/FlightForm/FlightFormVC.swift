//
//  FlightFormVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 25/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import Spring
import UIKit

class FlightFormVC: UIViewController {
    
    
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var flightFormStackView: UIStackView!
    @IBOutlet fileprivate weak var fromInputStackView: UIStackView!
    
    @IBOutlet fileprivate weak var fromContainerView: UIView!
    @IBOutlet fileprivate weak var ToContainerView: UIView!
    @IBOutlet fileprivate weak var passengersContainerView: UIView!
    @IBOutlet fileprivate weak var classContainerView: UIView!
    
    @IBOutlet fileprivate weak var orderFirstButton: DesignableButton!
    
    static func instantiate() -> FlightFormVC {
        let vc = Storyboard.FlightForm.instantiate(FlightFormVC.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .red
    }    
    
    override func bindStyles() {
        super.bindStyles()
        
        print("Lets some do bind styles..")
        
        _ = self.flightFormStackView
            |> UIStackView.lens.layoutMargins .~ .init(topBottom: Styles.grid(6), leftRight: Styles.grid(2))
            |> UIStackView.lens.spacing .~ Styles.grid(4)
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
        
        _ = self.fromContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.ToContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.passengersContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.classContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.orderFirstButton
            |> UIButton.lens.titleColor(forState: .normal) .~ .white
            |> UIButton.lens.backgroundColor .~ .tk_official_green
    }

}
