//
//  GuestOptionViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 16/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import UIKit

protocol GuestOptionViewCellDelegate: class {
    func guestFormOptionChanged(_ option: Bool)
}

public enum BookingOptionFormState {
    case flightOption
    case hotelOption
}

internal class GuestOptionViewCell: UITableViewCell, ValueCell {
    
    typealias Value = BookingOptionFormState
    
    weak var delegate: GuestOptionViewCellDelegate?
    
    @IBOutlet fileprivate weak var guestOptionStackView: UIStackView!
    @IBOutlet fileprivate weak var titleOptionLabel: UILabel!
    @IBOutlet fileprivate weak var guestSwitch: UISwitch!
    
    
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
        
        _ = self.guestSwitch
            |> UISwitch.lens.tintColor .~ .tk_official_green
        

        
        self.guestSwitch.onTintColor = .tk_official_green
    }
    
    @IBAction private func guestOptionIsSwitched(_ sender: UISwitch) {
        self.delegate?.guestFormOptionChanged(sender.isOn)
    }
    
    func configureWith(value: BookingOptionFormState) {
        switch value {
        case .flightOption:
            _ = self.titleOptionLabel
                |> UILabel.lens.text .~ Localizations.OptionTitlePassengerForm
        case .hotelOption:
            _ = self.titleOptionLabel
                |> UILabel.lens.text .~ Localizations.AnotherguestOptionFormTitle
        }
       
    }
    
}
