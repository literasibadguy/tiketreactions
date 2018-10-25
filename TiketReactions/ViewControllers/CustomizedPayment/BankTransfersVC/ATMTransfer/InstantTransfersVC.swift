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
    
    private let activityIndicator = UIActivityIndicatorView()
    
    internal override func viewDidLoad() {
        super.viewDidLoad()

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
    }
}
