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
    
    fileprivate let activityIndicator = UIActivityIndicatorView()
    
    public static func instantiate() -> BankTransfersVC {
        let vc = Storyboard.BankTransfers.instantiate(BankTransfersVC.self)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Bank Transfer"
        
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
        
        _ = self.activityIndicator
            |> baseActivityIndicatorStyle
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.activityIndicator.rac.animating = self.viewModel.outputs.banksAreAnimating
        
        self.viewModel.outputs.banks
            .observe(on: UIScheduler())
            .observeValues { [weak self] bankData in
                self?.dataSource.load(bankData)
                self?.tableView.reloadData()
        }
        
    }
}
