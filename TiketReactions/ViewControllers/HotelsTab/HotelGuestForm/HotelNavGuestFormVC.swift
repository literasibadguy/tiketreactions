//
//  HotelNavGuestFormVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 15/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

public protocol HotelNavGuestFormDelegate: class {
    func navGuestFormDidTapPayment(_ controller: HotelNavGuestFormVC, loading: Bool)
    func bookingButtonTapped(_ controller: HotelNavGuestFormVC)
}

public final class HotelNavGuestFormVC: UIViewController {
    internal weak var delegate: HotelNavGuestFormDelegate?
    fileprivate let viewModel: NavGuestFormViewModelType = NavGuestFormViewModel()
    
    @IBOutlet fileprivate weak var totalTitleLabel: UILabel!
    @IBOutlet fileprivate weak var totalValueLabel: UILabel!
    @IBOutlet fileprivate  weak var goPaymentButton: UIButton!
    
    internal func configureWith(room: AvailableRoom) {
        self.viewModel.inputs.configWith(room: room)
    }
    
    internal func configureGuestForm(guestForm: CheckoutGuestParams) {
        self.viewModel.inputs.configFormGuest(guestForm)
    }
    
    internal func formed(enable: Bool) {
        self.viewModel.inputs.form(completed: enable)
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
            |> UIButton.lens.backgroundColor(forState: .normal) .~ .tk_official_green
            |> UIButton.lens.titleColor(forState: .normal) .~ .white
            |> UIButton.lens.backgroundColor(forState: .disabled) .~ .tk_typo_green_grey_500
            |> UIButton.lens.isEnabled .~ false
            |> UIButton.lens.title(forState: .normal) .~ Localizations.ChoosepaymentTitle
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.goPaymentButton.rac.isEnabled = self.viewModel.outputs.isCheckoutButtonEnabled
        self.totalValueLabel.rac.text = self.viewModel.outputs.totalPriceText
        
        self.viewModel.outputs.diagnosticEvent
            .observe(on: UIScheduler())
            .observeValues { status in
                print("DIAGNOSTIC STATUS: \(status)")
        }
        
        self.viewModel.outputs.showLoadingOverlay
            .observe(on: UIScheduler())
            .observeValues { [weak self] overlay in
                print("TELL ME BUTTON TAPPED PROPERTY: \(overlay)")
                self?.delegate?.navGuestFormDidTapPayment(self!, loading: overlay)
                self?.delegate?.bookingButtonTapped(self!)
        }
        
        self.viewModel.outputs.checkoutGuestParam
            .observe(on: UIScheduler())
            .observeValues { guestData in
                print("WHO IS GUEST First Name FROM BOOKING RECEIPT: \(String(describing: guestData.conFirstName))")
                print("WHO IS GUEST Last Name FROM BOOKING RECEIPT: \(String(describing: guestData.conLastName))")
                print("WHO IS GUEST PHONE: \(String(describing: guestData.conPhone))")
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
