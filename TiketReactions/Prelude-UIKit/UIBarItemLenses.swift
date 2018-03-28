//
//  UIBarItemLenses.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 08/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit

public protocol UIBarItemProtocol: CKObjectProtocol {
    var isEnabled: Bool { get set }
    var title: String? { get set }
    var image: UIImage? { get set }
    var imageInsets: UIEdgeInsets { get set }
    var landscapeImagePhone: UIImage? { get set }
    var landscapeImagePhoneInsets: UIEdgeInsets { get set }
    var tag: Int { get set }
}

extension UIBarItem: UIBarItemProtocol {}

public extension LensHolder where Object: UIBarItemProtocol {
    public var enabled: Lens<Object, Bool> {
        return Lens(
            view: { $0.isEnabled },
            set: { $1.isEnabled = $0; return $1 }
        )
    }
    
    public var title: Lens<Object, String?> {
        return Lens(
            view: { $0.title },
            set: { $1.title = $0; return $1 }
        )
    }
    
    public var image: Lens<Object, UIImage?> {
        return Lens(
            view: { $0.image },
            set: { $1.image = $0; return $1 }
        )
    }
    
    public var imageInsets: Lens<Object, UIEdgeInsets> {
        return Lens(
            view: { $0.imageInsets },
            set: { $1.imageInsets = $0; return $1 }
        )
    }
    
    public var landscapeImagePhone: Lens<Object, UIImage?> {
        return Lens(
            view: { $0.landscapeImagePhone },
            set: { $1.landscapeImagePhone = $0; return $1 }
        )
    }
    
    public var landscapeImagePhoneInsets: Lens<Object, UIEdgeInsets> {
        return Lens(
            view: { $0.landscapeImagePhoneInsets },
            set: { $1.landscapeImagePhoneInsets = $0; return $1 }
        )
    }
    
    public var tag: Lens<Object, Int> {
        return Lens(
            view: { $0.tag },
            set: { $1.tag = $0; return $1 }
        )
    }
}
