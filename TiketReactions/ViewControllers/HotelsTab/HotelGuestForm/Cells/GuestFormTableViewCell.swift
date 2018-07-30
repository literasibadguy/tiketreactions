//
//  GuestFormTableViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 24/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

protocol GuestFormTableCellDelegate: class {
    func goToPassengerPickerVC(passengerPickerVC: PassengerTitlePickerVC)
    func putAnotherParams(_ guestForm: CheckoutGuestParams)
    func getFinishedForm(_ completed: Bool)
    func canceledTitlePick()
}

internal final class GuestFormTableViewCell: UITableViewCell, ValueCell {
    
    typealias Value = CheckoutGuestParams
    
    weak var delegate: GuestFormTableCellDelegate?
    
    fileprivate let viewModel: AnotherGuestFormViewModelType = AnotherGuestFormViewModel()
    
    @IBOutlet weak var guestFormStackView: UIStackView!
    @IBOutlet fileprivate weak var guestDataTitleLabel: UILabel!
    
    @IBOutlet fileprivate weak var titleInputStackView: UIStackView!
    
    @IBOutlet fileprivate weak var titleInputLabel: UILabel!
    @IBOutlet fileprivate weak var titleContainerView: UIView!
    @IBOutlet fileprivate weak var titlePickButton: UIButton!
    @IBOutlet fileprivate weak var titleMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var titleSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var firstNameInputStackView: UIStackView!
    @IBOutlet fileprivate weak var firstNameInputLabel: UILabel!
    @IBOutlet fileprivate weak var firstNameTextField: UITextField!
    @IBOutlet fileprivate weak var firstNameSeparatorView: UIView!
    
    
    @IBOutlet fileprivate weak var lastNameInputStackView: UIStackView!
    @IBOutlet fileprivate weak var lastNameInputLabel: UILabel!
    @IBOutlet fileprivate weak var lastNameTextField: UITextField!
    @IBOutlet fileprivate weak var lastNameSeparatorView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.titlePickButton.addTarget(self, action: #selector(titleSalutationButtonTapped), for: .touchUpInside)
        
        self.firstNameTextField.addTarget(self, action: #selector(firstNameTextFieldChanged(_:)), for: [.editingDidEndOnExit, .editingChanged])
        self.firstNameTextField.addTarget(self, action: #selector(firstNameTextFieldDoneEditing), for: .editingDidEndOnExit)
        
        self.lastNameTextField.addTarget(self, action: #selector(lastNameTextFieldChanged(_:)), for: [.editingDidEndOnExit, .editingChanged])
        self.lastNameTextField.addTarget(self, action: #selector(lastNameTextFieldDoneEditing), for: .editingDidEndOnExit)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self.contentView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.guestFormStackView
            |> UIStackView.lens.layoutMargins %~~ { _, stackView in
                stackView.traitCollection.isRegularRegular
                    ? .init(topBottom: Styles.grid(6), leftRight: Styles.grid(16))
                    : .init(top: Styles.grid(2), left: Styles.grid(4), bottom: Styles.grid(3), right: Styles.grid(4))
            }
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = self.guestDataTitleLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
            |> UILabel.lens.text .~ Localizations.GuestContactFormTitle
        
        _ = titleInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = titleInputLabel
            |> UILabel.lens.text .~ Localizations.TitleFormData
        
        _ = titleContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = titleMenuStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
            |> UIStackView.lens.alignment .~ .center
            |> UIStackView.lens.isUserInteractionEnabled .~ false
        
        _ = titleSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = firstNameInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = firstNameInputLabel
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
            |> UITextField.lens.returnKeyType .~ .done
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.borderStyle .~ .roundedRect
            |> UITextField.lens.keyboardType .~ .default
        
        _ = lastNameSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.firstNameTextField.rac.becomeFirstResponder = self.viewModel.outputs.firstnameFirstResponder
        self.lastNameTextField.rac.becomeFirstResponder = self.viewModel.outputs.lastnameFirstResponder
        
        self.titleLabel.rac.text = self.viewModel.outputs.titleLabelText
        self.firstNameTextField.rac.text = self.viewModel.outputs.firstnameTextFieldText
        self.lastNameTextField.rac.text = self.viewModel.outputs.lastnameTextFieldText
        
        self.viewModel.outputs.goToTitleSalutationPicker
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.goToPickerTitlePassenger()
        }
        
        self.viewModel.outputs.dismissSalutationPicker
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.delegate?.canceledTitlePick()
        }
        
        self.viewModel.outputs.isGuestFormValid
            .observe(on: UIScheduler())
            .observeValues { [weak self] valid in
                self?.delegate?.getFinishedForm(valid)
        }
        
        self.viewModel.outputs.notifyGuestParam
            .observe(on: UIScheduler())
            .observeValues { [weak self] valid in
                self?.delegate?.putAnotherParams(valid)
        }
    }
    
    func configureWith(value: CheckoutGuestParams) {
        self.viewModel.inputs.configureWith(value)
    }
    
    @objc fileprivate func goToPickerTitlePassenger() {
        let titles = [Localizations.MrFormData, Localizations.MsFormData, Localizations.MsFormData]
        let titlePickerVC = PassengerTitlePickerVC.instantiate(titles: titles, selectedTitle: Localizations.MrFormData, delegate: self)
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
    
    @objc fileprivate func firstNameTextFieldDoneEditing(_ textField: UITextField) {
        self.viewModel.inputs.firstNameTextFieldDidEndEditing()
    }
    
    @objc fileprivate func lastNameTextFieldChanged(_ textField: UITextField) {
        self.viewModel.inputs.lastNameTextFieldChange(textField.text)
    }
    
    @objc fileprivate func lastNameTextFieldDoneEditing(_ textField: UITextField) {
        self.viewModel.inputs.lastNameTextFieldDidEndEditing()
        self.lastNameTextField.resignFirstResponder()
    }
}

extension GuestFormTableViewCell: PassengerTitlePickerVCDelegate {
    func passengerTitlePickerVC(_ controller: PassengerTitlePickerVC, choseTitle: String) {
        self.viewModel.inputs.titleSalutationChanged(choseTitle)
    }
    
    func passengerTitlePickerVCCancelled(_ controller: PassengerTitlePickerVC) {
        self.viewModel.inputs.titleSalutationCanceled()
    }
    
}

