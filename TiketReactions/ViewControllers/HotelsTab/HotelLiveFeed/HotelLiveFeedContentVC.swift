//
//  HotelLiveFeedContentVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 06/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import UIKit
import TiketKitModels

internal final class HotelLiveFeedContentVC: UITableViewController {
    fileprivate var emptyStatesController: EmptyStatesVC? = nil
    fileprivate let dataSource = HotelDiscoveryDataSource()
    fileprivate let loadingIndicatorView = UIActivityIndicatorView()
    
    fileprivate let viewModel: HotelLiveFeedContentViewModelType = HotelLiveFeedContentViewModel()
    
    internal static func configureWith(params: SearchHotelParams) -> HotelLiveFeedContentVC {
        let vc = Storyboard.HotelLiveFeed.instantiate(HotelLiveFeedContentVC.self)
        vc.viewModel.inputs.selectedFilter(params)
        return vc
    }
    
    internal func change(filter: SearchHotelParams) {
        self.viewModel.inputs.selectedFilter(filter)
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.addSubview(self.loadingIndicatorView)
        self.tableView.dataSource = self.dataSource
        
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
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.inputs.viewWillAppear()
    }
    
    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel.inputs.viewDidAppear()
    }
    
    internal override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.viewModel.inputs.viewDidDisappear(animated)
    }
    
    internal override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.loadingIndicatorView.center = self.tableView.center
    }
    
    internal override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> baseTableControllerStyle()
        
        _ = self.loadingIndicatorView
            |> baseActivityIndicatorStyle
    }
    
    internal override func bindViewModel() {
        super.bindViewModel()
        
        self.loadingIndicatorView.rac.animating = self.viewModel.outputs.hotelsAreLoading
        
        self.viewModel.outputs.hotels
            .observe(on: UIScheduler())
            .observeValues { [weak self] hotels in
                self?.dataSource.load(hotelResult: hotels)
                self?.tableView.reloadData()
        }
        
        self.viewModel.outputs.showEmptyState
            .observe(on: UIScheduler())
            .observeValues { [weak self] emptyState in
                self?.showEmptyState(emptyState)
        }
        
        self.viewModel.outputs.hideEmptyState
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.emptyStatesController?.view.alpha = 0
                self?.emptyStatesController?.view.isHidden = true

        }
    }
    
    fileprivate func showEmptyState(_ emptyState: EmptyState) {
        guard let emptyVC = self.emptyStatesController else { return }
        
        emptyVC.setEmptyState(emptyState)
        emptyVC.view.isHidden = false
        self.view.bringSubview(toFront: emptyVC.view)
        UIView.animate(withDuration: 0.3, animations: {
            self.emptyStatesController?.view.alpha = 1.0
        }, completion: nil)
    }
}
