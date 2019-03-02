//
//  UIAlertController.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 24/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import class UIKit.UIAlertController
import class UIKit.UIAlertAction

public extension UIAlertController {
    
    public static func alert(_ title: String? = nil, message: String? = nil, confirm: ((UIAlertAction) -> Void)? = nil, cancel: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Localizations.ConfirmyesTitle, style: .default, handler: confirm))
        alertController.addAction(UIAlertAction(title: Localizations.ConfirmnoTitle, style: .cancel, handler: cancel))
        
        return alertController
    }
    
    public static func genericError(_ title: String? = nil, message: String? = nil, cancel: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: cancel))
        
        return alertController
    }
    
}
