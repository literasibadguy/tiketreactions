//
//  FlightResultsContentViewModel.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 12/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketAPIs

public protocol FlightResultsContentViewModelInputs {
    func configureWith(sort: SearchFlightParams)
    func selectedFilter(_ params: SearchFlightParams)
    func tapped(flight: Flight)
    func viewDidAppear()
    func viewDidDisappear(animated: Bool)
    func viewWillAppear()
    func willDisplayRow(_ row: Int, outOf totalRows: Int)
}

public protocol FlightResultsContentViewModelOutputs {
    var hideEmptyState: Signal<(), NoError> { get }
    var flights: Signal<[FlightInfo], NoError> { get }
}

public protocol FlightResultsContentViewModelTypes {
    var inputs: FlightResultsContentViewModelInputs { get }
    var outputs: FlightResultsContentViewModelOutputs { get }
}

public final class FlightResultsContentViewModel: FlightResultsContentViewModelTypes, FlightResultsContentViewModelInputs, FlightResultsContentViewModelOutputs {
    
    init() {
        self.hideEmptyState = .empty
        self.flights = .empty
    }
    
    fileprivate let sortProperty = MutableProperty<SearchFlightParams?>(nil)
    public func configureWith(sort: SearchFlightParams) {
        self.sortProperty.value = sort
    }
    
    fileprivate let selectedFilterProperty = MutableProperty<SearchFlightParams?>(nil)
    public func selectedFilter(_ params: SearchFlightParams) {
        self.selectedFilterProperty.value = params
    }
    
    fileprivate let tappedFlight = MutableProperty<Flight?>(nil)
    public func tapped(flight: Flight) {
        self.tappedFlight.value = flight
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
    
    public let hideEmptyState: Signal<(), NoError>
    public let flights: Signal<[FlightInfo], NoError>
    
    public var inputs: FlightResultsContentViewModelInputs { return self }
    public var outputs: FlightResultsContentViewModelOutputs { return self }
}


