//
//  BankTransfersVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 21/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import UIKit
import TiketKitModels

public final class BankTransfersVC: UITableViewController {
    
    fileprivate let viewModel: BankTransfersViewModelType = BankTransfersViewModel()
    fileprivate let dataSource = BankTransfersDataSource()
    
    private var doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonItemTapped))
    
    lazy private var lazyDoneButton: UIBarButtonItem = {
        let closeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonItemTapped))
        return closeBarButtonItem
    }()
    
    fileprivate let activityIndicator = UIActivityIndicatorView()
    
    public static func instantiate() -> BankTransfersVC {
        let vc = Storyboard.BankTransfers.instantiate(BankTransfersVC.self)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Bank Transfer"
        
        self.navigationItem.leftBarButtonItem = self.lazyDoneButton
        self.navigationItem.rightBarButtonItem = self.lazyDoneButton
        
        self.doneButton.isEnabled = false
        
       self.tableView.register(nib: .NoticeSummaryViewCell)
        self.tableView.addSubview(self.activityIndicator)
        self.tableView.dataSource = dataSource
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.activityIndicator.center = self.tableView.center
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> baseTableControllerStyle(estimatedRowHeight: 105.0)
        
        _ = self.lazyDoneButton
            |> UIBarButtonItem.lens.accessibilityLabel .~ "Done"
        
        _ = self.activityIndicator
            |> baseActivityIndicatorStyle
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.doneButton.rac.isEnabled = self.viewModel.outputs.doneEnabled.negate()
        self.activityIndicator.rac.animating = self.viewModel.outputs.banksAreAnimating
        
        self.viewModel.outputs.banks
            .observe(on: UIScheduler())
            .observeValues { [weak self] bankData in
                self?.dataSource.load(bankData)
                self?.tableView.reloadData()
        }
        
        self.viewModel.outputs.selectedPayment
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] url in
                let urlRequest = URLRequest(url: url)
                self?.goToCheckout(urlRequest, title: "")
        }
        
        self.viewModel.outputs.confirmTransfers
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.present(UIAlertController.alert(message: Localizations.PaymentdoneNotice, confirm: { _ in self?.viewModel.inputs.dismissTransfers(true) }, cancel: { _ in self?.viewModel.inputs.dismissTransfers(false) }), animated: true, completion: nil)
        }
        
        self.viewModel.outputs.transferNotAvailable
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.present(UIAlertController.genericError("Bank Transfer", message: $0, cancel: { _ in self?.navigationController?.popViewController(animated: true) }), animated: true, completion: nil)
        }
        
        self.viewModel.outputs.dismissToChecked
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
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let virtualPay = self.dataSource.issueAtIndexPath(indexPath) {
            self.viewModel.inputs.didSelectVirtual(payment: virtualPay)
        }
    }
    
    fileprivate func goToCheckout(_ request: URLRequest, title: String) {
        let checkoutVC = CheckoutPageVC.configuredWith(initialRequest: request)
        checkoutVC.title = title
        let navVC = UINavigationController(rootViewController: checkoutVC)
        self.present(navVC, animated: true, completion: nil)
    }
    
    @objc private func doneButtonItemTapped() {
        print("Done Button Item Tapped")
        self.viewModel.inputs.doneButtonItemTapped()
    }
}
