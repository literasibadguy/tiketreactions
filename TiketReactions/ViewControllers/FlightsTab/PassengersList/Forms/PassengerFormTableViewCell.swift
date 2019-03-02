//
//  PassengerFormTableViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 07/01/19.
//  Copyright © 2019 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

protocol PassengerFormTableDelegate: class {
    func submitPassengerAgain()
    func goToTitlePicker(controller: PassengerTitlePickerVC)
    func goToBirthdatePicker(controller: PassengerBirthdatePickerVC)
    func canceledPick()
}

internal final class PassengerFormTableViewCell: UITableViewCell, ValueCell {
    
    typealias Value = FormatDataForm
    
    private let viewModel: PassengerTableCellFormViewModelType = PassengerTableCellFormViewModel()
    
    @IBOutlet private weak var passengerContainerView: UIView!
    @IBOutlet private weak var formStackView: UIStackView!
    
    @IBOutlet private weak var passengerLabel: UILabel!
    @IBOutlet private weak var titleInputStackView: UIStackView!
    @IBOutlet private weak var titleContainerView: UIView!
    @IBOutlet private weak var titleMenuStackView: UIStackView!
    @IBOutlet private weak var passengerTitlePickButton: UIButton!
    @IBOutlet private weak var passengerTitleLabel: UILabel!
    @IBOutlet private weak var titleSeparatorView: UIView!
    
    @IBOutlet private weak var firstNameInputStackView: UIStackView!
    @IBOutlet private weak var firstNameSeparatorView: UIView!
    @IBOutlet private weak var firstNameTextField: UITextField!
    
    @IBOutlet private weak var lastNameInputStackView: UIStackView!
    @IBOutlet private weak var lastNameSeparatorView: UIView!
    @IBOutlet private weak var lastNameTextField: UITextField!
    
    @IBOutlet private weak var birthdateInputStackView: UIStackView!
    @IBOutlet private weak var birthdatePickButton: UIButton!
    @IBOutlet private weak var birthdateMenuStackView: UIStackView!
    @IBOutlet private weak var birthdateContainerView: UIView!
    @IBOutlet private weak var birthdateTitleLabel: UILabel!
    @IBOutlet private weak var birthdateSeparatorView: UIView!
    
    @IBOutlet private weak var passportNationalityInputStackView: UIStackView!
    @IBOutlet private weak var passportNationalityContainerView: UIView!
    @IBOutlet private weak var passportNationalityMenuStackView: UIStackView!
    @IBOutlet private weak var passportNationalitySeparatorView: UIView!
    @IBOutlet private weak var passportNationalityPickButton: UIButton!
    @IBOutlet private weak var passportNationalityLabel: UILabel!
    
