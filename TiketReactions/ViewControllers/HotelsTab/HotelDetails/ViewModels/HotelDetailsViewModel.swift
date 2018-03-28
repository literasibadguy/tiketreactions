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
import TiketAPIs

public protocol HotelDetailsVCViewModelInputs {
    func configureWith(hotelResult: HotelResult)
    
    func viewDidLoad()
    
    func initial(topConstraint: CGFloat)
    
    func viewDidAppear(animated: Bool)
    
    func viewWillAppear(animated: Bool)
    
    func willTransition(toNewCollection collection: UITraitCollection)
}

public protocol HotelDetailsVCViewModelOutputs {
    var configureChildVCHotelDirect: Signal<HotelDirect, NoError> { get }
    
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
        
        self.configureChildVCHotelDirect = self.configHotelDirectProperty.signal.skipNil().switchMap { result in
            AppEnvironment.current.apiService.fetchHotelDetail(url: result.businessURI, params: sampleParams).demoteErrors()
        }
        
        self.setNeedsStatusBarAppearanceUpdate = Signal.merge(self.viewWillAppearAnimatedProperty.signal.ignoreValues(), self.willTransitionToCollectionProperty.signal.ignoreValues())
        
        self.setNavigationBarHiddenAnimated = Signal.merge(
            self.viewDidLoadProperty.signal.mapConst((true, false)),
            self.viewWillAppearAnimatedProperty.signal.skip(first: 1).map { (true, $0) }
        )
        
        self.topLayoutConstraintConstant = self.initialTopConstraintProperty.signal.skipNil().takePairWhen(self.willTransitionToCollectionProperty.signal.skipNil()).map(topLayoutConstraintConstant(initialTopConstraint:traitCollection:))
    }
    
    private let configHotelDirectProperty = MutableProperty<HotelResult?>(nil)
    public func configureWith(hotelResult: HotelResult) {
        self.configHotelDirectProperty.value = hotelResult
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
    
    public let configureChildVCHotelDirect: Signal<HotelDirect, NoError>
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
