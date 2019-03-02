//
//  HotelContainerGuestFormVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 15/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

protocol HotelContainerGuestFormDelegate: class {
    func goToOrderLists(_ controller: HotelContainerGuestFormVC, param: CheckoutGuestParams)
}

public final class HotelContainerGuestFormVC: UIViewController {
    internal weak var delegate: HotelContainerGuestFormDelegate?
    fileprivate let viewModel: HotelEmbedGuestFormViewModelType = HotelEmbedGuestFormViewModel()
    
    fileprivate var contentController: HotelGuestFormVC!
    fileprivate var bookingController: HotelNavGuestFormVC!
    
    fileprivate let backButton = UIBarButtonItem()
    
    
    @IBOutlet fileprivate weak var loadingOverlayLabel: UILabel!
    @IBOutlet fileprivate weak var loadingOverlayView: UIView!
    @IBOutlet fileprivate weak var loadingIndicatorView: UIActivityIndicatorView!
    
    internal static func configureWith(hotelDirect: HotelDirect, room: AvailableRoom, summary: HotelBookingSummary) -> HotelContainerGuestFormVC {
        let vc = Storyboard.HotelGuestForm.instantiate(HotelContainerGuestFormVC.self)
        vc.viewModel.inputs.configureWith(hotelDirect: hotelDirect, availableRoom: room, booking: summary)
        return vc
    }
    
     public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.contentController = self.childViewControllers.compactMap { $0 as? HotelGuestFormVC }.first
        self.contentController.delegate = self
        self.bookingController = self.childViewControllers.compactMap { $0 as? HotelNavGuestFormVC }.first
        self.bookingController.delegate = self
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        self.navigationItem.backBarButtonItem = backButton
        
        _ = self.backButton
            |> UIBarButtonItem.lens.tintColor .~ .tk_official_green
        
        _ = self.loadingOverlayLabel
            |> UILabel.lens.isHidden .~ true
            |> UILabel.lens.text .~ Localizations.BookingattentionTitle
        
        _ = self.loadingIndicatorView
            |> baseActivityIndicatorStyle
        
        _ = self.loadingOverlayView
            |> UIView.lens.backgroundColor .~ UIColor(white: 1.0, alpha: 0.99)
        
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.loadingIndicatorView.rac.animating = self.viewModel.outputs.orderIsLoading
        self.loadingOverlayLabel.rac.hidden = self.viewModel.outputs.loadingOverlayIsHidden
        self.loadingOverlayView.rac.hidden = self.viewModel.outputs.loadingOverlayIsHidden
        
        self.viewModel.outputs.configureEmbedVCWithHotelAndRoom
            .observe(on: UIScheduler())
            .observeValues { [weak self] hotel, room, summary in
                print("CONFIGURE EMBED ROOM: \(room)")
                self?.contentController.configureWith(hotelDirect: hotel, availableRoom: room, booking: summary)
                self?.bookingController.configureWith(room: room)
        }
        
        self.viewModel.outputs.configureGuestFormParam
            .observe(on: UIScheduler())
            .observeValues { [weak self] guestForm in
                print("CONFIGURE GUEST FORM PARAM: \(guestForm)")
                self?.bookingController.configureGuestForm(guestForm: guestForm)
        }
        
        self.viewModel.outputs.notifyEnabled
            .observe(on: UIScheduler())
            .observeValues { [weak self] enabled in
                self?.bookingController.formed(enable: enabled)
        }
        
        self.viewModel.outputs.remindAlert
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] remind in
                self?.present(UIAlertController.alert(message: remind, confirm: {
                    _ in self?.viewModel.inputs.remindAlertTappedOK(shouldCheckOut: true)
                }, cancel: { _ in self?.viewModel.inputs.remindAlertTappedOK(shouldCheckOut: false) }), animated: true, completion: nil)
        }
        
        self.viewModel.outputs.dismissAlert
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
        }
        
        self.viewModel.outputs.errorAlert
            .observe(on: UIScheduler())
            .observeValues { [weak self] errorReason in
                self?.present(UIAlertController.genericError(message: errorReason, cancel: {
                    _ in self?.viewModel.inputs.errorAlertTappedOK(shouldDismiss: true)
                }), animated: true, completion: nil)
        }
        
        self.viewModel.outputs.isLoginCompleted
            .observe(on: UIScheduler())
            .observeValues { [weak self] hotelLogin in
                print("WHATS STATUS HOTEL DIAGNOSTIC: \(hotelLogin.diagnostic)")
                print("WHATS STATUS HOTEL LOGIN: \(hotelLogin.loginStatus)")
                self?.viewModel.inputs.tellsToCheckoutCustomer(status: hotelLogin.loginStatus)
        }
        
        self.viewModel.outputs.goToPayments
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] myOrder in
                self?.goToPayments(myOrder)
        }
    }
    
    fileprivate func goToPayments(_ order: MyOrder) {
//        let paymentVC = HotelPaymentsVC.configureWith(myorder: order)
        let listPaymentVC = PaymentsListVC.configureWith(myorder: order)
        self.navigationController?.pushViewController(listPaymentVC, animated: true)
    }
}

extension HotelContainerGuestFormVC: PassengerTitlePickerVCDelegate {
    func passengerTitlePickerVC(_ controller: PassengerTitlePickerVC, choseTitle: String) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func passengerTitlePickerVCCancelled(_ controller: PassengerTitlePickerVC) {
        print("Passenger Title Picker VC Cancelled..")
        self.dismiss(animated: true , completion: nil)
    }
}

extension HotelContainerGuestFormVC: HotelNavGuestFormDelegate {
    public func navGuestFormDidTapPayment(_ controller: HotelNavGuestFormVC, loading: Bool) {
       
    }
    public func bookingButtonTapped(_ controller: HotelNavGuestFormVC) {
        self.viewModel.inputs.bookingButtonTapped()
    }
}

extension HotelContainerGuestFormVC: HotelGuestFormDelegate {
    public func shouldFirstGuestForm(_ valid: Bool) {
        self.viewModel.inputs.isFormFilled(valid)
    }
    
    public func shouldThereAnotherGuest(_ should: Bool) {
        self.viewModel.inputs.isThereAnotherGuest(should)
    }
    
    public func preparedFinalCheckoutParam(_ param: CheckoutGuestParams) {
        self.viewModel.inputs.configFormOrder(param)
    }
    
}
