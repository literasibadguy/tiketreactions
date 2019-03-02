//
//  PickPassengersViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 04/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result

public protocol PickPassengersViewModelInputs {
    func configureWith(adult: Int, child: Int, infant: Int)
    func adultStepperChanged(_ value: Double)
    func childStepperChanged(_ value: Double)
    func infantStepperChanged(_ value: Double)
    func tappedConfirmButton()
    func viewDidLoad()
}

public protocol PickPassengersViewModelOutputs {
    var adultValueText: Signal<String, NoError> { get }
    var childValueText: Signal<String, NoError> { get }
    var infantValueText: Signal<String, NoError> { get }
    var passengerTotalValueText: Signal<String, NoError> { get }
    var adultValue: Signal<Double, NoError> { get }
    var childValue: Signal<Double, NoError> { get }
    var infantValue: Signal<Double, NoError> { get }
    var dismissPickPassengers: Signal<(Int, Int, Int), NoError> { get }
    var doneButtonDisabled: Signal<Bool, NoError> { get }
}

public protocol PickPassengersViewModelType {
    var inputs: PickPassengersViewModelInputs { get }
    var outputs: PickPassengersViewModelOutputs { get }
}

public final class PickPassengersViewModel: PickPassengersViewModelType, PickPassengersViewModelInputs, PickPassengersViewModelOutputs {
    
    public init() {
        let countChanged = Signal.combineLatest(self.configCountProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        let adultChanged = Signal.merge(countChanged.map { Double($0.0) }, self.adultChangedProperty.signal.skipNil()).map { Int($0) }
        let childChanged = Signal.merge(countChanged.map { Double($0.1) }, self.childChangedProperty.signal.skipNil()).map { Int($0) }
        
        let infantChanged = Signal.merge(countChanged.map { Double($0.2) }, self.infantChangedProperty.signal.skipNil()).map { Int($0) }
        
        let passengerAdapted = Signal.combineLatest(adultChanged, childChanged, infantChanged).map { $0.0 < $0.1 && $0.0 < $0.2 }
        
        self.adultValueText = adultChanged.map { "\(Int($0)) Dewasa" }
        self.childValueText = childChanged.map { "\(Int($0)) Anak" }
        self.infantValueText = infantChanged.map { "\(Int($0)) Bayi" }
        
        self.adultValue = adultChanged.map { Double($0) }
        self.childValue = childChanged.map { Double($0) }
        self.infantValue = infantChanged.map { Double($0) }
        
        let totalValue = Signal.combineLatest(adultChanged, childChanged, infantChanged).map { $0.0 + $0.1 + $0.2 }
        
        self.passengerTotalValueText = totalValue.map { "\($0) Penumpang" }
        
        self.dismissPickPassengers = Signal.combineLatest(adultChanged, childChanged, infantChanged).takeWhen(self.confirmButtonProperty.signal)
        
        self.doneButtonDisabled = passengerAdapted.negate()
    }
    
    fileprivate let configCountProperty = MutableProperty<(Int, Int, Int)?>(nil)
    public func configureWith(adult: Int, child: Int, infant: Int) {
        self.configCountProperty.value = (adult, child, infant)
    }
    
    fileprivate let adultChangedProperty = MutableProperty<Double?>(nil)
    public func adultStepperChanged(_ value: Double) {
        self.adultChangedProperty.value = value
    }
    
    fileprivate let childChangedProperty = MutableProperty<Double?>(nil)
    public func childStepperChanged(_ value: Double) {
        self.childChangedProperty.value = value
    }
    
    fileprivate let infantChangedProperty = MutableProperty<Double?>(nil)
    public func infantStepperChanged(_ value: Double) {
        self.infantChangedProperty.value = value
    }
    
    fileprivate let confirmButtonProperty = MutableProperty(())
    public func tappedConfirmButton() {
        self.confirmButtonProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let adultValueText: Signal<String, NoError>
    public let childValueText: Signal<String, NoError>
    public let infantValueText: Signal<String, NoError>
    public let passengerTotalValueText: Signal<String, NoError>
    public let adultValue: Signal<Double, NoError>
    public let childValue: Signal<Double, NoError>
    public let infantValue: Signal<Double, NoError>
    public let dismissPickPassengers: Signal<(Int, Int, Int), NoError>
    public let doneButtonDisabled: Signal<Bool, NoError>
    
    public var inputs: PickPassengersViewModelInputs { return self }
    public var outputs: PickPassengersViewModelOutputs { return self }
}
