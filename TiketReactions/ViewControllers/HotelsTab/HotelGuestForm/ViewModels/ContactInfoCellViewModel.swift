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

public enum ContactFormState {
    case flightResult
    case hotelResult
}

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
    func phoneCodeChanged(_ text: Country?)
    
    func phoneTextFieldChange(_ text: String?, code: String?)
    func phoneTextFieldDidEndEditing()
    
    func contactCellDidLoad(_ state: ContactFormState)
}

public protocol ContactInfoCellViewModelOutputs {
    var statusFormText: Signal<String, NoError> { get }
    var titleLabelText: Signal<String, NoError> { get }
    var goToTitleSalutationPicker: Signal<(), NoError> { get }
    var goToPhoneCodePicker: Signal<(), NoError> { get }
    var dismissSalutationPicker: Signal<(), NoError> { get }
    var firstNameFirstResponder: Signal<(), NoError> { get }
    var lastNameFirstResponder: Signal<(), NoError> { get }
    var emailFirstResponder: Signal<(), NoError> { get }
    var phoneFirstResponder: Signal<(), NoError> { get }
    var firstNameTextFieldText: Signal<String, NoError> { get }
    var lastNameTextFieldText: Signal<String, NoError> { get }
    var emailTextFieldText: Signal<String, NoError> { get }
    var phoneCodeLabelText: Signal<String, NoError> { get }
    var phoneTextFieldText: Signal<String, NoError> { get }
    var contactFormIsCompleted: Signal<Bool, NoError> { get }
    var collectForContactFlight: Signal<GroupPassengersParam, NoError> { get }
    var collectForCheckout: Signal<CheckoutGuestParams, NoError> { get }
}

public protocol ContactInfoCellViewModelType {
    var inputs: ContactInfoCellViewModelInputs { get }
    var outputs: ContactInfoCellViewModelOutputs { get }
}

public final class ContactInfoCellViewModel: ContactInfoCellViewModelType, ContactInfoCellViewModelInputs, ContactInfoCellViewModelOutputs {
    
