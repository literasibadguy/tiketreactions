//
//  UIImageView+URL.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 07/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import AlamofireImage
import UIKit

extension UIImageView {
    
    public func ck_setImageWithURL(_ url: URL) {
        self.af_setImage(withURL: url, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: false            , completion: nil)
    }
}
