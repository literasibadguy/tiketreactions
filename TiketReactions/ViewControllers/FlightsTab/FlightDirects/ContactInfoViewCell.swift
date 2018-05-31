//
//  ContactInfoViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 26/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

protocol ContactInfoViewCellDelegate: class {
    func goToPassengerPickerVC(passengerPickerVC: PassengerTitlePickerVC)
    func getContactInfoParams(guestForm: CheckoutGuestParams)
    func getFinishedForm(_ completed: Bool)
    func canceledTitlePick()
}

internal final class ContactInfoViewCell: UITableViewCell, ValueCell {
    
    public typealias Value = Int
    internal let viewModel: ContactInfoCellViewModelType = ContactInfoCellViewModel()
    
    weak var delegate: ContactInfoViewCellDelegate?
    
    @IBOutlet fileprivate weak var contactInfoStackView: UIStackView!
    @IBOutlet fileprivate weak var contactContainerView: UIView!
    @IBOutlet fileprivate weak var contactInfoLabel: UILabel!
    
    @IBOutlet fileprivate weak var titleInputStackView: UIStackView!
    @IBOutlet fileprivate weak var titleSeparatorView: UIView!
    @IBOutlet fileprivate weak var titleInputTextLabel: UILabel!
    @IBOutlet fileprivate weak var titleContainerView: UIView!
    @IBOutlet weak var titleMenuStackView: UIStackView!
    @IBOutlet var titlePickedLabel: UILabel!
    
    @IBOutlet fileprivate weak var firstNameInputStackView: UIStackView!
    @IBOutlet fileprivate weak var firstNameSeparatorView: UIView!
    @IBOutlet fileprivate weak var firstNameInputTextLabel: UILabel!
    @IBOutlet fileprivate weak var firstNameTextField: UITextField!
    @IBOutlet fileprivate weak var titlePickButton: UIButton!
    
    @IBOutlet fileprivate weak var lastNameInputStackView: UIStackView!
    @IBOutlet fileprivate weak var lastNameInputLabel: UILabel!
    @IBOutlet fileprivate weak var lastNameTextField: UITextField!
    @IBOutlet fileprivate weak var lastNameSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var emailInputStackView: UIStackView!
    @IBOutlet fileprivate weak var emailInputTitleLabel: UILabel!
    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var emailSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var phoneInputStackView: UIStackView!
    @IBOutlet var phoneCodeButton: UIButton!
    @IBOutlet fileprivate weak var phoneArrangeStackView: UIStackView!
    @IBOutlet fileprivate weak var phoneInputTitleLabel: UILabel!
    @IBOutlet fileprivate weak var phoneTextField: UITextField!
    @IBOutlet fileprivate weak var phoneSeparatorView: UIView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let doneToolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.contentView.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: Localizations.DonebuttonTitle, style: .done, target: self, action: #selector(phoneTextFieldDoneEditing))
        doneBtn.tintColor = .tk_official_green
        doneToolbar.setItems([flexSpace, doneBtn], animated: false)
        doneToolbar.sizeToFit()
        
