//
//  WebViewEnums.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 21/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import Foundation

enum AppURLString: String {
    case appURLScheme = "edxapp"
    case pathPlaceHolder = "{path_id}"
}

enum AppURLParameterKey: String, RawStringExtractable {
    case pathId = "path_id";
    case courseId = "course_id"
    case emailOptIn = "email_opt_in"
}

// Define Your Hosts Here
enum AppURLHost: String {
    case courseEnrollment = "enroll"
    case courseDetail = "course_info"
    case programDetail = "program_info"
}
