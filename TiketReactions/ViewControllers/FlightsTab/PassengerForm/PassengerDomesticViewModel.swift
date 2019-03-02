//
//  PassengerDomesticViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 30/08/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol PassengerDomesticViewModelInputs {
    func titleSalutationButtonTapped()
    func titleSalutationChanged(_ text: String?)
    func titleSalutationCanceled()
    
    func firstNameTextFieldChange(_ text: String?)
    func firstNameTextFieldDidEndEditing()
    
    func lastNameTextFieldChange(_ text: String?)
    func lastNameTextFieldDidEndEditing()
    
    func submitDomesticFormButtonTapped()
    
    func viewDidLoad()
}

public protocol PassengerDomesticViewModelOutputs {
    var titleLabelText: Signal<String, NoError> { get }
    var goToTitleSalutationPicker: Signal<(), NoError> { get }
    var dismissSalutationPicker: Signal<(), NoError> { get }
    var firstNameFirstResponder: Signal<(), NoError> { get }
    var lastNameFirstResponder: Signal<(), NoError> { get }
    var firstNameTextFieldText: Signal<String, NoError> { get }
    var lastNameTextFieldText: Signal<String, NoError> { get }
    var domesticFormIsCompleted: Signal<Bool, NoError> { get }
    var dismissDomesticForm: Signal<(), NoError> { get }
}

public protocol PassengerDomesticViewModelType {
    var inputs: PassengerDomesticViewModelInputs { get }
    var outputs: PassengerDomesticViewModelOutputs { get }
}

public final class PassengerDomesticViewModel: PassengerDomesticViewModelType, PassengerDomesticViewModelInputs, PassengerDomesticViewModelOutputs {
    
    public init() {
        
        let initialText = self.viewDidLoadProperty.signal.mapConst("")
        
        self.goToTitleSalutationPicker = self.titleSalutationTappedProperty.signal
        self.dismissSalutationPicker = self.titleSalutationCanceledProperty.signal
        
        self.firstNameFirstResponder = self.titleSalutationChangedProperty.signal.ignoreValues()
        self.lastNameFirstResponder = self.firstNameTextFieldDidEndProperty.signal
        
        let title = Signal.merge(self.titleSalutationChangedProperty.signal.skipNil(), initialText)
        let firstName = Signal.merge(self.firstNameTextFieldChangedProperty.signal.skipNil(), initialText)
        let lastName = Signal.merge(self.lastNameTextChangedProperty.signal.skipNil(), initialText)
        
        let domesticForm = Signal.combineLatest(title, firstName, lastName)
        
        /*
        let domesticFormParam = domesticForm.switchMap { title, first, last -> SignalProducer<AdultPassengerParam, NoError> in
            let passengerParam = .defaults
                |> AdultPassengerParam.lens.title .~ title
                |> AdultPassengerParam.lens.firstname .~ first
                |> AdultPassengerParam.lens.lastname .~ last
            return SignalProducer(value: passengerParam)
        }
        */
        
        self.titleLabelText = title
        self.firstNameTextFieldText = firstName
        self.lastNameTextFieldText = lastName
        self.domesticFormIsCompleted = domesticForm.map(isDomesticValid(title:firstName:lastName:)).filter { $0 == true }
        
        self.dismissDomesticForm = self.submitDomesticTappedProperty.signal
    }
    
    fileprivate let titleSalutationTappedProperty = MutableProperty(())
    public func titleSalutationButtonTapped() {
        self.titleSalutationTappedProperty.value = ()
    }
    
    fileprivate let titleSalutationChangedProperty = MutableProperty<String?>(nil)
    public func titleSalutationChanged(_ text: String?) {
        self.titleSalutationChangedProperty.value = text
    }
    
    fileprivate let titleSalutationCanceledProperty = MutableProperty(())
    public func titleSalutationCanceled() {
        self.titleSalutationCanceledProperty.value = ()
    }
    
    fileprivate let firstNameTextFieldChangedProperty = MutableProperty<String?>(nil)
    public func firstNameTextFieldChange(_ text: String?) {
        self.firstNameTextFieldChangedProperty.value = text
    }
    
    fileprivate let firstNameTextFieldDidEndProperty = MutableProperty(())
    public func firstNameTextFieldDidEndEditing() {
        self.firstNameTextFieldDidEndProperty.value = ()
    }
    
    fileprivate let lastNameTextChangedProperty = MutableProperty<String?>(nil)
    public func lastNameTextFieldChange(_ text: String?) {
        self.lastNameTextChangedProperty.value = text
    }
    
    fileprivate let lastNameTextFieldDidEndProperty = MutableProperty(())
    public func lastNameTextFieldDidEndEditing() {
        self.lastNameTextFieldDidEndProperty.value = ()
    }
    
    fileprivate let submitDomesticTappedProperty = MutableProperty(())
    public func submitDomesticFormButtonTapped() {
        self.submitDomesticTappedProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let titleLabelText: Signal<String, NoError>
    public let goToTitleSalutationPicker: Signal<(), NoError>
    public let dismissSalutationPicker: Signal<(), NoError>
    public let firstNameFirstResponder: Signal<(), NoError>
    public let lastNameFirstResponder: Signal<(), NoError>
    public let firstNameTextFieldText: Signal<String, NoError>
    public let lastNameTextFieldText: Signal<String, NoError>
    public let domesticFormIsCompleted: Signal<Bool, NoError>
    public let dismissDomesticForm: Signal<(), NoError>
    
    public var inputs: PassengerDomesticViewModelInputs { return self }
    public var outputs: PassengerDomesticViewModelOutputs { return self }
}

private func isDomesticValid(title: String, firstName: String, lastName: String) -> Bool {
    return !title.isEmpty && !firstName.isEmpty && !lastName.isEmpty
}