        self.titlePickButton.addTarget(self, action: #selector(titleSalutationButtonTapped), for: .touchUpInside)
        
        self.firstNameTextField.addTarget(self, action: #selector(firstNameTextFieldChanged(_:)), for: .editingChanged)
        self.firstNameTextField.addTarget(self, action: #selector(firstNameTextFieldDoneEditing), for: [.editingDidEndOnExit, .editingDidEnd])
        
        self.lastNameTextField.addTarget(self, action: #selector(lastNameTextFieldChanged(_:)), for: .editingChanged)
        self.lastNameTextField.addTarget(self, action: #selector(lastNameTextFieldDoneEditing), for: [.editingDidEndOnExit, .editingDidEnd])
        
        self.emailTextField.addTarget(self, action: #selector(emailTextFieldChanged(_:)), for: .editingChanged)
        self.emailTextField.addTarget(self, action: #selector(emailTextFieldDoneEditing), for: [.editingDidEndOnExit, .editingDidEnd])
        
        self.phoneTextField.addTarget(self, action: #selector(phoneTextFieldChanged(_:)), for: .editingChanged)
        self.phoneTextField.addTarget(self, action: #selector(phoneTextFieldDoneEditing), for: [.editingDidEndOnExit, .editingDidEnd])
        self.phoneTextField.inputAccessoryView = doneToolbar
    }

    override public func bindStyles() {
        super.bindStyles()
        
        _ = self.contentView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.contactInfoStackView
            |> UIStackView.lens.layoutMargins %~~ { _, stackView in
                stackView.traitCollection.isRegularRegular
                    ? .init(topBottom: Styles.grid(6), leftRight: Styles.grid(16))
                    : .init(top: Styles.grid(2), left: Styles.grid(4), bottom: Styles.grid(3), right: Styles.grid(4))
            }
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = self.contactInfoLabel
            |> UILabel.lens.text .~ Localizations.GuestContactFormTitle
        
        _ = titleInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = titleInputTextLabel
            |> UILabel.lens.text .~ Localizations.TitleFormData
        
        _ = titleMenuStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
            |> UIStackView.lens.alignment .~ .center
            |> UIStackView.lens.isUserInteractionEnabled .~ false
        
        _ = titleContainerView
            |> UIView.lens.layoutMargins .~ .init(top: Styles.grid(2), left: Styles.grid(2), bottom: Styles.grid(2), right: Styles.grid(4))
            |> UIView.lens.backgroundColor .~ .white
        
        _ = titleSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = titlePickedLabel
            |> UILabel.lens.text .~ Localizations.TitleFormData
            |> UILabel.lens.textColor .~ .darkGray
        
        _ = firstNameInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = firstNameInputTextLabel
            |> UILabel.lens.text .~ Localizations.FirstnameFormData
        
        _ = firstNameTextField
            |> UITextField.lens.returnKeyType .~ .next
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.borderStyle .~ .roundedRect
            |> UITextField.lens.keyboardType .~ .default
        
        _ = firstNameSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = lastNameInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = lastNameInputLabel
            |> UILabel.lens.text .~ Localizations.LastnameFormData
        
        _ = lastNameTextField
            |> UITextField.lens.returnKeyType .~ .next
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.borderStyle .~ .roundedRect
            |> UITextField.lens.keyboardType .~ .default
        
        _ = lastNameSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = emailInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = emailInputTitleLabel
            |> UILabel.lens.text .~ Localizations.EmailFormData
        
        _ = emailTextField
            |> UITextField.lens.returnKeyType .~ .next
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.borderStyle .~ .roundedRect
            |> UITextField.lens.keyboardType .~ .default
        
        _ = emailSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = phoneInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = phoneInputTitleLabel
            |> UILabel.lens.text .~ Localizations.PhonenumberFormData
        
        _ = phoneTextField
            |> UITextField.lens.returnKeyType .~ .done
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.borderStyle .~ .roundedRect
            |> UITextField.lens.keyboardType .~ .phonePad
        
        _ = phoneArrangeStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = phoneSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
    }
    
    override public func bindViewModel() {
        super.bindViewModel()
        
        print("BIND VIEW MODEL")
        
        self.titlePickedLabel.rac.text = self.viewModel.outputs.titleLabelText
        self.firstNameTextField.rac.text = self.viewModel.outputs.firstNameTextFieldText
        self.emailTextField.rac.text = self.viewModel.outputs.emailTextFieldText
        self.phoneTextField.rac.text = self.viewModel.outputs.phoneTextFieldText
 
        self.viewModel.outputs.goToTitleSalutationPicker
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                print("Picker Title passenger Tapped Observable")
                 self?.goToPickerTitlePassenger()
        }
        
        self.viewModel.outputs.dismissSalutationPicker
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.delegate?.canceledTitlePick()
        }
        
        self.viewModel.outputs.collectForCheckout
            .observe(on: UIScheduler())
            .observeValues { [weak self] guestForm in
//                print("WHO IS THE GUEST: \(guestForm)")
                self?.delegate?.getContactInfoParams(guestForm: guestForm)
        }
        
        self.viewModel.outputs.contactFormIsCompleted
            .observe(on: UIScheduler())
            .observeValues { [weak self] completed in
                self?.delegate?.getFinishedForm(completed)
        }
    }
    
    public func configureWith(value: Int) {
        
    }
    
    @objc fileprivate func goToPickerTitlePassenger() {
        let titles = ["Tuan", "Nyonya", "Nona"]
        let titlePickerVC = PassengerTitlePickerVC.instantiate(titles: titles, selectedTitle: "", delegate: self)
        titlePickerVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        titlePickerVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.delegate?.goToPassengerPickerVC(passengerPickerVC: titlePickerVC)
        print("Passenger Title Picker VC Delegate")
    }
    
    @objc fileprivate func titleSalutationButtonTapped() {
        print("Title Salutation Button Tapped")
        self.viewModel.inputs.titleSalutationButtonTapped()
    }
    
    @objc fileprivate func firstNameTextFieldChanged(_ textField: UITextField) {
        self.viewModel.inputs.firstNameTextFieldChange(textField.text)
    }
    
    @objc fileprivate func firstNameTextFieldDoneEditing() {
        self.viewModel.inputs.firstNameTextFieldDidEndEditing()
    }
    
    @objc fileprivate func lastNameTextFieldChanged(_ textField: UITextField) {
        self.viewModel.inputs.lastNameTextFieldChange(textField.text)
    }
    
    @objc fileprivate func lastNameTextFieldDoneEditing() {
        self.viewModel.inputs.lastNameTextFieldDidEndEditing()
    }
    
    @objc fileprivate func emailTextFieldChanged(_ textField: UITextField) {
        self.viewModel.inputs.emailTextFieldChange(textField.text)
    }
    
    @objc fileprivate func emailTextFieldDoneEditing() {
        self.viewModel.inputs.emailTextFieldDidEndEditing()

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
        self.viewModel.inputs.titleSalutationChanged(choseTitle)
    }
    
    func passengerTitlePickerVCCancelled(_ controller: PassengerTitlePickerVC) {
        self.viewModel.inputs.titleSalutationCanceled()
    }
    
    
}
