//
//  HotelFormViewModel.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 13/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import Result
import TiketAPIs

public protocol HotelFormViewModelInputs {
    
    func destinationButtonTapped()
    
    func destinationHotelSelected(row: AutoHotelResult)
    
    func roomGuestSelected(room: Int, guest: Int)
    
    func guestButtonTapped()
    
    func selectDatePressed()
    
    func viewDidLoad()
}

public protocol HotelFormViewModelOutputs {
    var dismissDestinationHotelList: Signal<(), NoError> { get }
    var destinationHotelLabelText: Signal<String, NoError> { get }
    var roomGuestFilledParam: Signal<(Int, Int), NoError> { get }
    var showDestinationHotelList: Signal<(), NoError> { get }
    var showGuestForm: Signal<(), NoError> { get }
}

public protocol HotelFormViewModelType {
    var inputs: HotelFormViewModelInputs { get }
    var outputs: HotelFormViewModelOutputs { get }
}

public final class HotelFormViewModel: HotelFormViewModelType, HotelFormViewModelInputs, HotelFormViewModelOutputs {
    
    init() {
        
//        let currentDestination = self.destinationHotelSelectedProperty.signal.skipNil()
        
        self.destinationHotelLabelText = self.destinationHotelSelectedProperty.signal.skipNil().map { selected in
            return selected.category
        }
        
        self.dismissDestinationHotelList = self.destinationHotelSelectedProperty.signal.ignoreValues().ck_delay(.milliseconds(400), on: AppEnvironment.current.scheduler)
        
        self.showDestinationHotelList = self.destinationButtonTappedProperty.signal
        self.showGuestForm = self.guestButtonTappedProperty.signal
        
        self.roomGuestFilledParam = .empty
    }
    
    fileprivate let destinationButtonTappedProperty = MutableProperty(())
    public func destinationButtonTapped() {
        self.destinationButtonTappedProperty.value = ()
    }
    
    fileprivate let destinationHotelSelectedProperty = MutableProperty<AutoHotelResult?>(nil)
    public func destinationHotelSelected(row: AutoHotelResult) {
        self.destinationHotelSelectedProperty.value = row
    }
    
    fileprivate let roomGuestSelectedProperty = MutableProperty<(Int, Int)?>(nil)
    public func roomGuestSelected(room: Int, guest: Int) {
        self.roomGuestSelectedProperty.value = (room, guest)
    }
    
    fileprivate let guestButtonTappedProperty = MutableProperty(())
    public func guestButtonTapped() {
        self.guestButtonTappedProperty.value = ()
    }
    
    fileprivate let selectDatePressedProperty = MutableProperty(())
    public func selectDatePressed() {
        self.selectDatePressedProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let dismissDestinationHotelList: Signal<(), NoError>
    public let destinationHotelLabelText: Signal<String, NoError>
    public let showDestinationHotelList: Signal<(), NoError>
    public let roomGuestFilledParam: Signal<(Int, Int), NoError>
    public let showGuestForm: Signal<(), NoError>
    
    public var inputs: HotelFormViewModelInputs { return self }
    public var outputs: HotelFormViewModelOutputs { return self }
}
