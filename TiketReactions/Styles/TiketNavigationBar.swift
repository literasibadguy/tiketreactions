//
//  TiketNavigationBar.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 27/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit
import Prelude

public class TiketNavigationBar: UINavigationBar {

    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        
        _ = self
            |> UINavigationBar.lens.titleTextAttributes .~ [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)]
            |> UINavigationBar.lens.translucent .~ true
            |> UINavigationBar.lens.barTintColor .~ .white
            |> UINavigationBar.lens.shadowImage .~ UIImage()
    }
}
