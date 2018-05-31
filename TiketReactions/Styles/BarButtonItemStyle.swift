//
//  BarButtonItemStyle.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 27/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit

public let baseBarButtonItemStyle =
    UIBarButtonItem.lens.tintColor .~ .tk_official_green

public let plainBarButtonItemStyle = baseBarButtonItemStyle
    <> UIBarButtonItem.lens.style .~ .plain

