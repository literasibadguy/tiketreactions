//
//  BannerPagerViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 08/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit
import FSPagerView
import Spring

public final class BannerPagerViewCell: FSPagerViewCell, ValueCell {
    
    public typealias Value = String
    
    @IBOutlet fileprivate weak var bannerImageView: UIImageView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configureWith(value: String) {
        self.bannerImageView.image = UIImage(named: value)
    }
    
}
