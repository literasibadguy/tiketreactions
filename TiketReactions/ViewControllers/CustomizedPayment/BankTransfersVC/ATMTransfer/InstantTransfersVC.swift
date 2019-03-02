//
//  InstantTransfersVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 16/10/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import UIKit

internal final class InstantTransfersVC: UITableViewController {

    private let dataSource = InstantTransfersDataSource()
    private let viewModel: InstantTransfersViewModelType = InstantTransfersViewModel()
    
    lazy private var lazyDoneButton: UIBarButtonItem = {
        let closeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonItemTapped))
        return closeBarButtonItem
    }()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.lazyDoneButton
        self.navigationItem.rightBarButtonItem = self.lazyDoneButton
        
        // Do any additional setup after loading the view.
        self.tableView.register(nib: .NoticeSummaryViewCell)
        self.tableView.addSubview(self.activityIndicator)
        self.tableView.dataSource = dataSource
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    internal override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.activityIndicator.center = self.tableView.center
    }
    
    internal static func instantiate() -> InstantTransfersVC {
        let vc = Storyboard.BankTransfers
            .instantiate(InstantTransfersVC.self)
        return vc
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> baseTableControllerStyle()
        
        _ = self.lazyDoneButton
            |> UIBarButtonItem.lens.accessibilityLabel .~ "Done"
        
        _ = self.activityIndicator
            |> baseActivityIndicatorStyle
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.activityIndicator.rac.animating = self.viewModel.outputs.instantsAreLoading
        
        self.viewModel.outputs.envelopeInstant
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.dataSource.load(instant: $0)
                self?.tableView.reloadData()
        }
        
        self.viewModel.outputs.confirmOrder
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.present(UIAlertController.alert(message: Localizations.PaymentdoneNotice, confirm: { _ in self?.viewModel.inputs.prepareToDismiss(true) }, cancel: { _ in self?.viewModel.inputs.prepareToDismiss(false) }), animated: true, completion: nil)
        }
        
        self.viewModel.outputs.dismissToIssue
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
    
    @objc private func doneButtonItemTapped() {
        print("Done Button Item Tapped")
        self.viewModel.inputs.doneButtonItemTapped()
    }
}
