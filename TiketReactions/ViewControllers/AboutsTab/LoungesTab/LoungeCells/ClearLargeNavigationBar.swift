//
//  ClearLargeNavigationBar.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 07/11/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import UIKit

public class ClearLargeNavigationBar: UINavigationBar {
    
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
            |> UINavigationBar.lens.prefersLargeTitles .~ true
            |> UINavigationBar.lens.barTintColor .~ .white
            |> UINavigationBar.lens.shadowImage .~ UIImage()
        
        self.setBackgroundImage(UIImage(), for: .default)
    }

}
