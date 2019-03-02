//
//  HotelDirectsVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 01/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

protocol HotelDirectsVCDelegate: class {
    func hotelDirects(_ controller: HotelDirectsVC, scrollViewPanGestureRecognizerDidChange recognizer: UIPanGestureRecognizer)
}

public final class HotelDirectsVC: UITableViewController {
    
    fileprivate let dataSource = HotelDirectsContentDataSource()
    weak var delegate: HotelDirectsVCDelegate?
    fileprivate let viewModel: HotelDirectsViewModelType = HotelDirectsViewModel()
    fileprivate let activityIndicator = UIActivityIndicatorView()
    
    internal func configureWith(selected: HotelResult, hotelDirect: HotelDirect, booking: HotelBookingSummary) {
        self.viewModel.inputs.configureWith(selected: selected, hotelDirect: hotelDirect, booking: booking)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.addSubview(self.activityIndicator)
        self.tableView.dataSource = dataSource
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.inputs.viewWillAppear(animated: animated)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.inputs.viewDidAppear(animated: animated)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.activityIndicator.center = self.tableView.center
    }
    
    override public func bindStyles() {
        super.bindStyles()
        
        _ = self.activityIndicator
            |> baseActivityIndicatorStyle
            |> UIActivityIndicatorView.lens.animating .~ true
        
        _ = self
            |> baseTableControllerStyle(estimatedRowHeight: 850)
            |> (UITableViewController.lens.tableView..UITableView.lens.delaysContentTouches) .~ false
            |> (UITableViewController.lens.tableView..UITableView.lens.canCancelContentTouches) .~ true
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.activityIndicator.rac.animating = self.viewModel.outputs.directsAreLoading
        
        self.viewModel.outputs.loadHotelDirect
            .observe(on: UIScheduler())
            .observeValues { [weak self] selected, hotelDirect in
                self?.dataSource.load(selected: selected, hotelDirect: hotelDirect)
                self?.tableView.reloadData()
        }
        
        self.viewModel.outputs.goToRoomAvailable
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] hotel, room, summary in
                self?.goToOrderGuestForm(hotelDirect: hotel, availableRoom: room, booking: summary)
        }
        
        
        self.viewModel.outputs.goToFacilities
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] facilities in
                let vc = FacilityListVC.configureWith(facilities: facilities)
                self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.viewModel.outputs.goToFullMapHotel
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] result in
                self?.goToEmbedMap(result: result)
        }
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let facilities = self.dataSource[indexPath] as? String {
            self.viewModel.inputs.tapHotelFacility(facilities)
        }
        
        if indexPath == self.dataSource.indexPathForMapCell() {
            print("Tapped Map Available")
            self.viewModel.inputs.tappedMapEmbed()
        }
        
        if let availableRoom = self.dataSource[indexPath] as? AvailableRoom {
            print("Tapped Room Available")
            self.viewModel.inputs.tappedRoomAvailable(availableRoom: availableRoom)
        }
        
        
    }
    
    private func goToOrderGuestForm(hotelDirect: HotelDirect, availableRoom: AvailableRoom, booking: HotelBookingSummary) {
        let vc = HotelContainerGuestFormVC.configureWith(hotelDirect: hotelDirect, room: availableRoom, summary: booking)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToEmbedMap(result: HotelResult) {
        let mapVC = HotelLocatedMapVC.configureWith(result)
        let navMap = UINavigationController(rootViewController: mapVC)
        
        self.present(navMap, animated: true, completion: nil)
    }
}
