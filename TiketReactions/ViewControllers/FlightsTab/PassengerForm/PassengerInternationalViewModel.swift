//
//  PassengerInternationalViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 01/09/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public enum InternationalFormGoTo {
    case goToTitleSalutationPicker
    case goToCitizenshipPicker
    case goToExpiredPassportPicker
    case goToIssuedPassportPicker
}

public protocol PassengerInternationalViewModelInputs {
    
    func configureWith(_ separator: FormatDataForm, status: PassengerStatus)
    func configCurrentPassenger(pass: AdultPassengerParam)
    
    func titleSalutationButtonTapped()
    func titleSalutationChanged(_ text: String?)
    func titleSalutationCanceled()
    
    func firstNameTextFieldChange(_ text: String?)
    func firstNameTextFieldDidEndEditing()
    
    func lastNameTextFieldChange(_ text: String?)
    func lastNameTextFieldDidEndEditing()
    
    func birthDateButtonTapped()
    func birthDateChanged(_ text: Date?)
    func birthDateCanceled()
    
    func citizenshipButtonTapped()
    func citizenshipChanged(_ text: CountryListEnvelope.ListCountry?)
    func citizenshipCanceled()
    
    func noPassportTextFieldChange(_ text: String?)
    func noPassportTextFieldDidEndEditing()
    
    func expiredPassportButtonTapped()
    func expiredPassportChanged(_ text: Date?)
    func expiredPassportCanceled()
    
    func issuedPassportButtonTapped()
    func issuedPassportChanged(_ text: CountryListEnvelope.ListCountry?)
    func issuedPassportCanceled()
    
    func submitButtonTapped()
    
    func viewDidLoad()
}

public protocol PassengerInternationalViewModelOutputs {
    var passengerStatusText: Signal<String, NoError> { get }
    var isInternational: Signal<Bool, NoError> { get }
    var titleLabelText: Signal<String, NoError> { get }
    var goToInputsPicker: Signal<InternationalFormGoTo, NoError> { get }
    var goToBirthdatePicker: Signal<String, NoError> { get }
    var dismissInputsPicker: Signal<InternationalFormGoTo, NoError> { get }
    var firstNameFirstResponder: Signal<(), NoError> { get }
    var lastNameFirstResponder: Signal<(), NoError> { get }
    var noPassportFirstResponder: Signal<(), NoError> { get }
    var firstNameTextFieldText: Signal<String, NoError> { get }
    var lastNameTextFieldText: Signal<String, NoError> { get }
    var noPassportTextFieldText: Signal<String, NoError> { get }
    var birthDateLabelText: Signal<String, NoError> { get }
    var citizenshipLabelText: Signal<String, NoError> { get }
    var expiredPassportLabelText: Signal<String, NoError> { get }
    var issuedPassportLabelText: Signal<String, NoError> { get }
    var isPassengerFormValid: Signal<Bool, NoError> { get }
    var submitInternationalPassenger: Signal<(FormatDataForm, AdultPassengerParam), NoError> { get }
}

public protocol PassengerInternationalViewModelType {
    var inputs: PassengerInternationalViewModelInputs { get }
    var outputs: PassengerInternationalViewModelOutputs { get }
}

public final class PassengerInternationalViewModel: PassengerInternationalViewModelType, PassengerInternationalViewModelInputs, PassengerInternationalViewModelOutputs {
    
