//
//  ContactInfoViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 26/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import PhoneNumberKit
import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

protocol ContactInfoViewCellDelegate: class {
    func goToPassengerPickerVC(passengerPickerVC: PassengerTitlePickerVC)
    func goToRegionalCodePhoneVC(phoneVC: PhoneCodeListVC)
    func getContactInfoParams(guestForm: CheckoutGuestParams)
    func getFinishedForm(_ completed: Bool)
    func canceledTitlePick()
}

protocol ContactFlightInfoViewCellDelegate: class {
    func goToPassengerPickerVC(passengerPickerVC: PassengerTitlePickerVC)
    func goToRegionalCodePhoneVC(phoneVC: PhoneCodeListVC)
    func getContactInfoParams(guestForm: GroupPassengersParam)
    func getFinishedForm(_ completed: Bool)
    func canceledTitlePick()
}

internal final class ContactInfoViewCell: UITableViewCell, ValueCell {
    
    public typealias Value = ContactFormState
    internal let viewModel: ContactInfoCellViewModelType = ContactInfoCellViewModel()
    
    weak var delegate: ContactInfoViewCellDelegate?
    weak var flightDelegate: ContactFlightInfoViewCellDelegate?
    
    @IBOutlet fileprivate weak var contactInfoStackView: UIStackView!
    @IBOutlet fileprivate weak var contactContainerView: UIView!
    @IBOutlet fileprivate weak var contactInfoLabel: UILabel!
    
    @IBOutlet fileprivate weak var titleInputStackView: UIStackView!
    @IBOutlet fileprivate weak var titleSeparatorView: UIView!
  //  @IBOutlet fileprivate weak var titleInputTextLabel: UILabel!
    @IBOutlet fileprivate weak var titleContainerView: UIView!
    @IBOutlet fileprivate weak var titleMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var titlePickedLabel: UILabel!
    
    @IBOutlet fileprivate weak var firstNameInputStackView: UIStackView!
    @IBOutlet fileprivate weak var firstNameSeparatorView: UIView!
 //   @IBOutlet fileprivate weak var firstNameInputTextLabel: UILabel!
    @IBOutlet fileprivate weak var firstNameTextField: UITextField!
    @IBOutlet fileprivate weak var titlePickButton: UIButton!
    
    @IBOutlet fileprivate weak var lastNameInputStackView: UIStackView!
 //   @IBOutlet fileprivate weak var lastNameInputLabel: UILabel!
    @IBOutlet fileprivate weak var lastNameTextField: UITextField!
    @IBOutlet fileprivate weak var lastNameSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var emailInputStackView: UIStackView!
 //   @IBOutlet fileprivate weak var emailInputTitleLabel: UILabel!
    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var emailSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var phoneInputStackView: UIStackView!
    @IBOutlet fileprivate weak var phoneCodeButton: UIButton!
    @IBOutlet fileprivate weak var phoneArrangeStackView: UIStackView!
    @IBOutlet fileprivate weak var countryCodePhoneStackView: UIStackView!
 //   @IBOutlet fileprivate weak var phoneInputTitleLabel: UILabel!
    @IBOutlet fileprivate weak var countryCodeInputTitleLabel: UILabel!
    @IBOutlet fileprivate weak var phoneTextField: PhoneNumberTextField!
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
        
