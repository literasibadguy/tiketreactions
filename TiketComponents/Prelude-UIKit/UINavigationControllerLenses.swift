//
//  UINavigationControllerLenses.swift
//  TiketSignal
//
//  Created by Firas Rafislam on 16/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit

public protocol UINavigationControllerProtocol: UIViewControllerProtocol {
    var navigationBar: UINavigationBar { get }
    var isNavigationBarHidden: Bool { get set }
    func setNavigationBarHidden(_ hidden: Bool, animated: Bool)
    var viewControllers: [UIViewController] { get set }
}

extension UINavigationController: UINavigationControllerProtocol {}

public extension LensHolder where Object: UINavigationControllerProtocol {
    public var navigationBar: Lens<Object, UINavigationBar> {
        return Lens(
            view: { view in view.navigationBar },
            set: { $1 }
        )
    }
    
    public var navigationBarHidden: Lens<Object, Bool> {
        return Lens(
            view: { view in view.isNavigationBarHidden },
            set: { view, set in set.isNavigationBarHidden = view; return set }
        )
    }
    
    public func setNavigationBarHidden(animated: Bool) -> Lens<Object, Bool> {
        return Lens(
            view: { view in view.isNavigationBarHidden },
            set: { view, set in set.setNavigationBarHidden(view, animated: animated); return set }
        )
    }
    
    public var viewControllers: Lens<Object, [UIViewController]> {
        return Lens(
            view: { view in view.viewControllers },
            set: { view, set in set.viewControllers = view; return set }
        )
    }
}
