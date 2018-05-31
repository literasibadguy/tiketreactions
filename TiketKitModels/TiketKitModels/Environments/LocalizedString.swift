//
//  LocalizedString.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 21/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude

public func localizedString(key: String,
                            defaultValue: String = "",
                            count: Int? = nil,
                            substitutions: [String: String] = [:],
                            env: Environment = AppEnvironment.current,
                            bundle: NSBundleType = stringsBundle) -> String {
    
    let augmentedKey = count.flatMap { key + "." + keySuffixForCount($0) }.coalesceWith(key)
    
    let lprojName = lprojFileNameForLanguage(env.language)
    let localized = bundle.path(forResource: lprojName, ofType: "lproj")
        .flatMap(type(of: bundle).create(path:))
        .flatMap { $0.localizedString(forKey: augmentedKey, value: nil, table: nil) }
        .filter {
            $0.caseInsensitiveCompare(augmentedKey) != .orderedSame
    }
    .filter { !$0.isEmpty }
    .coalesceWith(defaultValue)
    
    return substitute(localized, with: substitutions)
}

private func lprojFileNameForLanguage(_ language: Language) -> String {
    return language.rawValue == "en" ? "Base" : language.rawValue
}

// Returns the pluralization suffix for a count.
private func keySuffixForCount(_ count: Int) -> String {
    switch count {
    case 0:
        return "zero"
    case 1:
        return "one"
    case 2:
        return "two"
    case 3...5:
        return "few"
    default:
        return "many"
    }
}

private func substitute(_ string: String, with substitutions: [String: String]) -> String {
    return substitutions.reduce(string) { accum, sub in
        return accum.replacingOccurrences(of: "%{\(sub.0)}", with: sub.1)
    }
}

private class Pin {}
public let stringsBundle = Bundle(for: Pin.self)
