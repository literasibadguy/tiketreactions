//
//  OptionsToggleButton.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 26/11/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class OptionsToggleButton: CustomStyledButton {
    override var intrinsicContentSize: CGSize {
        guard title == "Yes" || title == "No" else {
            var superSize = super.intrinsicContentSize
            if superSize.width != UIViewNoIntrinsicMetric {
                superSize.width += 20
            }
            return superSize
        }
        return CGSize(width: 50, height: 30)
    }
    
    override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle(title, for: state)
        invalidateIntrinsicContentSize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("Toggle Button Awake from Nib")
        self.setTitle("Yes", for: .selected)
        self.setTitle("No", for: .normal)
        self.style = CustomStyledButton.Style(backgroundColor: .tk_base_grey_100, selectedBackgroundColor: .tk_official_green, titleColor: .white, selectedTitleColor: .white, cornerRadius: .pill)
    }
    
    convenience init() {
        self.init(frame: .zero)
        print("Convenience Init Toggle Button")
        self.setTitle("Yes", for: .selected)
        self.setTitle("No", for: .normal)
    }
    
    override func updateStyle() {
        super.updateStyle()
        self.alpha = isEnabled ? 1 : 0.5
    }
}
