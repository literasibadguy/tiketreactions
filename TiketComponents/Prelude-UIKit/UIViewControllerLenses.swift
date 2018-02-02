//
//  UIViewControllerLenses.swift
//  TiketSignal
//
//  Created by Firas Rafislam on 12/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit

public protocol UIViewControllerProtocol: UITraitEnvironmentProtocol, LensObject {
    var navigationController: UINavigationController? { get }
    var navigationItem: UINavigationItem { get }
    var title: String? { get set }
    var view: UIView! { get set }
}

extension UIViewController: UIViewControllerProtocol {}

public extension LensHolder where Object: UIViewControllerProtocol {

    public var navigationController: Lens<Object, UINavigationController?> {
        return Lens(view: { navVC in navVC.navigationController }, set: { $1 })
    }
    
    public var navigationItem: Lens<Object, UINavigationItem> {
        return Lens(view: { navVC in navVC.navigationItem }, set: { $1 })
    }
    
    public var title: Lens<Object, String?> {
        return Lens(view: { navVC in navVC.title }, set: { all, setTitle in setTitle.title = all; return setTitle })
    }
    
    public var view: Lens<Object, UIView> {
        return Lens(view: { navVC in navVC.view! }, set: { all, setView in setView.view = all; return setView })
    }
}

extension Lens where Whole: UIViewControllerProtocol, Part == UIView {
    public var backgroundColor: Lens<Whole, UIColor> {
        return Whole.lens.view..Part.lens.backgroundColor
    }
    
    public var layoutMargins: Lens<Whole, UIEdgeInsets> {
        return Whole.lens.view..Part.lens.layoutMargins
    }
    
    public var tintColor: Lens<Whole, UIColor> {
        return Whole.lens.view..Part.lens.tintColor
    }
}
