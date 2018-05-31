//
//  AnotherGuestFormViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 29/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol AnotherGuestFormViewModelInputs {
    func configureWith(_ param: CheckoutGuestParams)
    
    func titleSalutationButtonTapped()
    func titleSalutationChanged(_ text: String?)
    func titleSalutationCanceled()
    
    func firstNameTextFieldChange(_ text: String?)
    func firstNameTextFieldDidEndEditing()
    
    func lastNameTextFieldChange(_ text: String?)
    func lastNameTextFieldDidEndEditing()
}

public protocol AnotherGuestFormViewModelOutputs {
    var titleLabelText: Signal<String, NoError> { get }
    var goToTitleSalutationPicker: Signal<(), NoError> { get }
    var dismissSalutationPicker: Signal<(), NoError> { get }
    var isGuestFormValid: Signal<Bool, NoError> { get }
    var notifyGuestParam: Signal<CheckoutGuestParams, NoError> { get }
    var fullnameTextFieldText: Signal<String, NoError> { get }
}

public protocol AnotherGuestFormViewModelType {
    var inputs: AnotherGuestFormViewModelInputs { get }
    var outputs: AnotherGuestFormViewModelOutputs { get }
}

public final class AnotherGuestFormViewModel: AnotherGuestFormViewModelType, AnotherGuestFormViewModelInputs, AnotherGuestFormViewModelOutputs {
    
    init() {
        
        let initialText = self.titleChangedTextProperty.signal.mapConst("")
        
        let titleText = Signal.merge(self.titleChangedTextProperty.signal.skipNil(), initialText)
        let firstNameText = Signal.merge(self.firstNameChangedTextProperty.signal.skipNil(), initialText)
        let lastNameText = Signal.merge(self.lastNameChangedTextProperty.signal.skipNil(), initialText)
        
        let anotherGuestParam = Signal.combineLatest(self.configGuestParamProperty.signal.skipNil(), titleText.filter { $0 != "" }, firstNameText.filter { $0 != "" }, lastNameText).switchMap { (arg) -> SignalProducer<CheckoutGuestParams, NoError> in
            let (current, title, firstName, lastName) = arg
            let param = current
                |> CheckoutGuestParams.lens.salutation .~ title
                |> CheckoutGuestParams.lens.firstName .~ firstName
                |> CheckoutGuestParams.lens.lastName .~ lastName
            
            return SignalProducer(value: param)
        }.materialize()
        
        self.titleLabelText = titleText
        
        self.goToTitleSalutationPicker = self.titleTappedProperty.signal
        
        self.dismissSalutationPicker = self.titleCanceledProperty.signal
        
        self.fullnameTextFieldText = firstNameText
        
        self.isGuestFormValid = Signal.combineLatest(titleText, firstNameText, lastNameText).map(isValid(title:firstName:lastName:))
        
        self.notifyGuestParam = anotherGuestParam.values()
    }
    
    fileprivate let configGuestParamProperty = MutableProperty<CheckoutGuestParams?>(nil)
    public func configureWith(_ param: CheckoutGuestParams) {
        self.configGuestParamProperty.value = param
    }
    
    fileprivate let titleTappedProperty = MutableProperty(())
    public func titleSalutationButtonTapped() {
        self.titleTappedProperty.value = ()
    }
    
    fileprivate let titleChangedTextProperty = MutableProperty<String?>(nil)
    public func titleSalutationChanged(_ text: String?) {
        self.titleChangedTextProperty.value = text
    }
    
    fileprivate let titleCanceledProperty = MutableProperty(())
    public func titleSalutationCanceled() {
        self.titleCanceledProperty.value = ()
    }
    
    fileprivate let firstNameChangedTextProperty = MutableProperty<String?>(nil)
    public func firstNameTextFieldChange(_ text: String?) {
        self.firstNameChangedTextProperty.value = text
    }
    
    fileprivate let firstNameTextDidEndProperty = MutableProperty(())
    public func firstNameTextFieldDidEndEditing() {
        self.firstNameTextDidEndProperty.value = ()
    }
    
    fileprivate let lastNameChangedTextProperty = MutableProperty<String?>(nil)
    public func lastNameTextFieldChange(_ text: String?) {
        self.lastNameChangedTextProperty.value = text
    }
    
    fileprivate let lastNameTextDidEndProperty = MutableProperty(())
    public func lastNameTextFieldDidEndEditing() {
        self.lastNameTextDidEndProperty.value = ()
    }
    
    public let titleLabelText: Signal<String, NoError>
    public let goToTitleSalutationPicker: Signal<(), NoError>
    public let dismissSalutationPicker: Signal<(), NoError>
    public let isGuestFormValid: Signal<Bool, NoError>
    public let notifyGuestParam: Signal<CheckoutGuestParams, NoError>
    public let fullnameTextFieldText: Signal<String, NoError>
    
    public var inputs: AnotherGuestFormViewModelInputs { return self }
    public var outputs: AnotherGuestFormViewModelOutputs { return self }
}

private func isValid(title: String, firstName: String, lastName: String) -> Bool {
    return !title.isEmpty && !firstName.isEmpty && !lastName.isEmpty
}

