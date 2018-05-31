//
//  FlightDirectViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 26/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import TiketKitModels
import UIKit

class FlightDirectViewCell: UITableViewCell, ValueCell {
    
    typealias Value = Flight
    
    // STACK MAINTAINED
    @IBOutlet fileprivate weak var flightDirectInfoStackView: UIStackView!
    
    @IBOutlet fileprivate weak var flightInfoStackView: UIStackView!
    
    @IBOutlet fileprivate weak var numberFlightTitleLabel: UILabel!
    @IBOutlet fileprivate weak var numberFlightLabel: UILabel!
    
    @IBOutlet fileprivate weak var departureInfoStackView: UIStackView!
    @IBOutlet fileprivate weak var arrivalInfoStackView: UIStackView!
    
    @IBOutlet fileprivate weak var departureTitleLabel: UILabel!
    @IBOutlet fileprivate weak var departureTimeLabel: UILabel!
    @IBOutlet fileprivate weak var departureDateLabel: UILabel!
    @IBOutlet fileprivate weak var departureCityLabel: UILabel!
    @IBOutlet fileprivate weak var departureCodeLabel: UILabel!
    
    @IBOutlet fileprivate weak var arrivalTitleLabel: UILabel!
    @IBOutlet fileprivate weak var arrivalTimeLabel: UILabel!
    @IBOutlet fileprivate weak var arrivalDateLabel: UILabel!
    @IBOutlet fileprivate weak var arrivalCityLabel: UILabel!
    @IBOutlet fileprivate weak var arrivalCodeLabel: UILabel!
    
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
        
        _ = self.flightDirectInfoStackView
            |> UIStackView.lens.layoutMargins %~~ { _, stackView in
                stackView.traitCollection.isRegularRegular
                    ? .init(topBottom: Styles.grid(2), leftRight: Styles.grid(14))
                    : .init(top: Styles.grid(2), left: Styles.grid(4), bottom: Styles.grid(2), right: Styles.grid(2))
            }
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
            |> UIStackView.lens.spacing .~ Styles.grid(2)
        
        _ = self.flightInfoStackView
            |> UIStackView.lens.spacing .~ Styles.grid(4)
        
        _ = self.departureInfoStackView
            |> UIStackView.lens.spacing .~ Styles.grid(4)
        
        _ = self.arrivalInfoStackView
            |> UIStackView.lens.spacing .~ Styles.grid(4)
        
        _ = self.departureDateLabel
            |> UILabel.lens.numberOfLines .~ 2
        
        _ = self.arrivalDateLabel
            |> UILabel.lens.numberOfLines .~ 2
    }
    
    func configureWith(value: Flight) {
        _ = self.numberFlightLabel
            |> UILabel.lens.text .~ value.flightNumber
        
        _ = self.departureTimeLabel
            |> UILabel.lens.text .~ value.flightDetail.simpleDepartureTime
        _ = self.arrivalTimeLabel
            |> UILabel.lens.text .~ value.flightDetail.simpleArrivalTime
        
        _ = self.departureDateLabel
            |> UILabel.lens.text .~ value.inner.departureFlightDateStrShort
        _ = self.arrivalDateLabel
            |> UILabel.lens.text .~ value.inner.arrivalFlightDateStrShort
        
        _ = self.departureCityLabel
            |> UILabel.lens.text .~ value.departureCity
        _ = self.arrivalCityLabel
            |> UILabel.lens.text .~ value.arrivalCity
        
    }
}
