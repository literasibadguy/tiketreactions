//
//  PickPassengersVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 28/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import Spring
import UIKit

class PickPassengersVC: UIViewController {
    
    @IBOutlet fileprivate weak var pickPassengerStackView: UIStackView!
    
    @IBOutlet fileprivate weak var passengerContainerView: UIView!
    @IBOutlet fileprivate weak var adultInputStackView: UIStackView!
    @IBOutlet fileprivate weak var childInputStackView: UIStackView!
    @IBOutlet fileprivate weak var infantInputStackView: UIStackView!
    
    @IBOutlet fileprivate weak var cancelButton: UIButton!
    @IBOutlet fileprivate weak var passengersTitleLabel: UILabel!
    
    @IBOutlet fileprivate weak var adultTitleLabel: UILabel!
    @IBOutlet fileprivate weak var adultStepper: UIStepper!
    
    @IBOutlet fileprivate weak var childTitleLabel: UILabel!
    @IBOutlet fileprivate weak var childStepper: UIStepper!
    
    @IBOutlet fileprivate weak var infantTitleLabel: UILabel!
    @IBOutlet fileprivate weak var infantStepper: UIStepper!
    
    @IBOutlet fileprivate weak var saveButton: DesignableButton!
    
    static func instantiate() -> PickPassengersVC {
        let vc = Storyboard.PickPassengers.instantiate(PickPassengersVC.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = pickPassengerStackView
            |> UIStackView.lens.layoutMargins .~ .init(topBottom: Styles.grid(4), leftRight: Styles.grid(4))
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
            |> UIStackView.lens.spacing .~ Styles.grid(6)
        
        _ = adultStepper
            |> UIStepper.lens.incrementImage(for: .normal) .~ UIImage(named: "increment-normal")
            |> UIStepper.lens.incrementImage(for: .selected) .~ UIImage(named: "increment-selected")
            |> UIStepper.lens.decrementImage(for: .normal) .~ UIImage(named: "decrement-normal")
            |> UIStepper.lens.decrementImage(for: .selected) .~ UIImage(named: "decrement-selected")
            |> UIStepper.lens.tintColor .~ .tk_official_green
        
        _ = childStepper
            |> UIStepper.lens.tintColor .~ .tk_official_green
        
        _ = infantStepper
            |> UIStepper.lens.tintColor .~ .tk_official_green
        
        _ = self.passengersTitleLabel
            |> UILabel.lens.textColor .~ .tk_official_green
        
        _ = self.saveButton
            |> UIButton.lens.backgroundColor .~ .tk_official_green
            |> UIButton.lens.titleColor(forState: .normal) .~ .white
    }
    
    @objc fileprivate func cancelPassengerVC() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction fileprivate func adultStepperChanged(_ sender: UIStepper) {
        self.adultTitleLabel.text = "\(Int(sender.value)) Adults"
    }
    
    @IBAction fileprivate func childStepperChanged(_ sender: UIStepper) {
        self.childTitleLabel.text = "\(Int(sender.value)) Childs"
    }
    
    @IBAction fileprivate func infantStepperChanged(_ sender: UIStepper) {
        self.infantTitleLabel.text = "\(Int(sender.value)) Infants"
    }
    
}
