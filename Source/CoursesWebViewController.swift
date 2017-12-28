//
//  CoursesWebViewController.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 18/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import UIKit

enum CoursesWebViewType {
    case discoverCourses
    case exploreSubjects
}

class CoursesWebViewController: DiscoverWebViewController{
    
    var coursesWebViewType: CoursesWebViewType?
    var courseEnrollmentConfig: CourseEnrollmentConfig {
        return OEXConfig.shared().courseEnrollment
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = courseEnrollmentConfig.discoveryTitle
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        webViewHelper = DiscoverCoursesWebViewHelper(config:OEXConfig.shared(), delegate: self, dataSource: self, bottomBar: bottomBar)
        view.backgroundColor = OEXStyles.shared().standardBackgroundColor()
        webViewHelper?.searchBaseURL = courseEnrollmentConfig.webview.searchURL
        if let urlToLoad =
            coursesWebViewType ?? .discoverCourses == .discoverCourses ? courseEnrollmentConfig.webview.searchURL : courseEnrollmentConfig.webview.exploreSubjectsURL {
            webViewHelper?.loadRequest(withURL: urlToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        OEXAnalytics.shared().trackScreen(withName: OEXAnalyticsScreenFindCourses)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return OEXStyles.shared().standardStatusBarStyle();
    }
    
    // MARK: - DiscoverWebViewHelperDelegate and DataSource Methods -
    override var webViewNativeSearchEnabled: Bool {
        return courseEnrollmentConfig.webview.searchbarEnabled
    }
    
    override func webViewHelper(helper: DiscoverWebViewHelper, shouldLoadLinkWithRequest request: URLRequest) -> Bool {
        guard let url = request.url,
            let courseDetailPath = getCourseDetailPath(from: url),
            let courseDetailURLString = courseEnrollmentConfig.webview.detailTemplate?.replacingOccurrences(of: DiscoverCatalog.pathPlaceHolder, with: courseDetailPath),
            let courseDetailURL = URL(string: courseDetailURLString) else {
            return true
        }
        
        showCourseDetails(with: courseDetailURL)
        return false
    }
}
