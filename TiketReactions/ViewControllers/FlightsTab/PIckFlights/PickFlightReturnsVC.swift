//
//  PickFlightReturnsVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 26/08/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import UIKit
import TiketKitModels

public final class PickFlightReturnsVC: UIViewController {
    
    fileprivate let viewModel: PickFlightReturnsViewModelType = PickFlightReturnsViewModel()
    fileprivate let dataSource = PickFlightReturnsDataSource()
    
    @IBOutlet fileprivate weak var navContainerView: UIView!
    @IBOutlet fileprivate weak var cancelButton: UIButton!
    @IBOutlet fileprivate weak var filterButton: UIButton!
    @IBOutlet fileprivate weak var headingStackView: UIStackView!
    @IBOutlet fileprivate weak var routeLabel: UILabel!
    @IBOutlet fileprivate weak var headingDateLabel: UILabel!
    @IBOutlet fileprivate weak var navSeparatorView: UIView!
    @IBOutlet fileprivate weak var returnsTableView: UITableView!
    @IBOutlet fileprivate weak var footerContainerView: UIView!
    @IBOutlet fileprivate weak var nextStepsButton: UIButton!
    
    public static func configureWith(_ envelope: SearchFlightEnvelope, selectedDepart: Flight) -> PickFlightReturnsVC {
        let vc = Storyboard.PickFlight.instantiate(PickFlightReturnsVC.self)
        vc.viewModel.inputs.configureWith(envelope, departFlight: selectedDepart)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        self.nextStepsButton.addTarget(self, action: #selector(nextStepButtonTapped), for: .touchUpInside)
        
        self.returnsTableView.register(nib: .PickFlightNoticeViewCell)
        self.returnsTableView.register(nib: .FlightResultViewCell)
        self.returnsTableView.dataSource = dataSource
        self.returnsTableView.delegate = self
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.viewModel.inputs.viewWillAppear(animated)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.inputs.viewDidAppear()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.viewModel.inputs.viewDidDisappear(animated: animated)
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.returnsTableView
            |> UITableView.lens.backgroundColor .~ .white
            |> UITableView.lens.rowHeight .~ UITableViewAutomaticDimension
            |> UITableView.lens.estimatedRowHeight .~ 480.0
            |> UITableView.lens.separatorStyle .~ .none
        
        _ = self.routeLabel
            |> UILabel.lens.textColor .~ .tk_dark_grey_500
        
        _ = self.headingDateLabel
            |> UILabel.lens.textColor .~ .tk_dark_grey_500
        
        _ = self.cancelButton
            |> UIButton.lens.titleColor(forState: .normal) .~ .tk_official_green
        
        _ = self.filterButton
            |> UIButton.lens.titleColor(forState: .normal) .~ .tk_official_green
        
        _ = self.footerContainerView
            |> UIView.lens.isHidden .~ true
        
        _ = self.nextStepsButton
            |> UIButton.lens.backgroundColor .~ .tk_official_green
        
        _ = self.navSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.flights
            .observe(on: UIScheduler())
            .observeValues { [weak self] flights, notice in
                self?.dataSource.load(flights: flights, notice: notice)
                self?.returnsTableView.reloadData()
        }
        
        self.viewModel.outputs.showNextSteps
            .observe(on: UIScheduler())
            .observeValues { [weak self] showed in
                self?.footerContainerView.isHidden = false
        }
        
        self.viewModel.outputs.dismissToFirsts
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.dismiss(animated: true, completion: nil)
        }
        
        self.viewModel.outputs.goToCartFlight
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] (departure: Flight, arrival: Flight) in
                self?.goToSelectedFlights(cartIn: departure, arrival: arrival)
        }
    }
    
    fileprivate func goToSelectedFlights(cartIn departure: Flight, arrival: Flight) {
        let summaryVC = FlightSummariesVC.configureWith(departure, returned: arrival)
        self.navigationController?.pushViewController(summaryVC, animated: true)
    }
    
    @objc fileprivate func cancelButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func nextStepButtonTapped() {
        self.viewModel.inputs.tappedButtonNextStep()
    }
}

extension PickFlightReturnsVC: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let flight = self.dataSource.flightAtIndexPath(indexPath) {
            self.viewModel.inputs.tapped(flight: flight)
        }
    }
}


