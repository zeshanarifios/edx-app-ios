//
//  DiscoverWebViewController.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 19/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import UIKit

class DiscoverWebViewController: UIViewController, DiscoverWebViewHelperDelegate, DiscoverWebViewHelperDataSource {

    var bottomBar: UIView?
    var webViewHelper: DiscoverWebViewHelper?
    
    init(with bottomBar: UIView?) {
        self.bottomBar = bottomBar
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = OEXStyles.shared().standardBackgroundColor()
        navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if OEXSession.shared()?.currentUser != nil {
            webViewHelper?.bottomBar?.removeFromSuperview()
        }
    }
    
    // MARK: - Local Methods -
    func showCourseDetails(with url: URL) {
        let courseDetailsWebViewController = CourseDetailsWebViewController(with: url, andBottomBar: bottomBar?.copy() as? UIView)
        navigationController?.pushViewController(courseDetailsWebViewController, animated: true)
    }
    
    func getCourseDetailPath(from url: URL) -> String? {
        return url.isValidAppURLScheme && url.hostlessPath == DiscoverCatalog.Course.detailPath ? url.queryParameters?[DiscoverCatalog.pathKey] as? String : nil
    }
    func parse(url: URL) -> (courseId: String?, emailOptIn: Bool)? {
        guard url.isValidAppURLScheme, url.hostlessPath == DiscoverCatalog.Course.enrollPath else {
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
    var webViewNativeSearchEnabled: Bool {
        return false
    }
    var webViewParentController: UIViewController {
        return self
    }
    func webViewHelper(helper: DiscoverWebViewHelper, shouldLoadLinkWithRequest request: URLRequest) -> Bool {
        return true
    }
    
    

}
