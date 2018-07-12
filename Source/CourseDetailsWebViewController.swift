//
//  CourseDetailsWebViewController.swift
//  edX
//
//  Created by Zeeshan Arif on 7/10/18.
//  Copyright © 2018 edX. All rights reserved.
//

import UIKit

class CourseDetailsWebViewController: WebViewController {
    
    var courseDetailURL:URL?
    init(environment: Environment?, courseDetailURL: URL, bottomBar: UIView?) {
        self.courseDetailURL = courseDetailURL
        super.init(environment: environment, bottomBar: bottomBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let courseDetailUrl = courseDetailURL {
            webViewHelper?.load(withURL: courseDetailUrl)
        }
        navigationItem.title = Strings.discover
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = environment?.session.currentUser {
            webViewHelper?.refreshView()
        }
        OEXAnalytics.shared().trackScreen(withName: OEXAnalyticsScreenCourseInfo)
    }
    
}
