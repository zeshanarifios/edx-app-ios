//
//  WebViewEnums.swift
//  edX
//
//  Created by Zeeshan Arif on 7/9/18.
//  Copyright © 2018 edX. All rights reserved.
//

import Foundation

enum AppURLString: String {
    case appURLScheme = "edxapp"
    case pathPlaceHolder = "{path_id}"
}

enum QueryParameterKeys: String {
    case pathId = "path_id";
    case courseId = "course_id"
    case emailOptIn = "email_opt_in"
    case searchQuery = "search_query"
    case subject = "subject"
}

// Define Your Hosts Here
enum AppURLHost: String {
    case courseEnrollment = "enroll"
    case courseDetail = "course_info"
    case programDetail = "program_info"
    case enrolledCourseDetail = "enrolled_course_info"
    case enrolledProgramDetail = "enrolled_program_info"
}
