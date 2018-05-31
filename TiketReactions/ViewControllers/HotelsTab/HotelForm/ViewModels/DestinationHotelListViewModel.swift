//
//  DestinationHotelListViewModel.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 13/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import GoogleMaps
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol DestinationHotelListViewModelInputs {
    func configureWith(selectedRow: SelectableRow)
    
    func cancelButtonPressed()
    
    func updateLastCurrentLocation(_ location: GMSAddress)
    
    func searchFieldDidBeginEditing()
    
    func searchTextChanged(_ searchText: String)
    
    func searchTextEditingDidEnd(_ searchBar: UISearchBar)
    
    func viewDidLoad()
    
    func viewWillAppear(animated: Bool)
    
    func tapped(hotelResult: AutoHotelResult)
}

public protocol DestinationHotelListViewModelOutputs {
    
    var fetchingLocation: Signal<(), NoError> { get }
    
    var initialCurrentLocation: Signal<GMSAddress, NoError> { get }
    
    var resultsAreLoading: Signal<Bool, NoError> { get }
    
    var results: Signal<[AutoHotelResult], NoError> { get }
    
    var searchFieldText: Signal<String, NoError> { get }

    var notifyDelegateOfSelectedHotel: Signal<AutoHotelResult, NoError> { get }
    
    var notifyDelegateOfPlacemark: Signal<(), NoError> { get }
}

public protocol DestinationHotelListViewModelType {
    var inputs: DestinationHotelListViewModelInputs { get }
    var outputs: DestinationHotelListViewModelOutputs { get }
}

public final class DestinationHotelListViewModel: DestinationHotelListViewModelType, DestinationHotelListViewModelInputs, DestinationHotelListViewModelOutputs {
    
    
    init() {
        
        let viewWillAppearNotAnimated = self.viewWillAppearAnimatedProperty.signal.filter(isFalse).ignoreValues()
        
        self.fetchingLocation = self.viewDidLoadProperty.signal.skipRepeats(==)
        
        self.initialCurrentLocation = self.lastLocationProperty.signal.skipNil().skipRepeats()
        
        let query = Signal.merge(self.searchTextChangedProperty.signal, viewWillAppearNotAnimated.mapConst("").take(first: 0), self.cancelButtonPressedProperty.signal.mapConst(""))
        
        let clears = query.mapConst([AutoHotelResult]())
        
        let loadingProperty = MutableProperty(false)
        let requestCustomized = query.filter { !$0.isEmpty }.switchMap {
            AppEnvironment.current.apiService.fetchAutocompleteHotel(query: $0).on(starting: { loadingProperty.value = true }, completed: { loadingProperty.value = true }, terminated: { loadingProperty.value = false }).materialize()
        }
        
        self.resultsAreLoading = loadingProperty.signal
        
        let queryResults = requestCustomized.values().map { $0.autoResults }
        
        self.results = Signal.merge(clears, queryResults).map { searchResults in
            return searchResults
        }
        
        self.searchFieldText = self.cancelButtonPressedProperty.signal.mapConst("")
        
        self.notifyDelegateOfSelectedHotel = self.tappedProperty.signal.skipNil()
        
        self.notifyDelegateOfPlacemark = .empty
        
    }
    
    fileprivate let configSelectedRowProperty = MutableProperty<SelectableRow?>(nil)
    public func configureWith(selectedRow: SelectableRow) {
        self.configSelectedRowProperty.value = selectedRow
    }
    
    fileprivate let cancelButtonPressedProperty = MutableProperty(())
    public func cancelButtonPressed() {
        self.cancelButtonPressedProperty.value = ()
    }
    
    fileprivate let lastLocationProperty = MutableProperty<GMSAddress?>(nil)
    public func updateLastCurrentLocation(_ location: GMSAddress) {
        self.lastLocationProperty.value = location
    }
    
    fileprivate let searchFieldDidBeginEditingProperty = MutableProperty(())
    public func searchFieldDidBeginEditing() {
        self.searchFieldDidBeginEditingProperty.value = ()
    }
    
    fileprivate let searchTextChangedProperty = MutableProperty("")
    public func searchTextChanged(_ searchText: String) {
        self.searchTextChangedProperty.value = searchText
    }
    
    fileprivate let searchTextEditingDidEndProperty = MutableProperty<UISearchBar?>(nil)
    public func searchTextEditingDidEnd(_ searchBar: UISearchBar) {
        self.searchTextEditingDidEndProperty.value = searchBar
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    fileprivate let viewWillAppearAnimatedProperty = MutableProperty(false)
    public func viewWillAppear(animated: Bool) {
        self.viewWillAppearAnimatedProperty.value = animated
    }
    
    fileprivate let tappedProperty = MutableProperty<AutoHotelResult?>(nil)
    public func tapped(hotelResult: AutoHotelResult) {
        self.tappedProperty.value = hotelResult
    }
    
    public let fetchingLocation: Signal<(), NoError>
    public let initialCurrentLocation: Signal<GMSAddress, NoError>
    public let resultsAreLoading: Signal<Bool, NoError>
    public let results: Signal<[AutoHotelResult], NoError>
    public let searchFieldText: Signal<String, NoError>
    public let notifyDelegateOfSelectedHotel: Signal<AutoHotelResult, NoError>
    public let notifyDelegateOfPlacemark: Signal<(), NoError>
    
    public var inputs: DestinationHotelListViewModelInputs { return self }
    public var outputs: DestinationHotelListViewModelOutputs { return self }
}



