//
//  CoursesWebViewController.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 18/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import UIKit

enum DiscoverCoursesBaseType {
    case discoverCourses
    case exploreSubjects
}

class CoursesWebViewController: DiscoverWebViewController{
    
    static var findCoursesLinkURLScheme = "edxapp"
    static var findCoursesCourseInfoPath = "course_info/";
    static var findCoursesPathIDKey = "path_id";
    static var findCoursePathPrefix = "course/";
    
    var startURL: DiscoverCoursesBaseType?
    var courseEnrollmentConfig: CourseEnrollmentConfig {
        return OEXConfig.shared().courseEnrollmentConfig
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = courseEnrollmentConfig.discoveryTitle
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        webViewHelper = DiscoverCoursesWebViewHelper(config:OEXConfig.shared(), delegate: self, bottomBar: bottomBar)
        view.backgroundColor = OEXStyles.shared().standardBackgroundColor()
        webViewHelper?.searchBaseURL = courseEnrollmentConfig.webviewConfig.searchURL
        var urlToLoad: URL?
        switch startURL ?? .discoverCourses {
        case .discoverCourses:
            urlToLoad = courseEnrollmentConfig.webviewConfig.searchURL
            break
        case .exploreSubjects:
            urlToLoad = courseEnrollmentConfig.webviewConfig.exploreSubjectsURL
            break
        }
        if let urlToLoad = urlToLoad
        {
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
    
    // // MARK: - Local Methods -
    private func showCourseDetails(with pathId: String) {
        let courseDetailsWebViewController = CourseDetailsWebViewController(with: pathId, and: bottomBar?.copy() as? UIView)
        navigationController?.pushViewController(courseDetailsWebViewController, animated: true)
    }
    
    func getCoursePathId(from url: URL) -> String? {
        if url.scheme ?? "" == CoursesWebViewController.findCoursesLinkURLScheme && url.hostlessPath == CoursesWebViewController.findCoursesCourseInfoPath {
            let path = url.queryParameters?[CoursesWebViewController.findCoursesPathIDKey] as? String
            // the site sends us things of the form "course/<path_id>" we only want the path id
            return path?.replacingOccurrences(of: CoursesWebViewController.findCoursePathPrefix, with: "")
        }
        return nil
    }
    
    
    // MARK: - DiscoverWebViewHelperDelegate Methods -
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
