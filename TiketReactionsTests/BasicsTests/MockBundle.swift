//
//  MockBundle.swift
//  TiketComponentsTests
//
//  Created by Firas Rafislam on 07/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
@testable import TiketComponents
import Prelude

private let stores = [
    "Base": [
        "hello": "world",
        "hello_format": "hello %{a} %{b}",
        "placeholder_password": "password",
        "dates.just_now": "just now"
    ],
    "id": [
        "hello": "dunia",
        "hello_format": "halo %{a} %{b}",
        "placeholder_password": "Kata sandi",
        "dates.just_now": "Baru sekarang"
    ]
]

internal struct MockBundle: NSBundleType {
    
    internal let bundleIdentifier: String?
    fileprivate let store: [String: String]
    
    internal init(bundleIdentifier: String? = "com.bundle.mock", lang: String = "Base") {
        self.bundleIdentifier = bundleIdentifier
        self.store = stores[lang] ?? [:]
    }
    
    internal static func create(path: String) -> NSBundleType? {
        return MockBundle(lang: path)
    }
    
    func path(forResource name: String?, ofType ext: String?) -> String? {
        return name
    }
    
    func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        return self.store[key] ?? value ?? key
    }
    
    internal var infoDictionary: [String : Any]? {
        var result: [String: Any] = [:]
        result["CFBundleIdentifier"] = self.bundleIdentifier
        result["CFBundleVersion"] = "1234567890"
        result["CFBundleShortVersionString"] = "1.2.3.4.5.6.7.8.9.0"
        return result
    }
}
