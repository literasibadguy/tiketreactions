//
//  PaymentsListVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 13/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

public final class PaymentsListVC: UIViewController {
    
    fileprivate let viewModel: PaymentsListViewModelType = PaymentsListViewModel()
    
    @IBOutlet fileprivate weak var baseScrollView: UIScrollView!
    @IBOutlet fileprivate weak var baseStackView: UIStackView!
    
    @IBOutlet fileprivate weak var orderIdInputLabel: UILabel!
    @IBOutlet fileprivate weak var totalPriceInputLabel: UILabel!
    
    // BANK TRANSFER
    @IBOutlet fileprivate weak var bankTransferView: UIView!
    @IBOutlet fileprivate weak var banktransferInputLabel: UILabel!
    @IBOutlet fileprivate weak var bankTransferButton: UIButton!
    
    @IBOutlet fileprivate weak var bankTransfertopSeparatorView: UIView!
    @IBOutlet fileprivate weak var bankTransferbottomSeparatorView: UIView!
    
    // KARTU KREDIT
    @IBOutlet fileprivate weak var kartuKreditView: UIView!
    @IBOutlet fileprivate weak var cardCreditInputLabel: UILabel!
    @IBOutlet fileprivate weak var cardCreditButton: UIButton!
    
    @IBOutlet fileprivate weak var cardCredittopSeparatorView: UIView!
    @IBOutlet fileprivate weak var cardCreditbottomSeparatorView: UIView!
    
    // ATM TRANSFER
    @IBOutlet fileprivate weak var transferATMView: UIView!
    @IBOutlet fileprivate weak var transferATMInputLabel: UILabel!
    @IBOutlet weak var transferATMButton: UIButton!
    
    @IBOutlet fileprivate weak var atmTransferTopSeparatorView: UIView!
    @IBOutlet fileprivate weak var atmTransferBottomSeparatorView: UIView!
    
    // KlikBCA
    @IBOutlet fileprivate weak var klikBCAView: UIView!
    @IBOutlet fileprivate weak var klikBCAInputLabel: UILabel!
    @IBOutlet fileprivate weak var klikBCAButton: UIButton!
    
    @IBOutlet fileprivate weak var klikBCATopSeparatorView: UIView!
    @IBOutlet fileprivate weak var klikBCABottomSeparatorView: UIView!
    
    // BCA Klikpay
    @IBOutlet fileprivate weak var bcaKlikpayView: UIView!
    @IBOutlet fileprivate weak var bcaKlikpayLabel: UILabel!
    @IBOutlet fileprivate weak var bcaKlikpayButton: UIButton!
    
    @IBOutlet fileprivate weak var bcaKlikpayTopSeparatorView: UIView!
    @IBOutlet fileprivate weak var bcaKlikpayBottomSeparatorView: UIView!
    
    
    // CIMB Clicks
    @IBOutlet fileprivate weak var cimbClicksView: UIView!
    @IBOutlet fileprivate weak var cimbClicksLabel: UILabel!
    @IBOutlet fileprivate weak var cimbClicksButton: UIButton!
    
    @IBOutlet fileprivate weak var cimbClicksTopSeparatorView: UIView!
    @IBOutlet fileprivate weak var cimbClicksBottomSeparatorView: UIView!
    
    // epayBRI
    @IBOutlet fileprivate weak var epayBRIView: UIView!
    @IBOutlet fileprivate weak var epayBRIInputLabel: UILabel!
    @IBOutlet fileprivate weak var ePayBRIButton: UIButton!
    
    @IBOutlet fileprivate weak var epayBriTopSeparatorView: UIView!
    @IBOutlet fileprivate weak var epayBriBottomSeparatorView: UIView!
    
    public static func configureWith(myorder: MyOrder) -> PaymentsListVC {
        let vc = Storyboard.PaymentsList.instantiate(PaymentsListVC.self)
        vc.viewModel.inputs.configureWith(myOrder: myorder)
        return vc
    }
    
