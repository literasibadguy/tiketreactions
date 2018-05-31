//
//  Navigation.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 12/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Argo
import Curry
import Runes
import Foundation
import TiketKitModels

public enum Navigation {
    case checkout(Navigation.Checkout)
    
    public enum Checkout {
        case payments(Navigation.Checkout.Payment)
        
        public enum Payment {
            
            public enum BankTransfer {
                case transferBCA
                case transferMandiri
            }
            
            case bankTransfers(Navigation.Checkout.Payment.BankTransfer)
            case creditCard
            case klikBCA
            case clicksCIMB
            case ePayBRI
        }
    }
}

extension Navigation {
    public static func match(_ url: URL) -> Navigation? {
        return paymentRoutes.reduce(nil) { accum, templateAndRoute in
            let (template, route) = templateAndRoute
            return accum ?? parsedParams(url: url, fromTemplate: template).flatMap(route)?.value
        }
    }
}

private let paymentRoutes: [String: (RouteParams) -> Decoded<Navigation>] = [
    "/checkout/checkout_payment/3?": klikBCA,
    // Seharusnya Virtual Account Bank Transfer
    "/checkout/checkout_payment/35?": klikBCA
    
]

public typealias RouteParams = JSON

private func kartuKredit(_ params: RouteParams) -> Decoded<Navigation> {
    return curry(Navigation.checkout)
        <^> .success(.payments(.creditCard))
}

private func klikBCA(_ params: RouteParams) -> Decoded<Navigation> {
    return curry(Navigation.checkout)
        <^> .success(.payments(.klikBCA))
}

// MARK: Helpers

private func parsedParams(url: URL, fromTemplate template: String) -> RouteParams? {
    
    let recognizedHosts = [
        AppEnvironment.current.apiService.serverConfig.apiBaseUrl.host,
        AppEnvironment.current.apiService.serverConfig.webBaseUrl.host
    ].compact()
    
    let isRecognizedHost = recognizedHosts.reduce(false) { accum, host in
        accum || url.host.map { $0.hasPrefix(host) } == .some(true)
    }
    
    guard isRecognizedHost else { return nil }
    
    let templateComponents = template
        .components(separatedBy: "/")
        .filter { $0 != "" }
    let urlComponents = url
        .path
        .components(separatedBy: "/")
        .filter { $0 != "" && !$0.hasPrefix("?") }
    
    guard templateComponents.count == urlComponents.count else { return nil }
    
    var params: [String: String] = [:]
    
    for (templateComponent, urlComponent) in zip(templateComponents, urlComponents) {
        if templateComponent.hasPrefix(":") {
            // matched a token
            let paramName = String(templateComponent.dropFirst())
            params[paramName] = urlComponent
        } else if templateComponent != urlComponent {
        }
    }
    
    URLComponents(url: url, resolvingAgainstBaseURL: false)?
        .queryItems?
        .forEach { item in
            params[item.name] = item.value
    }
    
    var object: [String: RouteParams] = [:]
    params.forEach { key, value in
        object[key] = .string(value)
    }
    
    return .object(object)
}


private func stringToInt(_ string: String) -> Decoded<Int> {
    return Int(string).map(Decoded.success) ?? .failure(.custom("Could not parse string into int."))

}
