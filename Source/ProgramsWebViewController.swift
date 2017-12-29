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
        webViewHelper?.searchBaseURL = programEnrollmentConfig.webview.searchURL
        if let urlToLoad = programEnrollmentConfig.webview.searchURL
        {
            webViewHelper?.loadRequest(withURL: urlToLoad)
        }
    }
    
    func getProgramDetailsURL(from url: URL) -> URL? {
        // TODO: Remove path.replacingOccurrences(of: "https://www.edx.org/", with: "")
        guard url.isValidAppURLScheme,
            let path = url.queryParameters?[AppURLParameterKey.pathId] as? String,
            let programDetailUrlString = programEnrollmentConfig.webview.detailTemplate?.replacingOccurrences(of: AppURLString.pathPlaceHolder.rawValue, with: path.replacingOccurrences(of: "https://www.edx.org/", with: ""))
        else {
            return nil
        }
        return URL(string: programDetailUrlString)
    }
    
    private func showProgramDetails(with url: URL) {
        let controller = ProgramDetailsWebViewController(with: url, andBottomBar: self.bottomBar?.copy() as? UIView)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - DiscoverWebViewHelperDelegate and DataSource Methods -
    override var webViewNativeSearchEnabled: Bool {
        return programEnrollmentConfig.webview.searchbarEnabled
    }
    
    override func webViewHelper(helper: DiscoverWebViewHelper, shouldLoadLinkWithRequest request: URLRequest) -> Bool {
        guard let url = request.url,
            url.isValidAppURLScheme,
            url.host ?? "" == AppURLHost.programDetail.rawValue,
            let programDetailsURL = getProgramDetailsURL(from: url) else {
            return true
        }
        showProgramDetails(with: programDetailsURL)
        return false
    }
    
}
