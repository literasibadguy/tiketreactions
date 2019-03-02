//
//  FlightResultsNavVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 31/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

public protocol FlightResultsNavDelegate: class {
    func goingBackToPickingDate(_ resultsNavVC: FlightResultsNavVC)
    func flightResultsNavigationHeaderSelectedParams(_ params: SearchFlightParams)
}

public final class FlightResultsNavVC: UIViewController {
    
    fileprivate let viewModel: FlightResultsNavViewModelType = FlightResultsNavViewModel()
    
    public weak var delegate: FlightResultsNavDelegate?
    
    @IBOutlet fileprivate weak var navResultsStackView: UIStackView!
    
    @IBOutlet fileprivate weak var cancelButton: UIButton!
    
    @IBOutlet fileprivate weak var headStackView: UIStackView!
    @IBOutlet fileprivate weak var routeTitleLabel: UILabel!
    @IBOutlet fileprivate weak var dateTitleLabel: UILabel!
    
    @IBOutlet fileprivate weak var filterButton: UIButton!
    @IBOutlet fileprivate weak var navSeparatorView: UIView!
    
    internal func configureWith(envelopeFlight: SearchFlightEnvelope) {
        self.viewModel.inputs.configureEnvelope(flightEnvelope: envelopeFlight)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        self.viewModel.inputs.viewDidLoad()
    }

    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.filterButton
            |> UIButton.lens.titleColor(forState: .normal) .~ .tk_official_green
        
        _ = self.routeTitleLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.dateTitleLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.navSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.routeTitleLabel.rac.text = self.viewModel.outputs.departureAirportCodeText
        
        self.viewModel.outputs.backToPickDates
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                guard let _self = self else { return }
                _self.delegate?.goingBackToPickingDate(_self)
        }
    }
    
    @objc fileprivate func cancelButtonTapped() {
        self.viewModel.inputs.tappedButtonCancel()
    }
}
