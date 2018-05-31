//
//  ContactInfoCellViewModel.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 16/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol ContactInfoCellViewModelInputs {
    func titleSalutationButtonTapped()
    func titleSalutationChanged(_ text: String?)
    func titleSalutationCanceled()
    
    func firstNameTextFieldChange(_ text: String?)
    func firstNameTextFieldDidEndEditing()
    
    func lastNameTextFieldChange(_ text: String?)
    func lastNameTextFieldDidEndEditing()
    
    func emailTextFieldChange(_ text: String?)
    func emailTextFieldDidEndEditing()
    
    func phoneCodeButtonTapped()
    func phoneCodeChanged(_ text: String?)
    
    func phoneTextFieldChange(_ text: String?)
    func phoneTextFieldDidEndEditing()
}

public protocol ContactInfoCellViewModelOutputs {
    var titleLabelText: Signal<String, NoError> { get }
    var goToTitleSalutationPicker: Signal<(), NoError> { get }
    var dismissSalutationPicker: Signal<(), NoError> { get }
    var firstNameTextFieldText: Signal<String, NoError> { get }
    var lastNameTextFieldText: Signal<String, NoError> { get }
    var emailTextFieldText: Signal<String, NoError> { get }
    var phoneCodeLabelText: Signal<String, NoError> { get }
    var phoneTextFieldText: Signal<String, NoError> { get }
    var contactFormIsCompleted: Signal<Bool, NoError> { get }
    var collectForCheckout: Signal<CheckoutGuestParams, NoError> { get }
}

public protocol ContactInfoCellViewModelType {
    var inputs: ContactInfoCellViewModelInputs { get }
    var outputs: ContactInfoCellViewModelOutputs { get }
}

public final class ContactInfoCellViewModel: ContactInfoCellViewModelType, ContactInfoCellViewModelInputs, ContactInfoCellViewModelOutputs {
    
    init() {
        
        let initialText = self.salutationChangedProperty.signal.mapConst("")
        
        self.goToTitleSalutationPicker = self.salutationButtonTappedProperty.signal
        self.dismissSalutationPicker = self.salutationCanceledProperty.signal
        
        let title = Signal.merge(self.salutationChangedProperty.signal.skipNil(), initialText)
        let firstname = Signal.merge(self.firstNameTextFieldChangeProperty.signal.skipNil(), initialText)
        let lastname = Signal.merge(self.lastNameTextFieldChangeProperty.signal.skipNil(), initialText)
        let email = Signal.merge(self.emailTextFieldChangeProperty.signal.skipNil(), initialText)
        let phone = Signal.merge(self.phoneTextFieldChangeProperty.signal.skipNil(), initialText)
        
        let titleIsPresent = title.map { $0 != "" }
        let firstnameIsPresent = firstname.map { $0 != "" }
        let lastnameIsPresent = lastname.map { $0 != "" }
        let emailIsPresent = email.map { $0 != "" }
        let phoneIsPresent = phone.map { $0 != "" }
        
        let contactForm = Signal.combineLatest(title, firstname, lastname, email, phone)
        
        self.titleLabelText = title
        self.firstNameTextFieldText = .empty
        self.lastNameTextFieldText = .empty
        self.emailTextFieldText = .empty
        self.phoneCodeLabelText = .empty
        self.phoneTextFieldText = .empty
        
        self.contactFormIsCompleted = Signal.combineLatest(titleIsPresent, firstnameIsPresent, lastnameIsPresent, emailIsPresent, phoneIsPresent).map { $0 && $1 && $2 && $3 && $4 }.skipRepeats()
        
        let contactInfoParams = contactForm.switchMap { title, first, last, email, phone -> SignalProducer<CheckoutGuestParams, NoError> in
            
            let param = .defaults
                |> CheckoutGuestParams.lens.conSalutation .~ "Mr"
                |> CheckoutGuestParams.lens.conFirstName .~ first
                |> CheckoutGuestParams.lens.conLastName .~ last
                |> CheckoutGuestParams.lens.conEmailAddress .~ email
                |> CheckoutGuestParams.lens.conPhone .~ "%2B\(phone)"
                |> CheckoutGuestParams.lens.salutation .~ "Mr"
                |> CheckoutGuestParams.lens.firstName .~ first
                |> CheckoutGuestParams.lens.lastName .~ last
                |> CheckoutGuestParams.lens.phone .~ "%2B\(phone)"
            
            return SignalProducer(value: param)
        }.materialize()
        
        self.collectForCheckout = contactInfoParams.values()
        
    }
    
