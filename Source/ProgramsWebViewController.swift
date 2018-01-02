//
//  ProgramsWebViewController.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 21/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import Foundation

class ProgramsWebViewController: DiscoverWebViewController {
    
    var programEnrollmentConfig: ProgramEnrollmentConfig {
        return OEXConfig.shared().programEnrollment
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = programEnrollmentConfig.discoveryTitle
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        webViewHelper = DiscoverProgramsWebViewHelper(config:OEXConfig.shared(), delegate: self, dataSource: self, bottomBar: bottomBar)
        view.backgroundColor = OEXStyles.shared().standardBackgroundColor()
        if let urlToLoad = programEnrollmentConfig.webview.searchURL
        {
            webViewHelper?.loadRequest(withURL: urlToLoad)
        }
    }
    
    override var detailTemplate: String? {
        return programEnrollmentConfig.webview.detailTemplate
    }
    
    override var webViewNativeSearchEnabled: Bool {
        return programEnrollmentConfig.webview.searchbarEnabled
    }
    
    override var webViewSearchBaseURL: URL? {
        return programEnrollmentConfig.webview.searchURL
    }
    
}
