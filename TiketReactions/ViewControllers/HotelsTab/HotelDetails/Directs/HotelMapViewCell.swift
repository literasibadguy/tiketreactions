//
//  HotelMapViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 18/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import GoogleMaps
import Prelude
import TiketKitModels
import UIKit

class HotelMapViewCell: UITableViewCell, ValueCell {
    
    typealias Value = HotelResult
    fileprivate let regionRadius: CLLocationDistance = 100
    
    @IBOutlet fileprivate weak var mapContainerView: UIView!
    
    @IBOutlet fileprivate weak var mapContentView: GMSMapView!
    
    @IBOutlet fileprivate weak var titleAddressLabel: UILabel!
    @IBOutlet fileprivate weak var addressLabel: UILabel!
    
    @IBOutlet fileprivate weak var mapSeparatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self.titleAddressLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
            |> UILabel.lens.text .~ Localizations.AddressHotelTitle
        
        _ = self.addressLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.mapSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    func configureWith(value: HotelResult) {
        
        let camera = GMSCameraPosition.camera(withLatitude: value.latitude, longitude: value.longitude, zoom: 16)
        self.mapContentView.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: value.latitude, longitude: value.longitude)
        marker.map = self.mapContentView
        
        self.mapContentView.isUserInteractionEnabled = false
        
        _ = self.addressLabel
            |> UILabel.lens.text .~ value.metadataHotel.address
    }
}
