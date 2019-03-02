//
//  PassengerDetailVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 19/01/19.
//  Copyright © 2019 Firas Rafislam. All rights reserved.
//

import UIKit
import PhoneNumberKit
import Prelude
import ReactiveSwift
import TiketKitModels

public protocol FirstPassengerDetailDelegate: class {
    func submitContactPassenger(param: GroupPassengersParam)
}

public protocol AdultPassengerDetailDelegate: class {
    func submitAdultPassenger(_ detail: PassengerDetailVC, format: FormatDataForm, passenger: AdultPassengerParam)
}

public protocol ChildPassengerDetailDelegate: class {
    func submitChildPassenger(param: ChildPassengerParam)
}

public final class PassengerDetailVC: UIViewController {
    
    fileprivate let viewModel: PassengerDetailViewModelType = PassengerDetailViewModel()
    
    @IBOutlet fileprivate weak var cardView: UIView!
    @IBOutlet fileprivate weak var rootStackView: UIStackView!
    
    @IBOutlet fileprivate weak var passengerFormStackView: UIStackView!
    @IBOutlet fileprivate weak var passengerLabel: UILabel!
    
    // Title Pick
    @IBOutlet fileprivate weak var titleInputStackView: UIStackView!
    @IBOutlet fileprivate weak var titleContainerView: UIView!
    @IBOutlet fileprivate weak var titlePickButton: UIButton!
    @IBOutlet fileprivate weak var titleMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var titleValueLabel: UILabel!
    @IBOutlet fileprivate weak var titleSeparatorView: UIView!
    
    // First Name
    @IBOutlet fileprivate weak var firstNameInputStackView: UIStackView!
    @IBOutlet fileprivate weak var firstNameTextField: UITextField!
    @IBOutlet fileprivate weak var firstNameSeparatorView: UIView!
    
    // Last Name
    @IBOutlet fileprivate weak var lastNameInputStackView: UIStackView!
    @IBOutlet fileprivate weak var lastNameTextField: UITextField!
    @IBOutlet fileprivate weak var lastNameSeparatorView: UIView!
    
    // Birthdate
    @IBOutlet fileprivate weak var birthdateInputStackView: UIStackView!
    @IBOutlet fileprivate weak var birthdateContainerView: UIView!
    @IBOutlet fileprivate weak var birthdatePickButton: UIButton!
    @IBOutlet fileprivate weak var birthdateMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var birthdateValueLabel: UILabel!
    @IBOutlet fileprivate weak var birthdateSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var nationalityInputStackView: UIStackView!
    @IBOutlet fileprivate weak var nationalityContainerView: UIView!
    @IBOutlet fileprivate weak var nationalityPickedButton: UIButton!
    @IBOutlet fileprivate weak var nationalityMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var nationalityValueLabel: UILabel!
    @IBOutlet fileprivate weak var nationalitySeparatorView: UIView!
    
    @IBOutlet fileprivate weak var rootFirstSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var contactStackView: UIStackView!
    @IBOutlet fileprivate weak var contactInfoLabel: UILabel!
    
    @IBOutlet fileprivate weak var emailInputStackView: UIStackView!
    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var emailSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var phoneInputStackView: UIStackView!
    
    @IBOutlet fileprivate weak var countryPhoneNumberInputLabel: UIStackView!
    
    @IBOutlet fileprivate weak var phoneRootStackView: UIStackView!
    
    @IBOutlet fileprivate weak var phoneCodeButton: UIButton!
    @IBOutlet fileprivate weak var phoneTextField: PhoneNumberTextField!
    
    @IBOutlet fileprivate weak var submitButtonView: UIView!
    @IBOutlet fileprivate weak var saveButton: UIButton!
    
    weak var delegate: FirstPassengerDetailDelegate?
    weak var adultDelegate: AdultPassengerDetailDelegate?
    
