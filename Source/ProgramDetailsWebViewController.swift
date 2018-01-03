//
//  ProgramDetailsWebViewController.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 21/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import Foundation

class ProgramDetailsWebViewController: WebViewController {
    
    var programDetailsURL:URL?
    var programEnrollmentConfig: ProgramEnrollmentConfig {
        return OEXConfig.shared().programEnrollment
    }
    
    init(with programDetailsURL: URL, andBottomBar bar: UIView?) {
        self.programDetailsURL = programDetailsURL
        super.init(with: bar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let programDetailsURL = programDetailsURL {
            webViewHelper?.loadRequest(withURL: programDetailsURL)
        }
        navigationItem.title = programEnrollmentConfig.discoveryTitle
    }
    
    override var detailTemplate: String? {
        return programEnrollmentConfig.webview.detailTemplate
    }
    
}
