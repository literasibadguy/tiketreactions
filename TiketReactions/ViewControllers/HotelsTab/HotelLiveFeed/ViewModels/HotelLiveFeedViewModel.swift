//
//  HotelLiveFeedViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 06/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol HotelLiveFeedViewModelInputs {
    func filter(withParams params: SearchHotelParams)
    func viewDidLoad()
    func viewWillAppear(animated: Bool)
}

public protocol HotelLiveFeedViewModelOutputs {
    var configureNavigationHeader: Signal<SearchHotelParams, NoError> { get }
    var loadFilterIntoDataSource: Signal<SearchHotelParams, NoError> { get }
}

public protocol HotelLiveFeedViewModelType {
    var inputs: HotelLiveFeedViewModelInputs { get }
    var outputs: HotelLiveFeedViewModelOutputs { get }
}

public final class HotelLiveFeedViewModel: HotelLiveFeedViewModelType, HotelLiveFeedViewModelInputs, HotelLiveFeedViewModelOutputs {
    
    fileprivate static let defaultParams = .defaults
        |> SearchHotelParams.lens.query .~ "Indonesia"
        |> SearchHotelParams.lens.startDate .~ "2018-05-11"
        |> SearchHotelParams.lens.endDate .~ "2018-05-12"
        |> SearchHotelParams.lens.sort .~ "popular"
        |> SearchHotelParams.lens.room .~ 1
        |> SearchHotelParams.lens.adult .~ "2"
    
    public init() {
        
        let currentParams = Signal.merge(self.viewDidLoadProperty.signal.take(first: 1).mapConst(HotelLiveFeedViewModel.defaultParams), self.filterWithParamsProperty.signal.skipNil()).skipRepeats()
        
        self.configureNavigationHeader = currentParams
        self.loadFilterIntoDataSource = currentParams
    }
    
    fileprivate let filterWithParamsProperty = MutableProperty<SearchHotelParams?>(nil)
    public func filter(withParams params: SearchHotelParams) {
        self.filterWithParamsProperty.value = params
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    fileprivate let viewWillAppearProperty = MutableProperty(())
    public func viewWillAppear(animated: Bool) {
        self.viewWillAppearProperty.value = ()
    }
    
    public let configureNavigationHeader: Signal<SearchHotelParams, NoError>
    public let loadFilterIntoDataSource: Signal<SearchHotelParams, NoError>
    
    public var inputs: HotelLiveFeedViewModelInputs { return self }
    public var outputs: HotelLiveFeedViewModelOutputs { return self }
}
