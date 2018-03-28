//
//  ContactInfoViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 26/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import UIKit

protocol ContactInfoViewCellDelegate: class {
    func goToPassengerPickerVC(passengerPickerVC: PassengerTitlePickerVC)
    func getContactInfoParams(fullName: String, email: String, phone: String)
}

class ContactInfoViewCell: UITableViewCell, ValueCell {
    
    typealias Value = Int
    internal let viewModel: ContactInfoCellViewModelType = ContactInfoCellViewModel()
    
    weak var delegate: ContactInfoViewCellDelegate?
    
    @IBOutlet fileprivate weak var contactInfoStackView: UIStackView!
    @IBOutlet fileprivate weak var contactInfoLabel: UILabel!
    
    @IBOutlet fileprivate weak var titleInputStackView: UIStackView!
    @IBOutlet fileprivate weak var titleSeparatorView: UIView!
    @IBOutlet fileprivate weak var titleInputTextLabel: UILabel!
    @IBOutlet fileprivate weak var titleContainerView: UIView!
    @IBOutlet fileprivate weak var titlePickButton: UIButton!
    @IBOutlet fileprivate weak var titleMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var titlePickedLabel: UILabel!
    
    @IBOutlet fileprivate weak var fullNameInputStackView: UIStackView!
    @IBOutlet fileprivate weak var fullNameSeparatorView: UIView!
    @IBOutlet fileprivate weak var fullNameInputTextLabel: UILabel!
    @IBOutlet fileprivate weak var fullNameTextField: UITextField!
    
    @IBOutlet fileprivate weak var emailInputStackView: UIStackView!
    
    @IBOutlet fileprivate weak var emailInputTitleLabel: UILabel!
    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var emailSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var phoneInputStackView: UIStackView!
    @IBOutlet fileprivate weak var phoneCodeButton: UIButton!
    @IBOutlet fileprivate weak var phoneArrangeStackView: UIStackView!
    @IBOutlet fileprivate weak var phoneInputTitleLabel: UILabel!
    @IBOutlet fileprivate weak var phoneTextField: UITextField!
    @IBOutlet fileprivate weak var phoneSeparatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.titlePickButton.addTarget(self, action: #selector(titleSalutationButtonTapped), for: .touchUpInside)
        
        self.fullNameTextField.addTarget(self, action: #selector(fullNameTextFieldChanged(_:)), for: .editingChanged)
        self.fullNameTextField.addTarget(self, action: #selector(fullNameTextFieldDoneEditing), for: [.editingDidEndOnExit, .editingDidEnd])
        
        self.emailTextField.addTarget(self, action: #selector(emailTextFieldChanged(_:)), for: .editingChanged)
        self.emailTextField.addTarget(self, action: #selector(emailTextFieldDoneEditing), for: [.editingDidEndOnExit, .editingDidEnd])
        
        self.phoneTextField.addTarget(self, action: #selector(phoneTextFieldChanged(_:)), for: .editingChanged)
        self.phoneTextField.addTarget(self, action: #selector(phoneTextFieldDoneEditing), for: [.editingDidEndOnExit, .editingDidEnd])
    }

    override func bindStyles() {
        super.bindStyles()
        
        _ = self.contactInfoStackView
            |> UIStackView.lens.layoutMargins %~~ { _, stackView in
                stackView.traitCollection.isRegularRegular
                    ? .init(topBottom: Styles.grid(6), leftRight: Styles.grid(16))
                    : .init(top: Styles.grid(4), left: Styles.grid(4), bottom: Styles.grid(3), right: Styles.grid(4))
            }
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
            |> UIStackView.lens.spacing .~ Styles.grid(4)
        
        _ = titleInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(2)
        
        _ = titleMenuStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
            |> UIStackView.lens.alignment .~ .center
            |> UIStackView.lens.isUserInteractionEnabled .~ false
        
        _ = titlePickedLabel
            |> UILabel.lens.isUserInteractionEnabled .~ false
        
        _ = titleContainerView
            |> UIView.lens.layoutMargins .~ .init(top: Styles.grid(2), left: Styles.grid(2), bottom: Styles.grid(2), right: Styles.grid(4))
            |> UIView.lens.backgroundColor .~ .white
            |> UIView.lens.isUserInteractionEnabled .~ false
        
        _ = fullNameInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(2)
        
        _ = fullNameTextField
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.borderStyle .~ .roundedRect
            |> UITextField.lens.keyboardType .~ .default
        
        _ = fullNameSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = emailInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(2)
        
        _ = emailTextField
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.borderStyle .~ .roundedRect
            |> UITextField.lens.keyboardType .~ .default
        
        _ = emailSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = phoneInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(2)
        
        _ = phoneTextField
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.borderStyle .~ .roundedRect
            |> UITextField.lens.keyboardType .~ .phonePad
        
        _ = phoneSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        /*
        self.titlePickButton.rac.title = self.viewModel.outputs.titleLabelText
        self.fullNameTextField.rac.text = self.viewModel.outputs.fullnameTextFieldText
        self.emailTextField.rac.text = self.viewModel.outputs.emailTextFieldText
        self.phoneTextField.rac.text = self.viewModel.outputs.phoneTextFieldText
        self.phoneCodeButton.rac.title = self.viewModel.outputs.phoneCodeLabelText
        */
 
        self.viewModel.outputs.goToTitleSalutationPicker
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                print("Picker Title passenger Tapped Observable")
                self?.goToPickerTitlePassenger()
        }
    }
    
    func configureWith(value: Int) {
        
    }
    
    @objc fileprivate func goToPickerTitlePassenger() {
        let titlePickerVC = PassengerTitlePickerVC.instantiate(delegate: self)
        self.delegate?.goToPassengerPickerVC(passengerPickerVC: titlePickerVC)
        print("Passenger Title Picker VC Delegate")
    }
    
    @objc fileprivate func titleSalutationButtonTapped() {
        print("Title Salutation Button Tapped")
        self.viewModel.inputs.titleSalutationButtonTapped()
    }
    
    @objc fileprivate func fullNameTextFieldChanged(_ textField: UITextField) {
        self.viewModel.inputs.fullNameTextFieldChange(textField.text)
    }
    
    @objc fileprivate func fullNameTextFieldDoneEditing() {
        self.viewModel.inputs.fullNameTextFieldDidEndEditing()
        self.fullNameTextField.resignFirstResponder()
    }
    
    @objc fileprivate func emailTextFieldChanged(_ textField: UITextField) {
        self.viewModel.inputs.emailTextFieldChange(textField.text)
    }
    
    @objc fileprivate func emailTextFieldDoneEditing() {
        self.viewModel.inputs.emailTextFieldDidEndEditing()
        self.emailTextField.resignFirstResponder()
    }
    
    @objc fileprivate func phoneTextFieldChanged(_ textField: UITextField) {
        self.viewModel.inputs.phoneTextFieldChange(textField.text)
    }
    
    @objc fileprivate func phoneTextFieldDoneEditing() {
        self.viewModel.inputs.phoneTextFieldDidEndEditing()
        self.phoneTextField.resignFirstResponder()
    }
}

extension ContactInfoViewCell: PassengerTitlePickerVCDelegate {
    func passengerTitlePickerVC(_ controller: PassengerTitlePickerVC, choseTitle: String) {
        
    }
    
    func passengerTitlePickerVCCancelled(_ controller: PassengerTitlePickerVC) {
        
    }
    
    
}
