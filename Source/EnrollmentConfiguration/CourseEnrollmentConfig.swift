//
//  CourseEnrollmentConfig.swift
//  edX
//
//  Created by Zeeshan Arif on 7/9/18.
//  Copyright © 2018 edX. All rights reserved.
//

import Foundation
import edXCore

class CourseEnrollmentConfig: EnrollmentConfig {
    
    override var discoveryTitle: String{
        return type == .native ? Strings.findCourses : Strings.discover
    }
    
}

extension OEXConfig {
    var courseEnrollment: CourseEnrollmentConfig {
        return CourseEnrollmentConfig(dictionary: self[EnrollmentKeys.course] as? [String:AnyObject] ?? [:])
    }
}
