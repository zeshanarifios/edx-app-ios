//
//  CourseDetailsWebViewController.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 19/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import UIKit

class CourseDetailsWebViewController: WebViewController {
    
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
        if let courseDetailUrl = courseDetailURL {
            webViewHelper?.loadRequest(withURL: courseDetailUrl)
        }
        navigationItem.title = Strings.discover
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        OEXAnalytics.shared().trackScreen(withName: OEXAnalyticsScreenCourseInfo)
    }
    
}
