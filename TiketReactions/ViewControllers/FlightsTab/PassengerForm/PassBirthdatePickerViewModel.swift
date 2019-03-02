//
//  PassBirthdateViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 27/02/19.
//  Copyright © 2019 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result

public protocol PassBirthdatePickerViewModelInputs {
    func configureWith(_ state: PassengerFormState)
    func configureForExpired()
    func doneButtonTapped()
    func viewDidLoad()
}

public protocol PassBirthdatePickerViewModelOutputs {
    var changeDateFormat: Signal<PassengerFormState, NoError> { get }
    var submitDate: Signal<(), NoError> { get }
}

public protocol PassBirthdatePickerViewModelType {
    var inputs: PassBirthdatePickerViewModelInputs { get }
    var outputs: PassBirthdatePickerViewModelOutputs { get }
}

public final class PassBirthdatePickerViewModel: PassBirthdatePickerViewModelType, PassBirthdatePickerViewModelInputs, PassBirthdatePickerViewModelOutputs {
    
    public init() {
        let current = Signal.combineLatest(self.viewDidLoadProperty.signal, self.configStateProperty.signal.skipNil()).map(second)
        
        let expiredConfig = Signal.combineLatest(self.viewDidLoadProperty.signal, self.configExpiredProperty.signal).mapConst(PassengerFormState.firstPassenger)
        
        self.changeDateFormat = Signal.merge(current.signal, expiredConfig.signal)
        
        self.submitDate = self.doneTappedProperty.signal
    }
    
    fileprivate let configStateProperty = MutableProperty<PassengerFormState?>(nil)
    public func configureWith(_ state: PassengerFormState) {
        self.configStateProperty.value = state
    }
    
    fileprivate let configExpiredProperty = MutableProperty(())
    public func configureForExpired() {
        self.configExpiredProperty.value = ()
    }
    
    fileprivate let doneTappedProperty = MutableProperty(())
    public func doneButtonTapped() {
        self.doneTappedProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let changeDateFormat: Signal<PassengerFormState, NoError>
    public let submitDate: Signal<(), NoError>
    
    public var inputs: PassBirthdatePickerViewModelInputs { return self }
    public var outputs: PassBirthdatePickerViewModelOutputs { return self }
}


