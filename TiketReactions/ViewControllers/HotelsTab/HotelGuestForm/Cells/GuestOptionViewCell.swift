//
//  GuestOptionViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 16/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import UIKit

class GuestOptionViewCell: UITableViewCell, ValueCell {
    
    typealias Value = Int
    
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
    
    
    func configureWith(value: Int) {
        _ = self.titleOptionLabel
            |> UILabel.lens.text .~ "Pemesanan untuk orang lain"
    }
}
