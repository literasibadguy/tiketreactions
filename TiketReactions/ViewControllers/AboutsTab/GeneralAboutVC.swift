//
//  GeneralAboutVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 08/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import MessageUI
import Prelude
import ReactiveSwift
import UIKit
import TiketKitModels

internal final class GeneralAboutVC: UIViewController {
    
    fileprivate let viewModel: GeneralAboutViewModelType = GeneralAboutViewModel()
    
    @IBOutlet fileprivate weak var logoBaseView: UIView!
    @IBOutlet fileprivate weak var welcomeLabel: UILabel!
    
    @IBOutlet private weak var currencyCellSeparatorView: UIView!
    @IBOutlet private weak var languageCellSeparatorView: UIView!
    @IBOutlet private weak var currencyButton: UIButton!
    @IBOutlet private weak var currencyInputLabel: UILabel!
    @IBOutlet private weak var deviceIDInputLabel: UILabel!
    
    @IBOutlet private weak var contactInputLabel: UILabel!
    @IBOutlet private weak var contactButton: UIButton!
    @IBOutlet private weak var contactCellSeparatorView: UIView!
    
    @IBOutlet private weak var currencyValueLabel: UILabel!
    @IBOutlet private weak var deviceIDValueLabel: UILabel!
    
    
    static func instantiate() -> GeneralAboutVC {
        let vc = Storyboard.GeneralAbout.instantiate(GeneralAboutVC.self)
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.currencyButton.addTarget(self, action: #selector(currencyButtonTapped), for: .touchUpInside)
        self.contactButton.addTarget(self, action: #selector(contactButtonTapped), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
        self.viewModel.inputs.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationItem.title = "Tentang"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self.currencyInputLabel
            |> UILabel.lens.textColor .~ .black
            |> UILabel.lens.text .~ Localizations.CurrencyTitle
        
        _ = self.deviceIDInputLabel
            |> UILabel.lens.textColor .~ .black
        
        _ = self.currencyValueLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        _ = self.deviceIDValueLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
    
        _ = self.contactInputLabel
            |> UILabel.lens.textColor .~ .tk_official_green
            |> UILabel.lens.text .~ "Feedback"
        
        _ = self.currencyCellSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.languageCellSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.contactCellSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.welcomeLabel
            |> UILabel.lens.text .~ "triptozero"
            |> UILabel.lens.textColor .~ .tk_official_green
    }
    
    override func bindViewModel() {
        super.bindViewModel()


        self.currencyValueLabel.rac.text = self.viewModel.outputs.currencySubText
        self.deviceIDValueLabel.rac.text = self.viewModel.outputs.deviceIdText
        
        self.viewModel.outputs.goToCurrency
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] currency in
                self?.goToCurrency(currency)
        }
        
        self.viewModel.outputs.goToContact
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.goToContactThread()
        }
    }
    
    fileprivate func goToCurrency(_ current: String) {
        let vc = CurrencyListVC.configureWith(current)
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    fileprivate func goToContactThread() {
        
//        let version = AppEnvironment.current.mainBundle.version
//        let shortVersion = AppEnvironment.current.mainBundle.shortVersionString
//        let device = UIDevice.current
        
        let mailController = MFMailComposeViewController()
        mailController.setToRecipients([Secrets.fieldReportEmail])
        mailController.setSubject("Complain / Feedback: ")
        mailController.setMessageBody(
                "Mohon masukan atau ketidakpuasan anda. Lampirkan gambar jika membantu!\n" +
            "---------------------------\n\n\n\n\n\n",
            isHTML: false
        )
        
        mailController.mailComposeDelegate = self
        self.present(mailController, animated: true, completion: nil)
    }
    
    @objc fileprivate func currencyButtonTapped() {
        self.viewModel.inputs.currencyButtonTapped()
    }
    
    @objc fileprivate func contactButtonTapped() {
        self.viewModel.inputs.contactButtonTapped()
    }
}

extension GeneralAboutVC: CurrencyListDelegate {
    func changedCurrency(_ list: CurrencyListVC, currency: CurrencyListEnvelope.Currency) {
        self.viewModel.inputs.currencyHaveChanged(currency)
    }
}

extension GeneralAboutVC: MFMailComposeViewControllerDelegate {
    internal func mailComposeController(_ controller: MFMailComposeViewController,
                                        didFinishWith result: MFMailComposeResult,
                                        error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
