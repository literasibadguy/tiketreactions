//
//  AirportViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 28/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import TiketKitModels
import UIKit

class AirportViewCell: UITableViewCell, ValueCell {
    
    typealias Value = AirportResult
    
    @IBOutlet fileprivate weak var cityLabel: UILabel!
    @IBOutlet fileprivate weak var airportLabel: UILabel!
    @IBOutlet fileprivate weak var airportCodeLabel: UILabel!
    @IBOutlet fileprivate weak var airportSeparatorView: UIView!
    
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
    }
    
    func configureWith(value: AirportResult) {
        _ = self.airportLabel
            |> UILabel.lens.text .~ value.airportName
        
        _ = self.cityLabel
            |> UILabel.lens.text .~ value.locationName
        
        _ = self.airportCodeLabel
            |> UILabel.lens.text .~ value.airportCode
        
        _ = self.airportSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
}
