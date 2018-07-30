//
//  ThirdIssueViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 19/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import PDFReader
import ReactiveSwift
import Result
import TiketKitModels

public protocol ThirdIssueViewModelInputs {
    func configureWith(_ issue: OrderCartDetail)
    func emailVoucherTapped()
    func downloadVoucherTapped()
}

public protocol ThirdIssueViewModelOutputs {
    var generateImage: Signal<PDFDocument, NoError> { get }
    var sendVoucher: Signal<(), NoError> { get }
}

public protocol ThirdIssueViewModelType {
    var inputs: ThirdIssueViewModelInputs { get }
    var outputs: ThirdIssueViewModelOutputs { get }
}

public final class ThirdIssueViewModel: ThirdIssueViewModelType, ThirdIssueViewModelInputs, ThirdIssueViewModelOutputs {
    
    public init() {
        let current = self.configIssueProperty.signal.skipNil()
        
        let printURIEvent = current.switchMap { documentPDFFromURI($0.printUri ?? "").materialize() }
        
        // printURIEvent.values().sample(on: self.downloadVoucherTappedProperty.signal)
        
        self.sendVoucher = .empty
        self.generateImage = printURIEvent.values().sample(on: self.downloadVoucherTappedProperty.signal)
    }
    
    fileprivate let configIssueProperty = MutableProperty<OrderCartDetail?>(nil)
    public func configureWith(_ issue: OrderCartDetail) {
        self.configIssueProperty.value = issue
    }
    
    fileprivate let emailVoucherTappedProperty = MutableProperty(())
    public func emailVoucherTapped() {
        self.emailVoucherTappedProperty.value = ()
    }
    
    fileprivate let downloadVoucherTappedProperty = MutableProperty(())
    public func downloadVoucherTapped() {
        self.downloadVoucherTappedProperty.value = ()
    }
    
    public let generateImage: Signal<PDFDocument, NoError>
    public let sendVoucher: Signal<(), NoError>
    
    public var inputs: ThirdIssueViewModelInputs { return self }
    public var outputs: ThirdIssueViewModelOutputs { return self }
}

fileprivate func documentPDFFromURI(_ printURI: String?) -> SignalProducer<PDFDocument, NoError> {
    
    let token = AppEnvironment.current.apiService.tiketToken?.token ?? ""
    
    let remotePDFDocumentURL = URL(string: "\(printURI ?? "")&token=\(token)")
    let document = PDFDocument(url: remotePDFDocumentURL!)!
    return SignalProducer(value: document)
}

