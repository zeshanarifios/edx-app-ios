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
        return OEXConfig.shared().programEnrollmentConfig
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = programEnrollmentConfig.discoveryTitle
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        webViewHelper = DiscoverProgramsWebViewHelper(config:OEXConfig.shared(), delegate: self, bottomBar: bottomBar)
        view.backgroundColor = OEXStyles.shared().standardBackgroundColor()
        webViewHelper?.searchBaseURL = programEnrollmentConfig.webviewConfig.searchURL
        if let urlToLoad = programEnrollmentConfig.webviewConfig.searchURL
        {
            webViewHelper?.loadRequest(withURL: urlToLoad)
        }
    }
    
    func getProgramDetailsURL(from url: URL) -> URL? {
        //edxapp://course_info?path_id=https://www.edx.org/professional-certificate/ritx-soft-skills
        
        if url.scheme ?? "" == CoursesWebViewController.findCoursesLinkURLScheme {
            if let path = url.queryParameters?[CoursesWebViewController.findCoursesPathIDKey] as? String {
                return URL(string: path)
            }
        }
        return nil
        
    }
    
    private func showProgramDetails(with url: URL) {
        let controller = ProgramDetailsViewController(with: url, andBottomBar: self.bottomBar?.copy() as? UIView)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - DiscoverWebViewHelperDelegate Methods -
    override var webViewNativeSearchEnabled: Bool {
        return programEnrollmentConfig.webviewConfig.nativeSearchbarEnabled
    }
    
    override func webViewHelper(helper: DiscoverWebViewHelper, shouldLoadLinkWithRequest request: URLRequest) -> Bool {
        guard let url = request.url,
            let programDetailsURL = getProgramDetailsURL(from: url) else {
            return true
        }
        showProgramDetails(with: programDetailsURL)
        return false
    }
    
}
