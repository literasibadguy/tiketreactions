//
//  PassengerBirthdatePickerVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 03/09/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit
import Prelude
import ReactiveSwift

internal protocol PassengerBirthdatePickerDelegate: class {
    func dateHaveSelected(_ date: Date)
}

internal protocol PassengerExpiredPassportPickerDelegate: class {
    func expiredDateHaveSelected(_ date: Date)
}

internal protocol PassengerIssueDatePassportPickerDelegate: class {
    func issueDateHaveSelected(_ date: Date)
}

internal final class PassengerBirthdatePickerVC: UIViewController {
    
    fileprivate let viewModel: PassBirthdatePickerViewModelType = PassBirthdatePickerViewModel()
    
    @IBOutlet fileprivate weak var birthdatePicker: UIDatePicker!
    @IBOutlet fileprivate weak var topSeparatorView: UIView!
    @IBOutlet fileprivate weak var birthdateStackView: UIStackView!
    @IBOutlet fileprivate weak var bottomSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var birthdateInputLabel: UILabel!
    @IBOutlet fileprivate weak var doneButton: UIButton!
    
    internal weak var delegate: PassengerBirthdatePickerDelegate?
    internal weak var expiredDelegate: PassengerExpiredPassportPickerDelegate?
    internal weak var issueDateDelegate: PassengerIssueDatePassportPickerDelegate?
    
    static func instantiate(delegate: PassengerBirthdatePickerDelegate) -> PassengerBirthdatePickerVC {
        let vc =  Storyboard.PassengerForm.instantiate(PassengerBirthdatePickerVC.self)
        vc.delegate = delegate
        return vc
    }
    
    static func instantiate(expiredDelegate: PassengerExpiredPassportPickerDelegate, state: PassengerFormState) -> PassengerBirthdatePickerVC {
        let vc =  Storyboard.PassengerForm.instantiate(PassengerBirthdatePickerVC.self)
        vc.viewModel.inputs.configureWith(state)
        vc.expiredDelegate = expiredDelegate
        return vc
    }
    
    static func instantiate(issueDelegate: PassengerIssueDatePassportPickerDelegate, state: PassengerFormState) -> PassengerBirthdatePickerVC {
        let vc =  Storyboard.PassengerForm.instantiate(PassengerBirthdatePickerVC.self)
        vc.viewModel.inputs.configureWith(state)
        vc.issueDateDelegate = issueDelegate
        return vc
    }
    
    static func configureBirthdate(_ delegate: PassengerBirthdatePickerDelegate, state: PassengerFormState) -> PassengerBirthdatePickerVC {
        let vc = Storyboard.PassengerForm.instantiate(PassengerBirthdatePickerVC.self)
        vc.viewModel.inputs.configureWith(state)
        vc.delegate = delegate
        return vc
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    internal override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> baseControllerStyle()
            |> UIViewController.lens.view.backgroundColor .~ UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        _ = self.birthdateStackView
            |> UIStackView.lens.layoutMargins %~~ { _, stackView in
                stackView.traitCollection.isRegularRegular
                    ? .init(topBottom: Styles.grid(0), leftRight: Styles.grid(4))
                    : .init(top: Styles.grid(0), left: Styles.grid(2), bottom: Styles.grid(0), right: Styles.grid(2))
            }
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = self.birthdatePicker
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.doneButton
            |> UIButton.lens.backgroundColor .~ .tk_official_green
        
        _ = self.topSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        _ = self.bottomSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.changeDateFormat
            .observe(on: UIScheduler())
            .observeValues { [weak self] format in
                self?.changedMinimumMaximumDate(state: format)
        }
        
        self.viewModel.outputs.submitDate
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                guard let _self = self else { return }
                _self.delegate?.dateHaveSelected(_self.birthdatePicker.date)
                _self.expiredDelegate?.expiredDateHaveSelected(_self.birthdatePicker.date)
                _self.issueDateDelegate?.issueDateHaveSelected(_self.birthdatePicker.date)
                _self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc fileprivate func doneButtonTapped() {
        self.viewModel.inputs.doneButtonTapped()
    }
    
    private func changedMinimumMaximumDate(state: PassengerFormState) {
        switch state {
        case .childPassenger:
            print("Child Passenger Birthdate Pick")
            self.birthdatePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -11, to: Date())
            self.birthdatePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -2, to: Date())
        case .infantPassenger:
            print("Infant Passenger Birthdate Pick")
            self.birthdatePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
            self.birthdatePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        case .adultPassenger:
            self.birthdatePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        case .expiredPassport:
            self.birthdatePicker.minimumDate = Calendar.current.date(byAdding: .month, value: +6, to: Date())
             self.birthdatePicker.maximumDate = Calendar.current.date(byAdding: .year, value: +10, to: Date())
        case .issueDatePassport:
            self.birthdatePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())
            self.birthdatePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        default: return
        }
    }
}

