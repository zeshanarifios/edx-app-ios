//
//  ProgramDetailsWebViewController.swift
//  edX
//
//  Created by Zeeshan Arif on 7/10/18.
//  Copyright © 2018 edX. All rights reserved.
//

import Foundation

enum ProgramDetailsWebViewType {
    case discovered
    case enrolled
}

class ProgramDetailsWebViewController: WebViewController {
    
    var programDetailsWebViewType: ProgramDetailsWebViewType = .discovered
    var programDetailsURL:URL?
    var programEnrollmentConfig: ProgramEnrollmentConfig {
        return OEXConfig.shared().programEnrollment
    }
    
    init(environment: Environment?, programDetailsURL: URL, bottomBar: UIView?) {
        self.programDetailsURL = programDetailsURL
        super.init(environment: environment, bottomBar: bottomBar)
    }
    
    convenience init(environment: Environment?, programDetailsURL: URL, webViewType: ProgramDetailsWebViewType ) {
        self.init(environment: environment, programDetailsURL: programDetailsURL, bottomBar: nil)
        programDetailsWebViewType = webViewType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let programDetailsURL = programDetailsURL {
            webViewHelper?.load(withURL: programDetailsURL)
        }
        navigationItem.title = programDetailsWebViewType == .discovered ? programEnrollmentConfig.discoveryTitle : ""
    }
    
    override var detailTemplate: String? {
        return programEnrollmentConfig.webview.detailTemplate
    }
    
}
