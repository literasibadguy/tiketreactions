//
//  PassengerDetailViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 21/01/19.
//  Copyright © 2019 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol PassengerDetailViewModelInputs {
    func configureStatePassenger(_ format: FormatDataForm, state: PassengerFormState)
    
    func titleSalutationButtonTapped()
    func titleSalutationChanged(_ text: String?)
    func titleSalutationCanceled()
    
    func birthdateButtonTapped()
    func birthdateChanged(_ text: Date?)
    func birthdateCanceled()
    
    func nationalityButtonTapped()
    func nationalityChanged(_ text: String?)
    func nationalityCanceled()
    
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
    
    func submitButtonTapped()
    
    func viewDidLoad()
}

public protocol PassengerDetailViewModelOutputs {
    var titleLabelText: Signal<String, NoError> { get }
    var goToTitleSalutationPicker: Signal<(), NoError> { get }
    var goToBirthdatePicker: Signal<PassengerFormState, NoError> { get }
    var goToNationalityPicker: Signal<(), NoError> { get }
    var goToPhoneCodePicker: Signal<(), NoError> { get }
    var dismissSalutationPicker: Signal<(), NoError> { get }
    var firstNameFirstResponder: Signal<(), NoError> { get }
    var lastNameFirstResponder: Signal<(), NoError> { get }
    var emailFirstResponder: Signal<(), NoError> { get }
    var phoneFirstResponder: Signal<(), NoError> { get }
    var firstNameTextFieldText: Signal<String, NoError> { get }
    var lastNameTextFieldText: Signal<String, NoError> { get }
    var birthdateLabelText: Signal<String, NoError> { get }
    var nationalityLabelText: Signal<String, NoError> { get }
    var emailTextFieldText: Signal<String, NoError> { get }
    var phoneCodeLabelText: Signal<String, NoError> { get }
    var phoneTextFieldText: Signal<String, NoError> { get }
    var hideContactForm: Signal<(), NoError> { get }
    var saveAdultDetail: Signal<(passenger: AdultPassengerParam, format: FormatDataForm), NoError> { get }
}

public protocol PassengerDetailViewModelType {
    var inputs: PassengerDetailViewModelInputs { get }
    var outputs: PassengerDetailViewModelOutputs { get }
}

public final class PassengerDetailViewModel: PassengerDetailViewModelType, PassengerDetailViewModelInputs, PassengerDetailViewModelOutputs {
    
    public init() {
        
        let current = Signal.combineLatest(self.viewDidLoadProperty.signal, self.configStateFormatProperty.signal.skipNil())
        
        let title = Signal.merge(current.signal.mapConst(""), self.salutationChangedProperty.signal.skipNil())
//        let firstName = self.firstNameTextFieldChangeProperty.signal.skipNil()
//        let lastName = self.lastNameTextFieldChangeProperty.signal.skipNil()
//        let email = self.emailTextFieldChangeProperty.signal.skipNil()
//        let phoneText = self.phoneTextFieldChangeProperty.signal.skipNil()
        let birthdate = Signal.merge(current.signal.mapConst("Tanggal lahir"), self.birthdateChangedProperty.signal.skipNil().map { Format.date(secondsInUTC: $0.timeIntervalSince1970, template: "d MMM yyyy")! })
        let nationality = Signal.merge(current.signal.mapConst("Kewarganegaraan"), self.nationalityChangedProperty.signal.skipNil())
        
        self.titleLabelText = title.signal
        self.goToTitleSalutationPicker = self.salutationButtonTappedProperty.signal
        self.goToBirthdatePicker = current.map(second).map(second).takeWhen(self.birthdateButtonTappedProperty.signal)
        self.goToNationalityPicker = self.nationalityButtonTappedProperty.signal
        self.goToPhoneCodePicker = self.phoneCodeButtonTappedProperty.signal
        self.dismissSalutationPicker = self.salutationCanceledProperty.signal
        self.firstNameFirstResponder = self.salutationChangedProperty.signal.ignoreValues()
        self.lastNameFirstResponder = self.firstNameEndEditingProperty.signal
        self.emailFirstResponder = self.nationalityChangedProperty.signal.ignoreValues()
        self.phoneFirstResponder = self.emailTextFieldDidEndEditingProperty.signal.ignoreValues()
        self.firstNameTextFieldText = .empty
        self.lastNameTextFieldText = .empty
        self.emailTextFieldText = .empty
        self.phoneCodeLabelText = self.phoneCodeChangedProperty.signal.skipNil().map { $0.code }.skipNil()
        self.phoneTextFieldText = .empty
        
        self.hideContactForm = current.signal.map(second).filter { $0.1 != .firstPassenger }.ignoreValues()
        
        self.birthdateLabelText = birthdate.signal
        self.nationalityLabelText = nationality.signal
        
        self.saveAdultDetail = Signal.combineLatest(current.map(second).map(first), self.salutationChangedProperty.signal.skipNil(), self.firstNameTextFieldChangeProperty.signal.skipNil(), self.lastNameTextFieldChangeProperty.signal.skipNil(), self.nationalityChangedProperty.signal, self.birthdateChangedProperty.signal.skipNil().map { Format.date(secondsInUTC: $0.timeIntervalSince1970, template: "yyyy-MM-dd") }).map(getAdultPass(format:title:firstName:lastName:nationality:birthdate:)).takeWhen(self.submitButtonTappedProperty.signal)
    }
    
