//
//  PassengerBaggagePickerViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 02/03/19.
//  Copyright © 2019 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol PassengerBaggagePickerViewModelInputs {
    func cancelButtonTapped()
    func configureBaggage(_ availables: [ResourceBaggage])
    func pickerView(didSelectRow row: Int)
    func doneButtonTapped()
    func viewDidLoad()
}

public protocol PassengerBaggagePickerViewModelOutputs {
    var dataSource: Signal<[ResourceBaggage], NoError> { get }
    var notifyDelegateChoseBaggage: Signal<ResourceBaggage, NoError> { get }
    var notifyDelegateToCancel: Signal<(), NoError> { get }
    var selectRow: Signal<Int, NoError> { get }
}

public protocol PassengerBaggagePickerViewModelType {
    var inputs: PassengerBaggagePickerViewModelInputs { get }
    var outputs: PassengerBaggagePickerViewModelOutputs { get }
}

public final class PassengerBaggagePickerViewModel: PassengerBaggagePickerViewModelType, PassengerBaggagePickerViewModelInputs, PassengerBaggagePickerViewModelOutputs {
    
    public init() {
        
        let availBaggages = Signal.combineLatest(self.configAvailBaggagesProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        let selectedBaggage = Signal.combineLatest(availBaggages.signal, self.pickerSelectedRowProperty.signal).map { baggages, index in baggages[index] }
        
        self.dataSource = availBaggages.signal
        self.selectRow = .empty
        
        self.notifyDelegateChoseBaggage = selectedBaggage.signal.takeWhen(self.doneButtonTappedProperty.signal)
        self.notifyDelegateToCancel = self.cancelTappedProperty.signal
    }
    
    fileprivate let cancelTappedProperty = MutableProperty(())
    public func cancelButtonTapped() {
        self.cancelTappedProperty.value = ()
    }
    
    fileprivate let configAvailBaggagesProperty = MutableProperty<[ResourceBaggage]?>(nil)
    public func configureBaggage(_ availables: [ResourceBaggage]) {
        self.configAvailBaggagesProperty.value = availables
    }
    
    fileprivate let pickerSelectedRowProperty = MutableProperty(-1)
    public func pickerView(didSelectRow row: Int) {
        self.pickerSelectedRowProperty.value = row
    }
    
    fileprivate let doneButtonTappedProperty = MutableProperty(())
    public func doneButtonTapped() {
        self.doneButtonTappedProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    fileprivate let viewWillAppearProperty = MutableProperty(())
    public func viewWillAppear() {
        self.viewWillAppearProperty.value = ()
    }
    
    public let dataSource: Signal<[ResourceBaggage], NoError>
    public let notifyDelegateChoseBaggage: Signal<ResourceBaggage, NoError>
    public let notifyDelegateToCancel: Signal<(), NoError>
    public let selectRow: Signal<Int, NoError>
    
    public var inputs: PassengerBaggagePickerViewModelInputs { return self }
    public var outputs: PassengerBaggagePickerViewModelOutputs { return self }
}
