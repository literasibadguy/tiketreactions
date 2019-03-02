//
//  OrderListVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 08/02/18.
//  Co pyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import RealmSwift
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

    @IBOutlet fileprivate weak var navigationPaymentView: UIView!
    @IBOutlet fileprivate weak var navigationSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var paymentMethodButton: UIButton!
    
    
    internal static func instantiate() -> OrderListVC {
        let vc = Storyboard.OrderList.instantiate(OrderListVC.self)
        return vc
    }
    
    internal override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.emptyStatesController?.view.frame = self.view.bounds
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = Localizations.CartOrdersTitle
        
//        let bookingButton = UIBarButtonItem(title: "History", style: .plain, target: self, action: #selector(historyButtonTapped))
        
        let issuedButton = UIBarButtonItem(image: UIImage(named: "issued-order-icon"), style: .plain, target: self, action: #selector(historyButtonTapped))
        issuedButton.tintColor = .tk_official_green
        
        self.paymentMethodButton.addTarget(self, action: #selector(paymentMethodButtonTapped), for: .touchUpInside)
        
        self.orderTableView.dataSource = dataSource
        self.orderTableView.delegate = self
        
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
    
    internal override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    internal override func bindStyles() {
        super.bindStyles()
        
        _ = (self.navigationController?.navigationBar)!
            |> UINavigationBar.lens.barTintColor .~ .white
            |> UINavigationBar.lens.shadowImage .~ UIImage()
        
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
            |> UIButton.lens.title(forState: .normal) .~ Localizations.ChoosepaymentTitle
        
        _ = self.navigationSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
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
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] remind in
                self?.present(UIAlertController.alert(message: remind, confirm: { _ in self?.viewModel.inputs.confirmDeleteOrder(true) }, cancel: { _ in self?.viewModel.inputs.confirmDeleteOrder(false) }), animated: true, completion: nil)
        }
        
        self.viewModel.outputs.deletedOrder
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] deleted in
                print("WHATS DIAGNOSTIC DELETED ORDER: \(deleted)")
                self?.viewModel.inputs.shouldRefresh()
                self?.orderTableView.reloadData()
        }
        
        self.viewModel.outputs.goToOrderDetail
            .observe(on: UIScheduler())
            .observeValues { _ in
                
        }
        
        self.viewModel.outputs.goToBookingCompleted
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.goToIssuedList()
        }
        
        self.viewModel.outputs.goToPayment
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] myOrder in
                self?.goToPayment(myOrder)
        }
    }

    @objc fileprivate func historyButtonTapped() {
        self.viewModel.inputs.historyButtonTapped()
    }
    
    @objc fileprivate func paymentMethodButtonTapped() {
        self.viewModel.inputs.paymentMethodButtonTapped()
    }
    
    fileprivate func goToPayment(_ order: MyOrder) {
        let paymentVC = PaymentsListVC.configureWith(myorder: order)
        let navPayment = UINavigationController(rootViewController: paymentVC)
        self.present(navPayment, animated: true, completion: nil)
    }
    
    @objc fileprivate func dismissPaymentMethod() {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func goToIssuedList() {
        let issuedListVC = IssuedListVC.instantiate()
        self.navigationController?.pushViewController(issuedListVC, animated: true)
    }
}

extension OrderListVC: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? OrderListViewCell {
            print("CELL DELEGATED FOR ORDER LIST")
            cell.delegate = self
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let order = self.dataSource.orderAtIndexPath(indexPath) {
            self.viewModel.inputs.tappedOrderDetail(order)
        }
    }
}

extension OrderListVC: OrderListViewCellDelegate {
    func orderDeleteButtonTapped(_ listCell: OrderListViewCell, order: OrderData) {
        print("ORDER LIST DELEGATE DETECTED: \(order)")
        self.viewModel.inputs.deletedOrderTapped(order)
    }
}
