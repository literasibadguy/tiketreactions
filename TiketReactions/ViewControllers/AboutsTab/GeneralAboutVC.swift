//
//  GeneralAboutVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 08/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import UIKit
import TiketKitModels

internal final class GeneralAboutVC: UIViewController {
    
    fileprivate let viewModel: GeneralAboutViewModelType = GeneralAboutViewModel()
    
    @IBOutlet fileprivate weak var rootStackView: UIStackView!
    
    @IBOutlet fileprivate weak var logoBaseView: UIView!
    @IBOutlet fileprivate weak var logoImageView: UIImageView!
    
    @IBOutlet fileprivate weak var introductionView: UIView!
    @IBOutlet fileprivate weak var introductionLabel: UILabel!
    
    
    @IBOutlet fileprivate weak var currencyTopSeparatorView: UIView!
    @IBOutlet fileprivate weak var currencyBottomSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var currencyViewCell: UIView!
    @IBOutlet fileprivate weak var currencyMainLabel: UILabel!
    @IBOutlet fileprivate weak var currencySubLabel: UILabel!
    @IBOutlet fileprivate weak var buildVersionLabel: UILabel!
    
    @IBOutlet fileprivate weak var currencyFrequencyButton: UIButton!
    
    
    static func instantiate() -> GeneralAboutVC {
        let vc = Storyboard.GeneralAbout.instantiate(GeneralAboutVC.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.currencyFrequencyButton.addTarget(self, action: #selector(currencyButtonTapped), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
        self.viewModel.inputs.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationItem.title = "Tentang"
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self.introductionLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.currencyTopSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        _ = self.currencyBottomSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.currencyMainLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        _ = self.currencySubLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.currencyMainLabel.rac.text = self.viewModel.outputs.currencyMainText
        self.currencySubLabel.rac.text = self.viewModel.outputs.currencySubText
        self.buildVersionLabel.rac.text = self.viewModel.outputs.buildVersionText
        
        self.viewModel.outputs.goToCurrency
            .observe(on: UIScheduler())
            .observeValues { [weak self] currency in
                self?.goToCurrency(currency)
        }
    }
    
    fileprivate func goToCurrency(_ current: String) {
        let vc = CurrencyListVC.configureWith(current)
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc fileprivate func currencyButtonTapped() {
        self.viewModel.inputs.currencyButtonTapped()
    }
}

extension GeneralAboutVC: CurrencyListDelegate {
    func changedCurrency(_ list: CurrencyListVC, currency: CurrencyListEnvelope.Currency) {
        self.viewModel.inputs.currencyHaveChanged(currency)
    }
    
}

