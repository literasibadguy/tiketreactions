//
//  FlightDirectsNavVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 30/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import Spring
import TiketKitModels
import UIKit


public final class FlightDirectsNavVC: UIViewController {
    
    fileprivate let viewModel: FlightDirectsNavViewModelType = FlightDirectsNavViewModel()
    
    @IBOutlet fileprivate weak var totalTitleLabel: UILabel!
    @IBOutlet fileprivate weak var totalValuePriceLabel: UILabel!
    
    @IBOutlet fileprivate weak var bookingButton: DesignableButton!
    
    public static func instantiate() -> FlightDirectsNavVC {
        let vc = Storyboard.FlightDirects.instantiate(FlightDirectsNavVC.self)
        return vc
    }
    
    internal func configureWith(flight: Flight, returned: Flight?) {
        self.viewModel.inputs.configureWith(flight: flight)
    }
    
    internal func configureWith(passengers: GroupPassengersParam) {
        self.viewModel.inputs.changedParams(params: passengers)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.bookingButton.addTarget(self, action: #selector(orderButtonTapped), for: .touchUpInside)
        
        self.viewModel.inputs.viewDidLoad()
    }

    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.totalTitleLabel
            |> UILabel.lens.textColor .~ .gray
        
        _ = self.bookingButton
            |> UIButton.lens.backgroundColor .~ .tk_official_green
            |> UIButton.lens.titleColor(forState: .normal) .~ .white
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.addOrder
            .observe(on: UIScheduler())
            .observeValues { [weak self] order in
                print("IS THERE ANY ORDER OUTPUTS: \(order)")
                self?.goToPaymentMethods()
        }
    }
    
    @objc fileprivate func orderButtonTapped() {
        print("ORDER BUTTON TAPPED INPUT")
        self.viewModel.inputs.addOrderButtonTapped()
    }
    
    fileprivate func goToPaymentMethods() {
        let availablePaymentsVC = FlightPaymentsTableVC.instantiate()
        self.navigationController?.pushViewController(availablePaymentsVC, animated: true)
    }
}
