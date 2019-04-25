//
//  CustomStyledButton.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 29/11/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import UIKit


class CustomStyledButton: UIButton {
    
    enum CornerRadius {
        case square
        case pill
        case rounded
        
        func size(in frame: CGRect) -> CGFloat {
            switch self {
            case .square:
                return 0
            case .pill:
                return min(frame.height, frame.width / 2)
            case .rounded:
                return 5
            }
        }
    }
    
    struct Style {
        let highlightedBackgroundColor: UIColor?
        let unselectHighlightedBackgroundColor: UIColor?
        let selectedBackgroundColor: UIColor?
        let disabledBackgroundColor: UIColor?
        let backgroundColor: UIColor?
        
        let highlightedTitleColor: UIColor?
        let unselectHighlightedTitleColor: UIColor?
        let selectedTitleColor: UIColor?
        let disabledTitleColor: UIColor?
        let titleColor: UIColor?
        
        let highlightedBorderColor: UIColor?
        let unselectHighlightedBorderColor: UIColor?
        let selectedBorderColor: UIColor?
        let disabledBorderColor: UIColor?
        let borderColor: UIColor?
        
        let cornerRadius: CornerRadius
        let underline: Bool
        let font: UIFont
        
        init(
            backgroundColor: UIColor? = nil,
            highlightedBackgroundColor: UIColor? = nil,
            unselectHighlightedBackgroundColor: UIColor? = nil,
            selectedBackgroundColor: UIColor? = nil,
            disabledBackgroundColor: UIColor? = nil,
            
            titleColor: UIColor? = nil,
            highlightedTitleColor: UIColor? = nil,
            unselectHighlightedTitleColor: UIColor? = nil,
            selectedTitleColor: UIColor? = nil,
            disabledTitleColor: UIColor? = nil,
            
            borderColor: UIColor? = nil,
            highlightedBorderColor: UIColor? = nil,
            unselectHighlightedBorderColor: UIColor? = nil,
            selectedBorderColor: UIColor? = nil,
            disabledBorderColor: UIColor? = nil,
            
            font: UIFont? = nil,
            cornerRadius: CornerRadius = .square,
            underline: Bool = false
        ) {
            self.highlightedBackgroundColor = highlightedBackgroundColor
            self.unselectHighlightedBackgroundColor = unselectHighlightedBackgroundColor
            self.selectedBackgroundColor = selectedBackgroundColor
            self.disabledBackgroundColor = disabledBackgroundColor
            self.backgroundColor = backgroundColor
            
            self.highlightedTitleColor = highlightedTitleColor
            self.unselectHighlightedTitleColor = unselectHighlightedTitleColor
            self.selectedTitleColor = selectedTitleColor
            self.disabledTitleColor = disabledTitleColor
            self.titleColor = titleColor
            
            self.highlightedBorderColor = highlightedBorderColor
            self.unselectHighlightedBorderColor = unselectHighlightedBorderColor
            self.selectedBorderColor = selectedBorderColor
            self.disabledBorderColor = disabledBorderColor
            self.borderColor = borderColor
            
            self.cornerRadius = cornerRadius
            self.underline = underline
            if let font = font {
                self.font = font
            } else {
                self.font = UIFont.systemFont(ofSize: 12.0)
            }
        }
    }
    
    var didOverrideTitle = false
    var style: Style = .default {
        didSet { updateStyle() }
    }
    
    override var isEnabled: Bool {
        didSet { updateStyle() }
    }
    
    override var isHighlighted: Bool {
        didSet { updateStyle() }
    }
    
    override var isSelected: Bool {
        didSet { updateStyle() }
    }
    
    var title: String? {
        get { return currentTitle ?? currentAttributedTitle?.string }
        set { setTitle(newValue, for: .normal) }
    }
    
    var titleLineBreakMode: NSLineBreakMode = .byWordWrapping {
        didSet { updateStyle() }
    }
    
    var titleAlignment: NSTextAlignment = .center {
        didSet { updateStyle() }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.masksToBounds = true
        layer.cornerRadius = style.cornerRadius.size(in: frame)
    }
    
    func updateStyle() {
        let layerBorder: UIColor?
        if !isEnabled {
            backgroundColor = style.disabledBackgroundColor ?? style.backgroundColor
            layerBorder = style.disabledBorderColor ?? style.borderColor
        }
        else if isHighlighted && isSelected {
            backgroundColor = style.unselectHighlightedBackgroundColor ?? style.highlightedBackgroundColor
            layerBorder = style.unselectHighlightedBorderColor ?? style.highlightedBorderColor ?? style.borderColor
        }
        else if isHighlighted {
            backgroundColor = style.highlightedBackgroundColor ?? style.backgroundColor
            layerBorder = style.highlightedBorderColor ?? style.borderColor
        } else if isSelected {
            backgroundColor = style.selectedBackgroundColor ?? style.backgroundColor
            layerBorder = style.selectedBorderColor ?? style.borderColor
        } else {
            backgroundColor = style.backgroundColor
            layerBorder = style.borderColor
        }
        
        if let layerBorder = layerBorder {
            layer.borderColor = layerBorder.cgColor
            layer.borderWidth = 1
        } else {
            layer.borderColor = nil
            layer.borderWidth = 0
        }
        
        if !didOverrideTitle {
            titleLabel?.font = style.font
            
            if let defaultTitle = self.title(for: .normal) {
                let states: [UIControl.State] = [.normal, .highlighted, .selected, .disabled]
                for state in states {
                    let title = self.title(for: state) ?? defaultTitle
                    self.setAttributedTitle(NSAttributedString(button: title, style: style, state: state, selected: isSelected, alignment: titleAlignment, lineBreakMode: titleLineBreakMode), for: state)
                    
                }
            }
        }
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        sharedSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedSetup()
    }
    
    convenience init(style: Style) {
        self.init()
        self.style = style
        updateStyle()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if buttonType != .custom {
            print("Warning, StyledButton instance '\(String(describing: currentTitle))' should be configured as 'Custom', not \(buttonType)")
        }
    }
    
    func sharedSetup() {
        titleLabel?.numberOfLines = 1
        updateStyle()
    }
}

extension CustomStyledButton {
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        updateStyle()
    }
    
    override func setAttributedTitle(_ title: NSAttributedString?, for state: UIControl.State) {
        super.setAttributedTitle(title, for: state)
        didOverrideTitle = title != nil
        updateStyle()
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        var titleRect = super.titleRect(forContentRect: contentRect)
        let delta: CGFloat = 4
        titleRect.size.height += 2 * delta
        titleRect.origin.y -= delta
        return titleRect
    }
}

extension CustomStyledButton.Style {
    static let `default` = CustomStyledButton.Style(backgroundColor: .black, disabledBackgroundColor: .black, titleColor: .white, disabledTitleColor: .tk_typo_green_grey_500)
}
