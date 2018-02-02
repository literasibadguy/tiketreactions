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
    public var alpha: Lens<Object, CGFloat> {
        return Lens(
            view: { view in view.alpha },
            set: { view, set in set.alpha = view; return set }
        )
    }
    public var backgroundColor: Lens<Object, UIColor> {
        return Lens(
            view: { view in view.backgroundColor ?? .clear },
            set: { view, set in set.backgroundColor = view; return set }
        )
    }
    public var clipsToBounds: Lens<Object, Bool> {
        return Lens(
            view: { view in view.clipsToBounds },
            set: { view, set in set.clipsToBounds = view; return set }
        )
    }
    public var constraints: Lens<Object, [NSLayoutConstraint]> {
        return Lens(
            view: { view in view.constraints },
            set: { view, set in
                set.removeConstraints(set.constraints)
                set.addConstraints(view)
                return set }
        )
    }
    
    public func contentCompressionResistancePriority(for axis: UILayoutConstraintAxis) -> Lens<Object, UILayoutPriority> {
        return Lens(
            view: { view in view.contentCompressionResistancePriority(for: axis) },
            set: { view, set in set.setContentCompressionResistancePriority(view, for: axis); return set }
        )
    }
    
    public func contentHuggingPriority(for axis: UILayoutConstraintAxis) -> Lens<Object, UILayoutPriority> {
        return Lens(
            view: { view in view.contentHuggingPriority(for: axis) },
            set: { view, set in set.setContentHuggingPriority(view, for: axis); return set }
        )
    }
    
    public var contentMode: Lens<Object, UIViewContentMode> {
        return Lens(
            view: { view in view.contentMode },
            set: { view, set in set.contentMode = view; return set }
        )
    }
    public var frame: Lens<Object, CGRect> {
        return Lens(
            view: { view in view.frame },
            set: { view, set in set.frame = view; return set }
        )
    }
    
    public var isHidden: Lens<Object, Bool> {
        return Lens(
            view: { view in view.isHidden },
            set: { view, set in set.isHidden = view; return set }
        )
    }
    
    public var layer: Lens<Object, CALayer> {
        return Lens(
            view: { view in view.layer },
            set: { $1 }
        )
    }
    
    public var layoutMargins: Lens<Object, UIEdgeInsets> {
        return Lens(
            view: { view in view.layoutMargins },
            set: { view, set in set.layoutMargins = view; return set }
        )
    }
    
    public var preservesSuperviewLayoutMargins: Lens<Object, Bool> {
        return Lens(
            view: { view in view.preservesSuperviewLayoutMargins },
            set: { view, set in set.preservesSuperviewLayoutMargins = view; return set }
        )
    }
    
    public var semanticContentAttributes: Lens<Object, UISemanticContentAttribute> {
        return Lens(
            view: { view in view.semanticContentAttribute },
            set: { view, set in set.semanticContentAttribute = view; return set }
        )
    }
    
    public var tag: Lens<Object, Int> {
        return Lens(
            view: { view in view.tag },
            set: { view, set in set.tag = view; return set }
        )
    }
    
    public var tintColor: Lens<Object, UIColor> {
        return Lens(
            view: { view in view.tintColor },
            set: { view, set in set.tintColor = view; return set }
        )
    }
    
    public var translatesAutoresizingMaskIntoConstraints: Lens<Object, Bool> {
        return Lens(
            view: { view in view.translatesAutoresizingMaskIntoConstraints },
            set: { view, set in set.translatesAutoresizingMaskIntoConstraints = view; return set }
        )
    }
    
    public var isUserInteractionEnabled: Lens<Object, Bool> {
        return Lens(
            view: { view in view.isUserInteractionEnabled },
            set: { view, set in set.isUserInteractionEnabled = view; return set }
        )
    }
}


public extension Lens where Whole: UIViewProtocol, Part == CGRect {
    public var origin: Lens<Whole, CGPoint> {
        return Whole.lens.frame..CGRect.lens.origin
    }
    public var size: Lens<Whole, CGSize> {
        return Whole.lens.frame..CGRect.lens.size
    }
}

public extension Lens where Whole: UIViewProtocol, Part == CGPoint {
    public var x: Lens<Whole, CGFloat> {
        return Whole.lens.frame.origin..CGPoint.lens.x
    }
    public var y: Lens<Whole, CGFloat> {
        return Whole.lens.frame.origin..CGPoint.lens.y
    }
}

public extension Lens where Whole: UIViewProtocol, Part == CGSize {
    public var width: Lens<Whole, CGFloat> {
        return Whole.lens.frame.size..CGSize.lens.width
    }
    public var height: Lens<Whole, CGFloat> {
        return Whole.lens.frame.size..CGSize.lens.height
    }
}

public extension Lens where Whole: UIViewProtocol, Part == CALayer {
    public var borderColor: Lens<Whole, CGColor?> {
        return Whole.lens.layer..Part.lens.borderColor
    }
    
    public var borderWidth: Lens<Whole, CGFloat> {
        return Whole.lens.layer..Part.lens.borderWidth
    }
    
    public var cornerRadius: Lens<Whole, CGFloat> {
        return Whole.lens.layer..Part.lens.cornerRadius
    }
    
    public var masksToBounds: Lens<Whole, Bool> {
        return Whole.lens.layer..Part.lens.masksToBounds
    }
    
    public var shadowColor: Lens<Whole, CGColor?> {
        return Whole.lens.layer..CALayer.lens.shadowColor
    }
    
    public var shadowOffset: Lens<Whole, CGSize> {
        return Whole.lens.layer..CALayer.lens.shadowOffset
    }
    
    public var shadowOpacity: Lens<Whole, Float> {
        return Whole.lens.layer..CALayer.lens.shadowOpacity
    }
    
    public var shadowRadius: Lens<Whole, CGFloat> {
        return Whole.lens.layer..CALayer.lens.shadowRadius
    }
    
    public var shouldRasterize: Lens<Whole, Bool> {
        return Whole.lens.layer..CALayer.lens.shouldRasterize
    }
}

