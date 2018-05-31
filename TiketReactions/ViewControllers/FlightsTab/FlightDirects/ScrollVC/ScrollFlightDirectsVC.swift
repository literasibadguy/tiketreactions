//
//  ScrollFlightDirectsVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 01/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

public final class ScrollFlightDirectsVC: UIViewController {
    
    // Contact Stack View
    @IBOutlet fileprivate weak var contactFormStackView: UIStackView!
    @IBOutlet fileprivate weak var salutationInputStackView: UIStackView!
    @IBOutlet fileprivate weak var fullNameInputStackView: UIStackView!
    @IBOutlet fileprivate weak var emailInputStackView: UIStackView!
    @IBOutlet fileprivate weak var phoneInputStackView: UIStackView!
    @IBOutlet fileprivate weak var phoneArrangeStackView: UIStackView!
    
    @IBOutlet fileprivate weak var salutationSeparatorView: UIView!
    @IBOutlet fileprivate weak var fullnameSeparatorView: UIView!
    @IBOutlet fileprivate weak var emailSeparatorView: UIView!
    @IBOutlet fileprivate weak var phoneSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var fullnameTextField: UITextField!
    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var phoneTextField: UITextField!
    
    
    fileprivate let viewModel: FlightDirectsContentViewModelType = FlightDirectsContentViewModel()
    
    static func configureWith(flight: Flight) -> ScrollFlightDirectsVC {
        let vc = Storyboard.FlightDirects.instantiate(ScrollFlightDirectsVC.self)
        vc.viewModel.inputs.configureWith(flight: flight)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        // CONTACT STACK VIEW
        
        _ = self.contactFormStackView
            |> UIStackView.lens.layoutMargins %~~ { _, stackView in
                stackView.traitCollection.isRegularRegular
                    ? .init(topBottom: Styles.grid(6), leftRight: Styles.grid(16))
                    : .init(top: Styles.grid(4), left: Styles.grid(4), bottom: Styles.grid(3), right: Styles.grid(4))
            }
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
            |> UIStackView.lens.spacing .~ Styles.grid(4)
        
        _ = self.salutationInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(2)
        
        _ = self.fullNameInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(2)
        
        _ = self.emailInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(2)
        
        _ = self.phoneInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(2)
        
        _ = self.phoneArrangeStackView
            |> UIStackView.lens.spacing .~ Styles.grid(2)
        
        // CONTACT SEPARATOR VIEW
        
        _ = self.salutationSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.fullnameSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.emailSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.phoneSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        // CONTACT TEXT FIELD
        
        _ = self.fullnameTextField
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.borderStyle .~ .roundedRect
            |> UITextField.lens.keyboardType .~ .default
        
        _ = self.emailTextField
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.borderStyle .~ .roundedRect
            |> UITextField.lens.keyboardType .~ .emailAddress
        
        _ = self.phoneTextField
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.borderStyle .~ .roundedRect
            |> UITextField.lens.keyboardType .~ .phonePad
    }
}
