//
//  EnrolledProgramsWebViewController.swift
//  edX
//
//  Created by Zeeshan Arif on 7/10/18.
//  Copyright © 2018 edX. All rights reserved.
//

import UIKit

class EnrolledProgramsWebViewController: WebViewController {
    
    var programEnrollmentConfig: ProgramEnrollmentConfig {
        return OEXConfig.shared().programEnrollment
    }
    // TODO: Need to Update URL
    var enrolledProgramsListURL: URL? {
        return programEnrollmentConfig.webview.searchURL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Title should be according to requirement
        //        navigationItem.title = programEnrollmentConfig.discoveryTitle
        //        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        webViewHelper = WebViewHelper(environment: environment, delegate: self, bottomBar: bottomBar, searchQuery: nil) //WebViewHelper(config:OEXConfig.shared(), delegate: self, bottomBar: nil)
        view.backgroundColor = OEXStyles.shared().standardBackgroundColor()
        if let urlToLoad = enrolledProgramsListURL
        {
            webViewHelper?.load(withURL: urlToLoad)
        }
    }
    
    override var enrolledDetailTemplate: String? {
        return nil
    }
    
}
