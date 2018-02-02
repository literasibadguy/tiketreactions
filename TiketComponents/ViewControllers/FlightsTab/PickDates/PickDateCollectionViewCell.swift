//
//  PickDateCollectionViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 29/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import UIKit

class PickDateCollectionViewCell: UICollectionViewCell, ValueCell {
    
    typealias Value = Date
    
    var selectedView: UIView?
    var halfBackgroundView: UIView?
    var roundHighlightView: UIView?
    
    var dateLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        dateLabel = UILabel(frame: frame)
        dateLabel.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        dateLabel.font = UIFont.systemFont(ofSize: 15.0)
        dateLabel.textColor = UIColor.darkGray
        dateLabel.textAlignment = NSTextAlignment.center
        self.addSubview(dateLabel)
    }
    
    func configureWith(value: Date) {
        
    }
}

extension PickDateCollectionViewCell {
    
    
}