    weak var delegate: PassengerFormTableDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.passengerTitlePickButton.addTarget(self, action: #selector(titlePickButtonTapped), for: .touchUpInside)
        
        self.firstNameTextField.addTarget(self, action: #selector(firstNameTextFieldChanged(_:)), for: [.editingDidEndOnExit, .editingChanged])
        self.firstNameTextField.addTarget(self, action: #selector(firstNameTextFieldDoneEditing(_:)), for: .editingDidEndOnExit)
        
        self.lastNameTextField.addTarget(self, action: #selector(lastNameTextFieldChanged(_:)), for: [.editingDidEndOnExit, .editingChanged])
        self.lastNameTextField.addTarget(self, action: #selector(lastNameTextFieldDoneEditing(_:)), for: .editingDidEndOnExit)
        
        self.birthdatePickButton.addTarget(self, action: #selector(birthdatePickButtonTapped), for: .touchUpInside)
        self.passportNationalityPickButton.addTarget(self, action: #selector(nationalityPickButtonTapped), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self.contentView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.passengerContainerView
            |> UIView.lens.layer.borderColor .~ UIColor.tk_official_green.cgColor
            |> UIView.lens.layer.borderWidth .~ 1.5
        
        _ = self.formStackView
            |> UIStackView.lens.layoutMargins %~~ { _, stackView in
                stackView.traitCollection.isRegularRegular
                    ? .init(topBottom: Styles.grid(4), leftRight: Styles.grid(16))
                    : .init(top: Styles.grid(2), left: Styles.grid(4), bottom: Styles.grid(3), right: Styles.grid(4))
            }
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
        
        _ = self.passengerLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.titleContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        // Menu Stack View
        
        _ = self.titleMenuStackView
            |> UIStackView.lens.alignment .~ .center
            |> UIStackView.lens.isUserInteractionEnabled .~ false
        
        _ = self.titleSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        
        _ = self.firstNameTextField
            |> UITextField.lens.returnKeyType .~ .next
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.keyboardType .~ .default
            |> UITextField.lens.placeholder .~ Localizations.FirstnameFormData
        
        _ = self.firstNameSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.lastNameTextField
            |> UITextField.lens.returnKeyType .~ .done
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.keyboardType .~ .default
            |> UITextField.lens.placeholder .~ Localizations.LastnameFormData
        
        _ = self.lastNameSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.birthdateContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.birthdateMenuStackView
            |> UIStackView.lens.alignment .~ .center
            |> UIStackView.lens.isUserInteractionEnabled .~ false
        
        _ = self.birthdateSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.passportNationalityContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.passportNationalityMenuStackView
            |> UIStackView.lens.alignment .~ .center
            |> UIStackView.lens.isUserInteractionEnabled .~ false
        
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.passengerTitleLabel.rac.text = self.viewModel.outputs.titleLabelText
        self.birthdateTitleLabel.rac.text = self.viewModel.outputs.birthdateLabelText
        self.firstNameTextField.rac.becomeFirstResponder = self.viewModel.outputs.firstnameFirstResponder
        self.lastNameTextField.rac.becomeFirstResponder = self.viewModel.outputs.lastnameFirstResponder
        
        self.firstNameTextField.rac.text = self.viewModel.outputs.firstnameTextFieldText
        self.lastNameTextField.rac.text = self.viewModel.outputs.lastnameTextFieldText
        
        self.viewModel.outputs.goToTitlePassPicker
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.goToPickerAdultTitlePassenger()
        }
        
        self.viewModel.outputs.goToBirthdatePassPicker
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.goToBirthdatePickerPassenger()
        }
        
        self.viewModel.outputs.dismissTitlePassPicker
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                guard let _self = self else { return }
                _self.delegate?.canceledPick()
        }
    }
    
    func configureWith(value: FormatDataForm) {
        self.viewModel.inputs.configureWith(value)
    }
    
    private func goToPickerAdultTitlePassenger() {
        let titles = [Localizations.MrFormData, Localizations.MsFormData, Localizations.MsFormData]
        let titlePickerVC = PassengerTitlePickerVC.instantiate(titles: titles, selectedTitle: "", delegate: self)
        titlePickerVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        titlePickerVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.delegate?.goToTitlePicker(controller: titlePickerVC)
        print("Passenger Title Picker VC Delegate")
    }
    
    private func goToPickerChildTitlePassenger() {
        let titles = ["Tuan", "Nyonya", "Nona"]
        let titlePickerVC = PassengerTitlePickerVC.instantiate(titles: titles, selectedTitle: "", delegate: self)
        titlePickerVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        titlePickerVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.delegate?.goToTitlePicker(controller: titlePickerVC)
        print("Passenger Title Picker VC Delegate")
    }
    
    private func goToBirthdatePickerPassenger() {
        let birthdatePicker = PassengerBirthdatePickerVC.instantiate(delegate: self)
        birthdatePicker.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        birthdatePicker.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.delegate?.goToBirthdatePicker(controller: birthdatePicker)
    }
    
    @objc private func titlePickButtonTapped() {
        self.viewModel.inputs.titlePassengerButtonTapped()
        print("Title Pick Passenger Tapped")
    }
    
    @objc private func firstNameTextFieldChanged(_ textField: UITextField) {
        self.viewModel.inputs.firstNameTextFieldChange(textField.text)
    }
    
    @objc private func firstNameTextFieldDoneEditing(_ textField: UITextField) {
        self.viewModel.inputs.firstNameTextFieldDidEndEditing()
    }
    
    @objc private func lastNameTextFieldChanged(_ textField: UITextField) {
        self.viewModel.inputs.lastNameTextFieldChange(textField.text)
    }
    
    @objc private func lastNameTextFieldDoneEditing(_ textField: UITextField) {
        self.viewModel.inputs.lastNameTextFieldDidEndEditing()
    }
    
    @objc private func birthdatePickButtonTapped() {
        self.viewModel.inputs.birthdatePassengerTapped()
    }
    
    @objc private func nationalityPickButtonTapped() {
        self.viewModel.inputs.nationalityPassengerTapped()
    }
}

extension PassengerFormTableViewCell: PassengerTitlePickerVCDelegate {
    func passengerTitlePickerVC(_ controller: PassengerTitlePickerVC, choseTitle: String) {
        
    }
    
    func passengerTitlePickerVCCancelled(_ controller: PassengerTitlePickerVC) {
        
    }
}

extension PassengerFormTableViewCell: PassengerBirthdatePickerDelegate {
    func dateHaveSelected(_ date: Date) {
        
    }
}
