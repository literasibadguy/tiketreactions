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
            
            case bankTransfers
            case instantBankTransfers
            case klikBCA
            case creditCard
            case bcaKlikpay
            case clicksCIMB
            case ePayBRI
        }
    }
}

extension Navigation: Equatable {}
public func == (lhs: Navigation, rhs: Navigation) -> Bool {
    switch (lhs, rhs) {
    case let (.checkout(lhsCheckout), .checkout(rhsCheckout)):
        return lhsCheckout == rhsCheckout
    }
}

extension Navigation.Checkout: Equatable {}
public func == (lhs: Navigation.Checkout, rhs: Navigation.Checkout) -> Bool {
    switch (lhs, rhs) {
    case let (.payments(lhsPayment), .payments(rhsPayment)):
        return lhsPayment == rhsPayment
    }
}

extension Navigation.Checkout.Payment: Equatable {}
public func == (lhs: Navigation.Checkout.Payment, rhs: Navigation.Checkout.Payment) -> Bool {
    switch (lhs, rhs) {
    case (.bankTransfers, .bankTransfers), (.instantBankTransfers, .instantBankTransfers), (.klikBCA, .klikBCA), (.creditCard, .creditCard), (.bcaKlikpay, .bcaKlikpay), (.clicksCIMB, .clicksCIMB), (.ePayBRI, .ePayBRI):
        return true
    default:
        return false
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

// Bank Transfer https://api-sandbox.tiket.com/checkout/checkout_payment/2?token=2ee91e32f9113e863da4c57e235098d1&currency=IDR&btn_booking=1&output=json
// Bank Transfer (Instant Confirmation) http://api-sandbox.tiket.com/checkout/checkout_payment/35?token=4c71d60d367bbffa1b293cb663afc4e9&btn_booking=1&currency=IDR&output=json
// KlikBCA https://api-sandbox.tiket.com/checkout/checkout_payment/3?token=2ee91e32f9113e863da4c57e235098d1&btn_booking=1&user_bca=examplee1810&currency=IDR&output=json

// Credit Card http://sandbox.tiket.com/payment/checkout_payment?checkouttoken=84ab8cba79dace1eef8edc708114
// BCA KlikPay http://sandbox.tiket.com/payment/checkout_payment?checkouttoken=84ab8cba79dace1eef8edc7081147b49&payment_type=4
// CIMB Clicks http://sandbox.tiket.com/payment/checkout_payment?checkouttoken=84ab8cba79dace1eef8edc7081147b49&payment_type=31
// ePay BRI http://sandbox.tiket.com/payment/checkout_payment?checkouttoken=84ab8cba79dace1eef8edc7081147b49&payment_type=33


private let paymentRoutes: [String: (RouteParams) -> Decoded<Navigation>] = [
    "/checkout/checkout_payment/2?&btn_booking=1": bankTransfer,
    "/checkout/checkout_payment/35?btn_booking=1": instantBankTransfer,
    "/checkout/checkout_payment/3?btn_booking=1&user_bca=:user_bca": klikBCA,
    "/payment/checkout_payment?checkouttoken=:checkouttoken": kartuKredit,
    "/payment/checkout_payment?checkouttoken=:checkouttoken&payment_type=4": bcaKlikpay,
    "/payment/checkout_payment?checkouttoken=:checkouttoken&payment_type=31": cimbClicks,
    "/payment/checkout_payment?checkouttoken=:checkouttoken&payment_type=33": epayBri
]

public typealias RouteParams = JSON

private func bankTransfer(_ params: RouteParams) -> Decoded<Navigation> {
    return curry(Navigation.checkout)    
        <^> .success(.payments(.bankTransfers))
}

private func instantBankTransfer(_ params: RouteParams) -> Decoded<Navigation> {
    return curry(Navigation.checkout)
        <^> .success(.payments(.instantBankTransfers))
}

private func klikBCA(_ params: RouteParams) -> Decoded<Navigation> {
    return curry(Navigation.checkout)
        <^> .success(.payments(.klikBCA))
}

private func kartuKredit(_ params: RouteParams) -> Decoded<Navigation> {
    return curry(Navigation.checkout)
        <^> .success(.payments(.creditCard))
}

private func bcaKlikpay(_ params: RouteParams) -> Decoded<Navigation> {
    return curry(Navigation.checkout)
        <^> .success(.payments(.bcaKlikpay))
}

private func cimbClicks(_ params: RouteParams) -> Decoded<Navigation> {
    return curry(Navigation.checkout)
        <^> .success(.payments(.creditCard))
}

private func epayBri(_ params: RouteParams) -> Decoded<Navigation> {
    return curry(Navigation.checkout)
        <^> .success(.payments(.ePayBRI))
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
