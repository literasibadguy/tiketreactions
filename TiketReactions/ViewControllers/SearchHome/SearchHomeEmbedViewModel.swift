//
//  SearchHomeEmbedViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 04/11/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result

public enum SearchHomeTab {
    case flight
    case hotel
    
    public static let allTabs: [SearchHomeTab] = [.flight, .hotel]
}

public protocol SearchHomeEmbedViewModelInputs {
    func flightButtonTapped()
    func hotelButtonTapped()
    func pageTransition(completed: Bool)
    func takeInitial()
    func viewDidLoad()
    func viewWillAppear()
    func willTransition(toPage nextPage: Int)
}

public protocol SearchHomeEmbedViewModelOutputs {
    var homeDateText: Signal<String, NoError> { get }
    var configurePagesDataSource: Signal<SearchHomeTab, NoError> { get }
    var currentSelectedTab: SearchHomeTab { get }
    var navigateToTab: Signal<SearchHomeTab, NoError> { get }
    var pinSelectedIndicatorToTab: Signal<(SearchHomeTab, Bool), NoError> { get }
    var setSelectedButton: Signal<SearchHomeTab, NoError> { get }
    
}

public protocol SearchHomeEmbedViewModelType {
    var inputs: SearchHomeEmbedViewModelInputs { get }
    var outputs: SearchHomeEmbedViewModelOutputs { get }
}

public final class SearchHomeEmbedViewModel: SearchHomeEmbedViewModelType, SearchHomeEmbedViewModelInputs, SearchHomeEmbedViewModelOutputs {
    
    public init() {
        
        self.configurePagesDataSource = self.viewDidLoadProperty.signal.map { SearchHomeTab.flight }
        
        let swipedToTab = self.willTransitionToPageProperty.signal
            .takeWhen(self.pageTransitionCompletedProperty.signal.filter(isTrue))
            .map { SearchHomeTab.allTabs[$0] }
        
        self.navigateToTab = Signal.merge(self.takeInitialProperty.signal.map { SearchHomeTab.flight },swipedToTab, self.flightTappedProperty.signal.mapConst(.flight), self.hotelTappedProperty.signal.mapConst(.hotel))
        
        self.currentSelectedTabProperty <~ self.navigateToTab
        
        self.setSelectedButton = self.navigateToTab
        
        self.pinSelectedIndicatorToTab = self.navigateToTab.map { ($0, true) }
        
        self.homeDateText = .empty
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    fileprivate let viewWillAppearProperty = MutableProperty(())
    public func viewWillAppear() {
        self.viewWillAppearProperty.value = ()
    }
    
    fileprivate let takeInitialProperty = MutableProperty(())
    public func takeInitial() {
        self.takeInitialProperty.value = ()
    }
    
    fileprivate let currentSelectedTabProperty = MutableProperty<SearchHomeTab>(.flight)
    public var currentSelectedTab: SearchHomeTab {
        return self.currentSelectedTabProperty.value
    }
    
    fileprivate let pageTransitionCompletedProperty = MutableProperty(false)
    public func pageTransition(completed: Bool) {
        self.pageTransitionCompletedProperty.value = completed
    }
    
    fileprivate let flightTappedProperty = MutableProperty(())
    public func flightButtonTapped() {
        self.flightTappedProperty.value = ()
    }
    
    fileprivate let hotelTappedProperty = MutableProperty(())
    public func hotelButtonTapped() {
        self.hotelTappedProperty.value = ()
    }
    
    fileprivate let willTransitionToPageProperty = MutableProperty<Int>(0)
    public func willTransition(toPage nextPage: Int) {
        self.willTransitionToPageProperty.value = nextPage
    }
    
    public let homeDateText: Signal<String, NoError>
    public let configurePagesDataSource: Signal<SearchHomeTab, NoError>
    public let navigateToTab: Signal<SearchHomeTab, NoError>
    public let pinSelectedIndicatorToTab: Signal<(SearchHomeTab, Bool), NoError>
    public let setSelectedButton: Signal<SearchHomeTab, NoError>
    
    public var inputs: SearchHomeEmbedViewModelInputs { return self }
    public var outputs: SearchHomeEmbedViewModelOutputs { return self }
}



