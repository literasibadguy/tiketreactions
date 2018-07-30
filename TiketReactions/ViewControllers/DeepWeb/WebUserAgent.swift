//
//  WebUserAgent.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 15/07/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import AVFoundation
import UIKit
import TiketKitModels

open class UserAgent {
    private static var defaults = AppEnvironment.current.userDefaults
    
    private static func clientUserAgent(prefix: String) -> String {
        return "\(prefix)\(AppEnvironment.current.mainBundle.version) (\(AppEnvironment.current.device.systemName); iPhone OS \(UIDevice.current.systemVersion))"
    }
    
    open static var defaultClientUserAgent: String {
        return clientUserAgent(prefix: "twh:[27029614];[Jajanan Online];")
    }
    
    open static func cachedUserAgent(checkiOSVersion: Bool = true, checkTiketVersion: Bool = true, checkTiketBuildNumber: Bool = true) -> String? {
        let currentiOSVersion = UIDevice.current.systemVersion
        let lastiOSVersion = defaults.string(forKey: "LastDeviceSystemVersionNumber")
        
        let currentTiketBuildNumber = AppEnvironment.current.mainBundle.buildNumber
        let currentTiketVersion = AppEnvironment.current.mainBundle.version
        let lastTiketVersion = defaults.string(forKey: "LastTiketVersionNumber")
        let lastTiketBuildNumber = defaults.string(forKey: "LastTiketBuildNumber")
        
        if let tiketUA = defaults.string(forKey: "UserAgent") {
            if (!checkiOSVersion || (lastiOSVersion == currentiOSVersion))
                && (!checkTiketVersion || (lastTiketVersion == currentTiketVersion)
                    && (!checkTiketBuildNumber || (lastTiketBuildNumber == currentTiketBuildNumber))) {
                return tiketUA
            }
        }
        
        return nil
    }
    
    open static func defaultUserAgent() -> String {
        assert(Thread.current.isMainThread, "This method must be called on the main thread.")
        
        if let firefoxUA = UserAgent.cachedUserAgent(checkiOSVersion: true) {
            return firefoxUA
        }
        
        let webView = UIWebView()
        
        let appVersion = AppEnvironment.current.mainBundle.version
        let buildNumber = AppEnvironment.current.mainBundle.buildNumber
        let currentiOSVersion = UIDevice.current.systemVersion
        defaults.set(currentiOSVersion, forKey: "LastDeviceSystemVersionNumber")
        defaults.set(appVersion, forKey: "LastTiketVersionNumber")
        defaults.set(buildNumber, forKey: "LastTiketBuildNumber")
        
        let userAgent = webView.stringByEvaluatingJavaScript(from: "navigator.userAgent")!
        
        // Extract the WebKit version and use it as the Safari version.
        let webKitVersionRegex = try! NSRegularExpression(pattern: "AppleWebKit/([^ ]+) ", options: [])
        
        let match = webKitVersionRegex.firstMatch(in: userAgent, options: [],
                                                  range: NSRange(location: 0, length: userAgent.count))
        
        if match == nil {
            print("Error: Unable to determine WebKit version in UA.")
            return userAgent     // Fall back to Safari's.
        }
        
        let webKitVersion = (userAgent as NSString).substring(with: match!.range(at: 1))
        
        // Insert "FxiOS/<version>" before the Mobile/ section.
        let mobileRange = (userAgent as NSString).range(of: "Mobile/")
        if mobileRange.location == NSNotFound {
            print("Error: Unable to find Mobile section in UA.")
            return userAgent     // Fall back to Safari's.
        }
        
        let mutableUA = NSMutableString(string: userAgent)
        mutableUA.insert("FxiOS/\(appVersion)b\(AppEnvironment.current.mainBundle.buildNumber) ", at: mobileRange.location)
        
        let tiketUA = "\(mutableUA) Safari/\(webKitVersion)"
        
        defaults.set(tiketUA, forKey: "UserAgent")
        
        return tiketUA
    }
    
    open static func desktopUserAgent() -> String {
        let userAgent = NSMutableString(string: defaultUserAgent())
        
        // Spoof platform section
        let platformRegex = try! NSRegularExpression(pattern: "\\([^\\)]+\\)", options: [])
        guard let platformMatch = platformRegex.firstMatch(in: userAgent as String, options: [], range: NSRange(location: 0, length: userAgent.length)) else {
            print("Error: Unable to determine platform in UA.")
            return String(userAgent)
        }
        userAgent.replaceCharacters(in: platformMatch.range, with: "(Macintosh; Intel Mac OS X 10_11_1)")
        
        // Strip mobile section
        let mobileRegex = try! NSRegularExpression(pattern: " TripToZeroiOS/[^ ]+ Mobile/[^ ]+", options: [])
        
        guard let mobileMatch = mobileRegex.firstMatch(in: userAgent as String, options: [], range: NSRange(location: 0, length: userAgent.length)) else {
            print("Error: Unable to find Mobile section in UA.")
            return String(userAgent)
        }
        
        // The iOS major version is equal to the Safari major version
        let majoriOSVersion = (UIDevice.current.systemVersion as NSString).components(separatedBy: ".")[0]
        userAgent.replaceCharacters(in: mobileMatch.range, with: " Version/\(majoriOSVersion).0")
        
        return String(userAgent)
    }
}
