//
//  UIViewLenses.swift
//  TiketSignal
//
//  Created by Firas Rafislam on 12/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit

public protocol UIViewProtocol: CKObjectProtocol, UITraitEnvironmentProtocol, LensObject {
    func addConstraints(_ constraints: [NSLayoutConstraint])
    var alpha: CGFloat { get set }
    var backgroundColor: UIColor? { get set }
    var clipsToBounds: Bool { get set }
    var constraints: [NSLayoutConstraint] { get }
    func contentCompressionResistancePriority(for axis: UILayoutConstraintAxis) -> UILayoutPriority
    func contentHuggingPriority(for axis: UILayoutConstraintAxis) -> UILayoutPriority
    var contentMode: UIViewContentMode { get set }
    var frame: CGRect { get set }
    var center: CGPoint { get set }
    var isHidden: Bool { get set }
    var layer: CALayer { get }
    var layoutMargins: UIEdgeInsets { get set }
    var preservesSuperviewLayoutMargins: Bool { get set }
    func removeConstraints(_ constraints: [NSLayoutConstraint])
    var semanticContentAttribute: UISemanticContentAttribute { get set }
    var tag: Int { get set }
    
    func setContentCompressionResistancePriority(_ priority: UILayoutPriority, for axis: UILayoutConstraintAxis)
    func setContentHuggingPriority(_ priority: UILayoutPriority, for axis: UILayoutConstraintAxis)
    
    var tintColor: UIColor! { get set }
    var translatesAutoresizingMaskIntoConstraints: Bool { get set }
    var isUserInteractionEnabled: Bool { get set }
}

extension UIView: UIViewProtocol {}

public extension LensHolder where Object: UIViewProtocol {
    var alpha: Lens<Object, CGFloat> {
        return Lens(
            view: { view in view.alpha },
            set: { view, set in set.alpha = view; return set }
        )
    }
    var backgroundColor: Lens<Object, UIColor> {
        return Lens(
            view: { view in view.backgroundColor ?? .clear },
            set: { view, set in set.backgroundColor = view; return set }
        )
    }
    var clipsToBounds: Lens<Object, Bool> {
        return Lens(
            view: { view in view.clipsToBounds },
            set: { view, set in set.clipsToBounds = view; return set }
        )
    }
    var constraints: Lens<Object, [NSLayoutConstraint]> {
        return Lens(
            view: { view in view.constraints },
            set: { view, set in
                set.removeConstraints(set.constraints)
                set.addConstraints(view)
                return set }
        )
    }
    
    func contentCompressionResistancePriority(for axis: UILayoutConstraintAxis) -> Lens<Object, UILayoutPriority> {
        return Lens(
            view: { view in view.contentCompressionResistancePriority(for: axis) },
            set: { view, set in set.setContentCompressionResistancePriority(view, for: axis); return set }
        )
    }
    
    func contentHuggingPriority(for axis: UILayoutConstraintAxis) -> Lens<Object, UILayoutPriority> {
        return Lens(
            view: { view in view.contentHuggingPriority(for: axis) },
            set: { view, set in set.setContentHuggingPriority(view, for: axis); return set }
        )
    }
    
    var contentMode: Lens<Object, UIViewContentMode> {
        return Lens(
            view: { view in view.contentMode },
            set: { view, set in set.contentMode = view; return set }
        )
    }
    var frame: Lens<Object, CGRect> {
        return Lens(
            view: { view in view.frame },
            set: { view, set in set.frame = view; return set }
        )
    }
    
    var center: Lens<Object, CGPoint> {
        return Lens(
            view: { view in view.center },
            set: { view, set in set.center = view; return set }
        )
    }
    
    var isHidden: Lens<Object, Bool> {
        return Lens(
            view: { view in view.isHidden },
            set: { view, set in set.isHidden = view; return set }
        )
    }
    
