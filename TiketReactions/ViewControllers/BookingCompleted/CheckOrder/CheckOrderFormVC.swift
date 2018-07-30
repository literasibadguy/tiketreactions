//
//  CheckOrderVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 28/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import Spring
import TiketKitModels
import UIKit

public final class CheckOrderFormVC: UIViewController {
    
    fileprivate let viewModel: CheckOrderFormViewModelType = CheckOrderFormViewModel()
    
    @IBOutlet fileprivate weak var orderIdTextField: UITextField!
    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var checkOrderButton: DesignableButton!
    @IBOutlet fileprivate weak var orderFormSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var loadingOverlayView: UIView!
    @IBOutlet fileprivate weak var loadingIndicatorView: UIActivityIndicatorView!
    
    
    public static func instantiate() -> CheckOrderFormVC {
        let vc = Storyboard.CheckOrderForm.instantiate(CheckOrderFormVC.self)
        vc.viewModel.inputs.configureWith(AppEnvironment.current.userDefaults.orderDetailIds.last ?? "", email: AppEnvironment.current.userDefaults.emailDetailLogins.last ?? "")
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Check Order"
        
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.orderIdTextField.addTarget(self,
                                     action: #selector(orderIdTextFieldReturn),
                                     for: .editingDidEndOnExit)
        
        self.orderIdTextField.addTarget(self,
                                     action: #selector(orderIdTextFieldChanged(_:)),
                                     for: [.editingDidEndOnExit, .editingChanged])
        
        self.emailTextField.addTarget(self,
                                      action: #selector(emailTextFieldReturn),
                                      for: .editingDidEndOnExit)
        
        self.emailTextField.addTarget(self,
                                      action: #selector(emailTextFieldChanged(_:)),
                                      for: [.editingDidEndOnExit, .editingChanged])
        
        self.checkOrderButton.addTarget(self, action: #selector(checkOrderButtonTapped), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.orderIdTextField
            |> UITextField.lens.returnKeyType .~ .next
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.emailTextField
            |> UITextField.lens.returnKeyType .~ .go
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.checkOrderButton
            |> UIButton.lens.titleColor(forState: .normal) .~ .white
            |> UIButton.lens.backgroundColor .~ .tk_official_green
            |> UIButton.lens.backgroundColor(forState: .disabled) .~ .tk_base_grey_100
            |> UIButton.lens.title(forState: .normal) .~ "Check Order"
            |> UIButton.lens.titleColor(forState: .disabled) .~ .tk_typo_green_grey_500
            |> UIButton.lens.isEnabled .~ false
        
        _ = self.loadingIndicatorView
            |> baseActivityIndicatorStyle
        
        _ = self.loadingIndicatorView
            |> UIView.lens.backgroundColor .~ UIColor(white: 1.0, alpha: 0.99)
            |> UIView.lens.isHidden .~ true
        
        _ = self.orderFormSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.orderIdTextField.rac.text = self.viewModel.outputs.orderIdText
        self.emailTextField.rac.text = self.viewModel.outputs.emailText
        self.checkOrderButton.rac.isEnabled = self.viewModel.outputs.isCheckOrderEnabled
        self.loadingOverlayView.rac.hidden = self.viewModel.outputs.loadingOverlayIsHidden
        self.loadingIndicatorView.rac.animating = self.viewModel.outputs.orderIssueIsLoading
        
        self.viewModel.outputs.goToCheckOrder
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] result in
                
        }
        
        self.viewModel.outputs.showError
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] message in
                self?.present(
                    UIAlertController.genericError(nil, message: message),
                    animated: true, completion: nil
                )
        }
    }
    
    @objc fileprivate func orderIdTextFieldReturn() {
        self.viewModel.inputs.orderIdTextFieldReturn()
    }
    
    @objc fileprivate func orderIdTextFieldChanged(_ order: UITextField) {
        self.viewModel.inputs.orderIdTextFieldChange(order.text!)
    }
    
    @objc fileprivate func emailTextFieldReturn() {
        self.viewModel.inputs.emailTextFieldReturn()
    }
    
    @objc fileprivate func emailTextFieldChanged(_ email: UITextField) {
        self.viewModel.inputs.emailTextFieldChange(email.text!)
    }
    
    @objc fileprivate func checkOrderButtonTapped() {
        self.viewModel.inputs.checkOrderButtonTapped()
    }
}
