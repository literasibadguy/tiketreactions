//
//  FlightResultViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 30/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit

class FlightResultViewCell: UITableViewCell, ValueCell {
    
    typealias Value = String
    
    
    @IBOutlet fileprivate weak var flightImageView: UIImageView!
    @IBOutlet fileprivate weak var flightNameLabel: UILabel!
    @IBOutlet fileprivate weak var flightPriceLabel: UILabel!
    
    @IBOutlet fileprivate weak var departureCodeLabel: UILabel!
    @IBOutlet fileprivate weak var departureTimeLabel: UILabel!
    
    @IBOutlet fileprivate weak var shortGreenArrow: UIImageView!
    
    @IBOutlet fileprivate weak var arrivalCodeLabel: UILabel!
    
    @IBOutlet fileprivate weak var arrivalTimeLabel: UILabel!
    
    
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
