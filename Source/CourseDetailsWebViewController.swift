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
        return OEXConfig.shared().courseEnrollmentConfig
    }
    
    var courseDetailsURL:URL? {
        guard let urlString = courseEnrollmentConfig.webviewConfig.courseInfoURLTemplate?.replacingOccurrences(of: DiscoverCatalog.pathIdPlaceHolder, with: self.pathId) else {
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
        if let courseDetailsUrl = courseDetailsURL {
            webViewHelper?.loadRequest(withURL: courseDetailsUrl)
        }
        navigationItem.title = courseEnrollmentConfig.discoveryTitle
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        OEXAnalytics.shared().trackScreen(withName: OEXAnalyticsScreenCourseInfo)
    }
    func parse(url: URL) -> (courseId: String?, emailOptIn: Bool)? {
        guard let scheme = url.scheme, (scheme == DiscoverCatalog.linkURLScheme && url.hostlessPath == DiscoverCatalog.Course.enrollPath) else {
            return nil
        }
        let courseId = url.queryParameters?[DiscoverCatalog.Course.courseIdKey] as? String
        let emailOptIn = url.queryParameters?[DiscoverCatalog.emailOptInKey] as? Bool
        return (courseId , emailOptIn ?? false)
    }
    
    func showMainScreen(with message: String, and courseId: String) {
        OEXRouter.shared().showMyCourses(animated: true, pushingCourseWithID: courseId)
        perform(#selector(postEnrollmentSuccessNotification), with: message, afterDelay: 0.5)
    }
    
    func postEnrollmentSuccessNotification(message: String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: EnrollmentShared.successNotification), object: message)
        if isModal() {
            view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func enrollInCourse(courseID: String, emailOpt: Bool) {
        
        let environment = OEXRouter.shared().environment;
        environment.analytics.trackCourseEnrollment(courseId: courseID, name: AnalyticsEventName.CourseEnrollmentClicked.rawValue, displayName: AnalyticsDisplayName.EnrolledCourseClicked.rawValue)
        
        guard let _ = OEXSession.shared()?.currentUser else {
            OEXRouter.shared().showSignUpScreen(from: self, completion: {
                self.enrollInCourse(courseID: courseID, emailOpt: emailOpt)
            })
            return;
        }
        
        if let _ = environment.dataManager.enrollmentManager.enrolledCourseWithID(courseID: courseID) {
            showMainScreen(with: Strings.findCoursesAlreadyEnrolledMessage, and: courseID)
            return
        }
        
        let request = CourseCatalogAPI.enroll(courseID: courseID)
        environment.networkManager.taskForRequest(request) {[weak self] response in
            if response.response?.httpStatusCode.is2xx ?? false {
                environment.analytics.trackCourseEnrollment(courseId: courseID, name: AnalyticsEventName.CourseEnrollmentSuccess.rawValue, displayName: AnalyticsDisplayName.EnrolledCourseSuccess.rawValue)
                self?.showMainScreen(with: Strings.findCoursesEnrollmentSuccessfulMessage, and: courseID)
            }
            else {
                self?.showOverlay(withMessage: Strings.findCoursesEnrollmentErrorDescription)
            }
        }
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
