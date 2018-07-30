//
//  HotelDiscoveryNavViewModel.swift
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

public protocol HotelDiscoveryNavViewModelInputs {
    func configureWith(selected: AutoHotelResult)
    func takingResults(_ envelope: SearchHotelEnvelopes)
    func extendingParam(_ param: SearchHotelParams)
    func filtersSelected(_ sort: SearchHotelParams.Sort)
    func filtersHaveDismissed()
    func configDateText(range: String)
    func cancelButtonTapped()
    func filterButtonTapped()
    func viewDidLoad()
}

public protocol HotelDiscoveryNavViewModelOutputs {
    var locationText: Signal<String, NoError> { get }
    var subtextContent: Signal<String, NoError> { get }
    var goFilters: Signal<SearchHotelParams.Sort, NoError> { get }
    var liveSort: Signal<SearchHotelParams.Sort, NoError> { get }
    var updatedParams: Signal<SearchHotelParams, NoError> { get }
    var dismissResults: Signal<(), NoError> { get }
}

public protocol HotelDiscoveryNavViewModelType {
    var inputs: HotelDiscoveryNavViewModelInputs { get }
    var outputs: HotelDiscoveryNavViewModelOutputs { get }
}

public final class HotelDiscoveryNavViewModel:  HotelDiscoveryNavViewModelType ,HotelDiscoveryNavViewModelInputs, HotelDiscoveryNavViewModelOutputs {
    
    init() {
        let current = Signal.combineLatest(self.configDataProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        let currentParam = Signal.merge(self.configResultsProperty.signal.skipNil().map { $0.searchQueries }, self.extendParamProperty.signal.skipNil())
        
        let rangeDate = Signal.combineLatest(self.configDateProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        let selectedResult = current.signal
        
        self.locationText = selectedResult.signal.map { $0.labelLocation }
        self.subtextContent = rangeDate
        
        self.goFilters = self.configResultsProperty.signal.skipNil().map { $0.searchQueries.sort ?? .popular }.takeWhen(self.filterButtonProperty.signal)
        self.liveSort = self.filterSelectedProperty.signal.skipNil().takeWhen(self.filtersDismissProperty.signal)
        
        self.updatedParams = currentParam.takeWhen(self.filtersDismissProperty.signal)
        
        self.dismissResults = self.cancelButtonProperty.signal
    }
    
    fileprivate let configDataProperty = MutableProperty<AutoHotelResult?>(nil)
    public func configureWith(selected: AutoHotelResult) {
        self.configDataProperty.value = selected
    }
    
    fileprivate let configResultsProperty = MutableProperty<SearchHotelEnvelopes?>(nil)
    public func takingResults(_ envelope: SearchHotelEnvelopes) {
        self.configResultsProperty.value = envelope
    }
    
    fileprivate let extendParamProperty = MutableProperty<SearchHotelParams?>(nil)
    public func extendingParam(_ param: SearchHotelParams) {
        self.extendParamProperty.value = param
    }
    
    fileprivate let filterSelectedProperty = MutableProperty<SearchHotelParams.Sort?>(nil)
    public func filtersSelected(_ sort: SearchHotelParams.Sort) {
        self.filterSelectedProperty.value = sort
    }
    
    fileprivate let filtersDismissProperty = MutableProperty(())
    public func filtersHaveDismissed() {
        self.filtersDismissProperty.value = ()
    }
    
    fileprivate let configDateProperty = MutableProperty<String?>(nil)
    public func configDateText(range: String) {
        self.configDateProperty.value = range
    }
    
    fileprivate let cancelButtonProperty = MutableProperty(())
    public func cancelButtonTapped() {
        self.cancelButtonProperty.value = ()
    }
    
    fileprivate let filterButtonProperty = MutableProperty(())
    public func filterButtonTapped() {
        self.filterButtonProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let locationText: Signal<String, NoError>
    public let subtextContent: Signal<String, NoError>
    public let goFilters: Signal<SearchHotelParams.Sort, NoError>
    public let liveSort: Signal<SearchHotelParams.Sort, NoError>
    public let updatedParams: Signal<SearchHotelParams, NoError>
    public let dismissResults: Signal<(), NoError>
    
    public var inputs: HotelDiscoveryNavViewModelInputs { return self }
    public var outputs: HotelDiscoveryNavViewModelOutputs { return self }
}
