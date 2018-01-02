//
//  DiscoverWebViewHelper.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 20/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import UIKit
import WebKit

@objc protocol DiscoverWebViewHelperDataSource: class {
    var webViewNativeSearchEnabled: Bool { get }
    var webViewSearchBaseURL: URL? { get }
    var webViewParentController: UIViewController { get }
}

@objc protocol DiscoverWebViewHelperDelegate: class {
    func webViewHelper(helper : DiscoverWebViewHelper, shouldLoadLinkWithRequest request: URLRequest) -> Bool
}

class DiscoverWebViewHelper: NSObject  {
    
    let bottomBarHeight: CGFloat = 50.0
    fileprivate lazy var loadController: LoadStateViewController = {
        return LoadStateViewController()
    }()
    lazy var webView : WKWebView = {
       return WKWebView()
    }()
    lazy var searchBar: UISearchBar = {
        return UISearchBar()
    }()
    var bottomBar: UIView?
    let config : OEXConfig?
    weak var delegate : DiscoverWebViewHelperDelegate?
    weak var dataSource : DiscoverWebViewHelperDataSource?
    fileprivate var request : URLRequest?
    
    init(config : OEXConfig?, delegate : DiscoverWebViewHelperDelegate?, dataSource : DiscoverWebViewHelperDataSource?, bottomBar: UIView?) {
        
        self.config = config
        self.delegate = delegate
        self.dataSource = dataSource
        self.bottomBar = bottomBar
        super.init()
        
        webView.navigationDelegate = self
        webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
        
        if let container = dataSource?.webViewParentController {
            loadController.setupInController(controller: container, contentView: webView)
            
            let webviewTop: ConstraintItem
            if dataSource?.webViewNativeSearchEnabled ?? false {
                searchBar.delegate = self
                container.view.addSubview(searchBar)
                searchBar.snp_makeConstraints { make in
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
                bar.snp_makeConstraints { make in
                    make.leading.equalTo(container.view)
                    make.trailing.equalTo(container.view)
                    make.bottom.equalTo(container.view)
                    make.height.equalTo(bottomBarHeight)
                }
            }
        }
        
    }
    
    func loadRequest(withURL url : URL) {
        request = URLRequest(url: url) // never gives nil
        self.webView.load(request!) // Force Unwrapping will not cause any crash
    }
    
    func showError(error : NSError) {
        let buttonInfo = MessageButtonInfo(title: Strings.reload) {[weak self] _ in
            if let request = self?.request {
                self?.webView.load(request as URLRequest)
                self?.loadController.state = .Initial
            }
        }
        loadController.state = LoadState.failed(error: error, buttonInfo: buttonInfo)
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
// MARK: - WKNavigationDelegate -
extension DiscoverWebViewHelper: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let request = navigationAction.request
        let capturedLink = navigationAction.navigationType == .linkActivated && (delegate?.webViewHelper(helper: self, shouldLoadLinkWithRequest: request) ?? true)
        
        let outsideLink = (request.mainDocumentURL?.host != self.request?.url?.host)
        if let URL = request.url, outsideLink || capturedLink {
            UIApplication.shared.openURL(URL)
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadController.state = .Loaded
        if let bar = bottomBar {
            bar.superview?.bringSubview(toFront: bar)
        }
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
// MARK: - UISearchBarDelegate -
extension DiscoverWebViewHelper: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchTerms = searchBar.text, let searchURL = dataSource?.webViewSearchBaseURL else { return }
        if let URL = DiscoverWebViewHelper.buildQuery(baseURL: searchURL.URLString, toolbarString: searchTerms) {
            loadRequest(withURL: URL)
        }
    }

}
