//
//  BookingCompletedViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 11/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import PDFReader
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol BookingCompletedViewModelInputs {
    func configureWith(_ orderId: String, email: String)
    func sendVoucherTapped()
    func printVoucherTapped(_ document: PDFDocument)
    func printVoucherError(_ description: String)
    func confirmDismissError()
    func baggagePrepaidTapped()
    func viewDidLoad()
}

public protocol BookingCompletedViewModelOutputs {
    var orderCartDetail: Signal<[OrderCartDetail], NoError> { get }
    var generatePDF: Signal<PDFDocument, NoError> { get }
    var resultsAreLoading: Signal<Bool, NoError> { get }
    var showAlert: Signal<String, NoError> { get }
    var errorPDFPrint: Signal<String, NoError> { get }
    var dismissError: Signal<(), NoError> { get }
    var goToWebBrowser: Signal<(), NoError> { get }
}

public protocol BookingCompletedViewModelType {
    var inputs: BookingCompletedViewModelInputs { get }
    var outputs: BookingCompletedViewModelOutputs { get }
}

public final class BookingCompletedViewModel: BookingCompletedViewModelType, BookingCompletedViewModelInputs, BookingCompletedViewModelOutputs {
    
    public init() {
        
        let isLoading = MutableProperty(false)
        let current = Signal.combineLatest(self.viewDidLoadProperty.signal, self.configIssueResultProperty.signal.skipNil()).map(second)
        
        let fetchBooked = current.switchMap { orderId, email in
            AppEnvironment.current.apiService.checkHistoryOrder(orderId, email: email).materialize()
        }
        
        self.orderCartDetail = fetchBooked.values().map { $0.result.orderCardDetail }
        
        self.generatePDF = self.printVoucherTappedProperty.signal.skipNil()
        
        self.resultsAreLoading = isLoading.signal
        
        self.showAlert = Signal.merge(fetchBooked.errors().map { _ in "Order tidak valid atau pesanan belum terbayar" })
        
        self.errorPDFPrint =  self.printVoucherErrorProperty.signal
        
        self.dismissError = self.confirmDismissProperty.signal.ignoreValues()
        
        self.goToWebBrowser = self.baggageTappedProperty.signal
    }
    
    
    fileprivate let configIssueResultProperty = MutableProperty<(String, String)?>(nil)
    public func configureWith(_ orderId: String, email: String) {
        self.configIssueResultProperty.value = (orderId, email)
    }
    
    fileprivate let sendVoucherTappedProperty = MutableProperty(())
    public func sendVoucherTapped() {
        self.sendVoucherTappedProperty.value = ()
    }
    
    fileprivate let printVoucherTappedProperty = MutableProperty<PDFDocument?>(nil)
    public func printVoucherTapped(_ document: PDFDocument) {
        self.printVoucherTappedProperty.value = document
    }
    
    fileprivate let printVoucherErrorProperty = MutableProperty("")
    public func printVoucherError(_ description: String) {
        self.printVoucherErrorProperty.value = description
    }
    
    fileprivate let confirmDismissProperty = MutableProperty(())
    public func confirmDismissError() {
        self.confirmDismissProperty.value = ()
    }
    
    fileprivate let baggageTappedProperty = MutableProperty(())
    public func baggagePrepaidTapped() {
        self.baggageTappedProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let orderCartDetail: Signal<[OrderCartDetail], NoError>
    public let generatePDF: Signal<PDFDocument, NoError>
    public let resultsAreLoading: Signal<Bool, NoError>
    public let showAlert: Signal<String, NoError>
    public let errorPDFPrint: Signal<String, NoError>
    public let dismissError: Signal<(), NoError>
    public let goToWebBrowser: Signal<(), NoError>
    
    public var inputs: BookingCompletedViewModelInputs { return self }
    public var outputs: BookingCompletedViewModelOutputs { return self }
}
