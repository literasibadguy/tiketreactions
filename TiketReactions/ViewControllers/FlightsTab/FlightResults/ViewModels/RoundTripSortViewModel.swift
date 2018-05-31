//
//  RoundTripSortViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 17/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol RoundTripSortViewModelInputs {
    func configureWith(sorts: [SearchFlightParams])
    func select(sort: SearchFlightParams)
    func departureButtonTapped(index: Int)
    func arrivalButtonTapped(index: Int)
    func viewDidAppear()
    func viewWillAppear()
}

public protocol RoundTripSortViewModelOutputs {
    var pinSelectedIndicatorToPage: Signal<(Int, Bool), NoError> { get }
    var notifyDelegateOfSelectedSort: Signal<SearchFlightParams, NoError> { get }
    var setSelectedButton: Signal<Int, NoError> { get }
    var updateSortStyle: Signal<[SearchFlightParams], NoError> { get }
}

public protocol RoundTripSortViewModelType {
    var inputs: RoundTripSortViewModelInputs { get }
    var outputs: RoundTripSortViewModelOutputs { get }
}

public final class RoundTripSortViewModel: RoundTripSortViewModelType, RoundTripSortViewModelInputs, RoundTripSortViewModelOutputs {
    
    public init() {
        let sorts = self.sortsProperty.signal.skipNil()
            .takeWhen(self.viewWillAppearProperty.signal)
        
        self.updateSortStyle = .empty
        
        let selectedPage = Signal.combineLatest(
            sorts,
            self.selectSortProperty.signal.skipNil()
        )
        .map { sorts, sort in (sorts.index(of: sort) ?? 0, sorts.count)  }
        
        let pageIndex = sorts.mapConst(0)
        
        self.pinSelectedIndicatorToPage = Signal.merge(pageIndex.takeWhen(self.viewDidAppearProperty.signal).take(first: 1).map { ($0, false) },
            selectedPage.map { page, _ in (page, true) }.skipRepeats(==)
        )
        
        self.notifyDelegateOfSelectedSort = Signal.combineLatest(sorts.take(first: 1), self.departureButtonIndexProperty.signal.skipNil(), self.arrivalButtonIndexProperty.signal.skipNil()).map { sorts, departure, arrival in
            sorts[arrival]
        }
        
        self.setSelectedButton = Signal.merge(pageIndex.take(first: 1), self.departureButtonIndexProperty.signal.skipNil(), self.arrivalButtonIndexProperty.signal.skipNil()).skipRepeats(==)
    }
    
    fileprivate let sortsProperty = MutableProperty<[SearchFlightParams]?>(nil)
    public func configureWith(sorts: [SearchFlightParams]) {
        self.sortsProperty.value = sorts
    }
    
    fileprivate let selectSortProperty = MutableProperty<SearchFlightParams?>(nil)
    public func select(sort: SearchFlightParams) {
        self.selectSortProperty.value = sort
    }
    
    fileprivate let departureButtonIndexProperty = MutableProperty<Int?>(nil)
    public func departureButtonTapped(index: Int) {
        self.departureButtonIndexProperty.value = index
    }
    
    fileprivate let arrivalButtonIndexProperty = MutableProperty<Int?>(nil)
    public func arrivalButtonTapped(index: Int) {
        self.arrivalButtonIndexProperty.value = index
    }
    
    fileprivate let viewDidAppearProperty = MutableProperty(())
    public func viewDidAppear() {
        self.viewDidAppearProperty.value = ()
    }
    
    fileprivate let viewWillAppearProperty = MutableProperty(())
    public func viewWillAppear() {
        self.viewWillAppearProperty.value = ()
    }
    
    public let pinSelectedIndicatorToPage: Signal<(Int, Bool), NoError>
    public let notifyDelegateOfSelectedSort: Signal<SearchFlightParams, NoError>
    public let setSelectedButton: Signal<Int, NoError>
    public let updateSortStyle: Signal<[SearchFlightParams], NoError>
    
    public var inputs: RoundTripSortViewModelInputs { return self }
    public var outputs: RoundTripSortViewModelOutputs { return self }
}
