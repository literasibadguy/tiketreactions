//
//  AirportViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 28/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit

class AirportViewCell: UITableViewCell, ValueCell {
    
    typealias Value = String
    
    @IBOutlet fileprivate weak var cityLabel: UILabel!
    @IBOutlet fileprivate weak var airportLabel: UILabel!
    @IBOutlet fileprivate weak var airportCodeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(value: String) {
        self.airportLabel?.text = value
    }
    
}
