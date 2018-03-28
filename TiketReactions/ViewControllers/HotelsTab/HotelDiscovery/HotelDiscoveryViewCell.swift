//
//  HotelDiscoveryViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 10/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Spring
import TiketAPIs
import UIKit

class HotelDiscoveryViewCell: UITableViewCell, ValueCell {
    typealias Value = HotelResult
    
    @IBOutlet fileprivate weak var primaryPhotoImageView: DesignableImageView!
    @IBOutlet fileprivate weak var cityLabel: UILabel!
    @IBOutlet fileprivate weak var businessNameLabel: UILabel!
    @IBOutlet fileprivate weak var priceValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configureWith(value: HotelResult) {
        self.cityLabel.text = value.provinceName
        self.businessNameLabel.text = value.name
        self.priceValueLabel.text = value.metadataHotel.totalPrice
    }
    
}
