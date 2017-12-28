//
//  CourseDetailsWebViewController.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 19/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import UIKit

class CourseDetailsWebViewController: DiscoverWebViewController {
    
    var courseDetailURL:URL?
    init(with courseDetailURL: URL, andBottomBar bar: UIView?) {
        self.courseDetailURL = courseDetailURL
        super.init(with: bar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webViewHelper = DiscoverCoursesWebViewHelper(config:OEXConfig.shared(), delegate: self, dataSource: self, bottomBar: bottomBar)
        if let courseDetailUrl = courseDetailURL {
            webViewHelper?.loadRequest(withURL: courseDetailUrl)
        }
        navigationItem.title = Strings.discover
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
