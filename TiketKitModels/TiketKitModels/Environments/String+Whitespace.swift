//
//  String+Whitespace.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 25/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation

extension String {
    
    public static let nbsp = " "
    
    public func nonBreakingSpaced() -> String {
        return self.replacingOccurrences(of: " ", with: "\u{00a0}")
    }
    
    public func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

public func isWhitespacesAndNewlines(_ s: String) -> Bool {
    return s.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
}
