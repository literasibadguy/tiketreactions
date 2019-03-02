//
//  CheckoutPageVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 12/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import KINWebBrowser
import Prelude
import ReactiveSwift
import RealmSwift
import TiketKitModels
import UIKit
import WebKit

internal final class CheckoutPageVC: UIViewController {
    
    fileprivate let activityIndicator = UIActivityIndicatorView()

    fileprivate var pendingRequests = [String: URLRequest]()
    @IBOutlet fileprivate weak var webView: WKWebView!
    
    fileprivate let viewModel: CheckoutPageViewModelType = CheckoutPageViewModel()
    
    internal static func configuredWith(initialRequest: URLRequest) -> CheckoutPageVC {
        let vc = Storyboard.CheckoutPage.instantiate(CheckoutPageVC.self)
        vc.viewModel.inputs.configureWith(initialRequest: initialRequest)
        return vc
    }
    
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.activityIndicator)
        
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.webView.scrollView.delegate = self
        
        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        
        self.activityIndicator.center = self.view.center
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.webView.uiDelegate = nil
        self.webView.navigationDelegate = nil
        self.webView.scrollView.delegate = nil
    }
    
    internal override func bindStyles() {
        super.bindStyles()
        
        _ = self.activityIndicator
            |> baseActivityIndicatorStyle
    }
    
    internal override func bindViewModel() {
        super.bindViewModel()
        
        self.activityIndicator.rac.animating = self.viewModel.outputs.webIsLoading
        
        self.viewModel.outputs.popViewController
            .observe(on: UIScheduler())
            .observeValues { [weak self] _ in
                self?.popViewController()
        }
        
        self.viewModel.outputs.webViewLoadRequest
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] request in
                self?.webView.load(request)
                self?.viewModel.inputs.webViewConfirm(self?.webView.isLoading ?? false)
        }
        
        self.viewModel.outputs.paymentCallback
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] _ in
                let issuedList = try! Realm().objects(IssuedOrderList.self).first!
                if let lasted = issuedList.items.last {
                    self?.goToBookingCompletedVC(lasted.orderId, email: lasted.email)
                }
        }
    }
    
    internal func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.viewModel.inputs.webViewConfirm(false)
    }
    
    internal func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.viewModel.inputs.webViewConfirm(false)
    }
    
    internal func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.viewModel.inputs.webViewConfirm(true)
    }
    
    
    
    @objc fileprivate func cancelButtonTapped() {
        self.viewModel.inputs.cancelButtonTapped()
    }
    
    fileprivate func popViewController() {
        self.dismiss(animated: true, completion: {
            self.dismiss(animated: true, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        })
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
    
    fileprivate func goToBookingCompletedVC(_ orderId: String, email: String) {
        let completedVC = BookingCompletedVC.configureWith(orderId, email: email)
        self.navigationController?.pushViewController(completedVC, animated: true)
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

extension CheckoutPageVC: WKUIDelegate {
    
}

extension CheckoutPageVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("Decided Policy For Navigation Action")
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
        
        if url.host == "kicikku.com" {
            print("KICIKKU.com Callback")
            self.viewModel.inputs.paymentIsFailedOrCompleted(true)
            decisionHandler(.cancel)
            return
        }
        
        if ["http", "https", "data", "blob", "file"].contains(url.scheme) {
            print("Whats Classical Equation")
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

extension CheckoutPageVC: UIScrollViewDelegate {
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

/*
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
*/
