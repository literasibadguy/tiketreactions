//
//  GuestRoomStepperVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 27/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import UIKit

public protocol GuestRoomStepperDelegate: class {
    func didDismissCounting(_ guest: Int, room: Int)
}

public final class GuestRoomStepperVC: UIViewController {
    
    fileprivate let viewModel: HotelGuestPickViewModelType = HotelGuestPickViewModel()
    
    @IBOutlet fileprivate weak var guestStepper: UIStepper!
    @IBOutlet fileprivate weak var roomStepper: UIStepper!
    
    @IBOutlet fileprivate weak var guestsLabel: UILabel!
    @IBOutlet fileprivate weak var roomsLabel: UILabel!
    
    @IBOutlet fileprivate weak var topSeparatorView: UIView!
    @IBOutlet fileprivate weak var bottomSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var guestInputTitleLabel: UILabel!
    @IBOutlet fileprivate weak var doneButton: UIButton!
    @IBOutlet fileprivate weak var navigationPickerView: UIView!
    
    public weak var delegate: GuestRoomStepperDelegate?
    
    public static func configureWith(guest: Int, room: Int) -> GuestRoomStepperVC {
        let vc = Storyboard.HotelForm.instantiate(GuestRoomStepperVC.self)
        vc.viewModel.inputs.configureWith(guest: guest, room: room)
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
        
        _ = self.topSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.bottomSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.doneButton
            |> UIButton.lens.titleColor(forState: .normal) .~ .tk_official_green
            |> UIButton.lens.titleColor(forState: .disabled) .~ .tk_base_grey_100
        
        _ = self.guestInputTitleLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.guestStepper
            |> UIStepper.lens.tintColor .~ .tk_official_green
            |> UIStepper.lens.minimumValue .~ 1
            |> UIStepper.lens.maximumValue .~ 8
        
        _ = self.roomStepper
            |> UIStepper.lens.tintColor .~ .tk_official_green
            |> UIStepper.lens.minimumValue .~ 1
            |> UIStepper.lens.maximumValue .~ 8
        
        _ = self.guestsLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        _ = self.roomsLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.navigationPickerView
            |> UIView.lens.backgroundColor .~ .white
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        _ = self
            |> baseControllerStyle()
            |> UIViewController.lens.view.backgroundColor .~ UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        self.guestStepper.rac.value = self.viewModel.outputs.guestValue
        self.roomStepper.rac.value = self.viewModel.outputs.roomValue
        
        self.guestsLabel.rac.text = self.viewModel.outputs.guestValueText
        self.roomsLabel.rac.text = self.viewModel.outputs.roomValueText
        
        self.doneButton.rac.isEnabled = self.viewModel.outputs.doneButtonDisabled
        
        self.viewModel.outputs.dismissCounts
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] guest, room in
                self?.delegate?.didDismissCounting(guest, room: room)
                self?.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction fileprivate func guestValueStepper(_ sender: UIStepper) {
        self.viewModel.inputs.guestStepperHasChanged(sender.value)
    }
    
    @IBAction fileprivate func roomValueStepper(_ sender: UIStepper) {
        self.viewModel.inputs.roomStepperHasChanged(sender.value)
    }
    
    @objc fileprivate func doneButtonTapped() {
        self.viewModel.inputs.continueButtonTapped()
    }
}
