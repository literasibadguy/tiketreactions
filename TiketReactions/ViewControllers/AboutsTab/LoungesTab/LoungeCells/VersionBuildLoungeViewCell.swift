//
//  VersionBuildLoungeViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 07/11/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit

internal final class VersionBuildLoungeViewCell: UITableViewCell, ValueCell {
    typealias Value = String
    
    @IBOutlet private weak var versionBuildLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureWith(value: String) {
        
    }
}
