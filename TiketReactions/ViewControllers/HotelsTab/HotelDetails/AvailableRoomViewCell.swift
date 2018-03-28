 //
//  AvailableRoomViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 08/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Spring
import TiketAPIs
import UIKit

 class AvailableRoomViewCell: UITableViewCell, ValueCell {
    
    typealias Value = AvailableRoom
    
    @IBOutlet fileprivate weak var roomTypeLabel: UILabel!
    @IBOutlet fileprivate weak var roomPriceLabel: UILabel!
    @IBOutlet fileprivate weak var roomDescriptionLabel: UILabel!
    @IBOutlet weak var roomPhotoImageView: DesignableImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(value: AvailableRoom) {
        self.roomPhotoImageView.image = imageFromURL(value.photoUrl)
        self.roomTypeLabel.text = value.roomName
        
        let endIndex = value.price.index(value.price.endIndex, offsetBy: -3)
        var summarizedPrice = String(value.price[..<endIndex])
        
        self.roomPriceLabel.text = "IDR \(summarizedPrice)"
        self.roomDescriptionLabel.text = "Room Available: \(value.roomAvailable)"
    }
}
