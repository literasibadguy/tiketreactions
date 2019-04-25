//
//  NSAttributedStringExtensions.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 30/11/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    convenience init(_ string: String, color: UIColor = .black, underlineStyle: NSUnderlineStyle? = nil, font: UIFont = .systemFont(ofSize: 12.0), alignment: NSTextAlignment = .left, lineBreakMode: NSLineBreakMode? = nil) {
        let paragraphStyle = NSMutableParagraphStyle()
        if lineBreakMode != .byTruncatingTail {
            paragraphStyle.lineSpacing = 6
        }
        paragraphStyle.alignment = alignment
        if let lineBreakMode = lineBreakMode {
            paragraphStyle.lineBreakMode = lineBreakMode
        }
        let underlineValue = underlineStyle?.rawValue ?? 0
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: font,
            .paragraphStyle: paragraphStyle,
            .underlineStyle: underlineValue,
        ]
        self.init(string: string, attributes: attrs)
    }
    
    convenience init(button string: String, style: CustomStyledButton.Style, state: UIControl.State = .normal, selected: Bool = false, alignment: NSTextAlignment = .center, lineBreakMode: NSLineBreakMode? = nil) {
        let stateColor: UIColor?
        if state == .disabled {
            stateColor = style.disabledTitleColor
        }
        else if state == .highlighted && selected {
            stateColor = style.unselectHighlightedTitleColor ?? style.highlightedTitleColor
        }
        else if state == .highlighted {
            stateColor = style.highlightedTitleColor
        }
        else if state == .selected {
            stateColor = style.selectedTitleColor
        }
        else {
            stateColor = style.titleColor
        }
        
        let color = stateColor ?? style.titleColor ?? .black
        self.init(string, color: color, underlineStyle: style.underline ? .single : .none, font: style.font, alignment: alignment, lineBreakMode: lineBreakMode)
    }
}

func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let retval = NSMutableAttributedString(attributedString: left)
    retval.append(right)
    return NSAttributedString(attributedString: retval)
}
