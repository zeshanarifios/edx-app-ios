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
        return OEXConfig.shared().courseEnrollmentConfig
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = courseEnrollmentConfig.discoveryTitle
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        webViewHelper = DiscoverCoursesWebViewHelper(config:OEXConfig.shared(), delegate: self, dataSource: self, bottomBar: bottomBar)
        view.backgroundColor = OEXStyles.shared().standardBackgroundColor()
        webViewHelper?.searchBaseURL = courseEnrollmentConfig.webviewConfig.searchURL
        if let urlToLoad =
            coursesWebViewType ?? .discoverCourses == .discoverCourses ? courseEnrollmentConfig.webviewConfig.searchURL : courseEnrollmentConfig.webviewConfig.exploreSubjectsURL {
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
    
    // MARK: - Local Methods -
    private func showCourseDetails(with pathId: String) {
        let courseDetailsWebViewController = CourseDetailsWebViewController(with: pathId, and: bottomBar?.copy() as? UIView)
        navigationController?.pushViewController(courseDetailsWebViewController, animated: true)
    }
    
    func getCoursePathId(from url: URL) -> String? {
        if url.scheme ?? "" == DiscoverCatalog.linkURLScheme && url.hostlessPath == DiscoverCatalog.Course.detailsPath {
            let path = url.queryParameters?[DiscoverCatalog.pathIdKey] as? String
            // the site sends us things of the form "course/<path_id>" we only want the path id
            return path?.replacingOccurrences(of: DiscoverCatalog.Course.pathPrefix, with: "")
        }
        return nil
    }
    
    
    // MARK: - DiscoverWebViewHelperDelegate and DataSource Methods -
    override var webViewNativeSearchEnabled: Bool {
        return courseEnrollmentConfig.webviewConfig.nativeSearchbarEnabled 
    }
    
    override func webViewHelper(helper: DiscoverWebViewHelper, shouldLoadLinkWithRequest request: URLRequest) -> Bool {
        guard let url = request.url, let coursePathId = getCoursePathId(from: url) else {
            return true
        }
        showCourseDetails(with: coursePathId)
        return false
    }
}