    var layer: Lens<Object, CALayer> {
        return Lens(
            view: { view in view.layer },
            set: { $1 }
        )
    }
    
    var layoutMargins: Lens<Object, UIEdgeInsets> {
        return Lens(
            view: { view in view.layoutMargins },
            set: { view, set in set.layoutMargins = view; return set }
        )
    }
    
    var preservesSuperviewLayoutMargins: Lens<Object, Bool> {
        return Lens(
            view: { view in view.preservesSuperviewLayoutMargins },
            set: { view, set in set.preservesSuperviewLayoutMargins = view; return set }
        )
    }
    
    var semanticContentAttributes: Lens<Object, UISemanticContentAttribute> {
        return Lens(
            view: { view in view.semanticContentAttribute },
            set: { view, set in set.semanticContentAttribute = view; return set }
        )
    }
    
    var tag: Lens<Object, Int> {
        return Lens(
            view: { view in view.tag },
            set: { view, set in set.tag = view; return set }
        )
    }
    
    var tintColor: Lens<Object, UIColor> {
        return Lens(
            view: { view in view.tintColor },
            set: { view, set in set.tintColor = view; return set }
        )
    }
    
    var translatesAutoresizingMaskIntoConstraints: Lens<Object, Bool> {
        return Lens(
            view: { view in view.translatesAutoresizingMaskIntoConstraints },
            set: { view, set in set.translatesAutoresizingMaskIntoConstraints = view; return set }
        )
    }
    
    var isUserInteractionEnabled: Lens<Object, Bool> {
        return Lens(
            view: { view in view.isUserInteractionEnabled },
            set: { view, set in set.isUserInteractionEnabled = view; return set }
        )
    }
}


public extension Lens where Whole: UIViewProtocol, Part == CGRect {
    var origin: Lens<Whole, CGPoint> {
        return Whole.lens.frame..CGRect.lens.origin
    }
    var size: Lens<Whole, CGSize> {
        return Whole.lens.frame..CGRect.lens.size
    }
}

public extension Lens where Whole: UIViewProtocol, Part == CGPoint {
    var x: Lens<Whole, CGFloat> {
        return Whole.lens.frame.origin..CGPoint.lens.x
    }
    var y: Lens<Whole, CGFloat> {
        return Whole.lens.frame.origin..CGPoint.lens.y
    }
}

public extension Lens where Whole: UIViewProtocol, Part == CGSize {
    var width: Lens<Whole, CGFloat> {
        return Whole.lens.frame.size..CGSize.lens.width
    }
    var height: Lens<Whole, CGFloat> {
        return Whole.lens.frame.size..CGSize.lens.height
    }
}

public extension Lens where Whole: UIViewProtocol, Part == CALayer {
    var borderColor: Lens<Whole, CGColor?> {
        return Whole.lens.layer..Part.lens.borderColor
    }
    
    var borderWidth: Lens<Whole, CGFloat> {
        return Whole.lens.layer..Part.lens.borderWidth
    }
    
    var cornerRadius: Lens<Whole, CGFloat> {
        return Whole.lens.layer..Part.lens.cornerRadius
    }
    
    var masksToBounds: Lens<Whole, Bool> {
        return Whole.lens.layer..Part.lens.masksToBounds
    }
    
    var shadowColor: Lens<Whole, CGColor?> {
        return Whole.lens.layer..CALayer.lens.shadowColor
    }
    
    var shadowOffset: Lens<Whole, CGSize> {
        return Whole.lens.layer..CALayer.lens.shadowOffset
    }
    
    var shadowOpacity: Lens<Whole, Float> {
        return Whole.lens.layer..CALayer.lens.shadowOpacity
    }
    
    var shadowRadius: Lens<Whole, CGFloat> {
        return Whole.lens.layer..CALayer.lens.shadowRadius
    }
    
    var shouldRasterize: Lens<Whole, Bool> {
        return Whole.lens.layer..CALayer.lens.shouldRasterize
    }
}

