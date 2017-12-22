//
//  DiscoverCoursesWebViewHelper.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 20/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import UIKit
import WebKit

class DiscoverCoursesWebViewHelper: DiscoverWebViewHelper {
    
    override init(config : OEXConfig?, delegate : DiscoverWebViewHelperDelegate?, dataSource: DiscoverWebViewHelperDataSource?, bottomBar: UIView?) {
        super.init(config: config, delegate: delegate, dataSource: dataSource, bottomBar: bottomBar)
        webView.accessibilityIdentifier = "find-courses-webview"
    }
    
    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        super.webView(webView, didFinish: navigation)
        
        // Setting webView accessibilityValue for testing
        let script = "document.getElementsByClassName('course-card')[0].innerText"
        webView.evaluateJavaScript(script, completionHandler: {
            (result: Any?, error: Error?) in
                if (error == nil) {
                    self.webView.accessibilityValue = "findCoursesLoaded"
                }
        })
    }
}