        self.firstNameTextField.addTarget(self, action: #selector(firstNameTextFieldChanged(_:)), for: [.editingDidEndOnExit, .editingChanged])
        self.firstNameTextField.addTarget(self, action: #selector(firstNameTextFieldDoneEditing), for: .editingDidEndOnExit)
        
        self.lastNameTextField.addTarget(self, action: #selector(lastNameTextFieldChanged(_:)), for: [.editingDidEndOnExit, .editingChanged])
        self.lastNameTextField.addTarget(self, action: #selector(lastNameTextFieldDoneEditing), for: .editingDidEndOnExit)
        
        self.emailTextField.addTarget(self, action: #selector(emailTextFieldChanged(_:)), for: [.editingDidEndOnExit, .editingChanged])
        self.emailTextField.addTarget(self, action: #selector(emailTextFieldDoneEditing), for: .editingDidEndOnExit)
        
        self.phoneTextField.addTarget(self, action: #selector(phoneTextFieldChanged(_:)), for: [.editingDidEndOnExit, .editingChanged])
        self.phoneTextField.addTarget(self, action: #selector(phoneTextFieldDoneEditing), for: .editingDidEndOnExit)
        self.phoneTextField.inputAccessoryView = doneToolbar
        
        self.phoneCodeButton.addTarget(self, action: #selector(phoneRegionalCodeButtonTapped), for: .touchUpInside)
    }

    override public func bindStyles() {
        super.bindStyles()
        
        
        _ = self.contentView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.contactContainerView
            |> UIView.lens.layer.borderColor .~ UIColor.tk_official_green.cgColor
            |> UIView.lens.layer.borderWidth .~ 1.5
        
        _ = self.contactInfoStackView
            |> UIStackView.lens.layoutMargins %~~ { _, stackView in
                stackView.traitCollection.isRegularRegular
                    ? .init(topBottom: Styles.grid(4), leftRight: Styles.grid(16))
                    : .init(top: Styles.grid(2), left: Styles.grid(4), bottom: Styles.grid(6), right: Styles.grid(4))
            }
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
        
        /*
        _ = titleInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = titleInputTextLabel
            |> UILabel.lens.text .~ Localizations.TitleFormData
        */
        
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
        
        /*

        _ = firstNameInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = firstNameInputTextLabel
            |> UILabel.lens.text .~ Localizations.FirstnameFormData
        */
        
        _ = firstNameTextField
            |> UITextField.lens.returnKeyType .~ .next
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.keyboardType .~ .default
            |> UITextField.lens.placeholder .~ Localizations.FirstnameFormData
            |> UITextField.lens.autocapitalizationType .~ .sentences
        
        _ = firstNameSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        /*
        _ = lastNameInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = lastNameInputLabel
            |> UILabel.lens.text .~ Localizations.LastnameFormData
        */
        
        _ = lastNameTextField
            |> UITextField.lens.returnKeyType .~ .next
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.keyboardType .~ .default
            |> UITextField.lens.placeholder .~ Localizations.LastnameFormData
            |> UITextField.lens.autocapitalizationType .~ .sentences
        
        _ = lastNameSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        /*
        _ = emailInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = emailInputTitleLabel
            |> UILabel.lens.text .~ Localizations.EmailFormData
        */
        
        _ = emailTextField
            |> UITextField.lens.returnKeyType .~ .next
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.keyboardType .~ .default
            |> UITextField.lens.placeholder .~ Localizations.EmailFormData
        
        _ = emailSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = countryCodePhoneStackView
            |> UIStackView.lens.spacing .~ 8
        
        /*
        _ = phoneInputTitleLabel
            |> UILabel.lens.text .~ Localizations.PhonenumberFormData
        */
        
        _ = countryCodeInputTitleLabel
            |> UILabel.lens.text .~ Localizations.CountrycodeTitle
        
        _ = phoneTextField
            |> UITextField.lens.returnKeyType .~ .done
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.keyboardType .~ .phonePad
            |> UITextField.lens.placeholder .~ Localizations.PhonetextfieldPlaceholder
        
        _ = self.phoneCodeButton
            |> UIButton.lens.titleColor(forState: .normal) .~ .tk_official_green
        
        self.phoneTextField.isPartialFormatterEnabled = false
        
        _ = phoneArrangeStackView
            |> UIStackView.lens.spacing .~ Styles.grid(2)
        
        _ = phoneSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
    }
    
    override public func bindViewModel() {
        super.bindViewModel()
        
        print("BIND VIEW MODEL")
        
        self.contactInfoLabel.rac.text = self.viewModel.outputs.statusFormText
        self.firstNameTextField.rac.becomeFirstResponder = self.viewModel.outputs.firstNameFirstResponder
        self.lastNameTextField.rac.becomeFirstResponder = self.viewModel.outputs.lastNameFirstResponder
        self.emailTextField.rac.becomeFirstResponder = self.viewModel.outputs.emailFirstResponder
        self.phoneTextField.rac.becomeFirstResponder = self.viewModel.outputs.phoneFirstResponder
        
        self.titlePickedLabel.rac.text = self.viewModel.outputs.titleLabelText
        self.firstNameTextField.rac.text = self.viewModel.outputs.firstNameTextFieldText
        self.emailTextField.rac.text = self.viewModel.outputs.emailTextFieldText
        self.phoneTextField.rac.text = self.viewModel.outputs.phoneTextFieldText
        self.phoneCodeButton.rac.title = self.viewModel.outputs.phoneCodeLabelText
        
        self.viewModel.outputs.titleLabelText
            .observe(on: UIScheduler())
            .observeValues { [weak self] picked in
                guard let _self = self else { return }
                _ = _self.titlePickedLabel
                    |> UILabel.lens.text .~ picked
                    |> UILabel.lens.textColor .~ .black
        }
 
        self.viewModel.outputs.goToTitleSalutationPicker
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                print("Picker Title passenger Tapped Observable")
                 self?.goToPickerTitlePassenger()
        }
        
        self.viewModel.outputs.goToPhoneCodePicker
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.goToRegionalCode()
        }
        
        self.viewModel.outputs.dismissSalutationPicker
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.delegate?.canceledTitlePick()
                self?.flightDelegate?.canceledTitlePick()
        }
        
        self.viewModel.outputs.collectForContactFlight
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] contactForm in
                guard let _self = self else { return }
                _self.flightDelegate?.getContactInfoParams(guestForm: contactForm)
        }
        
        self.viewModel.outputs.collectForCheckout
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] guestForm in
                guard let _self = self else { return }
                _self.delegate?.getContactInfoParams(guestForm: guestForm)
        }
        
        self.viewModel.outputs.contactFormIsCompleted
            .observe(on: UIScheduler())
            .observeValues { [weak self] completed in
                self?.delegate?.getFinishedForm(completed)
                self?.flightDelegate?.getFinishedForm(completed)
        }
    }
    
    public func configureWith(value: ContactFormState) {
        self.viewModel.inputs.contactCellDidLoad(value)
    }
    
    fileprivate func goToPickerTitlePassenger() {
        let titles = [Localizations.MrFormData, Localizations.MrsFormData, Localizations.MsFormData]
        let titlePickerVC = PassengerTitlePickerVC.instantiate(titles: titles, selectedTitle: "", delegate: self)
        titlePickerVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        titlePickerVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.delegate?.goToPassengerPickerVC(passengerPickerVC: titlePickerVC)
        self.flightDelegate?.goToPassengerPickerVC(passengerPickerVC: titlePickerVC)
        print("Passenger Title Picker VC Delegate")
    }
    
    fileprivate func goToRegionalCode() {
        let phoneListVC = PhoneCodeListVC.instantiate()
        phoneListVC.delegate = self
        self.delegate?.goToRegionalCodePhoneVC(phoneVC: phoneListVC)
        self.flightDelegate?.goToRegionalCodePhoneVC(phoneVC: phoneListVC)
    }
    
    @objc fileprivate func titleSalutationButtonTapped() {
        print("Title Salutation Button Tapped")
        self.viewModel.inputs.titleSalutationButtonTapped()
    }
    
    @objc fileprivate func phoneRegionalCodeButtonTapped() {
        self.viewModel.inputs.phoneCodeButtonTapped()
    }
    
    @objc fileprivate func firstNameTextFieldChanged(_ textField: UITextField) {
        self.viewModel.inputs.firstNameTextFieldChange(textField.text)
    }
    
    @objc fileprivate func firstNameTextFieldDoneEditing(_ textField: UITextField) {
        self.viewModel.inputs.firstNameTextFieldDidEndEditing()
    }
    
    @objc fileprivate func lastNameTextFieldChanged(_ textField: UITextField) {
        self.viewModel.inputs.lastNameTextFieldChange(textField.text)
    }
    
    @objc fileprivate func lastNameTextFieldDoneEditing(_ textField: UITextField) {
        self.viewModel.inputs.lastNameTextFieldDidEndEditing()
    }
    
    @objc fileprivate func emailTextFieldChanged(_ textField: UITextField) {
        self.viewModel.inputs.emailTextFieldChange(textField.text)
    }
    
    @objc fileprivate func emailTextFieldDoneEditing(_ textField: UITextField) {
        self.viewModel.inputs.emailTextFieldDidEndEditing()

    }
    
    @objc fileprivate func phoneTextFieldChanged(_ textField: PhoneNumberTextField) {
        self.viewModel.inputs.phoneTextFieldChange(textField.text?.description, code: textField.defaultRegion)
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


extension ContactInfoViewCell: PhoneCodeListDelegate {
    func selectedCountryCode(_ listVC: PhoneCodeListVC, country: Country) {
        self.viewModel.inputs.phoneCodeChanged(country)
    }
}
