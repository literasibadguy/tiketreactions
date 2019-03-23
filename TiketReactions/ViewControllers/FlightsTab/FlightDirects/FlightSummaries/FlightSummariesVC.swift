//
//  FlightSummariesVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 05/09/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit
import Prelude
import ReactiveSwift
import TiketKitModels

public final class FlightSummariesVC: UIViewController {

    fileprivate let viewModel: FlightSummariesViewModelType = FlightSummariesViewModel()
    fileprivate let dataSource = FlightSummariesDataSource()
    
    @IBOutlet fileprivate weak var summaryTableView: UITableView!
    @IBOutlet fileprivate weak var nextStepButton: UIButton!
    @IBOutlet fileprivate weak var loadingOverlayView: UIView!
    @IBOutlet fileprivate weak var grayActivityIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var labelActivityIndicator: UILabel!
    
    public static func configureWith(_ first: Flight, returned: Flight) -> FlightSummariesVC {
        let vc = Storyboard.FlightDirects.instantiate(FlightSummariesVC.self)
        vc.viewModel.inputs.configureWith(first: first, returned: returned)
        return vc
    }
    
    public static func configureSingleWith(_ first: Flight) -> FlightSummariesVC {
        let vc = Storyboard.FlightDirects.instantiate(FlightSummariesVC.self)
        vc.viewModel.inputs.configureSingleWith(first)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Flight Summary"
        
        self.summaryTableView.register(nib: .FlightDirectViewCell)
        self.summaryTableView.register(nib: .ValueTotalFlightViewCell)
        self.summaryTableView.register(nib: .NoticeSummaryViewCell)
        self.summaryTableView.dataSource = dataSource
        
        self.nextStepButton.addTarget(self, action: #selector(nextStepButtonTapped), for: .touchUpInside)
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.summaryTableView
            |> UITableView.lens.backgroundColor .~ .tk_base_grey_100
            |> UITableView.lens.rowHeight .~ UITableViewAutomaticDimension
            |> UITableView.lens.estimatedRowHeight .~ 480.0
            |> UITableView.lens.separatorStyle .~ .none
        
        _ = self.nextStepButton
            |> UIButton.lens.backgroundColor .~ .tk_official_green
            |> UIButton.lens.title(forState: .normal) .~ Localizations.OrderTitleButtonPickFlight
        
        _ = self.labelActivityIndicator
            |> UILabel.lens.text .~ Localizations.BookingattentionTitle
        
        _ = self.loadingOverlayView
            |> UIView.lens.isHidden .~ true
        
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.loadingOverlayView.rac.hidden = self.viewModel.outputs.getFlightDataLoading.negate()
        self.grayActivityIndicator.rac.animating = self.viewModel.outputs.getFlightDataLoading
        
        self.viewModel.outputs.loadSingleFlightSource
            .observe(on: UIScheduler())
            .observeValues { [weak self] single in
                self?.dataSource.loadSingle(single)
                self?.summaryTableView.reloadData()
        }
        
        self.viewModel.outputs.loadFlightSources
            .observe(on: UIScheduler())
            .observeValues { [weak self] first, returned in
                self?.dataSource.load(first: first, returned: returned)
                self?.summaryTableView.reloadData()
        }
        
        self.viewModel.outputs.loadPriceValueTotal
            .observe(on: UIScheduler())
            .observeValues { [weak self] total in
                self?.dataSource.load(total)
                self?.summaryTableView.reloadData()
        }
        
        self.viewModel.outputs.goToPassengerList
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] flightData in
                self?.goToPassengerList(flightData)
        }
    }
    
    fileprivate func goToPassengerList(_ envelope: GetFlightDataEnvelope) {
        let passengerVC = PassengersListVC.configureWith(envelope)
        self.navigationController?.pushViewController(passengerVC, animated: true)
    }
    
    @objc fileprivate func nextStepButtonTapped() {
        self.viewModel.inputs.nextStepsButtonTapped()
    }
}
