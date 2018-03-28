//
//  DestinationHotelListVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 13/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import Result
import TiketAPIs
import UIKit

internal protocol DestinationHotelListVCDelegate: class {
    func destinationHotelList(_ vc: DestinationHotelListVC, selectedRow: AutoHotelResult)
    func destinationHotelListDidClose(_ vc: DestinationHotelListVC)
}

internal final class DestinationHotelListVC: UIViewController, UITableViewDelegate {
    
    @IBOutlet fileprivate weak var headerDestinationView: UIView!
    @IBOutlet fileprivate weak var titleHeaderLabel: UILabel!
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var cancelButton: UIButton!
    @IBOutlet fileprivate weak var hotelDestinationTableView: UITableView!
    
    private let dataSource = DestinationHotelDataSource()
    private let viewModel: DestinationHotelListViewModelType = DestinationHotelListViewModel()
    
    internal weak var delegate: DestinationHotelListVCDelegate?
    
    internal static func configuredWith() -> DestinationHotelListVC {
        let vc = Storyboard.DestinationHotel.instantiate(DestinationHotelListVC.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hotelDestinationTableView.dataSource = self.dataSource
        self.hotelDestinationTableView.delegate = self
        
        // Do any additional setup after loading the view.
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.cancelButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        self.searchBar.delegate = self
        self.viewModel.inputs.viewWillAppear(animated: animated)
    }
    
    internal override func bindStyles() {
        super.bindStyles()
        
        _ = self.titleHeaderLabel
            |> UILabel.lens.text .~ "Destinasi / Hotel"
    }
    
    internal override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.results
            .observe(on: UIScheduler())
            .observeValues { [weak self] results in
                self?.dataSource.load(results: results)
                self?.hotelDestinationTableView.reloadData()
        }
        
//        self.searchBar.rac.text = self.viewModel.outputs.
        
        self.viewModel.outputs.notifyDelegateOfSelectedHotel
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] selectedRow in
                guard let _self = self else { return }
                _self.dismiss(animated: true, completion: nil)
                _self.delegate?.destinationHotelList(_self, selectedRow: selectedRow)
                
        }
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let expandableRow = self.dataSource.destHotelRow(indexPath: indexPath) {
            print("WHAT SELECTED: \(expandableRow.category)")
            self.viewModel.inputs.tapped(hotelResult: expandableRow)
        }
//        self.dismiss(animated: true, completion: nil)
    }
    
    private func animateIn() {
        self.hotelDestinationTableView.frame.origin.y -= 20.0
        self.hotelDestinationTableView.alpha = 0
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            options: .curveEaseOut,
            animations: {
                self.hotelDestinationTableView.alpha = 1.0
                self.hotelDestinationTableView.frame.origin.y += 20.0
        }, completion: nil)
    }
    
    @objc fileprivate func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension DestinationHotelListVC: UISearchBarDelegate {
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.inputs.searchFieldDidBeginEditing()
    }
    
    internal func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.viewModel.inputs.searchFieldDidBeginEditing()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.inputs.searchTextChanged(searchText)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.viewModel.inputs.searchTextEditingDidEnd(searchBar)
    }
    
    
}
