//
//  NSHTTPCookieStorageType.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 07/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation

public protocol HTTPCookieStorageProtocol {
    var cookies: [HTTPCookie]? { get }
    func deleteCookie(_ cookie: HTTPCookie)
    func setCookie(_ cookie: HTTPCookie)
}

extension HTTPCookieStorage: HTTPCookieStorageProtocol {
    
}

internal final class MockCookieStorage: HTTPCookieStorageProtocol {
    fileprivate var storage: Set<HTTPCookie> = []
    
    internal var cookies: [HTTPCookie]? {
        return Array(self.storage)
    }
    
    internal func deleteCookie(_ cookie: HTTPCookie) {
        if let idx = self.storage.index(of: cookie) {
            self.storage.remove(at: idx)
        }
    }
    
    internal func setCookie(_ cookie: HTTPCookie) {
        self.storage.insert(cookie)
    }
}
