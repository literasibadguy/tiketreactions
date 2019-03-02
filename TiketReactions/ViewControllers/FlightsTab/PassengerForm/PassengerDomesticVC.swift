//
//  PassengerDomesticVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 26/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import UIKit
import TiketKitModels
 
public protocol PassengerDomesticDelegate: class {
    func submitAdultDomesticFormTapped(_ vc: PassengerDomesticVC, adult: AdultPassengerParam)
//    func submitChildDomesticFormTapped(_ vc: PassengerDomesticVC, child: ChildPassengerParam)
//    func submitInfantDomesticFormTapped(_ vc: PassengerDomesticVC, infant: InfantPassengerParam)
}

public final class PassengerDomesticVC: UIViewController {
    
    fileprivate let viewModel: PassengerDomesticViewModelType = PassengerDomesticViewModel()
    
    @IBOutlet fileprivate weak var domesticStackView: UIStackView!
    @IBOutlet fileprivate weak var titleInputStackView: UIStackView!
    @IBOutlet fileprivate weak var titleContainerView: UIView!
    @IBOutlet fileprivate weak var titleMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var titlePickButton: UIButton!
    @IBOutlet fileprivate weak var titleSeparatorView: UIView!
    @IBOutlet fileprivate weak var titlePickedLabel: UILabel!
    
    @IBOutlet fileprivate weak var firstNameInputStackView: UIStackView!
    @IBOutlet fileprivate weak var firstNameInputLabel: UILabel!
    @IBOutlet fileprivate weak var firstNameTextField: UITextField!
    @IBOutlet fileprivate weak var firstNameSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var lastNameInputStackView: UIStackView!
    @IBOutlet fileprivate weak var lastNameInputLabel: UILabel!
    @IBOutlet fileprivate weak var lastNameTextField: UITextField!
    @IBOutlet fileprivate weak var lastNameSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var collectDomesticButton: UIButton!
    
    internal weak var delegate: PassengerDomesticDelegate?
    
    static func instantiate() -> PassengerDomesticVC {
        let vc = Storyboard.PassengerForm.instantiate(PassengerDomesticVC.self)
        return vc
    }
    
    static func instantiate(manager: PassengerListManager) {
        
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneToolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: Localizations.DonebuttonTitle, style: .done, target: self, action: #selector(lastNameTextFieldDoneEditing))
        doneBtn.tintColor = .tk_official_green
        doneToolbar.setItems([flexSpace, doneBtn], animated: false)
        doneToolbar.sizeToFit()

        // Do any additional setup after loading the view.
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        self.navigationItem.setLeftBarButton(cancelBarButton, animated: true)
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.titlePickButton.addTarget(self, action: #selector(titleSalutationButtonTapped), for: .touchUpInside)
        
        self.firstNameTextField.addTarget(self, action: #selector(firstNameTextFieldChanged(_:)), for: [.editingDidEndOnExit, .editingChanged])
        self.firstNameTextField.addTarget(self, action: #selector(firstNameTextFieldDoneEditing), for: .editingDidEndOnExit)
        
        self.lastNameTextField.addTarget(self, action: #selector(lastNameTextFieldChanged(_:)), for: [.editingDidEndOnExit, .editingChanged])
        self.lastNameTextField.addTarget(self, action: #selector(lastNameTextFieldDoneEditing), for: .editingDidEndOnExit)
        
        self.collectDomesticButton.addTarget(self, action: #selector(submitDomesticButtonTapped), for: .touchUpInside)
    }

    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.domesticStackView
            |> UIStackView.lens.layoutMargins %~~ { _, stackView in
                stackView.traitCollection.isRegularRegular
                    ? .init(topBottom: Styles.grid(6), leftRight: Styles.grid(16))
                    : .init(top: Styles.grid(2), left: Styles.grid(4), bottom: Styles.grid(3), right: Styles.grid(4))
            }
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = self.titlePickedLabel
            |> UILabel.lens.text .~ Localizations.TitleFormData
            |> UILabel.lens.textColor .~ .darkGray
        
        _ = self.titleInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        
        _ = self.titleMenuStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
            |> UIStackView.lens.alignment .~ .center
            |> UIStackView.lens.isUserInteractionEnabled .~ false
        
        _ = self.titleContainerView
            |> UIView.lens.layoutMargins .~ .init(top: Styles.grid(2), left: Styles.grid(2), bottom: Styles.grid(2), right: Styles.grid(4))
            |> UIView.lens.backgroundColor .~ .white
        
        
        _ = self.titleSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.firstNameInputLabel
            |> UILabel.lens.text .~ Localizations.FirstnameFormData
        
        _ = self.firstNameTextField
            |> UITextField.lens.returnKeyType .~ .next
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.borderStyle .~ .none
            |> UITextField.lens.keyboardType .~ .default
        
        _ = self.firstNameSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.lastNameInputLabel
            |> UILabel.lens.text .~ Localizations.LastnameFormData
        
        _ = self.lastNameTextField
            |> UITextField.lens.returnKeyType .~ .next
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.borderStyle .~ .none
            |> UITextField.lens.keyboardType .~ .default
        
        _ = self.lastNameSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.collectDomesticButton
            |> UIButton.lens.backgroundColor .~ .tk_official_green
            |> UIButton.lens.titleColor(forState: .normal) .~ .white
            |> UIButton.lens.isHidden .~ true
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.firstNameTextField.rac.becomeFirstResponder = self.viewModel.outputs.firstNameFirstResponder
        self.lastNameTextField.rac.becomeFirstResponder = self.viewModel.outputs.lastNameFirstResponder
        
        self.titlePickedLabel.rac.text = self.viewModel.outputs.titleLabelText
        self.firstNameTextField.rac.text = self.viewModel.outputs.firstNameTextFieldText
        self.lastNameTextField.rac.text = self.viewModel.outputs.lastNameTextFieldText
        
        self.collectDomesticButton.rac.hidden = self.viewModel.outputs.domesticFormIsCompleted.negate()
        
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
        
        self.viewModel.outputs.dismissDomesticForm
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc fileprivate func goToTitlePicker() {
        print("TITLE PICKER SELECTED")
        let titles = ["Tuan", "Nyonya"]
        let vc = PassengerTitlePickerVC.instantiate(titles: titles, selectedTitle: titles.first!, delegate: self)
        self.present(vc, animated: true, completion: nil)
    }
    
    fileprivate func goToPickerTitlePassenger() {
        let titles = ["Tuan", "Nyonya", "Nona"]
        let titlePickerVC = PassengerTitlePickerVC.instantiate(titles: titles, selectedTitle: "", delegate: self)
        titlePickerVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        titlePickerVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(titlePickerVC, animated: true, completion: nil)
        print("Passenger Title Picker VC Delegate")
    }

    
    @objc fileprivate func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func submitDomesticButtonTapped() {
        self.viewModel.inputs.submitDomesticFormButtonTapped()
    }
    
    @objc fileprivate func titleSalutationButtonTapped() {
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
    }
}

extension PassengerDomesticVC: PassengerTitlePickerVCDelegate {
    func passengerTitlePickerVC(_ controller: PassengerTitlePickerVC, choseTitle: String) {
        self.viewModel.inputs.titleSalutationChanged(choseTitle)
    }
    
    func passengerTitlePickerVCCancelled(_ controller: PassengerTitlePickerVC) {
        self.viewModel.inputs.titleSalutationCanceled()
    }
}
