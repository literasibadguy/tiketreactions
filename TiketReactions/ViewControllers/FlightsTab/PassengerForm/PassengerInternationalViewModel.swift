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
    
    func configureWith(_ separator: FormatDataForm, status: PassengerStatus, baggages: FormatDataForm?)
    func configureWith(data: PassengersData)
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
    
    func baggageDepartButtonTapped()
    func baggageDepartChanged(_ res: ResourceBaggage?)
    func baggageDepartCanceled()
    
    func baggageReturnButtonTapped()
    func baggageReturnChanged(_ res: ResourceBaggage?)
    func baggageReturnCanceled()
    
    func submitButtonTapped()
    
    func viewDidLoad()
}

public protocol PassengerInternationalViewModelOutputs {
    var passengerStatusText: Signal<String, NoError> { get }
    var isInternational: Signal<Bool, NoError> { get }
    var isAvailableBaggage: Signal<Bool, NoError> { get }
    var departBaggageText: Signal<String, NoError> { get }
    var returnBaggageText: Signal<String, NoError> { get }
    var titleLabelText: Signal<String, NoError> { get }
    var goToInputsPicker: Signal<InternationalFormGoTo, NoError> { get }
    var goToBirthdatePicker: Signal<String, NoError> { get }
    var goToBaggagePicker: Signal<[ResourceBaggage], NoError> { get }
    var goReturnBaggagePicker: Signal<[ResourceBaggage], NoError> { get }
    var dismissBaggagePicker: Signal<(), NoError> { get }
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
        
        let baggageData = Signal.combineLatest(self.configSeparatorProperty.signal.skipNil().map(third), self.viewDidLoadProperty.signal).map(first)
        
