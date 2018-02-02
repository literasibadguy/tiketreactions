//
//  EnvironmentTests.swift
//  TiketComponentsTests
//
//  Created by Firas Rafislam on 27/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import XCTest
@testable import TiketComponents

class EnvironmentTests: XCTestCase {
    
    func testInit() {
        let env = Environment()
        
        XCTAssertEqual(env.calendar, Calendar.current)
        XCTAssertEqual(env.language, Language(languageStrings: Locale.preferredLanguages))
        XCTAssertEqual(env.locale, Locale.current)
        XCTAssertEqual(env.countryCode, "ID")
    }
    
}
