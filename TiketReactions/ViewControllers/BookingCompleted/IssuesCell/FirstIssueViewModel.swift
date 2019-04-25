//
//  FirstIssueViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 23/04/19.
//  Copyright © 2019 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol FirstIssueViewModelInputs {
    func configureWith(_ issue: OrderCartDetail)
    func baggageDetailButtonTapped()
}

public protocol FirstIssueViewModelOutputs {
    var isItLionFlight: Signal<Bool, NoError> { get }
    var baggageTapped: Signal<(), NoError> { get }
}

public protocol FirstIssueViewModelType {
    var inputs: FirstIssueViewModelInputs { get }
    var outputs: FirstIssueViewModelOutputs { get }
}

public final class FirstIssueViewModel: FirstIssueViewModelType, FirstIssueViewModelInputs, FirstIssueViewModelOutputs {
    
    public init() {
        let configFlightHotel = self.configCartDetailProperty.signal.skipNil()
        
        self.isItLionFlight = configFlightHotel.signal.map { $0.flightDetail.airlinesName }.map { $0 == "LION" }.negate()
        
        self.baggageTapped = self.baggageDetailTappedProperty.signal
    }
    
    fileprivate let configCartDetailProperty = MutableProperty<OrderCartDetail?>(nil)
    public func configureWith(_ issue: OrderCartDetail) {
        self.configCartDetailProperty.value = issue
    }
    
    fileprivate let baggageDetailTappedProperty = MutableProperty(())
    public func baggageDetailButtonTapped() {
        self.baggageDetailTappedProperty.value = ()
    }
    
    public let isItLionFlight: Signal<Bool, NoError>
    public let baggageTapped: Signal<(), NoError>
    
    public var inputs: FirstIssueViewModelInputs { return self }
    public var outputs: FirstIssueViewModelOutputs { return self }
}
