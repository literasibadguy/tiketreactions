//
//  DestinationHotelListVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 13/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import CoreLocation
import GoogleMaps
import Prelude
import ReactiveSwift
import Result
import TiketKitModels
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
    @IBOutlet fileprivate weak var destinationSeparatorView: UIView!
    @IBOutlet fileprivate weak var loadingIndicatorView: UIActivityIndicatorView!
    
    fileprivate let dataSource = DestinationHotelDataSource()
    fileprivate let viewModel: DestinationHotelListViewModelType = DestinationHotelListViewModel()
    fileprivate let locationManager = CLLocationManager()
    
    internal weak var delegate: DestinationHotelListVCDelegate?
    
    internal static func configuredWith() -> DestinationHotelListVC {
        let vc = Storyboard.DestinationHotel.instantiate(DestinationHotelListVC.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.hotelDestinationTableView.dataSource = self.dataSource
        self.hotelDestinationTableView.delegate = self
        
        self.searchBar.becomeFirstResponder()
        
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
        
        _ = self.hotelDestinationTableView
            |> UITableView.lens.separatorStyle .~ .none
            |> UITableView.lens.backgroundColor .~ .white
            |> UITableView.lens.rowHeight .~ UITableViewAutomaticDimension
            |> UITableView.lens.estimatedRowHeight .~ 88.0
        
        _ = self.searchBar
            |> UISearchBar.lens.tintColor .~ .tk_official_green
        
        _ = self.loadingIndicatorView
            |> baseActivityIndicatorStyle
        
        _ = self.destinationSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.titleHeaderLabel
            |> UILabel.lens.text .~ Localizations.DestinationHotelTitleForm
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
            |> UILabel.lens.font .~ UIFont.boldSystemFont(ofSize: 22.0)
    }
    
    internal override func bindViewModel() {
        super.bindViewModel()
        
        self.loadingIndicatorView.rac.animating = self.viewModel.outputs.resultsAreLoading
        
        self.viewModel.outputs.initialCurrentLocation
            .observe(on: UIScheduler())
            .observeValues { [weak self] current in
//                self?.locationManager.stopUpdatingLocation()
                print("CURRENT CITY: \(current.locality ?? "")")
                self?.dataSource.initialDestination(current)
                self?.hotelDestinationTableView.reloadData()
        }
        
        self.viewModel.outputs.results
            .observe(on: UIScheduler())
            .observeValues { [weak self] results in
//                self?.getCurrentLocation()
                self?.dataSource.load(results: results)
                self?.hotelDestinationTableView.reloadData()
        }
        
//        self.searchBar.rac.text = self.viewModel.outputs.
        
        self.viewModel.outputs.notifyDelegateOfSelectedHotel
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] selectedRow in
                guard let _self = self else { return }
                _self.searchBar.resignFirstResponder()
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
    
    fileprivate func getCurrentLocation() {
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
            return
        }
        
        // 3
        if status == .denied || status == .restricted {
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    
    
    @objc fileprivate func closeButtonTapped() {
        self.searchBar.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension DestinationHotelListVC: CLLocationManagerDelegate {
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lookUpCurrentLocation(lastLocation: locations.last!, completionHandler: { self.viewModel.inputs.updateLastCurrentLocation($0!) })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    private func lookUpCurrentLocation(lastLocation: CLLocation, completionHandler: @escaping (GMSAddress?)
        -> Void ) {
        // Use the last reported location.
        
        let googleGeocoder = GMSGeocoder()
        
        googleGeocoder.reverseGeocodeCoordinate(lastLocation.coordinate, completionHandler: { (placesmarks, error) in
            if error == nil {
                let firstLocation = placesmarks?.firstResult()
                completionHandler(firstLocation)
            } else {
                completionHandler(nil)
            }
        })
        
        /*
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(lastLocation,
                                        completionHandler: { (placemarks, error) in
                                            if error == nil {
                                                let firstLocation = placemarks?[0]
                                                completionHandler(firstLocation)
                                            }
                                            else {
                                                // An error occurred during geocoding.
                                                completionHandler(nil)
                                            }
        })
        */
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
