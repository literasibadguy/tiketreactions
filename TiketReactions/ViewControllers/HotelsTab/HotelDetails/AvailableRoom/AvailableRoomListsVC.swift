//
//  AvailableRoomListsVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 13/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

public final class AvailableRoomListsVC: UITableViewController {
    
    fileprivate let viewModel: AvailableRoomListsViewModelType = AvailableRoomListsViewModel()
    fileprivate let dataSource = AvailableRoomListsDataSource()
    
    internal static func configureWith(hotelDirect: HotelDirect, booking: HotelBookingSummary) -> AvailableRoomListsVC {
        let vc = Storyboard.AvailableRoomLists.instantiate(AvailableRoomListsVC.self)
        vc.viewModel.inputs.configureWith(hotelDirect: hotelDirect, booking: booking)
        return vc
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = dataSource
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel.inputs.viewDidAppear(animated)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = Localizations.ChooseRoomTitle
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> baseTableControllerStyle(estimatedRowHeight: 155)
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.rooms
            .observe(on: UIScheduler())
            .observeValues { [weak self] rooms in
                self?.dataSource.load(rooms: rooms)
                self?.tableView.reloadData()
        }
        
        self.viewModel.outputs.goToCheckout
            .observe(on: UIScheduler())
            .observeValues { [weak self] direct, summary, room in
                self?.goToFormOrder(direct: direct, room: room, booking: summary)
        }
    }
    
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let cell = cell as? AvailableRoomViewCell {
            cell.delegate = self
        }
    }

    fileprivate func goToFormOrder(direct: HotelDirect, room: AvailableRoom, booking: HotelBookingSummary) {
        let formOrderVC = HotelContainerGuestFormVC.configureWith(hotelDirect: direct, room: room, summary: booking)
        self.navigationController?.pushViewController(formOrderVC, animated: true)
    }
}

extension AvailableRoomListsVC: AvailableRoomCellDelegate {
    public func goToNextCheckout(_ cell: AvailableRoomViewCell, with room: AvailableRoom) {
        self.viewModel.inputs.selected(room: room)
    }
}

