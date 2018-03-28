//
//  XCTestCase+Async.swift
//  TiketComponentsTests
//
//  Created by Firas Rafislam on 10/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import XCTest

extension XCTestCase {
    internal func async(expect description: String = "async", timeout: Double = 4, block: @escaping (() -> Void) -> Void) {
        let expectation = self.expectation(description: description)
        DispatchQueue.main.async {
            block(expectation.fulfill)
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    internal func eventually( _ assertion: @autoclosure @escaping () -> Void) {
        async { done in
           assertion()
           done()
        }
    }
}
