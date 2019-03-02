//
//  KlikBCATransferVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 22/10/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import SwiftSoup
import Result
import UIKit

internal final class KlikBCATransferVC: UIViewController {
    
    private let viewModel: KlikBCATransferViewModelType = KlikBCATransferViewModel()
    
    @IBOutlet private weak var receiptContainerView: UIView!
    @IBOutlet private weak var noticeContainerView: UIView!
    @IBOutlet private weak var stepsStackView: UIStackView!
    
    @IBOutlet private weak var totalPriceTextLabel: UILabel!
    @IBOutlet private weak var orderIdTextLabel: UILabel!
    @IBOutlet private weak var totalInputLabel: UILabel!
    @IBOutlet private weak var messageTextLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    lazy private var lazyDoneButton: UIBarButtonItem = {
        let closeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonItemTapped))
        return closeBarButtonItem
    }()
    
    
    public static func configureWith(klikBCAId: String) -> KlikBCATransferVC {
        let vc = Storyboard.BankTransfers.instantiate(KlikBCATransferVC.self)
        vc.viewModel.inputs.configureWith(klikBCAId: klikBCAId)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = lazyDoneButton
        self.navigationItem.rightBarButtonItem = lazyDoneButton
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self.receiptContainerView
            |> UIView.lens.backgroundColor .~ .tk_fade_green_grey
        
        _ = self.noticeContainerView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.activityIndicator
            |> baseActivityIndicatorStyle
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.activityIndicator.rac.animating = self.viewModel.outputs.klikBCALoading
        self.totalPriceTextLabel.rac.text = self.viewModel.outputs.totalPriceText
        self.orderIdTextLabel.rac.text = self.viewModel.outputs.orderIdText
        self.messageTextLabel.rac.text = self.viewModel.outputs.messageText
        
        self.viewModel.outputs.stepsText
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.load(items: $0)
        }
        
        self.viewModel.outputs.klikBCAErrors
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.present(UIAlertController.genericError("KlikBCA", message: $0, cancel: { _ in self?.navigationController?.popViewController(animated: true) }), animated: true, completion: nil)
        }
        
        self.viewModel.outputs.doneConfirm
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.present(UIAlertController.alert(message: Localizations.PaymentdoneNotice, confirm: { _ in self?.viewModel.inputs.klikBCADone(true) }, cancel: { _ in self?.viewModel.inputs.klikBCADone(false) }), animated: true, completion: nil)
        }
        
        self.viewModel.outputs.klikBCADone
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                guard let _self = self else { return }
                _self.view.window?.rootViewController.flatMap { $0 as? RootTabBarVC }.doIfSome { root in
                    root.dismiss(animated: true, completion: nil)
                    UIView.transition(with: root.view, duration: 0.3, options: [.transitionCrossDissolve], animations: {
                        root.switchToLounge()
                    }, completion: { _ in
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GoToIssues"), object: nil)
                    })
                }
        }
    }
    
    private func load(items: [String]) {
        self.stepsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for item in items {
            let label = UILabel()
                |> UILabel.lens.font .~ UIFont.boldSystemFont(ofSize: 16.0)
                |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
                |> UILabel.lens.text .~ parseHTMLStrip(item)
                |> UILabel.lens.numberOfLines .~ 0
            
            self.stepsStackView.addArrangedSubview(label)
        }
    }
    
    private func parseHTMLStrip(_ content: String) -> String {
        do {
            let doc: Document = try SwiftSoup.parse(content)
            let parsed = try doc.text()
            return parsed
        } catch Exception.Error(_, let message) {
            return message
        } catch {
            return content
        }
    }
    
    @objc private func doneButtonItemTapped() {
        self.viewModel.inputs.confirmDoneButtonTapped()
    }
}
