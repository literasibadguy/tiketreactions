//
//  IsValidEmail.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 19/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import PhoneNumberKit

private let pattern = "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}\\@" +
    "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\." +
"[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+"

private let phonePatter = "^((\\+)|(00))[0-9]{6,14}$"

public func isValidEmail(_ email: String) -> Bool {
    let regex = try? NSRegularExpression(pattern: pattern, options: [])
    
    let range = NSRange.init(location: 0, length: email.count)
    return regex?.firstMatch(in: email, options: [], range: range) != nil
}


public func isValidPhone(_ phone: String, code: String) -> Bool {
//    let regex = try? NSRegularExpression(pattern: phonePatter, options: [])
    
    print("WHATS CURRENT CODE PHONE NUMBER: \(code)")
    
    let kitNumber = PhoneNumberKit()
    do {
        let _ = try kitNumber.parse(phone, withRegion: code)
        return true
    } catch {
        return false
    }
}
