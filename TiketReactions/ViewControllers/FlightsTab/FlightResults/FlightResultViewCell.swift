//
//  FlightResultViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 30/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import TiketKitModels
import UIKit

class FlightResultViewCell: UITableViewCell, ValueCell {
    
    typealias Value = Flight
    
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
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self.flightPriceLabel
            |> UILabel.lens.font .~ .systemFont(ofSize: 14.0)
        
    }
    
    func configureWith(value: Flight) {
        _ = self.flightNameLabel
            |> UILabel.lens.text .~ value.flightNumber
        _ = self.flightPriceLabel
            |> UILabel.lens.text .~ value.priceValue
        _ = self.departureCodeLabel
            |> UILabel.lens.text .~ value.departureCity
        _ = self.departureTimeLabel
            |> UILabel.lens.text .~ value.flightDetail.simpleDepartureTime
    }
    
}
