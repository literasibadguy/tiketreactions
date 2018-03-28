//
//  HotelContainerGuestFormVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 15/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import TiketAPIs
import UIKit

internal final class HotelContainerGuestFormVC: UIViewController {
    fileprivate let viewModel: HotelEmbedGuestFormViewModelType = HotelEmbedGuestFormViewModel()
    
    fileprivate var contentController: HotelGuestFormVC!
    fileprivate var bookingController: HotelNavGuestFormVC!
    
    @IBOutlet fileprivate weak var loadingOverlayView: UIView!
    @IBOutlet fileprivate weak var loadingIndicatorView: UIActivityIndicatorView!
    
    internal static func configureWith(hotelDirect: HotelDirect, room: AvailableRoom) -> HotelContainerGuestFormVC {
        let vc = Storyboard.HotelGuestForm.instantiate(HotelContainerGuestFormVC.self)
        vc.viewModel.inputs.configureWith(hotelDirect: hotelDirect, availableRoom: room)
        return vc
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.contentController = self.childViewControllers.flatMap { $0 as? HotelGuestFormVC }.first
        self.bookingController = self.childViewControllers.flatMap { $0 as? HotelNavGuestFormVC }.first
        self.bookingController.delegate = self
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.viewModel.inputs.viewWillAppear(animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel.inputs.viewDidAppear(animated: animated)
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self.loadingIndicatorView
            |> baseActivityIndicatorStyle
        
        _ = self.loadingOverlayView
            |> UIView.lens.backgroundColor .~ UIColor(white: 1.0, alpha: 0.99)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.loadingIndicatorView.rac.animating = self.viewModel.outputs.orderIsLoading
        self.loadingOverlayView.rac.hidden = self.viewModel.outputs.loadingOverlayIsHidden
        
        self.viewModel.outputs.configureEmbedVCWithHotelAndRoom
            .observe(on: UIScheduler())
            .observeValues { [weak self] hotel, room in
                print("CONFIGURE EMBED ROOM: \(room)")
                self?.contentController.configureWith(hotelDirect: hotel, availableRoom: room)
                self?.bookingController.configureWith(room: room)
        }
        
    }
}

extension HotelContainerGuestFormVC: HotelNavGuestFormDelegate {
    func navGuestFormDidTapPayment(_ controller: HotelNavGuestFormVC, loading: Bool) {
        
    }
}

