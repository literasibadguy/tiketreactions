//
//  DestinationHotelListViewModel.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 13/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result

public protocol DestinationHotelListViewModelInputs {
    func cancelButtonPressed()
    
    func searchFieldDidBeginEditing()
    
    func searchTextChanged(_ searchText: String)
    
    func searchTextEditingDidEnd(_ searchBar: UISearchBar)
    
    func viewDidLoad()
    
    func viewWillAppear(animated: Bool)
    
    func tapped(hotelResult: AutoHotelResult)
}

public protocol DestinationHotelListViewModelOutputs {
    
    var results: Signal<[AutoHotelResult], NoError> { get }
    
    var searchFieldText: Signal<String, NoError> { get }
    
    var notifyDelegateOfSelectedHotel: Signal<AutoHotelResult, NoError> { get }
}

public protocol DestinationHotelListViewModelType {
    var inputs: DestinationHotelListViewModelInputs { get }
    var outputs: DestinationHotelListViewModelOutputs { get }
}

public final class DestinationHotelListViewModel: DestinationHotelListViewModelType, DestinationHotelListViewModelInputs, DestinationHotelListViewModelOutputs {
    
    
    init() {
        
        let viewWillAppearNotAnimated = self.viewWillAppearAnimatedProperty.signal.filter(isFalse).ignoreValues()
        
        let query = Signal.merge(self.searchTextChangedProperty.signal, viewWillAppearNotAnimated.mapConst("").take(first: 0), self.cancelButtonPressedProperty.signal.mapConst(""))
        
        let clears = query.mapConst([AutoHotelResult]())
        
        let requestCustomized = query.filter { !$0.isEmpty }.switchMap {
            AppEnvironment.current.apiService.fetchAutocompleteHotel(query: $0).demoteErrors()
            }.map { envelope in
                return envelope.autoResults
        }
        
        let requestDestinations = query.signal.switchMap { _ in
            AppEnvironment.current.apiService.fetchAutocompleteHotel(query: "bandung").demoteErrors()
            }.map { envelope in
                return envelope.autoResults
        }
        
        self.results = Signal.merge(clears, requestCustomized).map { searchResults in
            return searchResults
        }
        
        self.notifyDelegateOfSelectedHotel = self.tappedProperty.signal.skipNil()
        
        self.searchFieldText = self.cancelButtonPressedProperty.signal.mapConst("")
    }
    
    fileprivate let cancelButtonPressedProperty = MutableProperty(())
    public func cancelButtonPressed() {
        self.cancelButtonPressedProperty.value = ()
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
    
    public let results: Signal<[AutoHotelResult], NoError>
    public let searchFieldText: Signal<String, NoError>
    public let notifyDelegateOfSelectedHotel: Signal<AutoHotelResult, NoError>
    
    public var inputs: DestinationHotelListViewModelInputs { return self }
    public var outputs: DestinationHotelListViewModelOutputs { return self }
}
