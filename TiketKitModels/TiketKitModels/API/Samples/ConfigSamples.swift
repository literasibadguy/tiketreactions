//
//  ConfigSamples.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 07/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude

extension Config {
    internal static let template = Config(countryCode: "US", iTunesLink: "http://www.itunes.com", locale: "en")
    
    internal static let config = Config.template
}
