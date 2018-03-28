//
//  ContactInfoCellViewModel.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 16/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import TiketAPIs

public protocol ContactInfoCellViewModelInputs {
    func titleSalutationButtonTapped()
    func titleSalutationChanged(_ text: String?)
    
    func fullNameTextFieldChange(_ text: String?)
    func fullNameTextFieldDidEndEditing()
    
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
    var isGuestFormValid: Signal<Bool, NoError> { get }
    var fullnameTextFieldText: Signal<String, NoError> { get }
    var emailTextFieldText: Signal<String, NoError> { get }
    var phoneCodeLabelText: Signal<String, NoError> { get }
    var phoneTextFieldText: Signal<String, NoError> { get }
    var collectForCheckout: Signal<CheckoutGuestParams, NoError> { get }
}

public protocol ContactInfoCellViewModelType {
    var inputs: ContactInfoCellViewModelInputs { get }
    var outputs: ContactInfoCellViewModelOutputs { get }
}

public final class ContactInfoCellViewModel: ContactInfoCellViewModelType, ContactInfoCellViewModelInputs, ContactInfoCellViewModelOutputs {
    
    init() {
        self.titleLabelText = .empty
        self.fullnameTextFieldText = .empty
        self.goToTitleSalutationPicker = self.salutationButtonTappedProperty.signal
        self.isGuestFormValid = self.emailTextFieldChangeProperty.signal.skipNil().map(isValidEmail)
        
        self.emailTextFieldText = .empty
        self.phoneTextFieldText = .empty
        self.phoneCodeLabelText = .empty
        
        let combineGuest = Signal.combineLatest(self.salutationChangedProperty.signal.skipNil(),self.emailTextFieldChangeProperty.signal, self.fullNameTextFieldChangeProperty.signal, self.phoneTextFieldChangeProperty.signal).map { title ,email, fullname, phone in
            return (title, email, fullname, phone)
        }
        self.collectForCheckout = .empty
    }
    
    fileprivate let salutationButtonTappedProperty = MutableProperty(())
    public func titleSalutationButtonTapped() {
        self.salutationButtonTappedProperty.value = ()
    }
    
    fileprivate let salutationChangedProperty = MutableProperty<String?>(nil)
    public func titleSalutationChanged(_ text: String?) {
        self.salutationChangedProperty.value = text
    }
    
    fileprivate let fullNameTextFieldChangeProperty = MutableProperty<String?>(nil)
    public func fullNameTextFieldChange(_ text: String?) {
        self.fullNameTextFieldChangeProperty.value = text
    }
    
    fileprivate let fullNameEndEditingProperty = MutableProperty(())
    public func fullNameTextFieldDidEndEditing() {
        self.fullNameEndEditingProperty.value = ()
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
    public let isGuestFormValid: Signal<Bool, NoError>
    public let fullnameTextFieldText: Signal<String, NoError>
    public let emailTextFieldText: Signal<String, NoError>
    public let phoneTextFieldText: Signal<String, NoError>
    public let phoneCodeLabelText: Signal<String, NoError>
    public let collectForCheckout: Signal<CheckoutGuestParams, NoError>
    
    public var inputs: ContactInfoCellViewModelInputs { return self }
    public var outputs: ContactInfoCellViewModelOutputs { return self }
}

private func isValid(email: String) -> Bool {
    return isValidEmail(email)
}
