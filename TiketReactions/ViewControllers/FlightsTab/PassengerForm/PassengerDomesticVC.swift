//
//  PassengerDomesticVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 26/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit

class PassengerDomesticVC: UIViewController {
    
    @IBOutlet fileprivate weak var domesticStackView: UIStackView!
    @IBOutlet fileprivate weak var titleInputStackView: UIStackView!
    @IBOutlet fileprivate weak var titleContainerView: UIView!
    @IBOutlet fileprivate weak var titleMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var titlePickButton: UIButton!
    @IBOutlet fileprivate weak var titleSeparatorView: UIView!
    @IBOutlet fileprivate weak var fullNameInputStackView: UIStackView!
    @IBOutlet fileprivate weak var fullNameTextField: UITextField!
    @IBOutlet fileprivate weak var fullNameSeparatorView: UIView!
    
    
    static func instantiate() -> PassengerDomesticVC {
        let vc = Storyboard.PassengerForm.instantiate(PassengerDomesticVC.self)
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        self.navigationItem.setLeftBarButton(cancelBarButton, animated: true)
        self.navigationController?.navigationBar.isTranslucent = false
        
//        self.titlePickButton.addTarget(self, action: #selector(goToTitlePicker), for: .touchUpInside)
//        self.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }

    override func bindStyles() {
        super.bindStyles()
        
        _ = self.domesticStackView
            |> UIStackView.lens.layoutMargins .~ .init(topBottom: Styles.grid(6), leftRight: Styles.grid(2))
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
            |> UIStackView.lens.spacing .~ Styles.grid(4)
        
        _ = self.titleInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(2)
        
        _ = self.titleMenuStackView
            |> UIStackView.lens.spacing .~ Styles.grid(2)
        
        _ = self.titleContainerView
            |> UIView.lens.layoutMargins .~ .init(top: Styles.grid(2), left: Styles.grid(2), bottom: Styles.grid(2), right: Styles.grid(4))
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.fullNameTextField
            |> UITextField.lens.borderStyle .~ .none
            |> UITextField.lens.font .~ UIFont.systemFont(ofSize: 24.0)
    }
    
    @objc fileprivate func goToTitlePicker() {
        print("TITLE PICKER SELECTED")
        let titles = ["Tuan", "Nyonya"]
        let vc = PassengerTitlePickerVC.instantiate(titles: titles, selectedTitle: titles.first!, delegate: self)
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc fileprivate func cancelButtonTapped() {
        print("CANCEL BUTTON TAPPED")
    }
}

extension PassengerDomesticVC: PassengerTitlePickerVCDelegate {
    func passengerTitlePickerVC(_ controller: PassengerTitlePickerVC, choseTitle: String) {
        print("TITLE HAVE CHANGED")
    }
    
    func passengerTitlePickerVCCancelled(_ controller: PassengerTitlePickerVC) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
