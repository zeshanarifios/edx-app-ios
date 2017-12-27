//
//  CourseDetailsWebViewController.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 19/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import UIKit

class CourseDetailsWebViewController: DiscoverWebViewController {
    
    var pathId: String
    var courseEnrollmentConfig: CourseEnrollmentConfig {
        return OEXConfig.shared().courseEnrollment
    }
    
    var courseDetailURL:URL? {
        guard let urlString = courseEnrollmentConfig.webview.detailTemplate?.replacingOccurrences(of: DiscoverCatalog.pathPlaceHolder, with: self.pathId) else {
            return nil
        }
        return URL(string: urlString)
    }
    
    init(with pathId: String, and bottomBar: UIView?){
        self.pathId = pathId
        super.init(with: bottomBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        pathId = ""
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webViewHelper = DiscoverCoursesWebViewHelper(config:OEXConfig.shared(), delegate: self, dataSource: self, bottomBar: bottomBar)
        if let courseDetailUrl = courseDetailURL {
            webViewHelper?.loadRequest(withURL: courseDetailUrl)
        }
        navigationItem.title = courseEnrollmentConfig.discoveryTitle
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        OEXAnalytics.shared().trackScreen(withName: OEXAnalyticsScreenCourseInfo)
    }
    
    
    // MARK: - DiscoverWebViewHelperDelegate and DataSource Methods -
    override func webViewHelper(helper: DiscoverWebViewHelper, shouldLoadLinkWithRequest request: URLRequest) -> Bool {
        guard let url = request.url,
            let urlData = parse(url: url),
            let courseId = urlData.courseId else {
            return true
        }
        enrollInCourse(courseID: courseId, emailOpt: urlData.emailOptIn)
        return false

    }
    
}