    public init() {
        
        let current = Signal.combineLatest(self.configSeparatorProperty.signal.skipNil().map(first), self.viewDidLoadProperty.signal).map(first)
        let statusFlight = Signal.combineLatest(self.configSeparatorProperty.signal.skipNil().map(second), self.viewDidLoadProperty.signal).map(first)
        let passengerFilled = Signal.combineLatest(self.configCurrentPassProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        statusFlight.observe(on: UIScheduler()).observeValues {
            print("What Status Flight: \($0)")
        }
        
        self.isInternational = statusFlight.signal.map { $0 == .domestic }
        
        let initial = self.viewDidLoadProperty.signal.mapConst("")
        
        self.passengerStatusText = current.map { $0.fieldText }

        self.goToInputsPicker = Signal.merge(self.titleSalutationTappedProperty.signal.map { InternationalFormGoTo.goToTitleSalutationPicker }, self.citizenshipTappedProperty.signal.map { InternationalFormGoTo.goToCitizenshipPicker }, self.expiredPassportTappedProperty.signal.map { InternationalFormGoTo.goToExpiredPassportPicker }, self.issuedPassportTappedProperty.signal.map { InternationalFormGoTo.goToIssuedPassportPicker })
        
        self.goToBirthdatePicker = current.signal.map { $0.fieldText }.takeWhen(self.birthDateTappedProperty.signal)
        
        self.dismissInputsPicker = Signal.merge(self.titleSalutationCanceledProperty.signal.map { InternationalFormGoTo.goToTitleSalutationPicker }, self.citizenshipCanceledProperty.signal.map { InternationalFormGoTo.goToCitizenshipPicker }, self.expiredPassportCanceledProperty.signal.map { InternationalFormGoTo.goToExpiredPassportPicker }, self.issuedPassportCanceledProperty.signal.map { InternationalFormGoTo.goToIssuedPassportPicker })
        
        self.firstNameFirstResponder = .empty
        self.lastNameFirstResponder = .empty
        self.noPassportFirstResponder = .empty
        
        self.titleLabelText = Signal.merge(initial, self.titleSalutationChangedProperty.signal.skipNil(), passengerFilled.signal.map { $0.title }.skipNil())
        self.firstNameTextFieldText = Signal.merge(self.firstNameTextChangedProperty.signal.skipNil(), passengerFilled.signal.map { $0.firstname }.skipNil())
        self.lastNameTextFieldText = Signal.merge(self.lastNameTextChangedProperty.signal.skipNil(), passengerFilled.signal.map { $0.lastname }.skipNil())
        self.noPassportTextFieldText = Signal.merge(self.noPassportTextChangedProperty.signal.skipNil(), initial)
        self.birthDateLabelText = Signal.merge(self.birthDateChangedProperty.signal.skipNil().map { Format.date(secondsInUTC: $0.timeIntervalSince1970, template: "MMM d, yyyy")! }, initial)
        self.citizenshipLabelText = Signal.merge(self.citizenshipChangedProperty.signal.skipNil().map { $0.countryName }, initial)
        self.expiredPassportLabelText = Signal.merge(self.expiredPassportChangedProperty.signal.skipNil().map { Format.date(secondsInUTC: $0.timeIntervalSince1970, template: "MMM d, yyyy")! }, initial)
        self.issuedPassportLabelText = Signal.merge(self.issuedPassportChangedProperty.signal.skipNil().map { $0.countryName }, initial)
        
        let domesticPassenger = Signal.combineLatest(self.titleLabelText.signal, self.firstNameTextFieldText.signal, self.lastNameTextFieldText.signal, current.map { $0.fieldText }).switchMap { title, firstname, lastname, counting -> SignalProducer<AdultPassengerParam, NoError> in
            let adult = .defaults
                |> AdultPassengerParam.lens.title .~ title
                |> AdultPassengerParam.lens.firstname .~ firstname
                |> AdultPassengerParam.lens.lastname .~ lastname
            return SignalProducer(value: adult)
        }
        
        let internationalPassenger = Signal.combineLatest(self.titleLabelText.signal, self.firstNameTextFieldText, self.lastNameTextFieldText.signal, self.birthDateChangedProperty.signal.skipNil().map { Format.date(secondsInUTC: $0.timeIntervalSince1970, template: "yyyy-MM-dd")! }, self.noPassportTextFieldText.signal, self.citizenshipChangedProperty.signal.skipNil().map { $0.countryId }, self.expiredPassportChangedProperty.signal.skipNil().map { Format.date(secondsInUTC: $0.timeIntervalSince1970, template: "yyyy-MM-dd")! }, self.issuedPassportChangedProperty.signal.skipNil().map { $0.countryId }).filter(isInternationalValid(title:firstName:lastName:birthdate:noPassport:citizenship:expired: issued:)).switchMap { title, firstname, lastname, birthdate, noPassport, citizenship, expired, issued -> SignalProducer<AdultPassengerParam, NoError> in
            let adult = .defaults
                |> AdultPassengerParam.lens.title .~ title
                |> AdultPassengerParam.lens.firstname .~ firstname
                |> AdultPassengerParam.lens.lastname .~ lastname
                |> AdultPassengerParam.lens.birthdate .~ birthdate
                |> AdultPassengerParam.lens.passportNo .~ noPassport
                |> AdultPassengerParam.lens.passportNationality .~ citizenship
                |> AdultPassengerParam.lens.passportExpiryDate .~ expired
                |> AdultPassengerParam.lens.passportIssue .~ issued
            return SignalProducer(value: adult)
        }
        
        self.isPassengerFormValid = Signal.combineLatest(self.titleLabelText.signal, self.firstNameTextFieldText.signal, self.lastNameTextFieldText.signal).map(isDomesticValid(title:firstName:lastName:))
        
        let internationalValid = Signal.combineLatest(statusFlight.signal.filter { $0 == .international }.ignoreValues(), internationalPassenger.signal).map(second)
        let domesticValid = Signal.combineLatest(statusFlight.signal.filter { $0 == .domestic}.ignoreValues(), domesticPassenger.signal).map(second)
        
        self.submitInternationalPassenger = Signal.combineLatest(current.signal ,Signal.merge(domesticValid.signal, internationalValid.signal)).takeWhen(self.submitPassengerTappedProperty.signal)
        
    }
    
    fileprivate let configSeparatorProperty = MutableProperty<(FormatDataForm, PassengerStatus)?>(nil)
    public func configureWith(_ separator: FormatDataForm, status: PassengerStatus) {
        self.configSeparatorProperty.value = (separator, status)
    }
    
    fileprivate let configCurrentPassProperty = MutableProperty<AdultPassengerParam?>(nil)
    public func configCurrentPassenger(pass: AdultPassengerParam) {
        self.configCurrentPassProperty.value = pass
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
    
    fileprivate let firstNameTextChangedProperty = MutableProperty<String?>(nil)
    public func firstNameTextFieldChange(_ text: String?) {
        self.firstNameTextChangedProperty.value = text
    }
    
    fileprivate let firstNameTextEndedProperty = MutableProperty(())
    public func firstNameTextFieldDidEndEditing() {
        self.firstNameTextEndedProperty.value = ()
    }
    
    fileprivate let lastNameTextChangedProperty = MutableProperty<String?>(nil)
    public func lastNameTextFieldChange(_ text: String?) {
        self.lastNameTextChangedProperty.value = text
    }
    
    fileprivate let lastNameTextEndedProperty = MutableProperty(())
    public func lastNameTextFieldDidEndEditing() {
        self.lastNameTextEndedProperty.value = ()
    }
    
    fileprivate let birthDateTappedProperty = MutableProperty(())
    public func birthDateButtonTapped() {
        self.birthDateTappedProperty.value = ()
    }
    
    fileprivate let birthDateChangedProperty = MutableProperty<Date?>(nil)
    public func birthDateChanged(_ text: Date?) {
        self.birthDateChangedProperty.value = text
    }
    fileprivate let birthDateCanceledProperty = MutableProperty(())
    public func birthDateCanceled() {
        self.birthDateCanceledProperty.value = ()
    }
    
    fileprivate let citizenshipTappedProperty = MutableProperty(())
    public func citizenshipButtonTapped() {
        self.citizenshipTappedProperty.value = ()
    }
    
    fileprivate let citizenshipChangedProperty = MutableProperty<CountryListEnvelope.ListCountry?>(nil)
    public func citizenshipChanged(_ text: CountryListEnvelope.ListCountry?) {
        self.citizenshipChangedProperty.value = text
    }
    fileprivate let citizenshipCanceledProperty = MutableProperty(())
    public func citizenshipCanceled() {
        self.citizenshipCanceledProperty.value = ()
    }
    
    fileprivate let noPassportTextChangedProperty = MutableProperty<String?>(nil)
    public func noPassportTextFieldChange(_ text: String?) {
        self.noPassportTextChangedProperty.value = text
    }
    fileprivate let noPassportTextEndedProperty = MutableProperty(())
    public func noPassportTextFieldDidEndEditing() {
        self.noPassportTextEndedProperty.value = ()
    }
    
    fileprivate let expiredPassportTappedProperty = MutableProperty(())
    public func expiredPassportButtonTapped() {
        self.expiredPassportTappedProperty.value = ()
    }
    fileprivate let expiredPassportChangedProperty = MutableProperty<Date?>(nil)
    public func expiredPassportChanged(_ text: Date?) {
        self.expiredPassportChangedProperty.value = text
    }
    fileprivate let expiredPassportCanceledProperty = MutableProperty(())
    public func expiredPassportCanceled() {
        self.expiredPassportCanceledProperty.value = ()
    }
    
    fileprivate let issuedPassportTappedProperty = MutableProperty(())
    public func issuedPassportButtonTapped() {
        self.issuedPassportTappedProperty.value = ()
    }
    fileprivate let issuedPassportChangedProperty = MutableProperty<CountryListEnvelope.ListCountry?>(nil)
    public func issuedPassportChanged(_ text: CountryListEnvelope.ListCountry?) {
        self.issuedPassportChangedProperty.value = text
    }
    
    fileprivate let issuedPassportCanceledProperty = MutableProperty(())
    public func issuedPassportCanceled() {
        self.issuedPassportCanceledProperty.value = ()
    }
    
    fileprivate let submitPassengerTappedProperty = MutableProperty(())
    public func submitButtonTapped() {
        self.submitPassengerTappedProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let passengerStatusText: Signal<String, NoError>
    public let isInternational: Signal<Bool, NoError>
    public let titleLabelText: Signal<String, NoError>
    public let goToInputsPicker: Signal<InternationalFormGoTo, NoError>
    public let goToBirthdatePicker: Signal<String, NoError>
    public let dismissInputsPicker: Signal<InternationalFormGoTo, NoError>
    public let firstNameFirstResponder: Signal<(), NoError>
    public let lastNameFirstResponder: Signal<(), NoError>
    public let noPassportFirstResponder: Signal<(), NoError>
    public let firstNameTextFieldText: Signal<String, NoError>
    public let lastNameTextFieldText: Signal<String, NoError>
    public let noPassportTextFieldText: Signal<String, NoError>
    public let birthDateLabelText: Signal<String, NoError>
    public let citizenshipLabelText: Signal<String, NoError>
    public let expiredPassportLabelText: Signal<String, NoError>
    public let issuedPassportLabelText: Signal<String, NoError>
    public let isPassengerFormValid: Signal<Bool, NoError>
    public let submitInternationalPassenger: Signal<(FormatDataForm, AdultPassengerParam), NoError>
    
    public var inputs: PassengerInternationalViewModelInputs { return self }
    public var outputs: PassengerInternationalViewModelOutputs { return self }
}

private func isDomesticValid(title: String, firstName: String, lastName: String) -> Bool {
    return !title.isEmpty && !firstName.isEmpty && !lastName.isEmpty
}

private func isInternationalValid(title: String, firstName: String, lastName: String, birthdate: String, noPassport: String, citizenship: String, expired: String, issued: String) -> Bool {
    return !title.isEmpty && !firstName.isEmpty && !lastName.isEmpty && !birthdate.isEmpty && !noPassport.isEmpty && !citizenship.isEmpty && !expired.isEmpty && !issued.isEmpty
}

private func identityPassenger(_ separator: String) -> String {
    switch separator {
    case "Penumpang Dewasa 1":
        return "a1"
    case "Penumpang Dewasa 2":
        return "a2"
    case "Penumpang Dewasa 3":
        return "a3"
    case "Penumpang Dewasa 4":
        return "a4"
    case "Penumpang Dewasa 5":
        return "a5"
    case "Penumpang Dewasa 6":
        return "a6"
    case "Penumpang Anak 1":
        return "c1"
    case "Penumpang Anak 2":
        return "c2"
    case "Penumpang Anak 3":
        return "c3"
    case "Penumpang Anak 4":
        return "c4"
    case "Penumpang Anak 5":
        return "c5"
    case "Penumpang Anak 6":
        return "c6"
    case "Penumpang Bayi 1":
        return "i1"
    case "Penumpang Bayi 2":
        return "i2"
    case "Penumpang Bayi 3":
        return "i3"
    case "Penumpang Bayi 4":
        return "i4"
    case "Penumpang Bayi 5":
        return "i5"
    case "Penumpang Bayi 6":
        return "i6"
    default:
        return ""
    }
}
