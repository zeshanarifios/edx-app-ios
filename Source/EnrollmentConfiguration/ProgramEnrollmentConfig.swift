//
//  ProgramEnrollmentConfig.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 18/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import Foundation
import edXCore

private enum ProgramEnrollmentKeys: String, RawStringExtractable {
    case courseDetailTemplate = "COURSE_DETAIL_TEMPLATE"
}

class ProgramEnrollmentWebviewConfig : EnrollmentWebviewConfig {
    
    let courseDetailTemplate: String?
    
    override init(dictionary: [String: AnyObject]) {
        courseDetailTemplate = dictionary[ProgramEnrollmentKeys.courseDetailTemplate] as? String
        super.init(dictionary: dictionary)
    }
}

class ProgramEnrollmentConfig: EnrollmentConfig {
    
    var webview: ProgramEnrollmentWebviewConfig
    var discoveryTitle: String{
        return Strings.discover
    }
    override var isEnabled: Bool {
        return type == .webview
    }
    
    override init(dictionary: [String: AnyObject]) {
        webview = ProgramEnrollmentWebviewConfig(dictionary: dictionary[EnrollmentKeys.webview] as? [String: AnyObject] ?? [:])
        super.init(dictionary: dictionary)
    }
    
}

extension OEXConfig {
    var programEnrollment : ProgramEnrollmentConfig {
        return ProgramEnrollmentConfig(dictionary: self[EnrollmentKeys.program] as? [String:AnyObject] ?? [:])
    }
}
