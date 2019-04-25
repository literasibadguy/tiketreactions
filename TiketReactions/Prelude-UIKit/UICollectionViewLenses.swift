//
//  UICollectionViewLenses.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 23/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit

public protocol UICollectionViewProtocol: UIViewProtocol {
    var contentInset: UIEdgeInsets { get set }
}


extension UICollectionView: UICollectionViewProtocol {}


public extension LensHolder where Object: UICollectionViewProtocol {
    var contentInset: Lens<Object, UIEdgeInsets> {
        return Lens(
            view: { $0.contentInset },
            set: { $1.contentInset = $0; return $1 }
        )
    }
}