        let passengerFilled = Signal.combineLatest(self.configCurrentPassProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        let passengerData = Signal.combineLatest(self.configPassengerDataProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        statusFlight.observe(on: UIScheduler()).observeValues {
            print("What Status Flight: \($0)")
        }
        
        self.isInternational = passengerData.signal.map { $0.isInternational }.negate()
        
        self.isAvailableBaggage = passengerData.signal.map { $0.isBaggage }.negate()
        
        let initial = self.viewDidLoadProperty.signal.mapConst("")
        
        self.passengerStatusText = Signal.merge(current.map { $0.fieldText }, passengerData.signal.map { $0.passenger.fieldText })

        self.goToInputsPicker = Signal.merge(self.titleSalutationTappedProperty.signal.map { InternationalFormGoTo.goToTitleSalutationPicker }, self.citizenshipTappedProperty.signal.map { InternationalFormGoTo.goToCitizenshipPicker }, self.expiredPassportTappedProperty.signal.map { InternationalFormGoTo.goToExpiredPassportPicker }, self.issuedPassportTappedProperty.signal.map { InternationalFormGoTo.goToIssuedPassportPicker })
        
        self.goToBirthdatePicker = passengerData.signal.map { $0.passenger.fieldText }.takeWhen(self.birthDateTappedProperty.signal)
        
        self.dismissInputsPicker = Signal.merge(self.titleSalutationCanceledProperty.signal.map { InternationalFormGoTo.goToTitleSalutationPicker }, self.citizenshipCanceledProperty.signal.map { InternationalFormGoTo.goToCitizenshipPicker }, self.expiredPassportCanceledProperty.signal.map { InternationalFormGoTo.goToExpiredPassportPicker }, self.issuedPassportCanceledProperty.signal.map { InternationalFormGoTo.goToIssuedPassportPicker })
        
        self.goToBaggagePicker = passengerData.signal.map { $0.departBaggage?.resBaggage }.skipNil().takeWhen(self.baggageDepartTappedProperty.signal)
        
        self.goReturnBaggagePicker = passengerData.signal.map { $0.returnBaggage?.resBaggage }.skipNil().takeWhen(self.baggageReturnTappedProperty.signal)
        
        self.dismissBaggagePicker = Signal.merge(self.baggageDepartCanceledProperty.signal, self.baggageReturnCanceledProperty.signal)
        
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
        
        self.departBaggageText = Signal.merge(initial, self.baggageDepartChangedProperty.signal.skipNil().map { $0.name })
        self.returnBaggageText = Signal.merge(initial, self.baggageReturnChangedProperty.signal.skipNil().map { $0.name })
        
        let domesticPassenger = Signal.combineLatest(self.titleLabelText.signal, self.firstNameTextFieldText.signal, self.lastNameTextFieldText.signal, passengerData.signal.map { $0.passenger.fieldText }, self.birthDateChangedProperty.signal.skipNil().map { Format.date(secondsInUTC: $0.timeIntervalSince1970, template: "yyyy-MM-dd")! }, self.citizenshipChangedProperty.signal.skipNil().map { $0.countryId }).switchMap { title, firstname, lastname, counting, birthdate, citizenship -> SignalProducer<AdultPassengerParam, NoError> in
            let adult = .defaults
                |> AdultPassengerParam.lens.title .~ title
                |> AdultPassengerParam.lens.firstname .~ firstname
                |> AdultPassengerParam.lens.lastname .~ lastname
                |> AdultPassengerParam.lens.birthdate .~ birthdate
                |> AdultPassengerParam.lens.passportNationality .~ citizenship
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
        
        let includedBaggage = Signal.combineLatest(passengerData.signal.map { $0.passenger.fieldText.contains("Dewasa") }, self.baggageDepartChangedProperty.signal.skipNil(), self.baggageReturnChangedProperty.signal.skipNil(), Signal.merge(domesticPassenger, internationalPassenger).signal).switchMap { _, baggageFirst, baggageReturn, passenger -> SignalProducer<AdultPassengerParam, NoError> in
            let custom = passenger
                |> AdultPassengerParam.lens.departAdultBaggage .~ baggageFirst.id
                |> AdultPassengerParam.lens.returnAdultBaggage .~ baggageReturn.id
            return SignalProducer(value: custom)
        }
        
        let includedChildBaggage = Signal.combineLatest(passengerData.signal.map { $0.passenger.fieldText.contains("Anak") }, includedBaggage, self.baggageDepartChangedProperty.signal.skipNil(), self.baggageReturnChangedProperty.signal.skipNil()).switchMap { _, passengers, baggageFirst, baggageReturn -> SignalProducer<AdultPassengerParam, NoError> in
            let custom = passengers
                |> AdultPassengerParam.lens.departChildBaggage .~ baggageFirst.id
                |> AdultPassengerParam.lens.returnChildBaggage .~ baggageReturn.id
            return SignalProducer(value: custom)
        }
        
        self.isPassengerFormValid = Signal.combineLatest(self.titleLabelText.signal, self.firstNameTextFieldText.signal, self.lastNameTextFieldText.signal).map(isDomesticValid(title:firstName:lastName:))
        
        let internationalValid = Signal.combineLatest(passengerData.signal.filter { $0.isInternational == true }.ignoreValues(), internationalPassenger.signal).map(second)
        let domesticValid = Signal.combineLatest(passengerData.signal.filter { $0.isInternational == false }.ignoreValues(), domesticPassenger.signal).map(second)
        
        let baggageValid = Signal.merge(includedBaggage.signal, includedChildBaggage.signal)
        
        self.submitInternationalPassenger = Signal.combineLatest(passengerData.signal.map { $0.passenger }, Signal.merge(domesticValid.signal, internationalValid.signal, baggageValid.signal)).takeWhen(self.submitPassengerTappedProperty.signal)
    }
    
    fileprivate let configSeparatorProperty = MutableProperty<(FormatDataForm, PassengerStatus, FormatDataForm?)?>(nil)
    public func configureWith(_ separator: FormatDataForm, status: PassengerStatus, baggages: FormatDataForm?) {
        self.configSeparatorProperty.value = (separator, status, baggages)
    }
    
    fileprivate let configPassengerDataProperty = MutableProperty<PassengersData?>(nil)
    public func configureWith(data: PassengersData) {
        self.configPassengerDataProperty.value = data
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
    
    fileprivate let baggageDepartTappedProperty = MutableProperty(())
    public func baggageDepartButtonTapped() {
        self.baggageDepartTappedProperty.value = ()
    }
    
    fileprivate let baggageDepartChangedProperty = MutableProperty<ResourceBaggage?>(nil)
    public func baggageDepartChanged(_ res: ResourceBaggage?) {
        self.baggageDepartChangedProperty.value = res
    }
    
    fileprivate let baggageDepartCanceledProperty = MutableProperty(())
    public func baggageDepartCanceled() {
        self.baggageDepartCanceledProperty.value = ()
    }
    
    fileprivate let baggageReturnTappedProperty = MutableProperty(())
    public func baggageReturnButtonTapped() {
        self.baggageReturnTappedProperty.value = ()
    }
    
    fileprivate let baggageReturnChangedProperty = MutableProperty<ResourceBaggage?>(nil)
    public func baggageReturnChanged(_ res: ResourceBaggage?) {
        self.baggageReturnChangedProperty.value = res
    }
    
    fileprivate let baggageReturnCanceledProperty = MutableProperty(())
    public func baggageReturnCanceled() {
        self.baggageReturnCanceledProperty.value = ()
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
    public let isAvailableBaggage: Signal<Bool, NoError>
    public let departBaggageText: Signal<String, NoError>
    public let returnBaggageText: Signal<String, NoError>
    public let titleLabelText: Signal<String, NoError>
    public let goToInputsPicker: Signal<InternationalFormGoTo, NoError>
    public let goToBirthdatePicker: Signal<String, NoError>
    public let goToBaggagePicker: Signal<[ResourceBaggage], NoError>
    public let goReturnBaggagePicker: Signal<[ResourceBaggage], NoError>
    public let dismissBaggagePicker: Signal<(), NoError>
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
