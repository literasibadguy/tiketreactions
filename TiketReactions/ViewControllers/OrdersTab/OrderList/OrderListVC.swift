//
//  OrderListVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 08/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import UIKit

internal final class OrderListVC: UITableViewController {
    fileprivate let viewModel: OrderListViewModelType = OrderListViewModel()
    fileprivate let dataSource = OrderListDataSource()
    
    fileprivate var emptyStatesController: EmptyStatesVC?
    
    static func instantiate() -> OrderListVC {
        let vc = Storyboard.OrderList.instantiate(OrderListVC.self)
        return vc
    }
    
    internal override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.emptyStatesController?.view.frame = self.view.bounds
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = dataSource
        
        let emptyVC = EmptyStatesVC.configuredWith(emptyState: EmptyState.orderResult)
        self.emptyStatesController = emptyVC
        self.addChildViewController(emptyVC)
        self.view.addSubview(emptyVC.view)
        emptyVC.didMove(toParentViewController: self)
        
        self.viewModel.inputs.viewDidLoad()
    }

    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.inputs.viewWillAppear(animated: animated)
    }
    
    internal override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> baseTableControllerStyle(estimatedRowHeight: 160.0)
    }
    
    internal override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.orders
            .observe(on: UIScheduler())
            .observeValues { [weak self] result in
                print("Whats the result: \(result)")
                self?.dataSource.load(orders: result)
                self?.tableView.reloadData()
        }
        
        self.viewModel.outputs.showEmptyState
            .observe(on: UIScheduler())
            .observeValues { [weak self] _ in
                self?.tableView.bounces = false
                if let emptyVC = self?.emptyStatesController {
                    self?.emptyStatesController?.view.isHidden = false
                    self?.view.bringSubview(toFront: emptyVC.view)
                }
        }
        
        self.viewModel.outputs.hideEmptyState
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.tableView.bounces = true
                self?.emptyStatesController?.view.isHidden = true
        }
    }
    
    fileprivate func goToOrderDetail() {
        
    }
}
