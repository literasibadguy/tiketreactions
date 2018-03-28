//
//  HotelDetailsVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 02/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import ReactiveSwift
import TiketAPIs
import UIKit

protocol HotelDetailsVCDelegate: class {
    func hotelDetails(_ controller: HotelDetailsVC, panGestureRecognizerDidChange recognizer: UIPanGestureRecognizer)
}

public final class HotelDetailsVC: UIViewController {
    weak var delegate: HotelDetailsVCDelegate?
    fileprivate let viewModel: HotelDetailsViewModelType = HotelDetailsViewModel()
    
    fileprivate var navDetailsVC: HotelDetailsNavVC!
    fileprivate var directsHotelVC: HotelDirectsVC!
    
    @IBOutlet weak private var navBarTopConstraint: NSLayoutConstraint!
    
    public static func configureWith(hotelResult: HotelResult) -> HotelDetailsVC {
        let vc = Storyboard.HotelDirects.instantiate(HotelDetailsVC.self)
        vc.viewModel.inputs.configureWith(hotelResult: hotelResult)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navDetailsVC = self.childViewControllers.flatMap { $0 as? HotelDetailsNavVC }.first
        self.directsHotelVC = self.childViewControllers.flatMap { $0 as? HotelDirectsVC }.first
        
        
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
        .observeValues { [weak self] hotelDirect in
            self?.directsHotelVC.configureWith(hotelDirect: hotelDirect)
            print("What Values: \(hotelDirect)")

        }
        
        self.viewModel.outputs.setNavigationBarHiddenAnimated
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.navigationController?.setNavigationBarHidden($0, animated: $1)
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
