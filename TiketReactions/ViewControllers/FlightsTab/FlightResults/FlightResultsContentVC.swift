//
//  FlightResultsContentVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 30/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import Result
import TiketAPIs
import UIKit

public final class FlightResultsContentVC: UITableViewController {
    fileprivate var emptyStatesController: EmptyStatesVC?
    fileprivate let dataSource = FlightResultsDataSource()
    fileprivate let loadingIndicatorView = UIActivityIndicatorView()
    
    fileprivate let viewModel: FlightResultsContentViewModelTypes = FlightResultsContentViewModel()
    
    public static func instantiate(sort: SearchFlightParams) -> FlightResultsContentVC {
        let vc = Storyboard.FlightResults.instantiate(FlightResultsContentVC.self)
        vc.viewModel.inputs.configureWith(sort: sort)
        return vc
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.addSubview(self.loadingIndicatorView)
        self.tableView.dataSource = dataSource
        
        self.tableView.register(nib: .FlightResultViewCell)
        
        let emptyVC = EmptyStatesVC.configuredWith(emptyState: nil)
        self.emptyStatesController = emptyVC
        self.addChildViewController(emptyVC)
        self.view.addSubview(emptyVC.view)
        NSLayoutConstraint.activate([
            emptyVC.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            emptyVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            emptyVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            emptyVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
        emptyVC.didMove(toParentViewController: self)
    }
    
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.flights
            .observe(on: UIScheduler())
            .observeValues { [weak self] flights in
                self?.dataSource.load()
                self?.tableView.reloadData()
        }
        
        self.viewModel.outputs.hideEmptyState
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.emptyStatesController?.view.alpha = 0
                self?.emptyStatesController?.view.isHidden = true
        }
    }
    
    fileprivate func goTo(flight: Flight) {
        let vc = FlightDirectsVC.instantiate()
        self.present(vc, animated: true, completion: nil)
    }
    
    fileprivate func showEmptyState(_ emptyState: String) {
        guard let emptyVC = self.emptyStatesController else { return }
        
        emptyVC.view.isHidden = false
        self.view.bringSubview(toFront: emptyVC.view)
        UIView.animate(withDuration: 0.3, animations: {
            self.emptyStatesController?.view.alpha = 1.0
        }, completion: nil)
    }
}
