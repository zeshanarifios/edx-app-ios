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

class CoursesWebViewController: WebViewController {
    
    var coursesWebViewType: CoursesWebViewType?
    var courseEnrollmentConfig: CourseEnrollmentConfig {
        return OEXConfig.shared().courseEnrollment
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = courseEnrollmentConfig.discoveryTitle
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if let urlToLoad =
            coursesWebViewType ?? .discoverCourses == .discoverCourses ? courseEnrollmentConfig.webview.searchURL : courseEnrollmentConfig.webview.exploreSubjectsURL {
            webViewHelper?.webView.accessibilityIdentifier = "find-courses-webview"
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
    
    override var detailTemplate: String? {
        return courseEnrollmentConfig.webview.detailTemplate
    }
    
    override var webViewNativeSearchEnabled: Bool {
        return courseEnrollmentConfig.webview.searchbarEnabled
    }
    
    override var webViewSearchBaseURL: URL? {
        return courseEnrollmentConfig.webview.searchURL
    }
    
    override func webViewDidFinishLoading(_ helper: WebViewHelper) {
        // Setting webView accessibilityValue for testing
        let script = "document.getElementsByClassName('course-card')[0].innerText"
        helper.webView.evaluateJavaScript(script, completionHandler: {
            (result: Any?, error: Error?) in
            if (error == nil) {
                helper.webView.accessibilityValue = "findCoursesLoaded"
            }
        })
    }

}
