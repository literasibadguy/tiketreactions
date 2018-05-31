//
//  HotelDetailsViewModel.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 08/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol HotelDetailsVCViewModelInputs {
    func configureWith(hotelResult: HotelResult, booking: HotelBookingSummary)
    
    func viewDidLoad()
    
    func initial(topConstraint: CGFloat)
    
    func viewDidAppear(animated: Bool)
    
    func viewWillAppear(animated: Bool)
    
    func willTransition(toNewCollection collection: UITraitCollection)
}

public protocol HotelDetailsVCViewModelOutputs {
    var configureChildVCHotelDirect: Signal<(HotelResult, HotelDirect, HotelBookingSummary), NoError> { get }
    
    var prefersStatusBarHidden: Bool { get }
    
    var setNavigationBarHiddenAnimated: Signal<(Bool, Bool), NoError> { get }
    
    var topLayoutConstraintConstant: Signal<CGFloat, NoError> { get }
}

public protocol HotelDetailsViewModelType {
    var inputs: HotelDetailsVCViewModelInputs { get }
    var outputs: HotelDetailsVCViewModelOutputs { get }
}

public final class HotelDetailsViewModel: HotelDetailsViewModelType, HotelDetailsVCViewModelInputs, HotelDetailsVCViewModelOutputs {
    
    public init() {
        
        let sampleParams = .defaults
            |> SearchHotelParams.lens.query .~ "Bandung"
            |> SearchHotelParams.lens.startDate .~ "2018-02-15"
            |> SearchHotelParams.lens.endDate .~ "2018-02-18"
            |> SearchHotelParams.lens.adult .~ "1"
            |> SearchHotelParams.lens.room .~ 1
        
        let selectedHotel = Signal.combineLatest(self.configHotelDirectProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        let requestDirect = selectedHotel.switchMap { result in
            AppEnvironment.current.apiService.fetchHotelDetail(url: result.0.businessURI, params: sampleParams).demoteErrors()
        }
        
        self.configureChildVCHotelDirect = Signal.combineLatest(selectedHotel.map(first), requestDirect, selectedHotel.map(second))
        
        self.setNeedsStatusBarAppearanceUpdate = Signal.merge(self.viewWillAppearAnimatedProperty.signal.ignoreValues(), self.willTransitionToCollectionProperty.signal.ignoreValues())
        
        self.setNavigationBarHiddenAnimated = Signal.merge(
            self.viewDidLoadProperty.signal.mapConst((true, false)),
            self.viewWillAppearAnimatedProperty.signal.skip(first: 1).map { (true, $0) }
        )
        
        self.topLayoutConstraintConstant = self.initialTopConstraintProperty.signal.skipNil().takePairWhen(self.willTransitionToCollectionProperty.signal.skipNil()).map(topLayoutConstraintConstant(initialTopConstraint:traitCollection:))
    }
    
    fileprivate let configHotelDirectProperty = MutableProperty<(HotelResult, HotelBookingSummary)?>(nil)
    public func configureWith(hotelResult: HotelResult, booking: HotelBookingSummary) {
        self.configHotelDirectProperty.value = (hotelResult, booking)
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    fileprivate let initialTopConstraintProperty = MutableProperty<CGFloat?>(nil)
    public func initial(topConstraint: CGFloat) {
        self.initialTopConstraintProperty.value = topConstraint
    }
    
    fileprivate let viewDidAppearAnimatedProperty = MutableProperty(false)
    public func viewDidAppear(animated: Bool) {
        self.viewDidAppearAnimatedProperty.value = animated
    }
    
    fileprivate let viewWillAppearAnimatedProperty = MutableProperty(false)
    public func viewWillAppear(animated: Bool) {
        self.viewWillAppearAnimatedProperty.value = animated
    }
    
    fileprivate let willTransitionToCollectionProperty = MutableProperty<UITraitCollection?>(nil)
    public func willTransition(toNewCollection collection: UITraitCollection) {
        self.willTransitionToCollectionProperty.value = collection
    }
    
    fileprivate let prefersStatusBarHiddenProperty = MutableProperty(false)
    public var prefersStatusBarHidden: Bool {
        return self.prefersStatusBarHiddenProperty.value
    }
    
    public let configureChildVCHotelDirect: Signal<(HotelResult, HotelDirect, HotelBookingSummary), NoError>
    public let setNavigationBarHiddenAnimated: Signal<(Bool, Bool), NoError>
    public let setNeedsStatusBarAppearanceUpdate: Signal<(), NoError>
    public let topLayoutConstraintConstant: Signal<CGFloat, NoError>
    
    public var inputs: HotelDetailsVCViewModelInputs { return self }
    public var outputs: HotelDetailsVCViewModelOutputs { return self }
}

private func topLayoutConstraintConstant(initialTopConstraint: CGFloat, traitCollection: UITraitCollection) -> CGFloat {
    guard !traitCollection.isRegularRegular else {
        return 0.0
    }
    return traitCollection.isVerticallyCompact ? 0.0 : initialTopConstraint
}
