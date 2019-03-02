//
//  EmptyStatesViewModel.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 14/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import Result

public enum EmptyState: String {
    case flightResult = "flight_result"
    case hotelResult = "hotel_result"
    case orderResult = "order_result"
    case issueResult = "issue_result"
}

public protocol EmptyStatesViewModelInputs {
    func configureWith(emptyState: EmptyState?)
    
    func setEmptyState(_ emptyState: EmptyState)
    
    func viewWillAppear()
}

public protocol EmptyStatesViewModelOutputs {
    var titleLabelText: Signal<String, NoError> { get }
    var subtitleLabelText: Signal<String, NoError> { get }
    var imageEmptyState: Signal<UIImage, NoError> { get }
}

public protocol EmptyStatesViewModelType {
    var inputs: EmptyStatesViewModelInputs { get }
    var outputs: EmptyStatesViewModelOutputs { get }
}

public final class EmptyStatesViewModel: EmptyStatesViewModelType, EmptyStatesViewModelInputs, EmptyStatesViewModelOutputs {
    
    public init() {
        let emptyState = Signal.combineLatest(self.emptyStateProperty.signal.skipNil(), self.viewWillAppearProperty.signal.take(first: 1)).map(first)
        
        self.titleLabelText = emptyState.map(textForTitle(emptyState:))
        self.subtitleLabelText = emptyState.map(textForSubtitle(emptyState:))
        self.imageEmptyState = emptyState.map(imageFor(emptyState:))
    }
    
    fileprivate let emptyStateProperty = MutableProperty<EmptyState?>(nil)
    public func configureWith(emptyState: EmptyState?) {
        self.emptyStateProperty.value = emptyState
    }
    
    public func setEmptyState(_ emptyState: EmptyState) {
        self.emptyStateProperty.value = emptyState
    }
    
    fileprivate let viewWillAppearProperty = MutableProperty(())
    public func viewWillAppear() {
        self.viewWillAppearProperty.value = ()
    }
    
    public let titleLabelText: Signal<String, NoError>
    public let subtitleLabelText: Signal<String, NoError>
    public let imageEmptyState: Signal<UIImage, NoError>
    
    public var inputs: EmptyStatesViewModelInputs { return self }
    public var outputs: EmptyStatesViewModelOutputs { return self }
}

private func textForTitle(emptyState: EmptyState) -> String {
    switch emptyState {
    case .flightResult:
        return Localizations.NoflightTitle
    case .hotelResult:
        return Localizations.NohotelTitle
    case .orderResult:
        return Localizations.NoorderTitle
    case .issueResult:
        return ""
    }
}

private func textForSubtitle(emptyState: EmptyState) -> String {
    switch emptyState {
    case .flightResult:
        return Localizations.NoflightDescription
    case .hotelResult:
        return Localizations.NohotelDescription
    case .orderResult:
        return Localizations.NoorderDescription
    case .issueResult:
        return Localizations.NoissueDescription
    }
}

private func imageFor(emptyState: EmptyState) -> UIImage {
    switch emptyState {
    case .issueResult:
        return UIImage(named: "illustrator-lounge")!
    default:
        return UIImage(named: "illustrator-emptystate")!
    }
}
