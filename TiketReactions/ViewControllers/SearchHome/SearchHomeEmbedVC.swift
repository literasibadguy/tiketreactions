//
//  SearchHomeEmbedVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 04/11/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import UIKit

public final class SearchHomeEmbedVC: UIViewController {
    
    private weak var flightViewController: BetweenFormsVC!
    
    private var viewModel: SearchHomeEmbedViewModelType = SearchHomeEmbedViewModel()
    
    @IBOutlet private weak var mainCurrentDateLabel: UILabel!
    @IBOutlet private weak var flightButton: UIButton!
    @IBOutlet private weak var hotelButton: UIButton!
    @IBOutlet private weak var selectedFormSeparatorView: UIView!
    @IBOutlet private weak var embedView: UIView!
    @IBOutlet private weak var buttonFormStackView: UIStackView!
    @IBOutlet private weak var equalWidthFormSeparatorView: NSLayoutConstraint!
    @IBOutlet private weak var alignLeadingFormSeparatorView: NSLayoutConstraint!
    
    private var visibleViewController: UIViewController?
    private var flightVC: FlightFormVC!
    private var hotelVC: HotelLiveFormVC!
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    public static func instanitate() -> SearchHomeEmbedVC {
        let vc = Storyboard.FlightForm.instantiate(SearchHomeEmbedVC.self)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.flightButton.addTarget(self, action: #selector(flightButtonTapped), for: .touchUpInside)
        self.hotelButton.addTarget(self, action: #selector(hotelButtonTapped), for: .touchUpInside)
        
        self.flightViewController = self.childViewControllers.compactMap { $0 as? BetweenFormsVC }.first
        
        // Do any additional setup after loading the view.
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.mainCurrentDateLabel.rac.text = self.viewModel.outputs.homeDateText
        
        self.viewModel.outputs.showFomrsController
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.setupFormControllers()
        }
        
        self.viewModel.outputs.flightFormVisible
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                guard let _self = self else { return }
                _self.pinSelectedIndicator(for: _self.flightButton, animated: true)
                _self.showController(_self.flightVC)
        }
        
        self.viewModel.outputs.hotelFormVisible
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                guard let _self = self else { return }
                _self.pinSelectedIndicator(for: _self.hotelButton, animated: true)
                _self.showController(_self.hotelVC)
        }
    }
    
    private func setupFormControllers() {
        let flightViewController = FlightFormVC.instantiate()
        addChildViewController(flightViewController)
        flightViewController.didMove(toParentViewController: self)
        self.flightVC = flightViewController
        
        let hotelViewController = HotelLiveFormVC.instantiate()
        addChildViewController(hotelViewController)
        hotelViewController.didMove(toParentViewController: self)
        self.hotelVC = hotelViewController
        
        self.showController(self.flightVC)
    }
    
    private func pinSelectedIndicator(for button: UIButton, animated: Bool) {
        let leadingConstant = button.frame.origin.x
        let widthConstant = button.titleLabel?.frame.size.width ?? button.frame.size.width
        
        UIView.animate(
            withDuration: animated ? 0.2 : 0.0,
            delay: 0.0,
            options: .curveEaseOut,
            animations: {
                self.selectedFormSeparatorView.setNeedsLayout()
                self.alignLeadingFormSeparatorView.constant = leadingConstant
                self.equalWidthFormSeparatorView.constant = widthConstant
                self.selectedFormSeparatorView.layoutIfNeeded()
        },
            completion: nil)
    }
    
    private func showController(_ viewController: UIViewController) {
        guard visibleViewController != viewController else { return }
        
        viewController.view.frame = self.embedView.bounds
        viewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        viewController.view.layoutIfNeeded()
        
        if let visibleViewController = visibleViewController {
            visibleViewController.view.removeFromSuperview()
        }
        else {
            self.embedView.addSubview(viewController.view)
        }
    }
    
    @objc private func flightButtonTapped() {
        self.viewModel.inputs.flightButtonTapped()
    }
    
    @objc private func hotelButtonTapped() {
        self.viewModel.inputs.hotelButtonTapped()
    }
}
