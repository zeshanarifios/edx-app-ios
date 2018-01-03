//
//  CourseEnrollmentConfig.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 18/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import Foundation
import edXCore

class CourseEnrollmentConfig: EnrollmentConfig {
    
    override var discoveryTitle: String{
        return type == .native ? Strings.findCourses : Strings.discover
    }
    
}

extension OEXConfig {
    var courseEnrollment : CourseEnrollmentConfig {
        return CourseEnrollmentConfig(dictionary: self[EnrollmentKeys.course] as? [String:AnyObject] ?? [:])
    }
}
