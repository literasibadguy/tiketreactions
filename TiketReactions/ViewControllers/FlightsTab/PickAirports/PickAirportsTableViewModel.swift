//
//  PickAirportsTableViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 03/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels
import UIKit

public protocol PickAirportsTableViewModelInputs {
    func configureWith(location: String)
    func configureWith(location: String, selectedRow: AirportResult)
    func tappedButtonCancel()
    func searchAirportDidBeginEditing()
    func searchTextAirportChanged(_ searchText: String)
    func searchTextAirportEditingDidEnd(_ searchBar: UISearchBar)
    func viewDidLoad()
    func viewWillAppear(animated: Bool)
    func tapped(airportResult: AirportResult)
}

public protocol PickAirportsTableViewModelOutputs {
    var airportsResult: Signal<[AirportResult], NoError> { get }
    var updatesResult: Signal<([AirportResult], AirportResult), NoError> { get }
    var titleStatusText: Signal<String, NoError> { get }
    var searchFieldText: Signal<String, NoError> { get }
    var cancelPickAirports: Signal<(), NoError> { get }
    var notifyDelegateOfSelectedAirport: Signal<AirportResult, NoError> { get }
}

public protocol PickAirportsTableViewModelType {
    var inputs: PickAirportsTableViewModelInputs { get }
    var outputs: PickAirportsTableViewModelOutputs { get }
}

public final class PickAirportsTableViewModel: PickAirportsTableViewModelType, PickAirportsTableViewModelInputs, PickAirportsTableViewModelOutputs {
    
    public init() {
        let viewWillAppearNotAnimated = self.viewWillAppearProperty.signal.filter(isFalse).ignoreValues()
        
        let current = Signal.combineLatest(self.viewDidLoadProperty.signal, self.configureDataProperty.signal.skipNil()).map(second)
        
        let airport = self.configureDataProperty.signal.skipNil().map(second)
        
        self.titleStatusText = current.signal.map(first).map(statusLocation(status:))
        
        let allAirports = self.viewWillAppearProperty.signal.switchMap { _ in
            AppEnvironment.current.apiService.fetchAirports(query: "").demoteErrors()
        }.map { $0.airportResults }
        
//        let query = Signal.merge(self.searchAirportChangedProperty.signal, viewWillAppearNotAnimated.mapConst("Jakarta").take(first: 0), self.tappedCancelProperty.signal.mapConst(""))
        
//        let clears = query.mapConst(allAirports.map { $0 })
        
        /*
        let requestCustomized = query.filter { !$0.isEmpty }.switchMap { AppEnvironment.current.apiService.fetchAirports(query: $0).demoteErrors()
            }.map { envelope in
                return envelope.airportResults
        }
        */
        
        let lowercased = self.searchAirportChangedProperty.signal.filter { $0 != "" }.map { $0.lowercased() }
        let combinedResults = Signal.combineLatest(allAirports, lowercased)
        
        let resultLocationSearched = combinedResults.signal.map { airports, lowercase in
            airports.filter { airport in
                return airport.locationName.lowercased().contains(lowercase.lowercased())
            }
        }
        
        self.airportsResult = .empty
        
        self.updatesResult = Signal.combineLatest(Signal.merge(allAirports, resultLocationSearched), airport)
        
        self.searchFieldText = self.tappedCancelProperty.signal.mapConst("")
        
        self.cancelPickAirports = self.tappedCancelProperty.signal
        
        self.notifyDelegateOfSelectedAirport = Signal.combineLatest(self.tappedProperty.signal.skipNil(), self.configureDataProperty.signal.skipNil().map(first).map(statusLocation(status:))).map(first)
    }
    
    fileprivate let configStatusProperty = MutableProperty("")
    public func configureWith(location: String) {
        self.configStatusProperty.value = location
    }
    
    fileprivate let configureDataProperty = MutableProperty<(String, AirportResult)?>(nil)
    public func configureWith(location: String, selectedRow: AirportResult) {
        self.configureDataProperty.value = (location, selectedRow)
    }
    
    fileprivate let tappedCancelProperty = MutableProperty(())
    public func tappedButtonCancel() {
        self.tappedCancelProperty.value = ()
    }
    
    fileprivate let airportBeginEditingProperty = MutableProperty(())
    public func searchAirportDidBeginEditing() {
        self.airportBeginEditingProperty.value = ()
    }
    
    fileprivate let searchAirportChangedProperty = MutableProperty("")
    public func searchTextAirportChanged(_ searchText: String) {
        self.searchAirportChangedProperty.value = searchText
    }
    
    fileprivate let searchAirportEditingEndProperty = MutableProperty<UISearchBar?>(nil)
    public func searchTextAirportEditingDidEnd(_ searchBar: UISearchBar) {
        self.searchAirportEditingEndProperty.value = searchBar
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    fileprivate let viewWillAppearProperty = MutableProperty(false)
    public func viewWillAppear(animated: Bool) {
        self.viewWillAppearProperty.value = animated
    }
    
    fileprivate let tappedProperty = MutableProperty<AirportResult?>(nil)
    public func tapped(airportResult: AirportResult) {
        self.tappedProperty.value = airportResult
    }
    
    public let airportsResult: Signal<[AirportResult], NoError>
    public let updatesResult: Signal<([AirportResult], AirportResult), NoError>
    public let titleStatusText: Signal<String, NoError>
    public let searchFieldText: Signal<String, NoError>
    public let cancelPickAirports: Signal<(), NoError>
    public let notifyDelegateOfSelectedAirport: Signal<AirportResult, NoError>
    
    public var inputs: PickAirportsTableViewModelInputs { return self }
    public var outputs: PickAirportsTableViewModelOutputs { return self }
}

private func statusLocation(status: String) -> String {
    switch status {
    case "Departure":
        return "origin"
    case "Arrival":
        return "destination"
    default:
        return "Tidak ada tujuan"
    }
}

private func searchedAirport(_ query: String, airports: [AirportResult]) -> [AirportResult] {
    return []
}