    public static func configureWith(_ format: FormatDataForm, state: PassengerFormState) -> PassengerDetailVC {
        let vc = Storyboard.PassengerForm.instantiate(PassengerDetailVC.self)
        vc.viewModel.inputs.configureStatePassenger(format, state: state)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.titlePickButton.addTarget(self, action: #selector(titleButtonTapped), for: .touchUpInside)
        self.phoneCodeButton.addTarget(self, action: #selector(countryCodeButtonTapped), for: .touchUpInside)
        self.birthdatePickButton.addTarget(self, action: #selector(birthdateButtonTapped), for: .touchUpInside)
        self.nationalityPickedButton.addTarget(self, action: #selector(nationalityButtonTapped), for: .touchUpInside)
        
        self.firstNameTextField.addTarget(self, action: #selector(firstNameTextFieldChanged(_:)), for: [.editingDidEndOnExit, .editingChanged])
        self.firstNameTextField.addTarget(self, action: #selector(firstNameTextFieldDoneEditing), for: .editingDidEndOnExit)
        
        self.lastNameTextField.addTarget(self, action: #selector(lastNameTextFieldChanged(_:)), for: [.editingDidEndOnExit, .editingChanged])
        self.lastNameTextField.addTarget(self, action: #selector(lastNameTextFieldDoneEditing), for: .editingDidEndOnExit)
        
        self.emailTextField.addTarget(self, action: #selector(emailTextFieldChanged(_:)), for: [.editingDidEndOnExit, .editingChanged])
        self.emailTextField.addTarget(self, action: #selector(emailTextFieldDoneEditing), for: .editingDidEndOnExit)
        
        self.phoneTextField.addTarget(self, action: #selector(phoneTextFieldChanged(_:)), for: [.editingDidEndOnExit, .editingChanged])
        self.phoneTextField.addTarget(self, action: #selector(phoneTextFieldDoneEditing), for: .editingDidEndOnExit)
        
        self.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

        
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.cardView
            |> UIView.lens.layer.shouldRasterize .~ true
            |> UIView.lens.backgroundColor .~ .clear
        
        _ = self.rootStackView
            |> UIStackView.lens.layoutMargins .~ .init(topBottom: Styles.grid(4) + Styles.grid(2),
                                                       leftRight: Styles.grid(2) + 1)
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
            |> UIStackView.lens.spacing .~ Styles.grid(4)
        
        
        _ = self.passengerFormStackView
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
        
        _ = self.contactStackView
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
        
        // Title
        _ = self.titleMenuStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
            |> UIStackView.lens.alignment .~ .center
            |> UIStackView.lens.isUserInteractionEnabled .~ false
        
        _ = self.titleContainerView
            |> UIView.lens.layoutMargins .~ .init(top: Styles.grid(2), left: Styles.grid(2), bottom: Styles.grid(2), right: Styles.grid(4))
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.titleSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.titleValueLabel
            |> UILabel.lens.text .~ Localizations.TitleFormData
            |> UILabel.lens.textColor .~ .darkGray
        
        // Birthdate
        _ = self.birthdateMenuStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
            |> UIStackView.lens.alignment .~ .center
            |> UIStackView.lens.isUserInteractionEnabled .~ false
        
        _ = self.birthdateContainerView
            |> UIView.lens.layoutMargins .~ .init(top: Styles.grid(2), left: Styles.grid(2), bottom: Styles.grid(2), right: Styles.grid(4))
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.birthdateSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.birthdateValueLabel
            |> UILabel.lens.text .~ "Tanggal lahir"
            |> UILabel.lens.textColor .~ .darkGray
        
        // Nationality
        _ = self.nationalityMenuStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
            |> UIStackView.lens.alignment .~ .center
            |> UIStackView.lens.isUserInteractionEnabled .~ false
        
        _ = self.nationalityContainerView
            |> UIView.lens.layoutMargins .~ .init(top: Styles.grid(2), left: Styles.grid(2), bottom: Styles.grid(2), right: Styles.grid(4))
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.nationalitySeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.nationalityValueLabel
            |> UILabel.lens.text .~ "Kewarganegaraan"
            |> UILabel.lens.textColor .~ .darkGray
        
        _ = self.firstNameTextField
            |> UITextField.lens.returnKeyType .~ .next
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.keyboardType .~ .default
            |> UITextField.lens.placeholder .~ Localizations.FirstnameFormData
            |> UITextField.lens.autocapitalizationType .~ .sentences
        
        _ = self.firstNameSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.lastNameTextField
            |> UITextField.lens.returnKeyType .~ .next
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.keyboardType .~ .default
            |> UITextField.lens.placeholder .~ Localizations.LastnameFormData
            |> UITextField.lens.autocapitalizationType .~ .sentences
        
        _ = self.lastNameSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.emailTextField
            |> UITextField.lens.returnKeyType .~ .next
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.keyboardType .~ .default
            |> UITextField.lens.placeholder .~ Localizations.EmailFormData
        
        _ = emailSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.phoneTextField
            |> UITextField.lens.returnKeyType .~ .done
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.keyboardType .~ .phonePad
            |> UITextField.lens.placeholder .~ Localizations.PhonetextfieldPlaceholder
        
        _ = self.phoneRootStackView
            |> UIStackView.lens.spacing .~ 2
        
        _ = self.saveButton
            |> UIButton.lens.backgroundColor .~ .tk_official_green
            |> UIButton.lens.titleColor(forState: .normal) .~ .white
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.titleValueLabel.rac.text = self.viewModel.outputs.titleLabelText
        self.firstNameTextField.rac.text = self.viewModel.outputs.firstNameTextFieldText
        self.lastNameTextField.rac.text = self.viewModel.outputs.lastNameTextFieldText
        self.emailTextField.rac.text = self.viewModel.outputs.emailTextFieldText
        self.phoneTextField.rac.text = self.viewModel.outputs.phoneTextFieldText
        self.birthdateValueLabel.rac.text = self.viewModel.outputs.birthdateLabelText
        self.nationalityValueLabel.rac.text = self.viewModel.outputs.nationalityLabelText
        
        self.viewModel.outputs.goToTitleSalutationPicker
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.goToPickerTitlePassenger()
        }
        
        self.viewModel.outputs.dismissSalutationPicker
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.dismiss(animated: true, completion: nil)
        }
        
        self.viewModel.outputs.goToBirthdatePicker
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] state in
                self?.goToBirthdatePassenger(state)
        }
        
        self.viewModel.outputs.goToNationalityPicker
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.goToNationalityPassenger()
        }
        
        self.viewModel.outputs.hideContactForm
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                guard let _self = self else { return }
                _ = _self.contactStackView
                    |> UIStackView.lens.isHidden .~ true
                
                _ = _self.contactInfoLabel
                    |> UILabel.lens.isHidden .~ true
        }
        
        self.viewModel.outputs.saveAdultDetail
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] (passengerParam, format) in
                guard let _self = self else { return }
                _self.adultDelegate?.submitAdultPassenger(_self, format: format, passenger: passengerParam)
                _self.navigationController?.popViewController(animated: true)
        }
    }
    
    fileprivate func goToPickerTitlePassenger() {
        let titles = [Localizations.MrFormData, Localizations.MsFormData, Localizations.MsFormData]
        let titlePickerVC = PassengerTitlePickerVC.instantiate(titles: titles, selectedTitle: "", delegate: self)
        titlePickerVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        titlePickerVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
//        self.delegate?.goToPassengerPickerVC(passengerPickerVC: titlePickerVC)
        print("Passenger Title Picker VC Delegate")
        self.present(titlePickerVC, animated: true, completion: nil)
    }
    
    fileprivate func goToBirthdatePassenger(_ status: PassengerFormState) {
        let birthdatePickerVC = PassengerBirthdatePickerVC.configureBirthdate(self, state: status)
        birthdatePickerVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        birthdatePickerVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(birthdatePickerVC, animated: true, completion: nil)
    }
    
    fileprivate func goToNationalityPassenger() {
        let nationalPickerVC = NationalityPickVC.configureWith()
        nationalPickerVC.delegate = self
        self.present(nationalPickerVC, animated: true, completion: nil)
    }
    
    @objc fileprivate func saveButtonTapped() {
        self.viewModel.inputs.submitButtonTapped()
    }
    
    @objc fileprivate func titleButtonTapped() {
        self.viewModel.inputs.titleSalutationButtonTapped()
    }
    
    @objc fileprivate func countryCodeButtonTapped() {
        self.viewModel.inputs.phoneCodeButtonTapped()
    }
    
    @objc fileprivate func birthdateButtonTapped() {
        self.viewModel.inputs.birthdateButtonTapped()
    }
    
    @objc fileprivate func nationalityButtonTapped() {
        self.viewModel.inputs.nationalityButtonTapped()
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

extension PassengerDetailVC: PassengerTitlePickerVCDelegate {
    func passengerTitlePickerVC(_ controller: PassengerTitlePickerVC, choseTitle: String) {
        self.viewModel.inputs.titleSalutationChanged(choseTitle)
    }
    
    func passengerTitlePickerVCCancelled(_ controller: PassengerTitlePickerVC) {
        self.viewModel.inputs.titleSalutationCanceled()
    }
}

extension PassengerDetailVC: PassengerBirthdatePickerDelegate {
    func dateHaveSelected(_ date: Date) {
        self.viewModel.inputs.birthdateChanged(date)
    }
}

extension PassengerDetailVC: NationalityPickDelegate {
    public func changedCountry(_ list: NationalityPickVC, country: CountryListEnvelope.ListCountry) {
        self.viewModel.inputs.nationalityChanged(country.countryName)
    }
}
