//
//  HotelLiveFeedContentViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 06/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol HotelLiveFeedContentViewModelInputs {
    func selectedFilter(_ params: SearchHotelParams)
    func viewDidAppear()
    func viewWillAppear()
    func viewDidDisappear(_ animated: Bool)
    func viewDidLoad()
    func willDisplayRow(_ row: Int, outOf totalRows: Int)
}

public protocol HotelLiveFeedContentViewModelOutputs {
    var hideEmptyState: Signal<(), NoError> { get }
    var hotels: Signal<[HotelResult], NoError> { get }
    var hotelsAreLoading: Signal<Bool, NoError> { get }
    var showEmptyState: Signal<EmptyState, NoError> { get }
}

public protocol HotelLiveFeedContentViewModelType {
    var inputs: HotelLiveFeedContentViewModelInputs { get }
    var outputs: HotelLiveFeedContentViewModelOutputs { get }
}

public final class HotelLiveFeedContentViewModel: HotelLiveFeedContentViewModelType, HotelLiveFeedContentViewModelInputs, HotelLiveFeedContentViewModelOutputs {
    
    fileprivate static let defaultParams = .defaults
        |> SearchHotelParams.lens.query .~ "Jakarta"
        |> SearchHotelParams.lens.startDate .~ "2018-05-11"
        |> SearchHotelParams.lens.endDate .~ "2018-05-12"
        |> SearchHotelParams.lens.room .~ 1
        |> SearchHotelParams.lens.adult .~ "2"
        |> SearchHotelParams.lens.night .~ 1
    
    public init() {
        
        let isLoading = MutableProperty(false)
        
        let isVisible = Signal.merge(self.viewDidAppearProperty.signal.mapConst(true), self.viewDidDisappearProperty.signal.mapConst(false)).skipRepeats()
        
        print("\(AppEnvironment.current.apiService.tiketToken?.token)")
        
        let customs = .defaults
            |> SearchHotelParams.lens.query .~ "Indonesia"
            |> SearchHotelParams.lens.startDate .~ "2018-05-11"
            |> SearchHotelParams.lens.endDate .~ "2018-05-12"
            |> SearchHotelParams.lens.room .~ 1
            |> SearchHotelParams.lens.adult .~ "2"
            |> SearchHotelParams.lens.night .~ 1
        
        let hotelServices = Signal.combineLatest(self.viewDidLoadProperty.signal.filter { AppEnvironment.current.apiService.tiketToken?.token != "" }, self.selectedFilterProperty.signal.skipNil(), isVisible).filter { _, _, visible in visible }.skipRepeats { lhs, rhs in lhs.0 == rhs.0 && lhs.1 == rhs.1 }.map(second).switchMap { params in
            return AppEnvironment.current.apiService.fetchHotelResults(params: params).retry(upTo: 3).on(started: { isLoading.value = true }, completed: { isLoading.value = false }, terminated: { isLoading.value = false }).materialize()
            }
        
//        print("\(hotelServices.values())")
        
        self.hideEmptyState = self.viewWillAppearProperty.signal.take(first: 1)
        self.hotelsAreLoading = isLoading.signal
        
        self.hotels = hotelServices.values().map { $0.searchHotelResults }.skip { $0.isEmpty }.skipRepeats(==)
        
        self.showEmptyState = hotelServices.values().filter { $0.diagnostic.status != .successful && $0.searchHotelResults.isEmpty }.map { _ in
            EmptyState.hotelResult
        }
    }
    
    fileprivate let selectedFilterProperty = MutableProperty<SearchHotelParams?>(nil)
    public func selectedFilter(_ params: SearchHotelParams) {
        self.selectedFilterProperty.value = params
    }
    
    fileprivate let viewDidAppearProperty = MutableProperty(())
    public func viewDidAppear() {
        self.viewDidAppearProperty.value = ()
    }
    
    fileprivate let viewWillAppearProperty = MutableProperty(())
    public func viewWillAppear() {
        self.viewWillAppearProperty.value = ()
    }
    
    fileprivate let viewDidDisappearProperty = MutableProperty(false)
    public func viewDidDisappear(_ animated: Bool) {
        self.viewDidDisappearProperty.value = animated
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    fileprivate let willDisplayRowProperty = MutableProperty<(row: Int, total: Int)?>(nil)
    public func willDisplayRow(_ row: Int, outOf totalRows: Int) {
        self.willDisplayRowProperty.value = (row, totalRows)
    }
    
    public let hideEmptyState: Signal<(), NoError>
    public let hotels: Signal<[HotelResult], NoError>
    public let hotelsAreLoading: Signal<Bool, NoError>
    public let showEmptyState: Signal<EmptyState, NoError>
    
    public var inputs: HotelLiveFeedContentViewModelInputs { return self }
    public var outputs: HotelLiveFeedContentViewModelOutputs { return self }
}
