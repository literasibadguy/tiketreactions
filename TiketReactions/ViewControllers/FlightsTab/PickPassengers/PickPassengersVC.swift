//
//  PickPassengersVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 28/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import UIKit

public protocol PickPassengersDelegate: class {
    func didPassengersPick(_ pickPassengersVC: PickPassengersVC, adult: Int, child: Int, infant: Int)
}

public final class PickPassengersVC: UIViewController {
    
    fileprivate let viewModel: PickPassengersViewModelType = PickPassengersViewModel()
    
    public weak var delegate: PickPassengersDelegate?
    
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
    
    @IBOutlet fileprivate weak var saveButton: UIButton!
    
    public static func configureWith(adult: Int, child: Int, infant: Int) -> PickPassengersVC {
        let vc = Storyboard.PickPassengers.instantiate(PickPassengersVC.self)
        vc.viewModel.inputs.configureWith(adult: adult, child: child, infant: infant)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.saveButton.addTarget(self, action: #selector(tappedConfirmButton), for: .touchUpInside)
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = adultStepper
            |> UIStepper.lens.backgroundColor .~ .tk_official_green
            |> UIStepper.lens.tintColor .~ .white
            |> UIStepper.lens.minimumValue .~ 1
        
        _ = childStepper
            |> UIStepper.lens.backgroundColor .~ .tk_official_green
            |> UIStepper.lens.tintColor .~ .white
            |> UIStepper.lens.minimumValue .~ 0
        
        _ = infantStepper
            |> UIStepper.lens.backgroundColor .~ .tk_official_green
            |> UIStepper.lens.tintColor .~ .white
            |> UIStepper.lens.minimumValue .~ 0
        
        _ = self.passengersTitleLabel
            |> UILabel.lens.textColor .~ .tk_official_green
            |> UILabel.lens.text .~ Localizations.PassengerFlightTitleForm
        
        _ = self.saveButton
            |> UIButton.lens.backgroundColor .~ .tk_official_green
            |> UIButton.lens.titleColor(forState: .normal) .~ .white
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.adultTitleLabel.rac.text = self.viewModel.outputs.adultValueText
        self.childTitleLabel.rac.text = self.viewModel.outputs.childValueText
        self.infantTitleLabel.rac.text = self.viewModel.outputs.infantValueText
        self.passengersTitleLabel.rac.text = self.viewModel.outputs.passengerTotalValueText
        
        self.adultStepper.rac.value = self.viewModel.outputs.adultValue
        self.childStepper.rac.value = self.viewModel.outputs.childValue
        self.infantStepper.rac.value = self.viewModel.outputs.infantValue

        
        self.viewModel.outputs.dismissPickPassengers
            .observe(on: UIScheduler())
            .observeValues { [weak self] adult, child, infant in
                guard let _self = self else { return }
                _self.delegate?.didPassengersPick(_self, adult: adult, child: child, infant: infant)
                _self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc fileprivate func tappedConfirmButton() {
        self.viewModel.inputs.tappedConfirmButton()
    }

    @IBAction fileprivate func adultStepperChanged(_ sender: UIStepper) {
        self.viewModel.inputs.adultStepperChanged(sender.value)
    }
    
    @IBAction fileprivate func childStepperChanged(_ sender: UIStepper) {
        self.viewModel.inputs.childStepperChanged(sender.value)
    }
    
    @IBAction fileprivate func infantStepperChanged(_ sender: UIStepper) {
        self.viewModel.inputs.infantStepperChanged(sender.value)
    }
    
}
