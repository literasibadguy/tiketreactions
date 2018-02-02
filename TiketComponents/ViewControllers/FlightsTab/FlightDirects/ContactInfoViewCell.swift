//
//  ContactInfoViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 26/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit

protocol ContactInfoViewCellDelegate: class {
    func goToPassengerPickerVC(passengerPickerVC: PassengerTitlePickerVC)
}

class ContactInfoViewCell: UITableViewCell, ValueCell {
    
    typealias Value = String
    
    weak var delegate: ContactInfoViewCellDelegate?
    
    @IBOutlet fileprivate weak var contactInfoStackView: UIStackView!
    @IBOutlet fileprivate weak var contactInfoLabel: UILabel!
    
    @IBOutlet fileprivate weak var titleInputStackView: UIStackView!
    @IBOutlet fileprivate weak var titleSeparatorView: UIView!
    @IBOutlet fileprivate weak var titleInputTextLabel: UILabel!
    @IBOutlet fileprivate weak var titleContainerView: UIView!
    @IBOutlet fileprivate weak var titlePickButton: UIButton!
    @IBOutlet fileprivate weak var titleMenuStackView: UIStackView!
    
    
    @IBOutlet fileprivate weak var fullNameInputStackView: UIStackView!
    @IBOutlet fileprivate weak var fullNameSeparatorView: UIView!
    @IBOutlet fileprivate weak var fullNameInputTextLabel: UILabel!
    @IBOutlet fileprivate weak var fullNameTextField: UITextField!
    
    @IBOutlet fileprivate weak var emailInputStackView: UIStackView!
    
    @IBOutlet fileprivate weak var emailInputTitleLabel: UILabel!
    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var emailSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var phoneInputStackView: UIStackView!
    @IBOutlet fileprivate weak var phoneInputTitleLabel: UILabel!
    @IBOutlet fileprivate weak var phoneTextField: UITextField!
    @IBOutlet fileprivate weak var phoneSeparatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.titlePickButton.addTarget(self, action: #selector(goToPickerTitlePassenger), for: .touchUpInside)
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
        
        _ = titleContainerView
            |> UIView.lens.layoutMargins .~ .init(top: Styles.grid(2), left: Styles.grid(2), bottom: Styles.grid(2), right: Styles.grid(4))
            |> UIView.lens.backgroundColor .~ .white
        
        _ = fullNameInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(2)
        
        _ = fullNameTextField
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.borderStyle .~ .roundedRect
            |> UITextField.lens.keyboardType .~ .namePhonePad
        
        _ = emailInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(2)
        
        _ = emailTextField
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.borderStyle .~ .roundedRect
            |> UITextField.lens.keyboardType .~ .emailAddress
        
        _ = phoneInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(2)
        
        _ = phoneTextField
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.borderStyle .~ .roundedRect
            |> UITextField.lens.keyboardType .~ .phonePad
        
    }
    
    func configureWith(value: String) {
        
    }
    
    @objc fileprivate func goToPickerTitlePassenger() {
        let titlePickerVC = PassengerTitlePickerVC.instantiate(delegate: self)
        self.delegate?.goToPassengerPickerVC(passengerPickerVC: titlePickerVC)
        print("Passenger Title Picker VC Delegate")
    }
}

extension ContactInfoViewCell: PassengerTitlePickerVCDelegate {
    func passengerTitlePickerVC(_ controller: PassengerTitlePickerVC, choseTitle: String) {
        
    }
    
    func passengerTitlePickerVCCancelled(_ controller: PassengerTitlePickerVC) {
        
    }
    
    
}
