//
//  HotelDiscoveryViewModel.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 10/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol HotelDiscoveryViewModelInputs {
    func configureWith(sort: SearchHotelParams.Sort)
    
    func selectedFilter(_ selected: AutoHotelResult, param: SearchHotelParams, summary: HotelBookingSummary)
    
    func filtersUpdated(_ param: SearchHotelParams)
    
    func filtersDismissed()
    
    func tapped(hotel: HotelResult)
    
    func viewDidAppear()
    
    func viewDidDisappear(animated: Bool)
    
    func viewWillAppear()
    
    func willDisplayRow(_ row: Int, outOf totalRows: Int)
}

public protocol HotelDiscoveryViewModelOutputs {
    var hideEmptyState: Signal<(), NoError> { get }
    var notifyDelegate: Signal<SearchHotelEnvelopes, NoError> { get }
    var hotels: Signal<[HotelResult], NoError> { get }
    var filtersHotels: Signal<[HotelResult], NoError> { get }
    var hotelsAreLoading: Signal<Bool, NoError> { get }
    var showEmptyState: Signal<EmptyState, NoError> { get }
    var goToHotel: Signal<(HotelResult, HotelBookingSummary), NoError> { get }
}

public protocol HotelDiscoveryViewModelType {
    var inputs: HotelDiscoveryViewModelInputs { get }
    var outputs: HotelDiscoveryViewModelOutputs { get }
}

public final class HotelDiscoveryViewModel: HotelDiscoveryViewModelType, HotelDiscoveryViewModelInputs, HotelDiscoveryViewModelOutputs {
    
    init() {
        
        let currentStatus = Signal.combineLatest(self.selectedFilterProperty.signal.skipNil(), self.viewDidAppearProperty.signal).map(first)
        
        let mergeSelected = currentStatus.map(first)
        let mergeParams = currentStatus.map(second)
        
        let isCloseToBottom = self.willDisplayRowProperty.signal.skipNil().map { row, total in
            row >= total - 3 && row > 0
        }.skipRepeats().filter(isTrue).ignoreValues()
        
        let isVisible = Signal.merge(self.viewDidAppearProperty.signal.mapConst(true), self.viewDidDisappearProperty.signal.mapConst(false)).skipRepeats()
        
        let requestSelected = Signal.combineLatest(self.viewDidAppearProperty.signal, mergeParams)
        
        let isLoading = MutableProperty(false)
        
        let requestHotelParams = Signal.combineLatest(self.viewDidAppearProperty.signal, mergeParams, isVisible).filter { _, _, visible in visible }.skipRepeats {
            lhs, rhs in lhs.0 == rhs.0 && lhs.1 == rhs.1
            }.map(second).switchMap { params in
                AppEnvironment.current.apiService.fetchHotelResults(params: params).on(starting: { isLoading.value = true }, completed: { isLoading.value = false }, terminated: { isLoading.value = false }).materialize()
        }
        
        let requestFirstPageWith = Signal.combineLatest(mergeParams, isVisible).filter { _, visible in visible }.skipRepeats { lhs, rhs in lhs.0 == rhs.0 && lhs.1 == rhs.1 }.map(first)
        
        let paginatedHotels: Signal<[HotelResult], NoError>
        let pageCount: Signal<Int, NoError>
        (paginatedHotels, self.hotelsAreLoading, pageCount) = paginate(
            requestFirstPageWith: requestFirstPageWith,
            requestNextPageWhen: isCloseToBottom,
            clearOnNewRequest: true,
            skipRepeats: false,
            valuesFromEnvelope: { $0.searchHotelResults },
            cursorFromEnvelope: { $0.searchQueries },
            requestFromParams: { params -> SignalProducer<SearchHotelEnvelopes, ErrorEnvelope> in  AppEnvironment.current.apiService.fetchHotelResults(params: params) },
            requestFromCursor: { cursor -> SignalProducer<SearchHotelEnvelopes, ErrorEnvelope> in
                
                AppEnvironment.current.apiService.fetchHotelResults(params: cursor) },
            concater: { ($0 + $1).distincts() })
        
        /*
        let requestHotelFilters = Signal.combineLatest(self.filterDismissProperty.signal, self.configParamFilterProperty.signal.skipNil(), isVisible).filter { _, _, visible in visible }.skipRepeats {
            lhs, rhs in lhs.0 == rhs.0 && lhs.1 == rhs.1
            }.map(second).switchMap { params in
                AppEnvironment.current.apiService.fetchHotelResults(params: params).on(starting: { isLoading.value = true }, completed: { isLoading.value = false }, terminated: { isLoading.value = false }).materialize()
        }
        
        let requestHotelSelected = Signal.combineLatest(self.viewDidAppearProperty.signal, mergeSelected, isVisible).filter { _, _, visible in visible }.skipRepeats {
            lhs, rhs in lhs.0 == rhs.0 && lhs.2 == rhs.2
            }.map(second).switchMap { params in
                AppEnvironment.current.apiService.fetchResultsHotelByArea(uid: params.id).demoteErrors()
        }
        */
        
//        let responseResults = Signal.merge(requestHotelParams.values(), requestHotelFilters.values()).map { $0.searchHotelResults }
        
        self.notifyDelegate = requestHotelParams.values()
        
//        let hotelsBetweenArea = requestHotelSelected.map { $0.hotelResults }
        
        // requestHotelParams.values().map { $0.searchHotelResults }
        
        self.hotels = paginatedHotels
        self.filtersHotels = .empty
        
        self.hideEmptyState = Signal.merge(self.viewWillAppearProperty.signal.take(first: 1), self.hotels.filter { !$0.isEmpty }.ignoreValues())
        self.showEmptyState = self.hotels.filter { $0.isEmpty }.map { _ in
            emptyStateHotel()
        }
        
        let hotelCardTapped = self.tappedHotel.signal.skipNil()
        
        self.goToHotel = Signal.combineLatest(hotelCardTapped, currentStatus.map(third)).takeWhen(self.tappedHotel.signal.skipNil().ignoreValues())
    }
    
