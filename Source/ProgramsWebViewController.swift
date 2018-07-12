//
//  ProgramsWebViewController.swift
//  edX
//
//  Created by Zeeshan Arif on 7/10/18.
//  Copyright © 2018 edX. All rights reserved.
//

import Foundation

class ProgramsWebViewController: WebViewController {
    
    var programEnrollmentConfig: ProgramEnrollmentConfig {
        return OEXConfig.shared().programEnrollment
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = programEnrollmentConfig.discoveryTitle
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if let urlToLoad = programEnrollmentConfig.webview.searchURL
        {
            webViewHelper?.load(withURL: urlToLoad)
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
