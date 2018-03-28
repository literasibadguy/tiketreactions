//
//  CGRectLenses.swift
//  TiketSignal
//
//  Created by Firas Rafislam on 12/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit

extension CGRect {
    public static let unit = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
    
    public enum lens {
        public static let origin = Lens<CGRect, CGPoint>(
            view: { view in view.origin },
            set: { view, set in .init(origin: view, size: set.size) }
        )
        
        public static let size = Lens<CGRect, CGSize>(
            view: { view in view.size },
            set: { view, set in .init(origin: set.origin, size: view) }
        )
    }
}

private let _x = CGRect.lens.origin..CGPoint.lens.x
private let _y = CGRect.lens.origin..CGPoint.lens.y

extension Lens where Whole == CGRect, Part == CGPoint {
    
    public var x: Lens<CGRect, CGFloat> {
        return _x
    }
    
    public var y: Lens<CGRect, CGFloat> {
        return _y
    }
}

private let _width = CGRect.lens.size..CGSize.lens.width
private let _height = CGRect.lens.size..CGSize.lens.height

extension Lens where Whole == CGRect, Part == CGSize {
    public var width: Lens<CGRect, CGFloat> {
        return _width
    }
    
    public var height: Lens<CGRect, CGFloat> {
        return _height
    }
}