    fileprivate let sortProperty = MutableProperty<SearchHotelParams.Sort?>(nil)
    public func configureWith(sort: SearchHotelParams.Sort) {
        self.sortProperty.value = sort
    }
    
    fileprivate let selectedFilterProperty = MutableProperty<(AutoHotelResult, SearchHotelParams, HotelBookingSummary)?>(nil)
    public func selectedFilter(_ selected: AutoHotelResult, param: SearchHotelParams, summary: HotelBookingSummary) {
        self.selectedFilterProperty.value = (selected, param, summary)
    }
    
    fileprivate let configParamFilterProperty = MutableProperty<SearchHotelParams?>(nil)
    public func filtersUpdated(_ param: SearchHotelParams) {
        self.configParamFilterProperty.value = param
    }
    
    fileprivate let filterDismissProperty = MutableProperty(())
    public func filtersDismissed() {
        self.filterDismissProperty.value = ()
    }

    fileprivate let tappedHotel = MutableProperty<(HotelResult)?>(nil)
    public func tapped(hotel: HotelResult) {
        self.tappedHotel.value = hotel
    }
    
    fileprivate let viewDidAppearProperty = MutableProperty(())
    public func viewDidAppear() {
        self.viewDidAppearProperty.value = ()
    }
    
    fileprivate let viewDidDisappearProperty = MutableProperty(())
    public func viewDidDisappear(animated: Bool) {
        self.viewDidDisappearProperty.value = ()
    }
    
    fileprivate let viewWillAppearProperty = MutableProperty(())
    public func viewWillAppear() {
        self.viewWillAppearProperty.value = ()
    }
    
    fileprivate let willDisplayRowProperty = MutableProperty<(row: Int, total: Int)?>(nil)
    public func willDisplayRow(_ row: Int, outOf totalRows: Int) {
        self.willDisplayRowProperty.value = (row, totalRows)
    }
    
    public let showEmptyState: Signal<EmptyState, NoError>
    public let notifyDelegate: Signal<SearchHotelEnvelopes, NoError>
    public let hotels: Signal<[HotelResult], NoError>
    public let filtersHotels: Signal<[HotelResult], NoError>
    public let hotelsAreLoading: Signal<Bool, NoError>
    public let hideEmptyState: Signal<(), NoError>
    public let goToHotel: Signal<(HotelResult, HotelBookingSummary), NoError>
    
    public var inputs: HotelDiscoveryViewModelInputs { return self }
    public var outputs: HotelDiscoveryViewModelOutputs { return self }
}

private func emptyStateHotel() -> EmptyState {
    return EmptyState.hotelResult
}

