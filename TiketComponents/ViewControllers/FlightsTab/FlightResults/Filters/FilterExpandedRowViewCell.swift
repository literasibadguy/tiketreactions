//
//  FilterExpandedRowViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 31/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit

class FilterExpandedRowViewCell: UITableViewCell, ValueCell {
    
    
    typealias Value = String
    
    @IBOutlet fileprivate weak var filterValueTitleLabel: UILabel!
    @IBOutlet fileprivate weak var checkmarkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(value: String) {
        
    }
}
