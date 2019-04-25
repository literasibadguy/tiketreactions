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

private let phonePatter = "^[0-9０-９٠-٩۰-۹]{2}$|^[+＋]*(?:[-x\u{2010}-\u{2015}\u{2212}\u{30FC}\u{FF0D}-\u{FF0F} \u{00A0}\u{00AD}\u{200B}\u{2060}\u{3000}()\u{FF08}\u{FF09}\u{FF3B}\u{FF3D}.\\[\\]/~\u{2053}\u{223C}\u{FF5E}*]*[0-9\u{FF10}-\u{FF19}\u{0660}-\u{0669}\u{06F0}-\u{06F9}]){3,}[-x\u{2010}-\u{2015}\u{2212}\u{30FC}\u{FF0D}-\u{FF0F} \u{00A0}\u{00AD}\u{200B}\u{2060}\u{3000}()\u{FF08}\u{FF09}\u{FF3B}\u{FF3D}.\\[\\]/~\u{2053}\u{223C}\u{FF5E}*A-Za-z0-9\u{FF10}-\u{FF19}\u{0660}-\u{0669}\u{06F0}-\u{06F9}]*(?:(?:;ext=([0-9０-９٠-٩۰-۹]{1,7})|[  \\t,]*(?:e?xt(?:ensi(?:ó?|ó))?n?|ｅ?ｘｔｎ?|[,xｘX#＃~～;]|int|anexo|ｉｎｔ)[:\\.．]?[  \\t,-]*([0-9０-９٠-٩۰-۹]{1,7})#?|[- ]+([0-9０-９٠-٩۰-۹]{1,5})#)?$)?$"

public func isValidEmail(_ email: String) -> Bool {
    let regex = try? NSRegularExpression(pattern: pattern, options: [])
    
    let range = NSRange.init(location: 0, length: email.count)
    return regex?.firstMatch(in: email, options: [], range: range) != nil
}

public func isValidPhone(_ phone: String) -> Bool {
    let regex = try? NSRegularExpression(pattern: phonePatter, options: [])
    
    let range = NSRange.init(location: 0, length: phone.count)
    return regex?.firstMatch(in: phone, options: [], range: range) != nil
}

public func isValidPhone(_ phone: String, code: String) -> Bool {
//    let regex = try? NSRegularExpression(pattern: phonePatter, options: [])
    
    print("WHATS CURRENT CODE PHONE NUMBER: \(code)")
    
    let kitNumber = PhoneNumberKit()
    do {
        let _ = try kitNumber.parse(phone)
        return true
    } catch {
        return false
    }
}