    fileprivate let salutationButtonTappedProperty = MutableProperty(())
    public func titleSalutationButtonTapped() {
        self.salutationButtonTappedProperty.value = ()
    }
    
    fileprivate let salutationChangedProperty = MutableProperty<String?>(nil)
    public func titleSalutationChanged(_ text: String?) {
        self.salutationChangedProperty.value = text
    }
    
    fileprivate let salutationCanceledProperty = MutableProperty(())
    public func titleSalutationCanceled() {
        self.salutationCanceledProperty.value = ()
    }
    
    fileprivate let firstNameTextFieldChangeProperty = MutableProperty<String?>(nil)
    public func firstNameTextFieldChange(_ text: String?) {
        self.firstNameTextFieldChangeProperty.value = text
    }
    
    fileprivate let firstNameEndEditingProperty = MutableProperty(())
    public func firstNameTextFieldDidEndEditing() {
        self.firstNameEndEditingProperty.value = ()
    }
    
    fileprivate let lastNameTextFieldChangeProperty = MutableProperty<String?>(nil)
    public func lastNameTextFieldChange(_ text: String?) {
        self.lastNameTextFieldChangeProperty.value = text
    }
    
    fileprivate let lastNameEndEditingProperty = MutableProperty(())
    public func lastNameTextFieldDidEndEditing() {
        self.lastNameEndEditingProperty.value = ()
    }
    
    fileprivate let emailTextFieldChangeProperty = MutableProperty<String?>(nil)
    public func emailTextFieldChange(_ text: String?) {
        self.emailTextFieldChangeProperty.value = text
    }
    
    fileprivate let emailTextFieldDidEndEditingProperty = MutableProperty(())
    public func emailTextFieldDidEndEditing() {
        self.emailTextFieldDidEndEditingProperty.value = ()
    }
    
    fileprivate let phoneCodeButtonTappedProperty = MutableProperty(())
    public func phoneCodeButtonTapped() {
        self.phoneCodeButtonTappedProperty.value = ()
    }
    
    fileprivate let phoneCodeChangedProperty = MutableProperty<String?>(nil)
    public func phoneCodeChanged(_ text: String?) {
        self.phoneCodeChangedProperty.value = text
    }
    
    fileprivate let phoneTextFieldChangeProperty = MutableProperty<String?>(nil)
    public func phoneTextFieldChange(_ text: String?) {
        self.phoneTextFieldChangeProperty.value = text
    }
    
    fileprivate let phoneTextFieldDidEndEditingProperty = MutableProperty(())
    public func phoneTextFieldDidEndEditing() {
        self.phoneTextFieldDidEndEditingProperty.value = ()
    }
    
    public let titleLabelText: Signal<String, NoError>
    public let goToTitleSalutationPicker: Signal<(), NoError>
    public let dismissSalutationPicker: Signal<(), NoError>
    public let firstNameTextFieldText: Signal<String, NoError>
    public let lastNameTextFieldText: Signal<String, NoError>
    public let emailTextFieldText: Signal<String, NoError>
    public let phoneTextFieldText: Signal<String, NoError>
    public let phoneCodeLabelText: Signal<String, NoError>
    public let contactFormIsCompleted: Signal<Bool, NoError>
    public let collectForCheckout: Signal<CheckoutGuestParams, NoError>
    
    public var inputs: ContactInfoCellViewModelInputs { return self }
    public var outputs: ContactInfoCellViewModelOutputs { return self }
}

private func isValid(title: String, email: String, fullname: String, phone: String) -> Bool {
    return isValidEmail(email) && !title.isEmpty
}