    public static func instantiate() -> PaymentsListVC {
        let vc = Storyboard.PaymentsList.instantiate(PaymentsListVC.self)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bankTransferButton.addTarget(self, action: #selector(bankTransferTapped), for: .touchUpInside)
        self.ePayBRIButton.addTarget(self, action: #selector(epayBRITapped), for: .touchUpInside)
        self.cimbClicksButton.addTarget(self, action: #selector(cimbClicksTapped), for: .touchUpInside)
        self.bcaKlikpayButton.addTarget(self, action: #selector(bcaKlikpayTapped), for: .touchUpInside)
        self.klikBCAButton.addTarget(self, action: #selector(klikBCATapped), for: .touchUpInside)
        self.cardCreditButton.addTarget(self, action: #selector(cardCreditTapped), for: .touchUpInside)
        self.transferATMButton.addTarget(self, action: #selector(atmTransferTapped), for: .touchUpInside)
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissPaymentMethod))
        cancelButton.tintColor = .tk_official_green
        self.navigationItem.leftBarButtonItem = cancelButton
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.orderIdInputLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.totalPriceInputLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.epayBRIInputLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        _ = self.cimbClicksLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        _ = self.bcaKlikpayLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        _ = self.klikBCAInputLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        _ = self.transferATMInputLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        _ = self.cardCreditInputLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        _ = self.banktransferInputLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.bankTransfertopSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        _ = self.bankTransferbottomSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        _ = self.cardCredittopSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        _ = self.cardCreditbottomSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        _ = self.atmTransferTopSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        _ = self.atmTransferBottomSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        _ = self.klikBCATopSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        _ = self.klikBCABottomSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        _ = self.bcaKlikpayTopSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        _ = self.bcaKlikpayBottomSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        _ = self.cimbClicksTopSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        _ = self.cimbClicksBottomSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        _ = self.epayBriTopSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        _ = self.epayBriBottomSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.orderIdInputLabel.rac.text = self.viewModel.outputs.orderIdLabelText
        self.totalPriceInputLabel.rac.text = self.viewModel.outputs.totalPriceLabelText
        
        self.viewModel.outputs.goBankTransfer
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.goToBankTransfers()
        }
        
        self.viewModel.outputs.goCardCredit
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] request in
                self?.goToCheckout(request, title: "Kartu Kredit")
        }
        
        self.viewModel.outputs.goBCAKlikpay
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] request in
                self?.goToCheckout(request, title: "BCA Klikpay")
        }
        
        self.viewModel.outputs.goKlikBCA
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] request in
                self?.goToCheckout(request, title: "Klik BCA")
        }
        
        self.viewModel.outputs.goCIMBClicks
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] request in
                self?.goToCheckout(request, title: "CIMB Clicks")
        }
        
        self.viewModel.outputs.goEpayBRI
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] request in
                self?.goToCheckout(request, title: "Epay BRI")
        }
    }
    
    @objc fileprivate func bankTransferTapped() {
        self.viewModel.inputs.bankTransferTapped()
    }
    
    @objc fileprivate func cardCreditTapped() {
        self.viewModel.inputs.cardCreditTapped()
    }
    
    @objc fileprivate func atmTransferTapped() {
        self.viewModel.inputs.transferATMTapped()
    }
    
    @objc fileprivate func klikBCATapped() {
        self.viewModel.inputs.klikBCATapped()
    }
    
    @objc fileprivate func bcaKlikpayTapped() {
        self.viewModel.inputs.bcaKlikpayTapped()
    }
    
    @objc fileprivate func cimbClicksTapped() {
        self.viewModel.inputs.cimbClicksTapped()
    }
    
    @objc fileprivate func epayBRITapped() {
        self.viewModel.inputs.epayBriTapped()
    }
    
    @objc fileprivate func dismissPaymentMethod() {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func goToCheckout(_ request: URLRequest, title: String) {
        let checkoutVC = CheckoutPageVC.configuredWith(initialRequest: request)
        checkoutVC.title = title
        self.navigationController?.pushViewController(checkoutVC, animated: true)
    }
    
    fileprivate func goToBankTransfers() {
        let bankTransferVC = BankTransfersVC.instantiate()
        self.navigationController?.pushViewController(bankTransferVC, animated: true)
    }
}
