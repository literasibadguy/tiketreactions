//
//  HotelDiscoveryFiltersViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 12/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol HotelDiscoveryFiltersViewModelInputs {
    func configureWith(_ hotels: SearchHotelEnvelopes)
    func configureWith(_ sort: SearchHotelParams.Sort)
    func sortFiltersTapped(_ sort: SearchHotelParams.Sort)
    func confirmFilterButtonTapped()
    func viewDidLoad()
}

public protocol HotelDiscoveryFiltersViewModelOutputs {
    var loadFilterDataSources: Signal<(), NoError> { get }
    var filteredParams: Signal<SearchHotelParams, NoError> { get }
    var selectedSorts: Signal<SearchHotelParams.Sort, NoError> { get }
    var hotelResultsText: Signal<String, NoError> { get }
}

public protocol HotelDiscoveryFiltersViewModelType {
    var inputs: HotelDiscoveryFiltersViewModelInputs { get }
    var outputs: HotelDiscoveryFiltersViewModelOutputs { get }
}

public final class HotelDiscoveryFiltersViewModel: HotelDiscoveryFiltersViewModelType, HotelDiscoveryFiltersViewModelInputs, HotelDiscoveryFiltersViewModelOutputs {
    
    public init() {
        
        let currentParam = Signal.combineLatest(self.configHotelsEnvelopeProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        let currentSort = Signal.combineLatest(self.configSortProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        let clearResults = currentParam.map { $0.searchHotelResults }
        
//        let fiveRating = clearResults.filterMap { $0.map { $0.starRating == "5" } }
        
        self.loadFilterDataSources = currentSort.ignoreValues()
        
        let queen = currentParam.map { $0.searchQueries }
        
        let customized = Signal.merge(queen.map { $0.sort! }, self.sortFilterTappedProperty.signal.skipNil())
        
        let updatedParams = Signal.combineLatest(currentParam, sortFilterTappedProperty.signal.skipNil()).switchMap { envelope, sortSelected -> SignalProducer<SearchHotelParams, NoError> in
            let updated = envelope.searchQueries
//                |> SearchHotelParams.lens.query .~ envelope.searchQueries.mainCountry?.replacingOccurrences(of: " ", with: "%20")
                |> SearchHotelParams.lens.query .~ "Jakarta"
                |> SearchHotelParams.lens.sort .~ sortSelected
            return SignalProducer(value: updated)
        }.materialize()
        
        self.selectedSorts = Signal.merge(currentSort, self.sortFilterTappedProperty.signal.skipNil()).takeWhen(self.confirmFilterTappedProperty.signal)
        
        self.filteredParams = updatedParams.values().takeWhen(self.confirmFilterTappedProperty.signal)
        self.hotelResultsText = currentParam.map { " \(Localizations.ApplybuttonTitle) -\(Localizations.FilterHotelresultsTitle($0.pagination.totalFound))" }
    }
    
    fileprivate let configHotelsEnvelopeProperty = MutableProperty<SearchHotelEnvelopes?>(nil)
    public func configureWith(_ hotels: SearchHotelEnvelopes) {
        self.configHotelsEnvelopeProperty.value = hotels
    }
    
    fileprivate let configSortProperty = MutableProperty<SearchHotelParams.Sort?>(nil)
    public func configureWith(_ sort: SearchHotelParams.Sort) {
        self.configSortProperty.value = sort
    }
    
    fileprivate let sortFilterTappedProperty = MutableProperty<SearchHotelParams.Sort?>(nil)
    public func sortFiltersTapped(_ sort: SearchHotelParams.Sort) {
        self.sortFilterTappedProperty.value = sort
    }
    
    fileprivate let confirmFilterTappedProperty = MutableProperty(())
    public func confirmFilterButtonTapped() {
        self.confirmFilterTappedProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let loadFilterDataSources: Signal<(), NoError>
    public let filteredParams: Signal<SearchHotelParams, NoError>
    public let selectedSorts: Signal<SearchHotelParams.Sort, NoError>
    public let hotelResultsText: Signal<String, NoError>
    
    public var inputs: HotelDiscoveryFiltersViewModelInputs { return self }
    public var outputs: HotelDiscoveryFiltersViewModelOutputs { return self }
}
