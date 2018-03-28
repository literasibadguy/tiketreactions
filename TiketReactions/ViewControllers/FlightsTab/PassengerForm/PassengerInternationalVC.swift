//
//  PassengerInternationalVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 26/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import UIKit

class PassengerInternationalVC: UIViewController {
    
    @IBOutlet fileprivate weak var interScrollView: UIScrollView!
    
    @IBOutlet fileprivate weak var internationalStackView: UIStackView!
    
    @IBOutlet fileprivate weak var cancelButton: UIButton!
    @IBOutlet fileprivate weak var passengerLabel: UILabel!
    
    // TITLE INPUT STACK VIEW
    @IBOutlet fileprivate weak var titleInputStackView: UIStackView!
    @IBOutlet fileprivate weak var titleInputTextLabel: UILabel!
    @IBOutlet fileprivate weak var titleContainerView: UIView!
    @IBOutlet fileprivate weak var titlePickButton: UIButton!
    @IBOutlet fileprivate weak var titleMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var titleSeparatorView: UIView!
    
    // FULL NAME INPUT STACK VIEW
    @IBOutlet fileprivate weak var fullnameInputStackView: UIStackView!
    @IBOutlet fileprivate weak var fullnameInputLabel: UILabel!
    @IBOutlet fileprivate weak var fullnameTextField: UITextField!
    @IBOutlet fileprivate weak var fullnameSeparatorView: UIView!
    
    // DATE BORN INPUT STACK VIEW
    @IBOutlet fileprivate weak var dateBornInputStackView: UIStackView!
    @IBOutlet fileprivate weak var dateBornInputTextLabel: UILabel!
    @IBOutlet fileprivate weak var dateBornContainerView: UIView!
    @IBOutlet fileprivate weak var dateBornPickButton: UIButton!
    @IBOutlet fileprivate weak var dateBornSeparatorView: UIView!
    @IBOutlet fileprivate weak var dateBornMenuStackView: UIStackView!
    
    // CITIZENSHIP INPUT STACK VIEW
    @IBOutlet fileprivate weak var citizenshipInputStackView: UIStackView!
    @IBOutlet fileprivate weak var citizenshipInputTextLabel: UILabel!
    @IBOutlet fileprivate weak var citizenshipContainerView: UIView!
    @IBOutlet fileprivate weak var citizenshipPickButton: UIButton!
    @IBOutlet fileprivate weak var citizenshipMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var citizenshipSeparatorView: UIView!
    
    // PASPORT NO INPUT STACK VIEW
    @IBOutlet fileprivate weak var pasportNoInputStackView: UIStackView!
    @IBOutlet fileprivate weak var pasportNoInputLabel: UILabel!
    @IBOutlet fileprivate weak var pasportNoTextField: UITextField!
    @IBOutlet fileprivate weak var pasportNoSeparatorView: UIView!
    
    // PASPORT EXPIRED STACK VIEW
    @IBOutlet fileprivate weak var pasportExpiredInputStackView: UIStackView!
    @IBOutlet fileprivate weak var pasportExpiredInputTextLabel: UILabel!
    @IBOutlet fileprivate weak var pasportExpiredContainerView: UIView!
    @IBOutlet fileprivate weak var pasportExpiredPickButton: UIButton!
    @IBOutlet fileprivate weak var pasportMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var pasportExpiredSeparatorView: UIView!
    
    // PASPORT ISSUES STACK VIEW
    @IBOutlet fileprivate weak var pasportIssuesStackView: UIStackView!
    @IBOutlet fileprivate weak var pasportIssuesInputLabel: UILabel!
    @IBOutlet fileprivate weak var pasportIssuesContainerView: UIView!
    @IBOutlet fileprivate weak var pasportIssuesPickButton: UIButton!
    @IBOutlet fileprivate weak var pasportIssuesMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var pasportIssuesSeparatorView: UIView!
    
    
    static func instantiate() -> PassengerInternationalVC {
        let vc = Storyboard.PassengerForm.instantiate(PassengerInternationalVC.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Dewasa 1"
        
        let cancelItemButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        self.navigationItem.leftBarButtonItem = cancelItemButton
    }

    override func bindStyles() {
        super.bindStyles()
        
        _ = self.internationalStackView
            |> UIStackView.lens.layoutMargins .~ .init(topBottom: Styles.grid(2), leftRight: Styles.grid(4))
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
            |> UIStackView.lens.spacing .~ Styles.grid(4)
        
        _ = self.fullnameInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(2)
        
        _ = self.dateBornContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.citizenshipContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.titleInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(2)
        
        _ = self.titleContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.pasportExpiredInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(2)
        
        _ = self.pasportExpiredContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.pasportIssuesStackView
            |> UIStackView.lens.spacing .~ Styles.grid(2)
        
        _ = self.pasportIssuesContainerView
            |> UIView.lens.backgroundColor .~ .white
    }
    
    @objc fileprivate func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
