//
//  CourseEnrollmentConfig.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 18/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import Foundation
import edXCore

private enum CourseEnrollmentKeys: String, RawStringExtractable {
    case exploreSubjectsURL = "EXPLORE_SUBJECTS_URL"
    case courseInfoURLTemplate = "COURSE_INFO_URL_TEMPLATE"
}

class CourseEnrollmentWebviewConfig : EnrollmentWebviewConfig {
    
    let exploreSubjectsURL: URL?
    let courseInfoURLTemplate: String?
    
    override init(dictionary: [String: AnyObject]) {
        courseInfoURLTemplate = dictionary[CourseEnrollmentKeys.courseInfoURLTemplate] as? String
        exploreSubjectsURL = (dictionary[CourseEnrollmentKeys.exploreSubjectsURL] as? String).flatMap { URL(string:$0)}
        super.init(dictionary: dictionary)
    }
}

class CourseEnrollmentConfig: EnrollmentConfig {
    
    var webviewConfig: CourseEnrollmentWebviewConfig
    var discoveryTitle: String{
        return type == .native ? Strings.findCourses : Strings.discover
    }
    
    override init(dictionary: [String: AnyObject]) {
        webviewConfig = CourseEnrollmentWebviewConfig(dictionary: dictionary[EnrollmentKeys.webview] as? [String: AnyObject] ?? [:])
        super.init(dictionary: dictionary)
    }
    
}


extension OEXConfig {
    var courseEnrollmentConfig : CourseEnrollmentConfig {
        return CourseEnrollmentConfig(dictionary: self[EnrollmentKeys.course] as? [String:AnyObject] ?? [:])
    }
}
