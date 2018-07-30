//
//  CurrentWebViewController.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 20/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit
import TiketKitModels
import WebKit

internal class CurrentWebViewController: UIViewController {
    
    internal let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
    
    private var pendingRequests = [String: URLRequest]()
    weak private var pendingDownloadWebView: WKWebView?
    
    override func loadView() {
        super.loadView()
        
        self.webView.configuration.suppressesIncrementalRendering = true
        self.webView.configuration.allowsInlineMediaPlayback = true
        self.webView.configuration.applicationNameForUserAgent = "Jajanan Online"
        
        self.view.addSubview(self.webView)
        NSLayoutConstraint.activate(
            [
                self.webView.topAnchor.constraint(equalTo: self.view.topAnchor),
                self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ]
        )
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.webView.scrollView.delegate = self
    }
    
    deinit {
        self.webView.uiDelegate = nil
        self.webView.navigationDelegate = nil
        self.webView.scrollView.delegate = nil
    }
    
    fileprivate func resetSpoofedUserAgentIfRequired(_ webView: WKWebView, newURL: URL) {
        if webView.url?.host != newURL.host {
            webView.customUserAgent = nil
        }
    }
    
    fileprivate func restoreSpoofedUserAgentIfRequired(_ webView: WKWebView, newRequest: URLRequest) {
        let ua = newRequest.value(forHTTPHeaderField: "User-Agent")
        webView.customUserAgent = ua != UserAgent.defaultUserAgent() ? ua : nil
    }
}

extension WKNavigationAction {
    var isAllowed: Bool {
        guard let url = request.url else {
            return true
        }
        
        return !url.isWebPage(includeDataURIs: false)
    }
}

extension CurrentWebViewController: WKUIDelegate {
    
}

extension CurrentWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        
        if url.scheme == "about" {
            decisionHandler(.allow)
            return
        }
        
        if !navigationAction.isAllowed && navigationAction.navigationType != .backForward {
            
        }
        
        if ["http", "https", "data", "blob", "file"].contains(url.scheme) {
            if navigationAction.navigationType == .linkActivated {
                resetSpoofedUserAgentIfRequired(webView, newURL: url)
            } else if navigationAction.navigationType == .backForward {
                restoreSpoofedUserAgentIfRequired(webView, newRequest: navigationAction.request)
            }
            
            pendingRequests[url.absoluteString] = navigationAction.request
            decisionHandler(.allow)
            return
        }
        
        UIApplication.shared.open(url, options: [:]) { openedURL in
            // Do not show error message for JS navigated links or redirect as it's not the result of a user action.
            if !openedURL, navigationAction.navigationType == .linkActivated {
                let alert = UIAlertController.alert("Can't Open", message: "Unable to Open URL", confirm: nil, cancel: nil)
                self.present(alert, animated: true, completion: nil)
            }
        }
        decisionHandler(.cancel)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let error = error as NSError
        if error.domain == "WebKitErrorDomain" && error.code == 102 {
            return
        }
        
        if checkIfWebContentProcessHasCrashed(webView, error: error as NSError) {
            return
        }
    }
    
    fileprivate func checkIfWebContentProcessHasCrashed(_ webView: WKWebView, error: NSError) -> Bool {
        if error.code == WKError.webContentProcessTerminated.rawValue && error.domain == "WebKitErrorDomain" {
            print("WebContent process has crashed. Trying to reload to restart it.")
            webView.reload()
            return true
        }
        
        return false
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust, let trust = challenge.protectionSpace.serverTrust {
            completionHandler(.useCredential, URLCredential(trust: trust))
            return
        }
        
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPBasic || challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPDigest || challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodNTLM else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
    }
}

extension CurrentWebViewController: UIScrollViewDelegate {
}

fileprivate let permanentURISchemes = ["aaa", "aaas", "about", "acap", "acct", "cap", "cid", "coap", "coaps", "crid", "data", "dav", "dict", "dns", "example", "file", "ftp", "geo", "go", "gopher", "h323", "http", "https", "iax", "icap", "im", "imap", "info", "ipp", "ipps", "iris", "iris.beep", "iris.lwz", "iris.xpc", "iris.xpcs", "jabber", "ldap", "mailto", "mid", "msrp", "msrps", "mtqp", "mupdate", "news", "nfs", "ni", "nih", "nntp", "opaquelocktoken", "pkcs11", "pop", "pres", "reload", "rtsp", "rtsps", "rtspu", "service", "session", "shttp", "sieve", "sip", "sips", "sms", "snmp", "soap.beep", "soap.beeps", "stun", "stuns", "tag", "tel", "telnet", "tftp", "thismessage", "tip", "tn3270", "turn", "turns", "tv", "urn", "vemmi", "vnc", "ws", "wss", "xcon", "xcon-userid", "xmlrpc.beep", "xmlrpc.beeps", "xmpp", "z39.50r", "z39.50s"]

extension URL {
    public func isWebPage(includeDataURIs: Bool = true) -> Bool {
        let schemes = includeDataURIs ? ["http", "https", "data"] : ["http", "https"]
        return scheme.map { schemes.contains($0) } ?? false
    }
    
    public var schemeIsValid: Bool {
        guard let scheme = scheme else { return false }
        return permanentURISchemes.contains(scheme.lowercased())
    }
    
    public func havingRemovedAuthorisationComponents() -> URL {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }
        urlComponents.user = nil
        urlComponents.password = nil
        if let url = urlComponents.url {
            return url
        }
        return self
    }
}

internal protocol WebViewControllerProtocol: UIViewControllerProtocol {
    var webView: WKWebView { get }
}


extension CurrentWebViewController: WebViewControllerProtocol {}

extension LensHolder where Object: WebViewControllerProtocol {
    internal var webView: Lens<Object, WKWebView> {
        return Lens(
            view: { $0.webView },
            set: { $1 }
        )
    }
}

extension Lens where Whole: WebViewControllerProtocol, Part == WKWebView {
    internal var scrollView: Lens<Whole, UIScrollView> {
        return Whole.lens.webView..Part.lens.scrollView
    }
}



