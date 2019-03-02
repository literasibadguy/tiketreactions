//
//  OrderListEmptyStateCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 06/11/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit

internal final class IssuedListEmptyStateCell: UITableViewCell, ValueCell {

    
    @IBOutlet private weak var summaryEmptyStateCell: UILabel!
    
    typealias Value = String
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureWith(value: String) {
        
    }
    
    
}
