//
//  OEXWebviews.swift
//  edX
//
//  Created by Saeed Bashir on 8/4/17.
//  Copyright © 2017 edX. All rights reserved.
//

import Foundation
import WebKit

private let CookieName = "prod-edx-language-preference"

class OEXWKWebView: WKWebView {
    @discardableResult override func load(_ request: URLRequest) -> WKNavigation? {
        
        let request = request.addCookies()
        return super.load(request)
    }
}

class OEXUIWebView: UIWebView {
    override func loadRequest(_ request: URLRequest) {
        
        let request = request.addCookies()
        super.loadRequest(request)
    }
}

private extension URLRequest {
    func addCookies() -> URLRequest {
        let mutatedRequest = self as! NSMutableURLRequest
        let cookieProperties: [HTTPCookiePropertyKey: Any] = [HTTPCookiePropertyKey.domain: OEXConfig.shared().apiHostURL()?.absoluteString ?? "", HTTPCookiePropertyKey.name: CookieName, HTTPCookiePropertyKey.value: Manager.supportedLanguage(),HTTPCookiePropertyKey.path: "/"]
        
        let cookie = HTTPCookie(properties: cookieProperties)
        if let cookie = cookie {
            let cookieHeaders = HTTPCookie.requestHeaderFields(with: [cookie])
            mutatedRequest.allHTTPHeaderFields = cookieHeaders
        }
        
        return mutatedRequest as URLRequest
    }
}
