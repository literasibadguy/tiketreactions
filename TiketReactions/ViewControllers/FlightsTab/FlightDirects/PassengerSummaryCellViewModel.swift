//
//  PassengerSummaryCellViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 15/03/19.
//  Copyright © 2019 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol PassengerSummaryCellViewModelInputs {
    func configurePassenger(_ format: FormatDataForm)
    func configureSummary(_ summary: AdultPassengerParam)
}

public protocol PassengerSummaryCellViewModelOutputs {
    var summaryText: Signal<String, NoError> { get }
}

public protocol PassengerSummaryCellViewModelType {
    var inputs: PassengerSummaryCellViewModelInputs { get }
    var outputs: PassengerSummaryCellViewModelOutputs { get }
}

public final class PassengerSummaryCellViewModel: PassengerSummaryCellViewModelType, PassengerSummaryCellViewModelInputs, PassengerSummaryCellViewModelOutputs {
    
    public init() {
//        let summaryText = self.configSummaryProperty.signal.skipNil().map { $0 }
        
        self.summaryText = Signal.merge(self.configPassengerProperty.signal.skipNil().mapConst(Localizations.FillDataTitlePassengerForm).skipRepeats(), self.configSummaryProperty.signal.skipNil().map { "\($0.title ?? "") \($0.firstname ?? "") \($0.lastname ?? "")" })
        
        
    }
    
    fileprivate let configPassengerProperty = MutableProperty<FormatDataForm?>(nil)
    public func configurePassenger(_ format: FormatDataForm) {
        self.configPassengerProperty.value = format
    }
    
    
    fileprivate let configSummaryProperty = MutableProperty<AdultPassengerParam?>(nil)
    public func configureSummary(_ summary: AdultPassengerParam) {
        self.configSummaryProperty.value = summary
    }
    
    public let summaryText: Signal<String, NoError>
    
    public var inputs: PassengerSummaryCellViewModelInputs { return self }
    public var outputs: PassengerSummaryCellViewModelOutputs { return self }
}
