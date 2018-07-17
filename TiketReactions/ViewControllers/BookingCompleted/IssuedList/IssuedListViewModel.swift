//
//  IssuedListViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 27/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result

public protocol IssuedListViewModelInputs {
    func viewDidLoad()
}

public protocol IssuedListViewModelOutputs {
    
}


public protocol IssuedListViewModelType {
    var inputs: IssuedListViewModelInputs { get }
    var outputs: IssuedListViewModelOutputs { get }
}

public final class IssuedListViewModel: IssuedListViewModelType, IssuedListViewModelInputs, IssuedListViewModelOutputs {
    
    public init() {
        
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public var inputs: IssuedListViewModelInputs { return self }
    public var outputs: IssuedListViewModelOutputs { return self }
    
}

