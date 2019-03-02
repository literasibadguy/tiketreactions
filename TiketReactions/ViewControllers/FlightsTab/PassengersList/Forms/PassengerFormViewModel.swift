//
//  PassengerFormViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 29/12/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol PassengerFormViewModelInputs {
    func configureWith(_ format: FormatDataForm, state: PassengerFormState)
    func viewDidLoad()
}

public protocol PassengerFormViewModelOutputs {
    var sourceContactFirstPassenger: Signal<FormatDataForm, NoError> { get }
    var sourceAdultsPassenger: Signal<FormatDataForm, NoError> { get }
    var sourceChildsPassenger: Signal<FormatDataForm, NoError> { get }
    var sourceInfantsPassenger: Signal<FormatDataForm, NoError> { get }
    var submitPassenger: Signal<GroupPassengersParam, NoError> { get }
}

public protocol PassengerFormViewModelType {
    var inputs: PassengerFormViewModelInputs { get }
    var outputs: PassengerFormViewModelOutputs { get }
}

public final class PassengerFormViewModel: PassengerFormViewModelType, PassengerFormViewModelInputs, PassengerFormViewModelOutputs {
    
    public init() {
//        let current = Signal.combineLatest(self.viewDidLoadProperty.signal, self.configStatePassengerProperty.signal.skipNil()).map(second)
        
        let current = Signal.combineLatest(self.viewDidLoadProperty.signal, self.configStatePassengerProperty.signal.skipNil()).map(second)
        
        self.sourceContactFirstPassenger = current.map(first).filter { $0.fieldText == "Penumpang Dewasa 1" }
        self.sourceAdultsPassenger = current.map(first).filter { $0.fieldText == "Penumpang Dewasa 2" && $0.fieldText == "Penumpang Dewasa 3" && $0.fieldText == "Penumpang Dewasa 4" && $0.fieldText == "Penumpang Dewasa 5" && $0.fieldText == "Penumpang Dewasa 6"  }
        self.sourceChildsPassenger = current.map(first).filter { $0.fieldText == "Penumpang Anak 1" && $0.fieldText == "Penumpang Anak 2" && $0.fieldText == "Penumpang Anak 3" && $0.fieldText == "Penumpang Anak 4" && $0.fieldText == "Penumpang Anak 5" && $0.fieldText == "Penumpang Anak 6"  }
        self.sourceInfantsPassenger = current.map(first).filter { $0.fieldText == "Penumpang Dewasa 2" && $0.fieldText == "Penumpang Dewasa 3" && $0.fieldText == "Penumpang Dewasa 4" && $0.fieldText == "Penumpang Dewasa 5" && $0.fieldText == "Penumpang Dewasa 6"  }
        
        self.submitPassenger = .empty
    }
    
    
    fileprivate let configStatePassengerProperty = MutableProperty<(FormatDataForm, PassengerFormState)?>(nil)
    public func configureWith(_ format: FormatDataForm, state: PassengerFormState) {
        self.configStatePassengerProperty.value = (format, state)
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let sourceContactFirstPassenger: Signal<FormatDataForm, NoError>
    public let sourceAdultsPassenger: Signal<FormatDataForm, NoError>
    public let sourceInfantsPassenger: Signal<FormatDataForm, NoError>
    public let sourceChildsPassenger: Signal<FormatDataForm, NoError>
    public let submitPassenger: Signal<GroupPassengersParam, NoError>
    
    public var inputs: PassengerFormViewModelInputs { return self }
    public var outputs: PassengerFormViewModelOutputs { return self }
}