    fileprivate let configStateFormatProperty = MutableProperty<(FormatDataForm, PassengerFormState)?>(nil)
    public func configureStatePassenger(_ format: FormatDataForm, state: PassengerFormState) {
        self.configStateFormatProperty.value = (format, state)
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
    
    fileprivate let birthdateButtonTappedProperty = MutableProperty(())
    public func birthdateButtonTapped() {
        self.birthdateButtonTappedProperty.value = ()
    }
    
    fileprivate let birthdateChangedProperty = MutableProperty<Date?>(nil)
    public func birthdateChanged(_ text: Date?) {
        self.birthdateChangedProperty.value = text
    }
    
    fileprivate let birthdateCanceledProperty = MutableProperty(())
    public func birthdateCanceled() {
        self.birthdateCanceledProperty.value = ()
    }
    
    fileprivate let nationalityButtonTappedProperty = MutableProperty(())
    public func nationalityButtonTapped() {
        self.nationalityButtonTappedProperty.value = ()
    }
    
    fileprivate let nationalityChangedProperty = MutableProperty<String?>(nil)
    public func nationalityChanged(_ text: String?) {
        self.nationalityChangedProperty.value = text
    }
    
    fileprivate let nationalityCanceledProperty = MutableProperty(())
    public func nationalityCanceled() {
        self.nationalityCanceledProperty.value = ()
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
    
    fileprivate let submitButtonTappedProperty = MutableProperty(())
    public func submitButtonTapped() {
        self.submitButtonTappedProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let titleLabelText: Signal<String, NoError>
    public let goToTitleSalutationPicker: Signal<(), NoError>
    public let goToBirthdatePicker: Signal<PassengerFormState, NoError>
    public let goToNationalityPicker: Signal<(), NoError>
    public let goToPhoneCodePicker: Signal<(), NoError>
    public let dismissSalutationPicker: Signal<(), NoError>
    public let firstNameFirstResponder: Signal<(), NoError>
    public let lastNameFirstResponder: Signal<(), NoError>
    public let emailFirstResponder: Signal<(), NoError>
    public let phoneFirstResponder: Signal<(), NoError>
    public let firstNameTextFieldText: Signal<String, NoError>
    public let lastNameTextFieldText: Signal<String, NoError>
    public let birthdateLabelText: Signal<String, NoError>
    public let nationalityLabelText: Signal<String, NoError>
    public let emailTextFieldText: Signal<String, NoError>
    public let phoneCodeLabelText: Signal<String, NoError>
    public let phoneTextFieldText: Signal<String, NoError>
    public let hideContactForm: Signal<(), NoError>
    public let saveAdultDetail: Signal<(passenger: AdultPassengerParam, format: FormatDataForm), NoError>
    
    public var inputs: PassengerDetailViewModelInputs { return self }
    public var outputs: PassengerDetailViewModelOutputs { return self }
}

private func getAdultPass(format: FormatDataForm, title: String, firstName: String, lastName: String, nationality: String? = nil, birthdate: String? = nil) -> (passenger: AdultPassengerParam, format: FormatDataForm) {
    
    let passengerParam = .defaults
        |> AdultPassengerParam.lens.title .~ title
        |> AdultPassengerParam.lens.firstname .~ firstName
        |> AdultPassengerParam.lens.lastname .~ lastName
        |> AdultPassengerParam.lens.passportNationality .~ nationality
        |> AdultPassengerParam.lens.birthdate .~ birthdate
    
    return (passenger: passengerParam, format: format)
}
