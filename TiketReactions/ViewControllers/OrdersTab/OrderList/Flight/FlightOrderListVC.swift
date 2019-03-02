//
//  FlightOrderListVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 02/10/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

internal final class FlightOrderListVC: UIViewController {
    
    fileprivate let viewModel: FlightOrderListViewModelType = FlightOrderListViewModel()
    fileprivate let dataSource = FlightOrderListDataSource()
    
    fileprivate var emptyStatesController: EmptyStatesVC?
    
    @IBOutlet fileprivate weak var orderTableView: UITableView!
    @IBOutlet fileprivate weak var loadingOverlayView: UIView!
    @IBOutlet fileprivate weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet fileprivate weak var navigationPaymentView: UIView!
    @IBOutlet fileprivate weak var navigationSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var paymentMethodButton: UIButton!
    
    internal static func instantiate() -> FlightOrderListVC {
        let vc = Storyboard.OrderList.instantiate(FlightOrderListVC.self)
        return vc
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.paymentMethodButton.addTarget(self, action: #selector(paymentButtonTapped), for: .touchUpInside)
        
        self.orderTableView.dataSource = dataSource
        self.orderTableView.delegate = self
        
        let emptyVC = EmptyStatesVC.configuredWith(emptyState: EmptyState.flightResult)
        self.emptyStatesController = emptyVC
        self.addChildViewController(emptyVC)
        self.view.addSubview(emptyVC.view)
        emptyVC.didMove(toParentViewController: self)
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.inputs.viewWillAppear(animated)
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
        
        _ = self.paymentMethodButton
            |> UIButton.lens.backgroundColor(forState: .normal) .~ .tk_official_green
            |> UIButton.lens.backgroundColor(forState: .disabled) .~ .tk_base_grey_100
        
        _ = self.navigationSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    internal override func bindViewModel() {
        super.bindViewModel()
        
        self.activityIndicatorView.rac.animating = self.viewModel.outputs.flightsAreLoading
        self.loadingOverlayView.rac.hidden = self.viewModel.outputs.loadingOverlaysIsHidden
        
        self.viewModel.outputs.flightOrders
            .observe(on: UIScheduler())
            .observeValues { [weak self] orders in
                self?.dataSource.load(orders: orders)
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
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] remind in
                self?.present(UIAlertController.alert(message: remind, confirm: { _ in self?.viewModel.inputs.confirmDeleteOrder(true) }, cancel: { _ in self?.viewModel.inputs.confirmDeleteOrder(false) }), animated: true, completion: nil)
        }
        
        self.viewModel.outputs.goToPayments
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] order in
                self?.goToPayment(order)
        }
    }
    
    fileprivate func goToPayment(_ order: FlightMyOrder) {
        let paymentVC = PaymentsListVC.configureFlightWith(myorder: order)
        let navPayment = UINavigationController(rootViewController: paymentVC)
        self.present(navPayment, animated: true, completion: nil)
    }
    
    @objc fileprivate func paymentButtonTapped() {
        self.viewModel.inputs.paymentButtonTapped()
    }
}

extension FlightOrderListVC: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? FlightOrderListViewCell {
            print("CELL DELEGATED FOR ORDER LIST")
            cell.delegate = self
        }
    }
}

extension FlightOrderListVC: FlightOrderListViewCellDelegate {
    func orderDeleteButtonTapped(_ listCell: FlightOrderListViewCell, order: FlightOrderData) {
        self.viewModel.inputs.deleteOrderTapped(order)
    }
}
