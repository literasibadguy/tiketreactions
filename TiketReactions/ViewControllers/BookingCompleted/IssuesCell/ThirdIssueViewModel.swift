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
    var titleOrderText: Signal<String, NoError> { get }
    var subtitleOrderText: Signal<String, NoError> { get }
    var orderIdText: Signal<String, NoError> { get }
    var firstFormTitle: Signal<String, NoError> { get }
    var guestNameText: Signal<String, NoError> { get }
    var secondFormTitle: Signal<String, NoError> { get }
    var thirdFormTitle: Signal<String, NoError> { get }
    var fourthFormTitle: Signal<String, NoError> { get }
    var checkInText: Signal<String, NoError> { get }
    var roomsText: Signal<String, NoError> { get }
    var breakfastText: Signal<String, NoError> { get }
    var generateImage: Signal<PDFDocument, NoError> { get }
    var generatePDFError: Signal<String, NoError> { get }
    var sendVoucher: Signal<(), NoError> { get }
}

public protocol ThirdIssueViewModelType {
    var inputs: ThirdIssueViewModelInputs { get }
    var outputs: ThirdIssueViewModelOutputs { get }
}

public final class ThirdIssueViewModel: ThirdIssueViewModelType, ThirdIssueViewModelInputs, ThirdIssueViewModelOutputs {
    
    public init() {
        let current = self.configIssueProperty.signal.skipNil()
        
        
        
        let printURIEvent = current.switchMap { documentPDFFromURI($0.printUri).materialize() }
        
        let hotelCheckin = current.signal.map { $0.hotelDetail.checkin }.skipNil()
        let nightCheckin = current.signal.map { $0.hotelDetail.nights }.skipNil()
        
        let accSalutationName = current.signal.map { $0.passenger.last?.accountSalutationName }.skipNil()
        let accFirstName = current.signal.map { $0.passenger.last?.accountFirstName }.skipNil()
        let accLastName = current.signal.map { $0.passenger.last?.accountLastName }.skipNil()
        
//        let departureFlight = current.signal.map { $0.flightDetail.departureCity }.skipNil()
//        let arrivalFlight = current.signal.map { $0.flightDetail.arrivalCity }.skipNil()
        
        // Keberangkatan
        let departureTime = current.signal.map { $0.flightDetail.departureTime }.skipNil().map(stringToDate(rawDate:)).map { dateFormatterString(date: $0, template: "MMM d, yyyy HH:mm") }
        // Kedatangan
        let arrivalTime = current.signal.map { $0.flightDetail.arrivalTime }.skipNil().map(stringToDate(rawDate:)).map { dateFormatterString(date: $0, template: "MMM d, yyyy HH:mm") }
        
        self.firstFormTitle = Signal.merge(departureTime.signal.mapConst("Keberangkatan"), accSalutationName.signal.mapConst("Guest Name"))
        self.secondFormTitle = Signal.merge(arrivalTime.signal.mapConst("Kedatangan"), accSalutationName.signal.mapConst("Check-in"))
        
        self.thirdFormTitle = Signal.merge(accSalutationName.signal.mapConst(Localizations.OrderRoomTitle), departureTime.signal.mapConst("Kode Booking"))
        self.fourthFormTitle = Signal.merge(accSalutationName.signal.mapConst(Localizations.AvailablebreakfastTitle), departureTime.signal.mapConst("Ticket Class"))

        self.titleOrderText = current.signal.map { $0.orderName }
        self.subtitleOrderText = current.signal.map { $0.orderNameDetail }
        self.orderIdText = current.signal.map { $0.orderDetailId }
        self.guestNameText = Signal.merge(Signal.combineLatest(accSalutationName, accFirstName, accLastName).map { "\($0.0) \($0.1) \($0.2)" }, departureTime.signal)
        self.checkInText = Signal.merge(Signal.combineLatest(hotelCheckin, nightCheckin).map { "\($0.0) - \(Localizations.CountNightsTitle(Int($0.1)!))" }, arrivalTime.signal)
        self.roomsText = Signal.merge(current.signal.map { "\($0.hotelDetail.rooms ?? "") Kamar" }, current.signal.map { $0.flightDetail.bookingCode ?? "" })
        self.breakfastText = Signal.merge(current.signal.map { "\(includedBreakfast($0.hotelDetail.breakfast ?? ""))" }, current.signal.map { $0.flightDetail.ticketClass ?? "" })
        
        // printURIEvent.values().sample(on: self.downloadVoucherTappedProperty.signal)
        
        self.sendVoucher = .empty
        
        self.generatePDFError = Signal.merge(printURIEvent.errors().ignoreValues(), printURIEvent.values().filter { $0.isNil }.ignoreValues()).map { _ in "FPDF Error: Can't print pdf" }
        
        self.generateImage = printURIEvent.values().skipNil().takeWhen(self.downloadVoucherTappedProperty.signal)
        
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
    
    public let titleOrderText: Signal<String, NoError>
    public let subtitleOrderText: Signal<String, NoError>
    public let orderIdText: Signal<String, NoError>
    public let firstFormTitle: Signal<String, NoError>
    public let guestNameText: Signal<String, NoError>
    public let secondFormTitle: Signal<String, NoError>
    public let thirdFormTitle: Signal<String, NoError>
    public let fourthFormTitle: Signal<String, NoError>
    public let checkInText: Signal<String, NoError>
    public let roomsText: Signal<String, NoError>
    public let breakfastText: Signal<String, NoError>
    public let generatePDFError: Signal<String, NoError>
    public let generateImage: Signal<PDFDocument, NoError>
    public let sendVoucher: Signal<(), NoError>
    
    public var inputs: ThirdIssueViewModelInputs { return self }
    public var outputs: ThirdIssueViewModelOutputs { return self }
}

fileprivate func documentPDFFromURI(_ printURI: String?) -> SignalProducer<PDFDocument?, NoError> {
    
    let token = AppEnvironment.current.apiService.tiketToken?.token ?? ""
    
    var remotePDFDocumentURI: URL!
    if let completedURI = printURI {
        remotePDFDocumentURI = URL(string: "\(completedURI)&token=\(token)")
        if let document = PDFDocument(url: remotePDFDocumentURI) {
            return SignalProducer(value: document)
        }
    }
    
    return SignalProducer(value: nil)
}


private func stringToDate(rawDate: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    print("RAW DATE: \(rawDate)")
    guard let date = dateFormatter.date(from: rawDate) else {
        fatalError("ERROR: Date conversion failed due to mismatched format.")
    }
    
    return date
}

private func dateFormatterString(date: Date, template: String) -> String {
    let printFormatter = DateFormatter()
    printFormatter.dateFormat = template
    
    let summaryDate = printFormatter.string(from: date)
    
    return summaryDate
}
