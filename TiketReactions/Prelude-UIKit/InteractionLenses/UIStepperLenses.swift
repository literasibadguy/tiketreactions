//
//  UIStepperLenses.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 28/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude

public protocol UIStepperProtocol: UIControlProtocol {
    var isContinuous: Bool { get set }
    var autorepeat: Bool { get set }
    var wraps: Bool { get set }
    var value: Double { get set }
    var minimumValue: Double { get set }
    var maximumValue: Double { get set }
    var stepValue: Double { get set }
    
    var tintColor: UIColor! { get set }
    
    func backgroundImage(for state: UIControl.State) -> UIImage?
    func setBackgroundImage(_ image: UIImage?, for state: UIControl.State)
    
    func incrementImage(for state: UIControl.State) -> UIImage?
    func setIncrementImage(_ image: UIImage?, for state: UIControl.State)
    func decrementImage(for state: UIControl.State) -> UIImage?
    func setDecrementImage(_ image: UIImage?, for state: UIControl.State)
    
}

extension UIStepper: UIStepperProtocol {
    
}

public extension LensHolder where Object: UIStepperProtocol {
    var isContinuous: Lens<Object, Bool> {
        return Lens(
            view: { $0.isContinuous },
            set: { $1.isContinuous = $0; return $1 }
        )
    }
    
    var autorepeat: Lens<Object, Bool> {
        return Lens(
            view: { $0.autorepeat },
            set: { $1.autorepeat = $0; return $1 }
        )
    }
    
    var wraps: Lens<Object, Bool> {
        return Lens(
            view: { $0.wraps },
            set: { $1.wraps = $0; return $1 }
        )
    }
    
    var value: Lens<Object, Double> {
        return Lens(
            view: { $0.value },
            set: { $1.value = $0; return $1 }
        )
    }
    
    var minimumValue: Lens<Object, Double> {
        return Lens(
            view: { $0.minimumValue },
            set: { $1.minimumValue = $0; return $1 }
        )
    }
    
    var maximumValue: Lens<Object, Double> {
        return Lens(
            view: { $0.maximumValue },
            set: { $1.maximumValue = $0; return $1 }
        )
    }
    
    var stepValue: Lens<Object, Double> {
        return Lens(
            view: { $0.stepValue },
            set: { $1.stepValue = $0; return $1 }
        )
    }
    
    var tintColor: Lens<Object, UIColor> {
        return Lens(
            view: { $0.tintColor },
            set: { $1.tintColor = $0; return $1 }
        )
    }
    
    func backgroundImage(for state: UIControl.State) -> Lens<Object, UIImage?> {
        return Lens(
            view: { view in view.backgroundImage(for: state) },
            set: { view, set in set.setBackgroundImage(view, for: state); return set }
        )
    }
    
    func incrementImage(for state: UIControl.State) -> Lens<Object, UIImage?> {
        return Lens(
            view: { view in view.incrementImage(for: state) },
            set: { view, set in set.setIncrementImage(view, for: state); return set}
        )
    }
    
    func decrementImage(for state: UIControl.State) -> Lens<Object, UIImage?> {
        return Lens(
            view: { view in view.decrementImage(for: state) },
            set: { view, set in set.setDecrementImage(view, for: state); return set}
        )
    }
}
