//
//  UIButton.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 10/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit

extension UIButton {
    
    public func setBackgroundColor(_ backgroundColor: UIColor, forState state: UIControl.State) {
        self.setBackgroundImage(.pixel(ofColor: backgroundColor), for: state)
    }
}
