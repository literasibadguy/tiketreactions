//
//  ManagedOrderListViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 01/10/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result

public enum ManagedOrderTab {
    case flight
    case hotel
    
    public static let allTabs: [ManagedOrderTab] = [.flight, .hotel]
}

public protocol ManagedOrderListViewModelInputs {
    func flightOrdersButtonTapped()
    
    func hotelOrdersButtonTapped()
    
    func issuesButtonTapped()
    
    func pageTransition(completed: Bool)
    
    func viewDidLoad()
    
    func willTransition(toPage nextPage: Int)
}

public protocol ManagedOrderListViewModelOutputs {
    
    var configurePagesDataSource: Signal<ManagedOrderTab, NoError> { get }
    
    var flightTitleText: Signal<String, NoError> { get }
    
    var hotelTitleText: Signal<String, NoError> { get }
    
    var currentSelectedTab: ManagedOrderTab { get }
    
    var goToIssues: Signal<(), NoError> { get }
    
    var navigateToTab: Signal<ManagedOrderTab, NoError> { get }
    
    var pinSelectedIndicatorTab: Signal<(ManagedOrderTab, Bool), NoError> { get }
    
    var setSelectedButton: Signal<ManagedOrderTab, NoError> { get }
}

public protocol ManagedOrderListViewModelType {
    var inputs: ManagedOrderListViewModelInputs { get }
    var outputs: ManagedOrderListViewModelOutputs { get }
}

public final class ManagedOrderListViewModel: ManagedOrderListViewModelType, ManagedOrderListViewModelInputs, ManagedOrderListViewModelOutputs {
    
    public init() {
        self.configurePagesDataSource = self.viewDidLoadProperty.signal.map { .flight }
        
        self.goToIssues = self.issuesButtonTappedProperty.signal
        
        let swipedToTab = self.willTransitionToPageProperty.signal.takeWhen(self.pageTransitionCompletedProperty.signal.filter(isTrue)).map { ManagedOrderTab.allTabs[$0] }
        
        self.navigateToTab = Signal.merge(swipedToTab, self.flightOrdersTappedProperty.signal.mapConst(.flight), self.hotelOrdersTappedProperty.signal.mapConst(.hotel))
        
        self.currentSelectedTabProperty <~ self.navigateToTab
        
        self.setSelectedButton = self.navigateToTab
        
        self.pinSelectedIndicatorTab = self.navigateToTab.map { ($0, true) }.skipRepeats(==)
        
        self.flightTitleText = self.viewDidLoadProperty.signal.map { "Flight" }
        self.hotelTitleText = self.viewDidLoadProperty.signal.map { "Hotel" }
    }
    
    private let flightOrdersTappedProperty = MutableProperty(())
    public func flightOrdersButtonTapped() {
        self.flightOrdersTappedProperty.value = ()
    }
    
    private let hotelOrdersTappedProperty = MutableProperty(())
    public func hotelOrdersButtonTapped() {
        self.hotelOrdersTappedProperty.value = ()
    }
    
    private let issuesButtonTappedProperty = MutableProperty(())
    public func issuesButtonTapped() {
        self.issuesButtonTappedProperty.value = ()
    }
    
    private let pageTransitionCompletedProperty = MutableProperty(false)
    public func pageTransition(completed: Bool) {
        self.pageTransitionCompletedProperty.value = completed
    }
    
    private let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    private let willTransitionToPageProperty = MutableProperty<Int>(0)
    public func willTransition(toPage nextPage: Int) {
        self.willTransitionToPageProperty.value = nextPage
    }
    
    private let currentSelectedTabProperty = MutableProperty<ManagedOrderTab>(.flight)
    public var currentSelectedTab: ManagedOrderTab {
        return self.currentSelectedTabProperty.value
    }
    
    public let configurePagesDataSource: Signal<ManagedOrderTab, NoError>
    public let flightTitleText: Signal<String, NoError>
    public let hotelTitleText: Signal<String, NoError>
    public let goToIssues: Signal<(), NoError>
    public let navigateToTab: Signal<ManagedOrderTab, NoError>
    public let pinSelectedIndicatorTab: Signal<(ManagedOrderTab, Bool), NoError>
    public let setSelectedButton: Signal<ManagedOrderTab, NoError>
    
    public var outputs: ManagedOrderListViewModelOutputs { return self }
    public var inputs: ManagedOrderListViewModelInputs { return self }
}
