//
//  HotelLiveFeedNavViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 06/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import TiketKitModels

public protocol HotelLiveFeedNavViewModelInputs {
    func configureWith(params: SearchHotelParams)
    
    func destinationButtonTapped()
    
    func destinationSelected(_ dest: SelectableRow)
    
    func dateRangeButtonTapped()
    
    func dateRangeSelected(_ startDate: String, endDate: String)
    
    func guestRoomButtonTapped()
    
    func guestRoomSelected(_ guest: Int, room: Int)
    
    func sortFilterButtonTapped()
    
    func viewDidLoad()
}

public protocol HotelLiveFeedNavViewModelOutputs {
    var destinationLabelText: Signal<String, NoError> { get }
    var dateRangeLabelText: Signal<String, NoError> { get }
    var guestRoomLabelText: Signal<String, NoError> { get }
    var showDestinationFilters: Signal<SelectableRow, NoError> { get }
    var showDateRangeFilters: Signal<(), NoError> { get }
    var showGuestRoomFilters: Signal<(), NoError> { get }
    var showSortFilters: Signal<(), NoError> { get }
    var dismissDestinationFilters: Signal<SearchHotelParams, NoError> { get }
    var dismissDateRangeFilters: Signal<(), NoError> { get }
}

public protocol HotelLiveFeedNavViewModelType {
    var inputs: HotelLiveFeedNavViewModelInputs { get }
    var outputs: HotelLiveFeedNavViewModelOutputs { get }
}

public final class HotelLiveFeedNavViewModel: HotelLiveFeedNavViewModelType, HotelLiveFeedNavViewModelInputs, HotelLiveFeedNavViewModelOutputs {
    
    
    public init() {
        
        self.destinationLabelText = .empty
        self.dateRangeLabelText = .empty
        self.guestRoomLabelText = .empty
        self.dismissDateRangeFilters = .empty
        
        let rowForFilters = Signal.merge(self.configParamsProperty.signal.skipNil().map { SelectableRow(isSelected: true, params: $0) }, self.destinationSelectedProperty.signal.skipNil())
        
        self.showDestinationFilters = rowForFilters.takeWhen(self.destinationButtonTappedProperty.signal)
        self.showDateRangeFilters = self.dateRangeButtonTappedProperty.signal
        self.showGuestRoomFilters = self.guestRoomButtonTappedProperty.signal
        self.showSortFilters = self.sortFilterButtonTappedProperty.signal
        
        self.dismissDestinationFilters = self.destinationSelectedProperty.signal.skipNil().map { $0.params }
    }
    
    fileprivate let configParamsProperty = MutableProperty<SearchHotelParams?>(nil)
    public func configureWith(params: SearchHotelParams) {
        self.configParamsProperty.value = params
    }
    
    fileprivate let destinationButtonTappedProperty = MutableProperty(())
    public func destinationButtonTapped() {
        self.destinationButtonTappedProperty.value = ()
    }
    
    fileprivate let destinationSelectedProperty = MutableProperty<SelectableRow?>(nil)
    public func destinationSelected(_ dest: SelectableRow) {
        self.destinationSelectedProperty.value = dest
    }
    
    fileprivate let dateRangeButtonTappedProperty = MutableProperty(())
    public func dateRangeButtonTapped() {
        self.dateRangeButtonTappedProperty.value = ()
    }
    
    fileprivate let dateRangeSelectedProperty = MutableProperty<(String, String)?>(nil)
    public func dateRangeSelected(_ startDate: String, endDate: String) {
        self.dateRangeSelectedProperty.value = (startDate, endDate)
    }
    
    fileprivate let guestRoomButtonTappedProperty = MutableProperty(())
    public func guestRoomButtonTapped() {
        self.guestRoomButtonTappedProperty.value = ()
    }
    
    fileprivate let guestRoomSelectedProperty = MutableProperty<(Int, Int)?>(nil)
    public func guestRoomSelected(_ guest: Int, room: Int) {
        self.guestRoomSelectedProperty.value = (guest, room)
    }
    
    fileprivate let sortFilterButtonTappedProperty = MutableProperty(())
    public func sortFilterButtonTapped() {
        self.sortFilterButtonTappedProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let destinationLabelText: Signal<String, NoError>
    public let dateRangeLabelText: Signal<String, NoError>
    public let guestRoomLabelText: Signal<String, NoError>
    public let showDestinationFilters: Signal<SelectableRow, NoError>
    public let showDateRangeFilters: Signal<(), NoError>
    public let showGuestRoomFilters: Signal<(), NoError>
    public let showSortFilters: Signal<(), NoError>
    public let dismissDestinationFilters: Signal<SearchHotelParams, NoError>
    public let dismissDateRangeFilters: Signal<(), NoError>
    
    public var inputs: HotelLiveFeedNavViewModelInputs { return self }
    public var outputs: HotelLiveFeedNavViewModelOutputs { return self }
}
