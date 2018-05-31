//
//  MinimalFlightViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 30/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import TiketKitModels
import UIKit

class MinimalFlightViewCell: UITableViewCell, ValueCell {

    typealias Value = Flight
    
    @IBOutlet fileprivate weak var minimalFlightStackView: UIStackView!
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
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self.minimalFlightStackView
            |> UIStackView.lens.layoutMargins .~ .init(top: Styles.grid(2), left: Styles.grid(2), bottom: Styles.grid(0), right: Styles.grid(2))
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
            |> UIStackView.lens.spacing .~ Styles.grid(2)
    }

    func configureWith(value: Flight) {
        _ = self.airlineImageView.ck_setImageWithURL(URL(string: value.inner.image)!)
        _ = self.airlineNameLabel
            |> UILabel.lens.text .~ value.airlinesName
        _ = self.statusFlightLabel
            |> UILabel.lens.text .~ value.timestamp
    }
    
}
