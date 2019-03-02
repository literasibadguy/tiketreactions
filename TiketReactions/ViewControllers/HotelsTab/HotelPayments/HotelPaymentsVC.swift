//
//  HotelPaymentsVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 12/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

public final class HotelPaymentsVC: UITableViewController {
    
    fileprivate let viewModel: HotelPaymentsViewModelType = HotelPaymentsViewModel()
    
    fileprivate let dataSource = HotelPaymentsDataSource()
    
    public static func configureWith(myorder: MyOrder) -> HotelPaymentsVC {
        let vc = Storyboard.HotelPaymentsVC.instantiate(HotelPaymentsVC.self)
        vc.viewModel.inputs.configureWith(myOrder: myorder)
        return vc
    }
    
    public static func configureWith(myorder: FlightMyOrder) -> HotelPaymentsVC {
        let vc = Storyboard.HotelPaymentsVC.instantiate(HotelPaymentsVC.self)
//        vc.viewModel.inputs.configureWith(myOrder: myorder)
        return vc
    }
    
    public static func instantiate() -> HotelPaymentsVC {
        let vc = Storyboard.HotelPaymentsVC.instantiate(HotelPaymentsVC.self)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = dataSource
//        self.tableView.register(nib: .PaymentSummaryViewCell)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        // Do any additional setup after loading the view.
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Pilih Pembayaran"
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> baseTableControllerStyle()
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        
        
        self.viewModel.outputs.paymentsAvailable
            .observe(on: UIScheduler())
            .observeValues { [weak self] order, envelope in
                self?.dataSource.loadPayments(order, envelope: envelope)
                self?.tableView.reloadData()
        }
        
        self.viewModel.outputs.goToPayment
            .observe(on: UIScheduler())
            .observeValues { [weak self] checkoutPay in
                self?.goToCheckout(checkoutPay)
                print("CHECKOUT PAY: \(checkoutPay)")
        }
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let availPayment = self.dataSource[indexPath] as? AvailablePaymentEnvelope.AvailablePayment {
            print("Tapped Room Available")
            self.viewModel.inputs.paymentTapped(availPayment)
        }
    }
    
    @objc fileprivate func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func goToCheckout(_ request: URLRequest) {
        let checkoutVC = CheckoutPageVC.configuredWith(initialRequest: request)
        self.navigationController?.pushViewController(checkoutVC, animated: true)
    }
}
