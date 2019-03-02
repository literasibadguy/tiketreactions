//
//  HotelPhotoViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 11/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import TiketKitModels
import UIKit

class HotelPhotoViewCell: UICollectionViewCell, ValueCell {
    
    typealias Value = HotelDirect.Photo
    
    @IBOutlet fileprivate weak var hotelPhotoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureWith(value: HotelDirect.Photo) {
        if let someURL = URL(string: value.fileName.replacingOccurrences(of: ".s", with: ".l")) {
            print("Whats Hotel Direct Here: \(value.fileName)")
            self.hotelPhotoImageView.ck_setImageWithURL(someURL)
        } else {
            self.hotelPhotoImageView.af_cancelImageRequest()
            self.hotelPhotoImageView.image = nil
        }
    }
}
