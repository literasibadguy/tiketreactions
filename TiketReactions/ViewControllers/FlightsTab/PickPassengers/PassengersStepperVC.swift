//
//  PassengersStepperVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 06/08/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit
import Prelude
import ReactiveSwift

public protocol PassengersStepperDelegate: class {
    func didDismissPassengers(_ adult: Int, child: Int, infant: Int)
}

public final class PassengersStepperVC: UIViewController {
    
    fileprivate let viewModel: PickPassengersViewModelType = PickPassengersViewModel()
    
    @IBOutlet fileprivate weak var adultStepper: UIStepper!
    @IBOutlet fileprivate weak var childStepper: UIStepper!
    @IBOutlet fileprivate weak var infantStepper: UIStepper!
    
    @IBOutlet fileprivate weak var adultLabel: UILabel!
    @IBOutlet fileprivate weak var childLabel: UILabel!
    @IBOutlet fileprivate weak var infantLabel: UILabel!
    

    @IBOutlet fileprivate weak var topSeparatorView: UIView!
    @IBOutlet fileprivate weak var bottomSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var guestInputTitleLabel: UILabel!
    @IBOutlet fileprivate weak var doneButton: UIButton!
    @IBOutlet fileprivate weak var navigationPickerView: UIView!
    
    public weak var delegate: PassengersStepperDelegate?
    
    public static func configureWith(adult: Int, child: Int, infant: Int) -> PassengersStepperVC {
        let vc = Storyboard.PickPassengers.instantiate(PassengersStepperVC.self)
        vc.viewModel.inputs.configureWith(adult: adult, child: child, infant: infant)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> baseControllerStyle()
            |> UIViewController.lens.view.backgroundColor .~ UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        _ = self.topSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.bottomSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.doneButton
            |> UIButton.lens.titleColor(forState: .normal) .~ .tk_official_green
            |> UIButton.lens.titleColor(forState: .disabled) .~ .tk_base_grey_100
            |> UIButton.lens.title(forState: .normal) .~ Localizations.DonebuttonTitle
        
        _ = self.guestInputTitleLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.adultStepper
            |> UIStepper.lens.tintColor .~ .tk_official_green
            |> UIStepper.lens.minimumValue .~ 1
            |> UIStepper.lens.maximumValue .~ 6
        
        _ = self.childStepper
            |> UIStepper.lens.tintColor .~ .tk_official_green
            |> UIStepper.lens.minimumValue .~ 0
            |> UIStepper.lens.maximumValue .~ 6
        
        _ = self.infantStepper
            |> UIStepper.lens.tintColor .~ .tk_official_green
            |> UIStepper.lens.minimumValue .~ 0
            |> UIStepper.lens.maximumValue .~ 6
        
        _ = self.adultLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        _ = self.childLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        _ = self.infantLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.navigationPickerView
            |> UIView.lens.backgroundColor .~ .white
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.adultStepper.rac.value = self.viewModel.outputs.adultValue
        self.childStepper.rac.value = self.viewModel.outputs.childValue
        self.infantStepper.rac.value = self.viewModel.outputs.infantValue
        
        self.guestInputTitleLabel.rac.text = self.viewModel.outputs.passengerTotalValueText
        self.adultLabel.rac.text = self.viewModel.outputs.adultValueText
        self.childLabel.rac.text = self.viewModel.outputs.childValueText
        self.infantLabel.rac.text = self.viewModel.outputs.infantValueText
        
        self.doneButton.rac.isEnabled = self.viewModel.outputs.doneButtonDisabled
        
        self.viewModel.outputs.dismissPickPassengers
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] adult, child, infant in
                self?.delegate?.didDismissPassengers(adult, child: child, infant: infant)
                self?.dismiss(animated: true, completion: nil)
        }
        
        /*
        self.guestStepper.rac.value = self.viewModel.outputs.guestValue
        self.roomStepper.rac.value = self.viewModel.outputs.roomValue
        
        self.guestsLabel.rac.text = self.viewModel.outputs.guestValueText
        self.roomsLabel.rac.text = self.viewModel.outputs.roomValueText
        
        self.doneButton.rac.isEnabled = self.viewModel.outputs.doneButtonDisabled
        */
        
        /*
        self.viewModel.outputs.dismissCounts
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] guest, room in
                self?.delegate?.didDismissCounting(guest, room: room)
                self?.dismiss(animated: true, completion: nil)
        }
        */
    }
    
    @IBAction fileprivate func adultValueStepper(_ sender: UIStepper) {
        self.viewModel.inputs.adultStepperChanged(sender.value)
    }
    
    @IBAction fileprivate func childValueStepper(_ sender: UIStepper) {
        self.viewModel.inputs.childStepperChanged(sender.value)
    }
    
    @IBAction fileprivate func infantValueStepper(_ sender: UIStepper) {
        self.viewModel.inputs.infantStepperChanged(sender.value)
    }
    
    @objc fileprivate func doneButtonTapped() {
        self.viewModel.inputs.tappedConfirmButton()
    }
}

