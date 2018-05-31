//
//  OrderListVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 08/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import Spring
import TiketKitModels
import UIKit

internal final class OrderListVC: UIViewController {
    fileprivate let viewModel: OrderListViewModelType = OrderListViewModel()
    fileprivate let dataSource = OrderListDataSource()
    @IBOutlet fileprivate weak var orderTableView: UITableView!
    
    fileprivate var emptyStatesController: EmptyStatesVC?
    
    @IBOutlet fileprivate weak var loadingOverlayView: UIView!
    @IBOutlet fileprivate weak var activityIndicatorView: UIActivityIndicatorView!
    
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
        
        navigationItem.title = "Keranjang"
        
        self.orderTableView.dataSource = dataSource
        
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
        
        _ = self.orderTableView
            |> UITableView.lens.rowHeight .~ UITableViewAutomaticDimension
            |> UITableView.lens.estimatedRowHeight .~ 160.0
            |> UITableView.lens.separatorStyle .~ .none
        
        _ = self.activityIndicatorView
            |> baseActivityIndicatorStyle
        
        _ = self.loadingOverlayView
            |> UIView.lens.backgroundColor .~ UIColor(white: 1.0, alpha: 0.99)
            |> UIView.lens.isHidden .~ false
    }
    
    internal override func bindViewModel() {
        super.bindViewModel()
        
        self.activityIndicatorView.rac.animating = self.viewModel.outputs.ordersAreLoading
        self.loadingOverlayView.rac.hidden = self.viewModel.outputs.loadingOverlaysIsHidden
        
        self.viewModel.outputs.orders
            .observe(on: UIScheduler())
            .observeValues { [weak self] result in
                print("Whats the result: \(result)")
                self?.dataSource.load(orders: result)
                self?.orderTableView.reloadData()
        }
        
        self.viewModel.outputs.showEmptyState
            .observe(on: UIScheduler())
            .observeValues { [weak self] _ in
                self?.orderTableView.bounces = false
                if let emptyVC = self?.emptyStatesController {
                    self?.emptyStatesController?.view.isHidden = false
                    self?.view.bringSubview(toFront: emptyVC.view)
                }
        }
        
        self.viewModel.outputs.hideEmptyState
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.orderTableView.bounces = true
                self?.emptyStatesController?.view.isHidden = true
        }
        
        self.viewModel.outputs.deleteOrderReminder
            .observe(on: UIScheduler())
            .observeValues { [weak self] remind in
                self?.present(UIAlertController.alert(message: remind, confirm: { _ in self?.viewModel.inputs.confirmDeleteOrder(true) }), animated: true, completion: nil)
        }
        
        self.viewModel.outputs.deletedOrder
            .observe(on: UIScheduler())
            .observeValues { deleted in
                print("WHATS DIAGNOSTIC DELETED ORDER: \(deleted)")
        }
        
        self.viewModel.outputs.goToOrderDetail
            .observe(on: UIScheduler())
            .observeValues {_ in
        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? OrderListViewCell {
            cell.delegate = self
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let order = self.dataSource.orderAtIndexPath(indexPath) {
            self.viewModel.inputs.tappedOrderDetail(order)
        }
    }
    
    fileprivate func goToOrderDetail() {
        
    }
    
    fileprivate func goToPayment() {
        let paymentVC = HotelPaymentsVC.instantiate()
        let navPayment = UINavigationController(rootViewController: paymentVC)
        self.present(navPayment, animated: true, completion: nil)
    }
}

extension OrderListVC: OrderListViewCellDelegate {
    func orderDeleteButtonTapped(_ listCell: OrderListViewCell, order: OrderData) {
        self.viewModel.inputs.deletedOrderTapped(order)
    }
}
