//
//  IssuedListViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 27/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import RealmSwift
import Result
import TiketKitModels

public protocol IssuedListViewModelInputs {
    func configureWith(_ issues: IssuedOrderList)
    func issuedOrderSelected(_ issue: IssuedOrder)
    func issuedOrderDeleted(_ issue: IssuedOrder)
    func confirmDeletedOrder(_ confirm: Bool)
    func getNotifiedToken(_ token: NotificationToken)
    func isEditingIssuedOrder(_ edit: Bool)
    func currencyRowSelected()
    func noticeAlertDelete()
    func viewDidLoad()
    func viewWillAppear()
}

public protocol IssuedListViewModelOutputs {
    var issues: Signal<IssuedOrderList, NoError> { get }
    var issueObserver: Signal<RealmCollectionChange<IssuedOrder>, NoError> { get }
    var goToIssue: Signal<IssuedOrder, NoError> { get }
    var deleteIssueReminder: Signal<String, NoError> { get }
    var commitWrite: Signal<(NotificationToken, List<IssuedOrder>), NoError> { get }
    var showEmptyState: Signal<EmptyState, NoError> { get }
    var hideEmptyState: Signal<(), NoError> { get }
    var goToCurrency: Signal<String, NoError> { get }
}


public protocol IssuedListViewModelType {
    var inputs: IssuedListViewModelInputs { get }
    var outputs: IssuedListViewModelOutputs { get }
}

public final class IssuedListViewModel: IssuedListViewModelType, IssuedListViewModelInputs, IssuedListViewModelOutputs {
    
    public init() {
        let current = Signal.combineLatest(Signal.merge(self.viewWillAppearProperty.signal, self.viewDidLoadProperty.signal), self.configIssuesProperty.signal.skipNil()).map(second)
        
        let pleaseCurrency = self.viewDidLoadProperty.signal.map { AppEnvironment.current.apiService.currency }
        
        self.issues = current.signal
        self.goToIssue = self.issueOrderSelectedProperty.signal.skipNil()
        
        self.issueObserver = .empty
        
        self.deleteIssueReminder = self.alertDeletedProperty.signal.map { "Yakin hapus pesanan ini?" }
        
        self.showEmptyState = current.map { $0.items }.filter { $0.isEmpty }.map { _ in emptyStateIssue() }
        self.hideEmptyState = current.map { $0.items }.filter { !$0.isEmpty }.ignoreValues()
        
        self.goToCurrency = pleaseCurrency.signal.takeWhen(self.currencyRowSelectedProperty.signal)
        
        self.commitWrite = Signal.combineLatest(self.notifiedTokenProperty.signal.skipNil(), self.issues.signal.map { $0.items })
    }
    
    fileprivate let configIssuesProperty = MutableProperty<IssuedOrderList?>(nil)
    public func configureWith(_ issues: IssuedOrderList) {
        self.configIssuesProperty.value = issues
    }
    
    fileprivate let issueOrderSelectedProperty = MutableProperty<IssuedOrder?>(nil)
    public func issuedOrderSelected(_ issue: IssuedOrder) {
        self.issueOrderSelectedProperty.value = issue
    }
    
    fileprivate let issueOrderDeletedProperty = MutableProperty<IssuedOrder?>(nil)
    public func issuedOrderDeleted(_ issue: IssuedOrder) {
        self.issueOrderDeletedProperty.value = issue
    }
    
    fileprivate let confirmOrderDeletedProperty = MutableProperty<Bool?>(nil)
    public func confirmDeletedOrder(_ confirm: Bool) {
        self.confirmOrderDeletedProperty.value = confirm
    }
    
    fileprivate let notifiedTokenProperty = MutableProperty<NotificationToken?>(nil)
    public func getNotifiedToken(_ token: NotificationToken) {
        self.notifiedTokenProperty.value = token
    }
    
    fileprivate let editingOrderProperty = MutableProperty(false)
    public func isEditingIssuedOrder(_ edit: Bool) {
        self.editingOrderProperty.value = edit
    }
    
    fileprivate let alertDeletedProperty = MutableProperty(())
    public func noticeAlertDelete() {
        self.alertDeletedProperty.value = ()
    }
    
    fileprivate let currencyRowSelectedProperty = MutableProperty(())
    public func currencyRowSelected() {
        self.currencyRowSelectedProperty.value = ()
    }
    
    fileprivate let shouldRefreshProperty = MutableProperty(())
    public func shouldRefresh() {
        self.shouldRefreshProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    fileprivate let viewWillAppearProperty = MutableProperty(())
    public func viewWillAppear() {
        self.viewWillAppearProperty.value = ()
    }
    
    public let issues: Signal<IssuedOrderList, NoError>
    public let issueObserver: Signal<RealmCollectionChange<IssuedOrder>, NoError>
    public let goToIssue: Signal<IssuedOrder, NoError>
    public let deleteIssueReminder: Signal<String, NoError>
    public let commitWrite: Signal<(NotificationToken, List<IssuedOrder>), NoError>
    public let showEmptyState: Signal<EmptyState, NoError>
    public let hideEmptyState: Signal<(), NoError>
    public let goToCurrency: Signal<String, NoError>
    
    public var inputs: IssuedListViewModelInputs { return self }
    public var outputs: IssuedListViewModelOutputs { return self }
    
}


private func emptyStateIssue() -> EmptyState {
    return EmptyState.issueResult
}

