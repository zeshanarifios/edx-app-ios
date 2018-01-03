//
//  WebViewController.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 19/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, WebViewHelperDelegate {
    
    var bottomBar: UIView?
    var webViewHelper: WebViewHelper?
    var detailTemplate: String? {
        return nil
    }
    
    init(with bottomBar: UIView?) {
        self.bottomBar = bottomBar
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webViewHelper = WebViewHelper(config:OEXConfig.shared(), delegate: self, bottomBar: bottomBar)
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
    func appURLHostIfValid(url: URL) -> AppURLHost? {
        guard url.isValidAppURLScheme, let appURLHost = AppURLHost(rawValue: url.appURLHost) else {
            return nil
        }
        return appURLHost
    }
    
    private func navigate(to url: URL) -> Bool {
        guard let appURLHost = appURLHostIfValid(url: url) else { return false }
        switch appURLHost {
        case .courseDetail:
            if let courseDetailPath = getCourseDetailPath(from: url),
                let courseDetailURLString = detailTemplate?.replacingOccurrences(of: AppURLString.pathPlaceHolder.rawValue, with: courseDetailPath),
                let courseDetailURL = URL(string: courseDetailURLString) {
                showCourseDetails(with: courseDetailURL)
            }
            break
        case .courseEnrollment:
            if let urlData = parse(url: url), let courseId = urlData.courseId {
                enrollInCourse(courseID: courseId, emailOpt: urlData.emailOptIn)
            }
            break
        case .programDetail:
            if let programDetailsURL = getProgramDetailsURL(from: url) {
                showProgramDetails(with: programDetailsURL)
            }
            break
        }
        return true
    }
    
    private func getProgramDetailsURL(from url: URL) -> URL? {
        guard url.isValidAppURLScheme,
            let path = url.queryParameters?[AppURLParameterKey.pathId] as? String,
            let programDetailUrlString = detailTemplate?.replacingOccurrences(of: AppURLString.pathPlaceHolder.rawValue, with: path)
            else {
                return nil
        }
        return URL(string: programDetailUrlString)
    }
    
    private func showProgramDetails(with url: URL) {
        let controller = ProgramDetailsWebViewController(with: url, andBottomBar: self.bottomBar?.copy() as? UIView)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func showCourseDetails(with url: URL) {
        let courseDetailsWebViewController = CourseDetailsWebViewController(with: url, andBottomBar: bottomBar?.copy() as? UIView)
        navigationController?.pushViewController(courseDetailsWebViewController, animated: true)
    }
    
    func getCourseDetailPath(from url: URL) -> String? {
        return url.isValidAppURLScheme && url.appURLHost == AppURLHost.courseDetail.rawValue ? url.queryParameters?[AppURLParameterKey.pathId] as? String : nil
    }
    
    func parse(url: URL) -> (courseId: String?, emailOptIn: Bool)? {
        guard url.isValidAppURLScheme, url.appURLHost == AppURLHost.courseEnrollment.rawValue else {
            return nil
        }
        let courseId = url.queryParameters?[AppURLParameterKey.courseId] as? String
        let emailOptIn = url.queryParameters?[AppURLParameterKey.emailOptIn] as? Bool
        return (courseId , emailOptIn ?? false)
    }
    
    private func showMainScreen(with message: String, and courseId: String) {
        OEXRouter.shared().showMyCourses(animated: true, pushingCourseWithID: courseId)
        perform(#selector(postEnrollmentSuccessNotification), with: message, afterDelay: 0.5)
    }
    
    private func postEnrollmentSuccessNotification(message: String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: EnrollmentShared.successNotification), object: message)
        if isModal() {
            view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    private func enrollInCourse(courseID: String, emailOpt: Bool) {
        
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
    
    // MARK: - WebViewHelperDelegate -
    
    var webViewNativeSearchEnabled: Bool {
        return false
    }
    
    var webViewSearchBaseURL: URL? {
        return nil
    }
    
    var webViewParentController: UIViewController {
        return self
    }
    
    func webView(helper: WebViewHelper, shouldLoad request: URLRequest) -> Bool {
        guard let url = request.url else {
            return true
        }
        let didNavigate = navigate(to: url)
        return !didNavigate
    }
    
    func webViewDidFinishLoading(_ helper: WebViewHelper) {
    }
    
}
