//
//  HotelDiscoveryVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 08/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import TiketAPIs
import UIKit

class HotelDiscoveryVC: UITableViewController {
    fileprivate var emptyStatesController: EmptyStatesVC?
    fileprivate let dataSource = HotelDiscoveryDataSource()
    fileprivate let loadingIndicatorView = UIActivityIndicatorView()
    
    fileprivate let viewModel: HotelDiscoveryViewModelType = HotelDiscoveryViewModel()
    
    static func configuredWith(sort: SearchHotelParams) -> HotelDiscoveryVC {
        let vc = Storyboard.HotelDiscovery.instantiate(HotelDiscoveryVC.self)
        vc.viewModel.inputs.selectedFilter(sort)
        return vc
    }
    
    static func instantiate() -> HotelDiscoveryVC {
        let vc = Storyboard.HotelDiscovery.instantiate(HotelDiscoveryVC.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.addSubview(self.loadingIndicatorView)
        
        self.tableView.dataSource = dataSource
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         self.viewModel.inputs.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
         self.viewModel.inputs.viewDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
         self.viewModel.inputs.viewDidDisappear(animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.loadingIndicatorView.center = self.tableView.center
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> baseTableControllerStyle(estimatedRowHeight: 300.0)
        
        _ = self.loadingIndicatorView
            |> baseActivityIndicatorStyle
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        print("[HOTEL DISCOVERY VC]: Hotel Discovery VC Bind View Model")
        
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
        
        self.viewModel.outputs.goToHotel
            .observe(on: UIScheduler())
            .observeValues { [weak self] hotelResult in
                print("GET ME LINK: \(hotelResult.businessURI)")
                self?.goTo(hotel: hotelResult)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let hotel = self.dataSource.hotelAtIndexPath(indexPath) {
            self.viewModel.inputs.tapped(hotel: hotel)
        }
    }
    
    fileprivate func goTo(hotel: HotelResult) {
        let vc = HotelDetailsVC.configureWith(hotelResult: hotel)
        let navHotelVC = UINavigationController(rootViewController: vc)
        self.present(navHotelVC, animated: true, completion: nil)
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
