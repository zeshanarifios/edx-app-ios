//
//  CoursesWebViewController.swift
//  edX
//
//  Created by Zeeshan Arif on 7/10/18.
//  Copyright © 2018 edX. All rights reserved.
//

import UIKit

enum CoursesWebViewType {
    case discoverCourses
    case exploreSubjects
}

class CoursesWebViewController: WebViewController {
    
    private var searchQuery: String?
    private var coursesWebViewType: CoursesWebViewType?
    private var courseEnrollmentConfig: CourseEnrollmentConfig {
        return OEXConfig.shared().courseEnrollment
    }
    
    init(environment: Environment, bottomBar: UIView?, searchQuery: String?) {
        self.searchQuery = searchQuery
        super.init(environment: environment, bottomBar: bottomBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webViewHelper = WebViewHelper(environment: environment, delegate: self, bottomBar: bottomBar, searchQuery: searchQuery)
        
        navigationItem.title = courseEnrollmentConfig.discoveryTitle
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if let urlToLoad =
            coursesWebViewType ?? .discoverCourses == .discoverCourses ? courseEnrollmentConfig.webview.searchURL : courseEnrollmentConfig.webview.exploreSubjectsURL {
            webViewHelper?.webView.accessibilityIdentifier = "find-courses-webview"
            webViewHelper?.load(withURL: urlToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = environment?.session.currentUser {
            webViewHelper?.refreshView()
        }
        environment?.analytics.trackScreen(withName: OEXAnalyticsScreenFindCourses)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webViewHelper?.updateSubjectsVisibility()
    }
    
    override var detailTemplate: String? {
        return courseEnrollmentConfig.webview.detailTemplate
    }
    
    override var webViewNativeSearchEnabled: Bool {
        return courseEnrollmentConfig.webview.searchbarEnabled
    }
    
    override var webViewSubjectsEnabled: Bool {
        return true
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
