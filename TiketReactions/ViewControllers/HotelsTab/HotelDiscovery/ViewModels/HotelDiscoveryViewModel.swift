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
import TiketAPIs

public protocol HotelDiscoveryViewModelInputs {
    func configureWith(sort: SearchHotelParams.Sort)
    
    func selectedFilter(_ params: SearchHotelParams)
    
    func tapped(hotel: HotelResult)
    
    func viewDidAppear()
    
    func viewDidDisappear(animated: Bool)
    
    func viewWillAppear()
    
    func willDisplayRow(_ row: Int, outOf totalRows: Int)
}

public protocol HotelDiscoveryViewModelOutputs {
    
    var hideEmptyState: Signal<(), NoError> { get }
    var hotels: Signal<[HotelResult], NoError> { get }
    var hotelsAreLoading: Signal<Bool, NoError> { get }
    var showEmptyState: Signal<EmptyState, NoError> { get }
    var goToHotel: Signal<HotelResult, NoError> { get }
}

public protocol HotelDiscoveryViewModelType {
    var inputs: HotelDiscoveryViewModelInputs { get }
    var outputs: HotelDiscoveryViewModelOutputs { get }
}

public final class HotelDiscoveryViewModel: HotelDiscoveryViewModelType, HotelDiscoveryViewModelInputs, HotelDiscoveryViewModelOutputs {
    
    init() {
        
        let paramsChanged = Signal.combineLatest(self.sortProperty.signal.skipNil(), self.selectedFilterProperty.signal.skipNil()).collect()
        
        let isCloseToBottom = self.willDisplayRowProperty.signal.skipNil().map { row, total in
            row >= total - 3 && row > 0
        }.skipRepeats().filter(isTrue).ignoreValues()
        
        let isVisible = Signal.merge(self.viewDidAppearProperty.signal.mapConst(true), self.viewDidDisappearProperty.signal.mapConst(false)).skipRepeats()
        
        let requestFirstPageWith = Signal.combineLatest(paramsChanged, isVisible).filter { _, visible in visible }.skipRepeats { lhs, rhs in lhs.0 == rhs.0 && lhs.1 && rhs.1 }.map(second)
        
        let sampleParams = .defaults
            |> SearchHotelParams.lens.query .~ "Bandung"
            |> SearchHotelParams.lens.startDate .~ "2018-02-22"
            |> SearchHotelParams.lens.endDate .~ "2018-02-25"
            |> SearchHotelParams.lens.adult .~ "1"
            |> SearchHotelParams.lens.room .~ 1
        
        let flattingHotels = self.selectedFilterProperty.signal.skipNil().switchMap { _ in
            AppEnvironment.current.apiService.fetchHotelResults(params: sampleParams).demoteErrors()
            }.map { envelope in
              return envelope.searchHotelResults
        }
        

        let paginatedHotels: Signal<[HotelResult], NoError>
        let pageCount: Signal<Int, NoError>
        
        
        self.hotels = self.viewDidAppearProperty.signal.switchMap { _ in
            AppEnvironment.current.apiService.fetchHotelResults(params: sampleParams).demoteErrors()
            }.map { envelope in return envelope.searchHotelResults }
        
        
        self.hideEmptyState = Signal.merge(self.viewWillAppearProperty.signal.take(first: 1), self.hotels.filter { !$0.isEmpty }.ignoreValues())
        self.showEmptyState = self.hotels.filter { $0.isEmpty }.map { _ in
            emptyStateHotel()
        }
        
        let hotelCardTapped = self.tappedHotel.signal.skipNil()
        self.goToHotel = hotelCardTapped
        
        self.hotelsAreLoading = .empty
    }
    
    fileprivate let sortProperty = MutableProperty<SearchHotelParams.Sort?>(nil)
    public func configureWith(sort: SearchHotelParams.Sort) {
        self.sortProperty.value = sort
    }
    
    fileprivate let selectedFilterProperty = MutableProperty<SearchHotelParams?>(nil)
    public func selectedFilter(_ params: SearchHotelParams) {
        self.selectedFilterProperty.value = params
    }
    
    fileprivate let tappedHotel = MutableProperty<HotelResult?>(nil)
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
    public let hotels: Signal<[HotelResult], NoError>
    public let hotelsAreLoading: Signal<Bool, NoError>
    public let hideEmptyState: Signal<(), NoError>
    public let goToHotel: Signal<HotelResult, NoError>
    
    public var inputs: HotelDiscoveryViewModelInputs { return self }
    public var outputs: HotelDiscoveryViewModelOutputs { return self }
}

private func emptyStateHotel() -> EmptyState {
    return EmptyState.hotelResult
}

