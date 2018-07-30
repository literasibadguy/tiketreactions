//
//  HotelDiscoveryEmbedViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 10/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol HotelDiscoveryEmbedViewModelInputs {
    func configureWith(selected: AutoHotelResult, params: SearchHotelParams, booking: HotelBookingSummary)
    func notifyResults(_ envelope: SearchHotelEnvelopes)
    func filtering(_ sort: SearchHotelParams.Sort)
    func filterHasBeenDismissed()
    func viewDidLoad()
}

public protocol HotelDiscoveryEmbedViewModelOutputs {
    var loadParamsIntoResults: Signal<(AutoHotelResult, SearchHotelParams, HotelBookingSummary), NoError> { get }
    var loadDataRange: Signal<(AutoHotelResult, String), NoError> { get }
    var loadResult: Signal<SearchHotelEnvelopes, NoError> { get }
    var loadParamsFromFilters: Signal<SearchHotelParams, NoError> { get }
    var loadSortFromFilters: Signal<SearchHotelParams.Sort, NoError> { get }
    var filterDismiss: Signal<(), NoError> { get }
}

public protocol HotelDiscoveryEmbedViewModelType {
    var inputs: HotelDiscoveryEmbedViewModelInputs { get }
    var outputs: HotelDiscoveryEmbedViewModelOutputs { get }
}

public final class HotelDiscoveryEmbedViewModel:  HotelDiscoveryEmbedViewModelType ,HotelDiscoveryEmbedViewModelInputs, HotelDiscoveryEmbedViewModelOutputs {
    
    init() {
        let currentParams = Signal.combineLatest(self.configDataProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        self.loadParamsIntoResults = currentParams
        
        self.loadDataRange = Signal.combineLatest(currentParams.map { $0.0 }, currentParams.map { $0.2.dateRange })
        
        self.loadResult = self.configResultsProperty.signal.skipNil()
        self.loadParamsFromFilters = .empty
        
        self.loadSortFromFilters = self.filterSortProperty.signal.skipNil()
        
        self.filterDismiss = self.filterDismissProperty.signal
    }
    
    fileprivate let configDataProperty = MutableProperty<(AutoHotelResult, SearchHotelParams, HotelBookingSummary)?>(nil)
    public func configureWith(selected: AutoHotelResult, params: SearchHotelParams, booking: HotelBookingSummary) {
        self.configDataProperty.value = (selected, params, booking)
    }
    
    fileprivate let configResultsProperty = MutableProperty<SearchHotelEnvelopes?>(nil)
    public func notifyResults(_ envelope: SearchHotelEnvelopes) {
        self.configResultsProperty.value = envelope
    }
    
    fileprivate let filterSortProperty = MutableProperty<SearchHotelParams.Sort?>(nil)
    public func filtering(_ sort: SearchHotelParams.Sort) {
        self.filterSortProperty.value = sort
    }
    
    fileprivate let filterDismissProperty = MutableProperty(())
    public func filterHasBeenDismissed() {
        self.filterDismissProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let loadParamsIntoResults: Signal<(AutoHotelResult, SearchHotelParams, HotelBookingSummary), NoError>
    public let loadDataRange: Signal<(AutoHotelResult, String), NoError>
    public let loadResult: Signal<SearchHotelEnvelopes, NoError>
    public let loadParamsFromFilters: Signal<SearchHotelParams, NoError>
    public let loadSortFromFilters: Signal<SearchHotelParams.Sort, NoError>
    public let filterDismiss: Signal<(), NoError>
    
    public var inputs: HotelDiscoveryEmbedViewModelInputs { return self }
    public var outputs: HotelDiscoveryEmbedViewModelOutputs { return self }
}
