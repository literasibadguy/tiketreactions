//
//  CGPointLenses.swift
//  TiketSignal
//
//  Created by Firas Rafislam on 12/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit

extension CGPoint {
    public enum lens {
        public static let x = Lens<CGPoint, CGFloat>(
            view: { view in view.x },
            set: { view, set in .init(x: view, y: set.y) }
        )
        
        public static let y = Lens<CGPoint, CGFloat>(
            view: { view in view.x },
            set: { view, set in .init(x: view, y: set.y) }
        )
    }
}
