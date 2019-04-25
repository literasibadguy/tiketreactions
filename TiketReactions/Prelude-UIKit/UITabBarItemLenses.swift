//
//  UITabBarItemLenses.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 08/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit

public protocol UITabBarItemProtocol: UIBarItemProtocol {
    var selectedImage: UIImage? { get set }
    var titlePositionAdjustment: UIOffset { get set }
}

extension UITabBarItem: UITabBarItemProtocol {}

public extension LensHolder where Object: UITabBarItemProtocol {
    var selectedImage: Lens<Object, UIImage?> {
        return Lens(
            view: { $0.selectedImage },
            set: { $1.selectedImage = $0; return $1 }
        )
    }
    
    var titlePositionAdjustment: Lens<Object, UIOffset> {
        return Lens(
            view: { $0.titlePositionAdjustment },
            set: { $1.titlePositionAdjustment = $0; return $1 }
        )
    }
}
