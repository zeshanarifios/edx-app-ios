//
//  DiscoverWebViewHelper.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 20/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import UIKit
import WebKit

@objc protocol DiscoverWebViewHelperDelegate: class {
    var webViewNativeSearchEnabled: Bool { get }
    var webViewParentController: UIViewController { get }
    func webViewHelper(helper : DiscoverWebViewHelper, shouldLoadLinkWithRequest request: URLRequest) -> Bool
}

class DiscoverWebViewHelper: NSObject, WKNavigationDelegate {
    
    lazy var webView : WKWebView = {
       return WKWebView()
    }()
    lazy var searchBar: UISearchBar = {
        return UISearchBar()
    }()
    private lazy var loadController: LoadStateViewController = {
        return LoadStateViewController()
    }()
    var bottomBar: UIView?
    let config : OEXConfig?
    weak var delegate : DiscoverWebViewHelperDelegate?
    private var request : URLRequest? = nil
    var searchBaseURL: URL?
    var isWebViewLoaded : Bool {
        return self.loadController.state.isLoaded
    }
    
    init(config : OEXConfig?, delegate : DiscoverWebViewHelperDelegate?, bottomBar: UIView?) {
        self.config = config
        self.delegate = delegate
        self.bottomBar = bottomBar
        super.init()
        
        webView.navigationDelegate = self
        webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
        
        if let container = delegate?.webViewParentController {
            loadController.setupInController(controller: container, contentView: webView)
            
            let webviewTop: ConstraintItem
            if delegate?.webViewNativeSearchEnabled ?? false {
                searchBar.delegate = self
                container.view.addSubview(searchBar)
                searchBar.snp_makeConstraints{ make in
                    make.leading.equalTo(container.view)
                    make.trailing.equalTo(container.view)
                    make.top.equalTo(container.view)
                }
                webviewTop = searchBar.snp_bottom
            } else {
                webviewTop = container.view.snp_top
            }
            
            container.view.addSubview(webView)
            webView.snp_makeConstraints { make in
                make.leading.equalTo(container.view)
                make.trailing.equalTo(container.view)
                make.bottom.equalTo(container.view)
                make.top.equalTo(webviewTop)
            }
            
            if let bar = bottomBar {
                container.view.addSubview(bar)
                bar.snp_makeConstraints(closure: { (make) in
                    make.height.equalTo(50)
                    make.leading.equalTo(container.view)
                    make.trailing.equalTo(container.view)
                    make.bottom.equalTo(container.view)
                })
            }
        }
    }
    
    func loadRequest(withURL url : URL) {
        let request = URLRequest(url: url)
        self.webView.load(request)
        self.request = request
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let request = navigationAction.request
        let capturedLink = navigationAction.navigationType == .linkActivated && (self.delegate?.webViewHelper(helper: self, shouldLoadLinkWithRequest: request) ?? true)
        
        let outsideLink = (request.mainDocumentURL?.host != self.request?.url?.host)
        if let URL = request.url, outsideLink || capturedLink {
            UIApplication.shared.openURL(URL)
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.loadController.state = .Loaded
        if let bar = bottomBar {
            bar.superview?.bringSubview(toFront: bar)
        }
    }
    
    func showError(error : NSError) {
        let buttonInfo = MessageButtonInfo(title: Strings.reload) {[weak self] _ in
            if let request = self?.request {
                self?.webView.load(request as URLRequest)
                self?.loadController.state = .Initial
            }
        }
        self.loadController.state = LoadState.failed(error: error, buttonInfo: buttonInfo)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showError(error: error as NSError)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showError(error: error as NSError)
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let credential = config?.URLCredentialForHost(challenge.protectionSpace.host as NSString) {
            completionHandler(.useCredential, credential)
        }
        else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
extension DiscoverWebViewHelper: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let searchTerms = searchBar.text, let searchURL = searchBaseURL else { return }
        if let URL = DiscoverWebViewHelper.buildQuery(baseURL: searchURL.URLString, toolbarString: searchTerms) {
            loadRequest(withURL: URL)
        }
    }
    
    @objc static func buildQuery(baseURL: String, toolbarString: String) -> URL? {
        let items = toolbarString.components(separatedBy: " ")
        let escapedItems = items.flatMap { $0.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)  }
        let searchTerm = "search_query=" + escapedItems.joined(separator: "+")
        let newQuery: String
        if baseURL.contains("?") {
            newQuery = baseURL + "&" + searchTerm
        } else {
            newQuery = baseURL + "?" + searchTerm
        }
        return URL(string: newQuery)
    }
}