    init() {
        
        self.statusFormText = self.contactCellDidLoadProperty.signal.skipNil().map(formatContactInfo(_ :))
        
        let initialText = self.contactCellDidLoadProperty.signal.mapConst("")
        
        self.goToTitleSalutationPicker = self.salutationButtonTappedProperty.signal
        self.goToPhoneCodePicker = self.phoneCodeButtonTappedProperty.signal
        self.dismissSalutationPicker = self.salutationCanceledProperty.signal
        
        self.firstNameFirstResponder = self.salutationChangedProperty.signal.ignoreValues()
        self.lastNameFirstResponder = self.firstNameEndEditingProperty.signal
        self.emailFirstResponder = self.lastNameEndEditingProperty.signal
        self.phoneFirstResponder = self.emailTextFieldDidEndEditingProperty.signal
        
        let title = Signal.merge(self.salutationChangedProperty.signal.skipNil(), initialText.skipRepeats(==))
        let firstname = self.firstNameTextFieldChangeProperty.signal.skipNil()
        let lastname = self.lastNameTextFieldChangeProperty.signal.skipNil()
        let email = self.emailTextFieldChangeProperty.signal.skipNil()
        let countryCode = Signal.merge(self.contactCellDidLoadProperty.signal.mapConst("+62").skipRepeats(==), self.phoneCodeChangedProperty.signal.skipNil().map { $0.phoneCode }).skipNil()
        let phone = Signal.combineLatest(countryCode, self.phoneTextFieldChangeProperty.signal.skipNil()).map { "\($0.0)\($0.1)" }
        
        let contactForm = Signal.combineLatest(title, firstname, lastname, email, phone, countryCode)
        
        self.titleLabelText = title
        self.firstNameTextFieldText = .empty
        self.lastNameTextFieldText = .empty
        self.emailTextFieldText = .empty
        self.phoneCodeLabelText = countryCode
        self.phoneTextFieldText = .empty

        self.contactFormIsCompleted = contactForm.map(isValid(title:firstname:lastname:email:phone:countryCode:)).skipRepeats()
        
        let contactInfoParams = contactForm.switchMap { title, first, last, email, phoneNumber, _ -> SignalProducer<CheckoutGuestParams, NoError> in
            let param = .defaults
                |> CheckoutGuestParams.lens.conSalutation .~ title
                |> CheckoutGuestParams.lens.conFirstName .~ first
                |> CheckoutGuestParams.lens.conLastName .~ last
                |> CheckoutGuestParams.lens.conEmailAddress .~ email
                |> CheckoutGuestParams.lens.conPhone .~ phoneNumber
                |> CheckoutGuestParams.lens.salutation .~ title
                |> CheckoutGuestParams.lens.firstName .~ first
                |> CheckoutGuestParams.lens.lastName .~ last
                |> CheckoutGuestParams.lens.phone .~ phoneNumber
            
            return SignalProducer(value: param)
        }.materialize()
        
        let contactFlightParams = contactForm.switchMap { title, first, last, email, phoneNumber, _ -> SignalProducer<GroupPassengersParam, NoError> in
            let param = .defaults
                |> GroupPassengersParam.lens.conSalutation .~ title
                |> GroupPassengersParam.lens.conFirstName .~ first
                |> GroupPassengersParam.lens.conLastName .~ last
                |> GroupPassengersParam.lens.conPhone .~ phoneNumber
                |> GroupPassengersParam.lens.conEmailAddress .~ email
            
            return SignalProducer(value: param)
        }.materialize()
        
        self.collectForContactFlight = contactFlightParams.values()
        
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
    
    fileprivate let phoneCodeChangedProperty = MutableProperty<Country?>(nil)
    public func phoneCodeChanged(_ text: Country?) {
        self.phoneCodeChangedProperty.value = text
    }
    
    fileprivate let phoneTextFieldChangeProperty = MutableProperty<String?>(nil)
    public func phoneTextFieldChange(_ text: String?, code: String?) {
        self.phoneTextFieldChangeProperty.value = text
    }
    
    fileprivate let phoneTextFieldDidEndEditingProperty = MutableProperty(())
    public func phoneTextFieldDidEndEditing() {
        self.phoneTextFieldDidEndEditingProperty.value = ()
    }
    
    fileprivate let contactCellDidLoadProperty = MutableProperty<ContactFormState?>(nil)
    public func contactCellDidLoad(_ state: ContactFormState) {
        self.contactCellDidLoadProperty.value = state
    }
    
    public let statusFormText: Signal<String, NoError>
    public let titleLabelText: Signal<String, NoError>
    public let goToTitleSalutationPicker: Signal<(), NoError>
    public let goToPhoneCodePicker: Signal<(), NoError>
    public let dismissSalutationPicker: Signal<(), NoError>
    public let firstNameFirstResponder: Signal<(), NoError>
    public let lastNameFirstResponder: Signal<(), NoError>
    public let emailFirstResponder: Signal<(), NoError>
    public let phoneFirstResponder: Signal<(), NoError>
    public let firstNameTextFieldText: Signal<String, NoError>
    public let lastNameTextFieldText: Signal<String, NoError>
    public let emailTextFieldText: Signal<String, NoError>
    public let phoneTextFieldText: Signal<String, NoError>
    public let phoneCodeLabelText: Signal<String, NoError>
    public let contactFormIsCompleted: Signal<Bool, NoError>
    public let collectForContactFlight: Signal<GroupPassengersParam, NoError>
    public let collectForCheckout: Signal<CheckoutGuestParams, NoError>
    
    public var inputs: ContactInfoCellViewModelInputs { return self }
    public var outputs: ContactInfoCellViewModelOutputs { return self }
}

private func isValid(title: String, firstname: String, lastname: String, email: String, phone: String, countryCode: String) -> Bool {
    return !title.isEmpty && !firstname.isEmpty && !lastname.isEmpty && isValidEmail(email) && isValidPhone(phone, code: countryCode)
}

private func formatContactInfo(_ state: ContactFormState) -> String {
    switch state {
    case .flightResult:
        return "Contact Info"
    case .hotelResult:
        return Localizations.GuestContactFormTitle
    }
}

/*
private func removeRestSpace(value: String) -> String {
    let spaces = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
    let namesDouble = value.components(separatedBy: spaces)
    if namesDouble.count > 1 {
        return value.components(separatedBy: " ").joined(separator: " ")
    }
    
    return value.components(separatedBy: " ").joined()
}
*/
