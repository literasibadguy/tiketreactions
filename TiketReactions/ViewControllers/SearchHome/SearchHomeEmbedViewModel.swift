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

public protocol SearchHomeEmbedViewModelInputs {
    func flightButtonTapped()
    func hotelButtonTapped()
    func viewDidLoad()
    func viewWillAppear()
}

public protocol SearchHomeEmbedViewModelOutputs {
    var homeDateText: Signal<String, NoError> { get }
    var showFomrsController: Signal<(), NoError> { get }
    var flightFormVisible: Signal<(), NoError> { get }
    var hotelFormVisible: Signal<(), NoError> { get }
}

public protocol SearchHomeEmbedViewModelType {
    var inputs: SearchHomeEmbedViewModelInputs { get }
    var outputs: SearchHomeEmbedViewModelOutputs { get }
}

public final class SearchHomeEmbedViewModel: SearchHomeEmbedViewModelType, SearchHomeEmbedViewModelInputs, SearchHomeEmbedViewModelOutputs {
    
    public init() {
        
        self.showFomrsController = self.viewDidLoadProperty.signal
        self.flightFormVisible = self.flightTappedProperty.signal
        self.hotelFormVisible = self.hotelTappedProperty.signal
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
    
    fileprivate let flightTappedProperty = MutableProperty(())
    public func flightButtonTapped() {
        self.flightTappedProperty.value = ()
    }
    
    fileprivate let hotelTappedProperty = MutableProperty(())
    public func hotelButtonTapped() {
        self.hotelTappedProperty.value = ()
    }
    
    public let homeDateText: Signal<String, NoError>
    public let showFomrsController: Signal<(), NoError>
    public let flightFormVisible: Signal<(), NoError>
    public let hotelFormVisible: Signal<(), NoError>
    
    public var inputs: SearchHomeEmbedViewModelInputs { return self }
    public var outputs: SearchHomeEmbedViewModelOutputs { return self }
}



