//
//  HotelNavGuestFormVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 15/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import Spring
import TiketAPIs
import UIKit

public protocol HotelNavGuestFormDelegate: class {
    func navGuestFormDidTapPayment(_ controller: HotelNavGuestFormVC, loading: Bool)
}

public final class HotelNavGuestFormVC: UIViewController {
    internal weak var delegate: HotelNavGuestFormDelegate?
    fileprivate let viewModel: NavGuestFormViewModelType = NavGuestFormViewModel()
    
    @IBOutlet fileprivate weak var totalTitleLabel: UILabel!
    @IBOutlet fileprivate weak var totalValueLabel: UILabel!
    @IBOutlet fileprivate  weak var goPaymentButton: DesignableButton!
    
    public func configureWith(room: AvailableRoom) {
        self.viewModel.inputs.configWith(room: room)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.goPaymentButton.addTarget(self, action: #selector(bookingButtonTapped), for: .touchUpInside)
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.goPaymentButton
            |> UIButton.lens.backgroundColor .~ .tk_official_green
            |> UIButton.lens.titleColor(forState: .normal) .~ .white
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.goToPayment
            .observe(on: UIScheduler())
            .observeValues { [weak self] addOrder in
                print("ORDER STATUS: \(addOrder.diagnostic.confirm)")
                self?.goToPaymentMethodsVC()
        }
        
        self.viewModel.outputs.showLoadingOverlay
            .observe(on: UIScheduler())
            .observeValues { [weak self] overlay in
                print("TELL ME BUTTON TAPPED PROPERTY: \(overlay)")
                self?.delegate?.navGuestFormDidTapPayment(self!, loading: overlay)
        }
    }
    
    @objc fileprivate func goToPaymentMethodsVC() {
        let vc = FlightPaymentsTableVC.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc fileprivate func bookingButtonTapped() {
        self.viewModel.inputs.bookingButtonTapped()
    }
}
