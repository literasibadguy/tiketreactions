//
//  HotelDirectsVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 01/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import UIKit

protocol HotelDirectsVCDelegate: class {
    func hotelDirects(_ controller: HotelDirectsVC, scrollViewPanGestureRecognizerDidChange recognizer: UIPanGestureRecognizer)
}

public final class HotelDirectsVC: UITableViewController {
    
    fileprivate let dataSource = HotelDirectsContentDataSource()
    weak var delegate: HotelDirectsVCDelegate?
    fileprivate let viewModel: HotelDirectsViewModelType = HotelDirectsViewModel()
    fileprivate let activityIndicator = UIActivityIndicatorView()
    
    internal func configureWith(hotelDirect: HotelDirect) {
        self.viewModel.inputs.configureWith(hotelDirect: hotelDirect)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.addSubview(self.activityIndicator)
        self.tableView.dataSource = dataSource
        self.tableView.register(nib: .AvailableRoomViewCell)
        
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
            |> baseTableControllerStyle(estimatedRowHeight: 450)
            |> (UITableViewController.lens.tableView..UITableView.lens.delaysContentTouches) .~ false
            |> (UITableViewController.lens.tableView..UITableView.lens.canCancelContentTouches) .~ true
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.activityIndicator.rac.animating = self.viewModel.outputs.directsAreLoading
        
        self.viewModel.outputs.loadHotelDirect
            .observe(on: UIScheduler())
            .observeValues { [weak self] hotelDirect in
                self?.dataSource.load(hotelDirect: hotelDirect)
                self?.tableView.reloadData()
        }
        
        self.viewModel.outputs.goToRoomAvailable
            .observe(on: UIScheduler())
            .observeValues { [weak self] hotel, room in
                self?.goToOrderGuestForm(hotelDirect: hotel, availableRoom: room)
        }
        
        
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let availableRoom = self.dataSource[indexPath] as? AvailableRoom {
            print("Tapped Room Available")
            self.viewModel.inputs.tappedRoomAvailable(availableRoom: availableRoom)
        }
    }
    
    private func goToOrderGuestForm(hotelDirect: HotelDirect, availableRoom: AvailableRoom) {
        let vc = HotelContainerGuestFormVC.configureWith(hotelDirect: hotelDirect, room: availableRoom)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
    override public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.scrollingIsAllowed(scrollView) else {
            return
        }
    }
    
    @objc fileprivate func scrollViewPanGestureRecognizerDidChange(_ recognizer: UIPanGestureRecognizer) {
        self.delegate?.hotelDirects(self, scrollViewPanGestureRecognizerDidChange: recognizer)
    }
    
    fileprivate func scrollingIsAllowed(_ scrollView: UIScrollView) -> Bool {
        return self.presentingViewController?.presentedViewController?.isBeingDismissed != .some(true) && (!scrollView.isTracking || scrollView.contentOffset.y >= 0)
    }
    */
}
