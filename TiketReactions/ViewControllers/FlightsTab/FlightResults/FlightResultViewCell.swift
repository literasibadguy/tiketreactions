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
    
    fileprivate let viewModel: FlightResultCellViewModelType = FlightResultCellViewModel()
    
    @IBOutlet fileprivate weak var flightImageView: UIImageView!
    @IBOutlet fileprivate weak var flightPriceLabel: UILabel!
    @IBOutlet fileprivate weak var generalFlightInfoStackView: UIStackView!
    
    @IBOutlet fileprivate weak var directTimeLabel: UILabel!
    @IBOutlet fileprivate weak var flightIdLabel: UILabel!
    @IBOutlet fileprivate weak var departureCodeLabel: UILabel!
    @IBOutlet fileprivate weak var departureTimeLabel: UILabel!
    @IBOutlet fileprivate weak var arrivalCodeLabel: UILabel!
    @IBOutlet fileprivate weak var arrivalTimeLabel: UILabel!
    @IBOutlet fileprivate weak var resultSeparatorView: UIView!
    
    
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
            |> UILabel.lens.font .~ .systemFont(ofSize: 18.0)
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.generalFlightInfoStackView
            |> UIStackView.lens.spacing .~ 6
        
        _ = self.departureCodeLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.departureTimeLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_500
        
        _ = self.arrivalCodeLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.arrivalTimeLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_500
        
        _ = self.resultSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.flightPriceLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.flightIdLabel.rac.text = self.viewModel.outputs.flightCodeText
        self.flightPriceLabel.rac.text = self.viewModel.outputs.flightPriceText
        self.departureCodeLabel.rac.text = self.viewModel.outputs.departureCodeText
        self.arrivalCodeLabel.rac.text = self.viewModel.outputs.arrivalCodeText
        self.departureTimeLabel.rac.text = self.viewModel.outputs.departureTimeText
        self.arrivalTimeLabel.rac.text = self.viewModel.outputs.arrivalTimeText
        self.directTimeLabel.rac.text = self.viewModel.outputs.directTimeText
    }
    
    func configureWith(value: Flight) {
        self.viewModel.inputs.configureWith(value)
        self.flightImageView.ck_setImageWithURL(URL(string: value.flightInfos.flightInfo.first!.timing.imageSrc)!)
    }
    

}
