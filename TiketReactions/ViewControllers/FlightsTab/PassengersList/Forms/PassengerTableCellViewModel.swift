//
//  PassengerTableCellViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 08/01/19.
//  Copyright © 2019 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol PassengerTableCellFormViewModelInputs {
    func configureWith(_ format: FormatDataForm)
    func titlePassengerButtonTapped()
    func titlePassengerChanged(_ text: String?)
    func titlePassengerCanceled()
    
    func firstNameTextFieldChange(_ text: String?)
    func firstNameTextFieldDidEndEditing()
    
    func lastNameTextFieldChange(_ text: String?)
    func lastNameTextFieldDidEndEditing()
    
    func birthdatePassengerTapped()
    func birthdatePassengerChanged(_ text: String?)
    func birthdatePassengerCanceled()
    
    func nationalityPassengerTapped()
    func nationalityPassengerChanged(_ text: String?)
    func nationalityPassengerCanceled()
}

public protocol PassengerTableCellFormViewModelOutputs {
    var titleLabelText: Signal<String, NoError> { get }
    var goToTitlePassPicker: Signal<(), NoError> { get }
    var dismissTitlePassPicker: Signal<(), NoError> { get }
    var firstnameFirstResponder: Signal<(), NoError> { get }
    var lastnameFirstResponder: Signal<(), NoError> { get }
    var firstnameTextFieldText: Signal<String, NoError> { get }
    var lastnameTextFieldText: Signal<String, NoError> { get }
    var goToBirthdatePassPicker: Signal<(), NoError> { get }
    var goToNationalityPassPicker: Signal<(), NoError> { get }
    var dismissBirthdatePassPicker: Signal<(), NoError> { get }
    var dismissNationalityPassPicker: Signal<(), NoError> { get }
    var birthdateLabelText: Signal<String, NoError> { get }
    var nationalityLabelText: Signal<String, NoError> { get }
}

public protocol PassengerTableCellFormViewModelType {
    var inputs: PassengerTableCellFormViewModelInputs { get }
    var outputs: PassengerTableCellFormViewModelOutputs { get }
}

public final class PassengerTableCellFormViewModel: PassengerTableCellFormViewModelType, PassengerTableCellFormViewModelInputs, PassengerTableCellFormViewModelOutputs {
    
    public init() {
        
        let birthdateText = Signal.merge(self.configFormatFormProperty.signal.mapConst("Tanggal Lahir"), self.birthdatePassChangedProperty.signal.skipNil())
        
        let nationalityText = Signal.merge(self.configFormatFormProperty.signal.mapConst("Kewarganegaraan"), self.nationalityPassChangedProperty.signal.skipNil())
        
        self.titleLabelText = .empty
        self.goToTitlePassPicker = self.titlePassTappedProperty.signal
        self.dismissTitlePassPicker = Signal.merge(self.titlePassCanceledProperty.signal, self.birthdatePassCanceledProperty.signal, self.nationalityPassCanceledProperty.signal)
        self.firstnameFirstResponder = self.titlePassChangedProperty.signal.ignoreValues()
        self.lastnameFirstResponder = self.firstNameTextEndProperty.signal
        self.firstnameTextFieldText = self.firstNameTextChangedProperty.signal.skipNil()
        self.lastnameTextFieldText = self.lastNameTextChangedProperty.signal.skipNil()
        self.goToBirthdatePassPicker = self.birthdatePassTappedProperty.signal
        self.goToNationalityPassPicker = self.nationalityPassTappedProperty.signal
        self.dismissBirthdatePassPicker = self.birthdatePassCanceledProperty.signal
        self.dismissNationalityPassPicker = self.nationalityPassCanceledProperty.signal
        self.birthdateLabelText = birthdateText.signal
        self.nationalityLabelText = nationalityText.signal
    }
    
    private let configFormatFormProperty = MutableProperty<FormatDataForm?>(nil)
    public func configureWith(_ format: FormatDataForm) {
        self.configFormatFormProperty.value = format
    }
    
    private let titlePassTappedProperty = MutableProperty(())
    public func titlePassengerButtonTapped() {
        self.titlePassTappedProperty.value = ()
    }
    
    private let titlePassChangedProperty = MutableProperty<String?>(nil)
    public func titlePassengerChanged(_ text: String?) {
        self.titlePassChangedProperty.value = text
    }
    
    private let titlePassCanceledProperty = MutableProperty(())
    public func titlePassengerCanceled() {
        self.titlePassCanceledProperty.value = ()
    }
    
    private let firstNameTextChangedProperty = MutableProperty<String?>(nil)
    public func firstNameTextFieldChange(_ text: String?) {
        self.firstNameTextChangedProperty.value = text
    }
    private let firstNameTextEndProperty = MutableProperty(())
    public func firstNameTextFieldDidEndEditing() {
        self.firstNameTextEndProperty.value = ()
    }
    
    private let lastNameTextChangedProperty = MutableProperty<String?>(nil)
    public func lastNameTextFieldChange(_ text: String?) {
        self.lastNameTextChangedProperty.value = text
    }
    private let lastNameTextEndProperty = MutableProperty(())
    public func lastNameTextFieldDidEndEditing() {
        self.lastNameTextEndProperty.value = ()
    }
    
    private let birthdatePassTappedProperty = MutableProperty(())
    public func birthdatePassengerTapped() {
        self.birthdatePassTappedProperty.value = ()
    }
    private let birthdatePassChangedProperty = MutableProperty<String?>(nil)
    public func birthdatePassengerChanged(_ text: String?) {
        self.birthdatePassChangedProperty.value = text
    }
    private let birthdatePassCanceledProperty = MutableProperty(())
    public func birthdatePassengerCanceled() {
        self.birthdatePassCanceledProperty.value = ()
    }
    
    private let nationalityPassTappedProperty = MutableProperty(())
    public func nationalityPassengerTapped() {
        self.nationalityPassTappedProperty.value = ()
    }
    private let nationalityPassChangedProperty = MutableProperty<String?>(nil)
    public func nationalityPassengerChanged(_ text: String?) {
        self.nationalityPassChangedProperty.value = text
    }
    private let nationalityPassCanceledProperty = MutableProperty(())
    public func nationalityPassengerCanceled() {
        self.nationalityPassCanceledProperty.value = ()
    }
    
    public let titleLabelText: Signal<String, NoError>
    public let goToTitlePassPicker: Signal<(), NoError>
    public let dismissTitlePassPicker: Signal<(), NoError>
    public let firstnameFirstResponder: Signal<(), NoError>
    public let lastnameFirstResponder: Signal<(), NoError>
    public let firstnameTextFieldText: Signal<String, NoError>
    public let lastnameTextFieldText: Signal<String, NoError>
    public let goToBirthdatePassPicker: Signal<(), NoError>
    public let goToNationalityPassPicker: Signal<(), NoError>
    public let dismissBirthdatePassPicker: Signal<(), NoError>
    public let dismissNationalityPassPicker: Signal<(), NoError>
    public let birthdateLabelText: Signal<String, NoError>
    public let nationalityLabelText: Signal<String, NoError>
    
    public var inputs: PassengerTableCellFormViewModelInputs { return self }
    public var outputs: PassengerTableCellFormViewModelOutputs { return self }
}
