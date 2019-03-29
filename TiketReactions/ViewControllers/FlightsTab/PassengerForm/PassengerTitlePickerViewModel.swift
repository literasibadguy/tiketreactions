//
//  PassengerTitlePickerViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 06/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol PassengerTitlePickerViewModelInputs {
    func cancelButtonTapped()
    func selectedSalutation(titles: [String], title: String)
    func pickerView(didSelectRow row: Int)
    func doneButtonTapped()
    func viewDidLoad()
    func viewWillAppear()
}

public protocol PassengerTitlePickerViewModelOutputs {
    var dataSource: Signal<[String], NoError> { get }
    var notifyDelegateChoseTitle: Signal<String, NoError> { get }
    var notifyDelegateToCancel: Signal<(), NoError> { get }
    var selectRow: Signal<Int, NoError> { get }
}

public protocol PassengerTitlePickerViewModelType {
    var inputs: PassengerTitlePickerViewModelInputs { get }
    var outputs: PassengerTitlePickerViewModelOutputs { get }
}

public final class PassengerTitlePickerViewModel: PassengerTitlePickerViewModelType, PassengerTitlePickerViewModelInputs, PassengerTitlePickerViewModelOutputs {
    
    public init() {
        let selectedSalutation = Signal.combineLatest(self.selectedSalutationProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        self.dataSource = selectedSalutation.signal.map(first)
        
        self.selectRow = selectedSalutation.map { (arg) -> Int in
            let (titles, selected) = arg
            return titles.index(of: selected) ?? 0
        }.takeWhen(self.viewWillAppearProperty.signal)
        
        let selectedRow = Signal.merge(self.pickerSelectedRowProperty.signal, self.selectRow)
        
        let currentTitle = Signal.combineLatest(selectedSalutation, selectedRow).map { titles, idx in titles.0[idx] }
        self.notifyDelegateChoseTitle = currentTitle.map(choseTitleIntoParam(_ :)).takeWhen(self.doneButtonTappedProperty.signal)
        
        self.notifyDelegateToCancel = self.cancelButtonTappedProperty.signal
    }
    
    fileprivate let cancelButtonTappedProperty = MutableProperty(())
    public func cancelButtonTapped() {
        self.cancelButtonTappedProperty.value = ()
    }
    
    fileprivate let selectedSalutationProperty = MutableProperty<([String], String)?>(nil)
    public func selectedSalutation(titles: [String], title: String) {
        self.selectedSalutationProperty.value = (titles, title)
    }
    
    fileprivate let doneButtonTappedProperty = MutableProperty(())
    public func doneButtonTapped() {
        self.doneButtonTappedProperty.value = ()
    }
    
    fileprivate let pickerSelectedRowProperty = MutableProperty(-1)
    public func pickerView(didSelectRow row: Int) {
        self.pickerSelectedRowProperty.value = row
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    fileprivate let viewWillAppearProperty = MutableProperty(())
    public func viewWillAppear() {
        self.viewWillAppearProperty.value = ()
    }
    
    public let dataSource: Signal<[String], NoError>
    public let notifyDelegateChoseTitle: Signal<String, NoError>
    public let notifyDelegateToCancel: Signal<(), NoError>
    public let selectRow: Signal<Int, NoError>
    
    public var inputs: PassengerTitlePickerViewModelInputs { return self }
    public var outputs: PassengerTitlePickerViewModelOutputs { return self }
}

fileprivate func choseTitleIntoParam(_ title: String) -> String {
    switch title {
    case Localizations.MrFormData:
        return "Mr"
    case Localizations.MsFormData:
        return "Ms"
    case Localizations.MrsFormData:
        return "Mrs"
    case Localizations.MstrFormData:
        return "Mstr"
    case Localizations.MissFormData:
        return "Miss"
    default:
        return ""
    }
}

