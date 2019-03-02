//
//  PickAirportsTableVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 28/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit
import Prelude
import ReactiveSwift
import TiketKitModels

public protocol PickDestinationTableDelegate: class {
    func pickDestinationAirportsTable(_ vc: PickAirportsTableVC, selectedRow: AirportResult)
}

public protocol PickOriginTableDelegate: class {
    func pickOriginAirportsTable(_ vc: PickAirportsTableVC, selectedRow: AirportResult)
    
}

public final class PickAirportsTableVC: UIViewController {
    
    fileprivate let viewModel: PickAirportsTableViewModelType = PickAirportsTableViewModel()
    fileprivate let dataSource = PickAirportsDataSource()
    
    public weak var delegate: PickOriginTableDelegate?
    public weak var destinationDelegate: PickDestinationTableDelegate?
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var cancelButton: UIButton!
    @IBOutlet fileprivate weak var statusDestinationLabel: UILabel!
    @IBOutlet fileprivate weak var searchBarAirport: UISearchBar!
    
    static func instantiate(status: String) -> PickAirportsTableVC {
        let vc = Storyboard.PickAirports.instantiate(PickAirportsTableVC.self)
        vc.viewModel.inputs.configureWith(location: status)
        return vc
    }
    
    static func configureWith(status: String, selectedRow: AirportResult) -> PickAirportsTableVC {
        let vc = Storyboard.PickAirports.instantiate(PickAirportsTableVC.self)
        vc.viewModel.inputs.configureWith(location: status, selectedRow: selectedRow)
        return vc
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self
        
        self.searchBarAirport.becomeFirstResponder()
        
        self.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        self.searchBarAirport.delegate = self
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.inputs.viewWillAppear(animated: animated)
    }
    
    override public func bindStyles() {
        super.bindStyles()
        
        _ = self.tableView
            |> UITableView.lens.separatorStyle .~ .none
            |> UITableView.lens.backgroundColor .~ .white
            |> UITableView.lens.rowHeight .~ UITableViewAutomaticDimension
        
        _ = self.statusDestinationLabel
            |> UILabel.lens.textColor .~ .tk_official_green
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.statusDestinationLabel.rac.text = self.viewModel.outputs.titleStatusText
        
        self.viewModel.outputs.cancelPickAirports
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.dismiss(animated: true, completion: nil)
                self?.searchBarAirport.resignFirstResponder()
        }
        
        self.viewModel.outputs.updatesResult
            .observe(on: UIScheduler())
            .observeValues { [weak self] results, selected in
                print("WHAT SELECTED: \(selected)")
                self?.dataSource.load(airportResults: results, selectedRow: selected)
                self?.tableView.reloadData()
        }
        
        self.viewModel.outputs.notifyDelegateOfSelectedAirport
            .observe(on: UIScheduler())
            .observeValues { [weak self] airport in
                guard let _self = self else { return }
                _self.dismiss(animated: true, completion: nil)
                _self.searchBarAirport.resignFirstResponder()
                _self.delegate?.pickOriginAirportsTable(_self, selectedRow: airport)
                _self.destinationDelegate?.pickDestinationAirportsTable(_self, selectedRow: airport)
        }
        
    }
    
    @objc fileprivate func cancelButtonTapped() {
        self.viewModel.inputs.tappedButtonCancel()
    }
    
    @objc fileprivate func searchBarAirportTapped() {
        
    }
}

extension PickAirportsTableVC: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let airportRow = self.dataSource.flightRow(indexPath: indexPath) {
            self.viewModel.inputs.tapped(airportResult: airportRow)
        }
    }
}

extension PickAirportsTableVC: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.inputs.searchAirportDidBeginEditing()
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.viewModel.inputs.searchAirportDidBeginEditing()
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.inputs.searchTextAirportChanged(searchText)
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.viewModel.inputs.searchTextAirportEditingDidEnd(searchBar)
    }
}


