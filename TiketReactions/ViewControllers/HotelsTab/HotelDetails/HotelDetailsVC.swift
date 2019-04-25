//
//  HotelDetailsVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 02/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import ReactiveSwift
import TiketKitModels
import UIKit

protocol HotelDetailsVCDelegate: class {
    func hotelDetails(_ controller: HotelDetailsVC, panGestureRecognizerDidChange recognizer: UIPanGestureRecognizer)
}

public final class HotelDetailsVC: UIViewController {
    weak var delegate: HotelDetailsVCDelegate?
    fileprivate let viewModel: HotelDetailsViewModelType = HotelDetailsViewModel()
    
    fileprivate var navDetailsVC: HotelDetailsNavVC!
    fileprivate var directsHotelVC: HotelDirectsVC!
    fileprivate var navRoomsVC: PickRoomNavVC!
    
    @IBOutlet weak private var navBarTopConstraint: NSLayoutConstraint!
    
    public static func configureWith(hotelResult: HotelResult, booking: HotelBookingSummary) -> HotelDetailsVC {
        let vc = Storyboard.HotelDirects.instantiate(HotelDetailsVC.self)
        vc.viewModel.inputs.configureWith(hotelResult: hotelResult, booking: booking)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navDetailsVC = self.children.compactMap { $0 as? HotelDetailsNavVC }.first
        self.directsHotelVC = self.children.compactMap { $0 as? HotelDirectsVC }.first
        self.navRoomsVC = self.children.compactMap { $0 as? PickRoomNavVC }.first
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.inputs.viewWillAppear(animated: animated)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setInitial(constraints: [navBarTopConstraint], constant: initialTopConstraint)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.inputs.viewDidAppear(animated: animated)
    }
    
    private var initialTopConstraint: CGFloat {
        if #available(iOS 11.0, *) {
            return parent?.view.safeAreaInsets.top ?? 0.0
        } else {
            return UIApplication.shared.statusBarFrame.size.height
        }
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        print("Hotel Details Configure Bind View Model..!")
        
        self.viewModel.outputs.configureChildVCHotelDirect
        .observe(on: UIScheduler())
        .observeValues { [weak self] selected, hotelDirect, summary in
            self?.navDetailsVC.configureWith(selected: selected)
            self?.directsHotelVC.configureWith(selected: selected, hotelDirect: hotelDirect, booking: summary)
            self?.navRoomsVC.configureWith(hotel: hotelDirect, booking: summary)
        }
        
        self.viewModel.outputs.setNavigationBarHiddenAnimated
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.navigationController?.setNavigationBarHidden($0, animated: $1)
        }
        
        self.viewModel.outputs.genericError
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] error in
                self?.present(UIAlertController.genericError("Ooops..", message: error, cancel: { _ in self?.dismiss(animated: true, completion: nil) }), animated: true, completion: nil)
        }
        
        self.viewModel.outputs.topLayoutConstraintConstant
            .observe(on: UIScheduler())
            .observeValues { [weak self] value in
                self?.navBarTopConstraint.constant = value
        }
    }
    
    private func setInitial(constraints: [NSLayoutConstraint?], constant: CGFloat) {
        constraints.forEach {
            $0?.constant = constant
        }
    }
}

extension HotelDetailsVC: HotelDirectsVCDelegate {
    func hotelDirects(_ controller: HotelDirectsVC, scrollViewPanGestureRecognizerDidChange recognizer: UIPanGestureRecognizer) {
        self.delegate?.hotelDetails(self, panGestureRecognizerDidChange: recognizer)
    }
}
