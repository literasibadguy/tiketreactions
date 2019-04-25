//
//  HotelGuestPickVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 16/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

public protocol HotelGuestPickDelegate: class {
    func didDismissGuestPick(_ pickGuestVC: HotelGuestPickVC, param: SearchHotelParams)
    func didDismissCounting(_ guest: Int, room: Int)
}

public final class HotelGuestPickVC: UIViewController {
    
    fileprivate let viewModel: HotelGuestPickViewModelType = HotelGuestPickViewModel()
    
    internal weak var delegate: HotelGuestPickDelegate?
    
    @IBOutlet fileprivate weak var guestRoomTitleLabel: UILabel!
    @IBOutlet fileprivate weak var guestContainerView: UIView!
    
    @IBOutlet fileprivate weak var guestTitleLabel: UILabel!
    @IBOutlet fileprivate weak var guestStepper: UIStepper!
    
    @IBOutlet fileprivate weak var roomTitleLabel: UILabel!
    @IBOutlet fileprivate weak var roomStepper: UIStepper!
    
    @IBOutlet fileprivate weak var continueButton: UIButton!
    
    internal static func instantiate(guest: Int, room: Int) -> HotelGuestPickVC {
        let vc = Storyboard.HotelForm.instantiate(HotelGuestPickVC.self)
        vc.viewModel.inputs.configureWith(guest: guest, room: room)
        return vc
    }
    
    internal static func configureWith(param: SearchHotelParams) -> HotelGuestPickVC {
        let vc = Storyboard.HotelForm.instantiate(HotelGuestPickVC.self)
        vc.viewModel.inputs.configureWith(param: param)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.continueButton
            |> UIButton.lens.backgroundColor .~ .tk_official_green
            |> UIButton.lens.titleColor(forState: .normal) .~ .white
            |> UIButton.lens.title(forState: .normal) .~ "Simpan"
        
        _ = self.guestStepper
            |> UIStepper.lens.minimumValue .~ 1
            |> UIStepper.lens.backgroundColor .~ .tk_official_green
            |> UIStepper.lens.tintColor .~ .white
        
        _ = self.roomStepper
            |> UIStepper.lens.minimumValue .~ 1
            |> UIStepper.lens.backgroundColor .~ .tk_official_green
            |> UIStepper.lens.tintColor .~ .white
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.guestTitleLabel.rac.text = self.viewModel.outputs.guestValueText
        self.roomTitleLabel.rac.text = self.viewModel.outputs.roomValueText
        
        self.guestStepper.rac.value = self.viewModel.outputs.guestValue
        self.roomStepper.rac.value = self.viewModel.outputs.roomValue
        
        self.viewModel.outputs.dismissPickGuest
            .observe(on: UIScheduler())
            .observeValues { [weak self] param in
                guard let _self = self else { return }
                _self.delegate?.didDismissGuestPick(_self, param: param)
                _self.dismiss(animated: true, completion: nil)
        }
        
        self.viewModel.outputs.dismissCounts
            .observe(on: UIScheduler())
            .observeValues { [weak self] guest, room in
                guard let _self = self else { return }
                _self.delegate?.didDismissCounting(guest, room: room)
                _self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction fileprivate func guestStepperValueHaveChanged(_ sender: UIStepper) {
        self.viewModel.inputs.guestStepperHasChanged(sender.value)
    }
    
    
    @IBAction fileprivate func roomStepperValueHaveChanged(_ sender: UIStepper) {
        self.viewModel.inputs.roomStepperHasChanged(sender.value)
    }
    
    @objc fileprivate func continueButtonTapped() {
        self.viewModel.inputs.continueButtonTapped()
    }
}
