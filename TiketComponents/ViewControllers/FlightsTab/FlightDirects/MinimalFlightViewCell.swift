//
//  MinimalFlightViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 30/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit

class MinimalFlightViewCell: UITableViewCell, ValueCell {

    typealias Value = String
    
    @IBOutlet fileprivate weak var airlineImageView: UIImageView!
    @IBOutlet fileprivate weak var airlineNameLabel: UILabel!
    @IBOutlet fileprivate weak var statusFlightLabel: UILabel!
    
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
