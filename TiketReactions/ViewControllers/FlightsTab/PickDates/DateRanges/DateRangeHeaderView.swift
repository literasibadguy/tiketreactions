//
//  DateRangeHeaderView.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 23/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit

public final class DateRangeHeaderView: UICollectionReusableView {
    var label: UILabel!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initLabel()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initLabel()
    }
    
    private func initLabel() {
        label = UILabel(frame: frame)
        label.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.textColor = UIColor.darkGray
        label.textAlignment = NSTextAlignment.left
        self.addSubview(label)
    }
    
}
