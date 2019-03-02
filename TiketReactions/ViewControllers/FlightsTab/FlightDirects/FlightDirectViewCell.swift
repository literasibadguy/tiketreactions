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

public final class FlightDirectViewCell: UITableViewCell, ValueCell {
    
    public typealias Value = Flight
    
    fileprivate let viewModel: FlightDirectsCellViewModelType = FlightDirectsCellViewModel()
    
    // STACK MAINTAINED
    @IBOutlet fileprivate weak var summaryContainerView: UIView!
    @IBOutlet fileprivate weak var flightSummaryStackView: UIStackView!
    @IBOutlet fileprivate weak var dateFlightLabel: UILabel!
    @IBOutlet fileprivate weak var flightRouteNameLabel: UILabel!
    @IBOutlet fileprivate weak var logoFlightImageView: UIImageView!
    
    @IBOutlet fileprivate weak var flightDirectStackView: UIStackView!
    @IBOutlet fileprivate weak var flightNameLabel: UILabel!
    @IBOutlet fileprivate weak var flightTimeLabel: UILabel!
    
    @IBOutlet fileprivate weak var flightStatusStackView: UIStackView!
    @IBOutlet fileprivate weak var flightStatusLabel: UILabel!
    @IBOutlet fileprivate weak var flightDurationLabel: UILabel!
    
    @IBOutlet fileprivate weak var summarySeparatorView: UIView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override public func bindStyles() {
        super.bindStyles()
        
        _ = self.contentView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.summaryContainerView
            |> UIView.lens.backgroundColor .~ .tk_fade_green_grey
        
        _ = self.dateFlightLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        _ = self.flightRouteNameLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.flightNameLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        _ = self.flightTimeLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.summarySeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    override public func bindViewModel() {
        super.bindViewModel()
        
        self.dateFlightLabel.rac.text = self.viewModel.outputs.dateDirectFlightText
        self.flightRouteNameLabel.rac.text = self.viewModel.outputs.flightRouteNameText
        self.flightNameLabel.rac.text = self.viewModel.outputs.flightNameText
        self.flightTimeLabel.rac.text = self.viewModel.outputs.flightTimeText
        self.flightStatusLabel.rac.text = self.viewModel.outputs.flightStatusText
        self.flightDurationLabel.rac.text = self.viewModel.outputs.flightDurationText
    }
    
    public func configureWith(value: Flight) {
        self.viewModel.inputs.configureWith(value)
        self.logoFlightImageView.ck_setImageWithURL(URL(string: value.flightInfos.flightInfo.first!.timing.imageSrc)!)
    }
}
