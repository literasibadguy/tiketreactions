//
//  UITableViewCellLenses.swift
//  TiketSignal
//
//  Created by Firas Rafislam on 12/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit

public protocol UITableViewCellProtocol: UIViewProtocol {
    var contentView: UIView { get }
    var selectionStyle: UITableViewCellSelectionStyle { get set }
}

extension UITableViewCell: UITableViewCellProtocol {}

public extension LensHolder where Object: UITableViewCellProtocol {
    public var contentView: Lens<Object, UIView> {
        return Lens(
            view: { view in view.contentView },
            set: { return $1 }
        )
    }
    
    public var selectionStyle: Lens<Object, UITableViewCellSelectionStyle> {
        return Lens(
            view: { view in view.selectionStyle },
            set: { view, set in set.selectionStyle = view; return set }
        )
    }
}

extension Lens where Whole: UITableViewCellProtocol, Part == UIView {
    public var layoutMargins: Lens<Whole, UIEdgeInsets> {
        return Whole.lens.contentView..Part.lens.layoutMargins
    }
}
