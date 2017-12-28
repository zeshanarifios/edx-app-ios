//
//  ProgramDetailsWebViewController.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 21/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import Foundation

class ProgramDetailsWebViewController: DiscoverWebViewController {
    
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
        webViewHelper = DiscoverProgramsWebViewHelper(config:OEXConfig.shared(), delegate: self, dataSource: self, bottomBar: bottomBar)
        if let programDetailsURL = programDetailsURL {
            webViewHelper?.loadRequest(withURL: programDetailsURL)
        }
        navigationItem.title = programEnrollmentConfig.discoveryTitle
    }
    
    // MARK: - DiscoverWebViewHelperDelegate and DataSource Methods -
    override func webViewHelper(helper: DiscoverWebViewHelper, shouldLoadLinkWithRequest request: URLRequest) -> Bool {
        // TODO: Remove Test Code
        let urlString = request.URLString
        let repUrlString = urlString.replacingOccurrences(of: "https://www.edx.org/", with: "edxapp://course_info?path_id=")
        guard let url = URL(string:repUrlString),//request.url,
              url.isValidAppURLScheme else {
            return true
        }
        switch url.hostlessPath {
        case DiscoverCatalog.Course.enrollPath:
            if let urlData = parse(url: url), let courseId = urlData.courseId {
                enrollInCourse(courseID: courseId, emailOpt: urlData.emailOptIn)
            }
            break
        case DiscoverCatalog.Course.detailPath:
            if let courseDetailPath = getCourseDetailPath(from: url),
                let courseDetailURLString = programEnrollmentConfig.webview.detailTemplate?.replacingOccurrences(of: DiscoverCatalog.pathPlaceHolder, with: courseDetailPath),
                let courseDetailURL = URL(string: courseDetailURLString) {
                showCourseDetails(with: courseDetailURL)
            }
            break
        default:
            break
        }
        
        return false
    }
}
