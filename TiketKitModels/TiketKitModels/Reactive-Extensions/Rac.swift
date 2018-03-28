//
//  Rac.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 13/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit

public struct Rac<Object: RacObject> {
    public let object: Object
}

public protocol RacObject {}


public extension RacObject {
    typealias Object = Self
    
    public var rac: Rac<Object> {
        return Rac(object: self)
    }
}

extension NSObject: RacObject {}
