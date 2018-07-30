 //
//  IssuedListCellViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 16/07/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result

public protocol IssuedListCellViewModelInputs {
    func configureWith(_ issue: IssuedOrder)
    func deletedOrderTapped()
}

public protocol IssuedListCellViewModelOutputs {
    var orderIdText: Signal<String, NoError> { get }
    var emailText: Signal<String, NoError> { get }
    var deletedOrder: Signal<IssuedOrder, NoError> { get }
}
 
public protocol IssuedListCellViewModelType {
    var inputs: IssuedListCellViewModelInputs { get }
    var outputs: IssuedListCellViewModelOutputs { get }
}
 
public final class IssuedListCellViewModel: IssuedListCellViewModelType, IssuedListCellViewModelInputs, IssuedListCellViewModelOutputs {
    
    public init() {
        self.orderIdText = self.configIssueProperty.signal.skipNil().map { "Order ID: \($0.orderId)" }
        self.emailText = self.configIssueProperty.signal.skipNil().map { "Email: \($0.email)" }
        
        self.deletedOrder = Signal.combineLatest(self.deletedOrderProperty.signal, self.configIssueProperty.signal.skipNil()).map(second)
    }
    
    fileprivate let configIssueProperty = MutableProperty<IssuedOrder?>(nil)
    public func configureWith(_ issue: IssuedOrder) {
        self.configIssueProperty.value = issue
    }
    
    fileprivate let deletedOrderProperty = MutableProperty(())
    public func deletedOrderTapped() {
        self.deletedOrderProperty.value = ()
    }
    
    public let orderIdText: Signal<String, NoError>
    public let emailText: Signal<String, NoError>
    public let deletedOrder: Signal<IssuedOrder, NoError>
    
    public var inputs: IssuedListCellViewModelInputs { return self }
    public var outputs: IssuedListCellViewModelOutputs { return self }
 }
