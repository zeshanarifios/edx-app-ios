//
//  ProgramEnrollmentConfig.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 18/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import Foundation
import edXCore


class ProgramEnrollmentConfig: EnrollmentConfig {
    
    var webview: EnrollmentWebviewConfig
    var discoveryTitle: String{
        return Strings.discover
    }
    override var isEnabled: Bool {
        return type == .webview
    }
    
    override init(dictionary: [String: AnyObject]) {
        webview = EnrollmentWebviewConfig(dictionary: dictionary[EnrollmentKeys.webview] as? [String: AnyObject] ?? [:])
        super.init(dictionary: dictionary)
    }
    
}

extension OEXConfig {
    var programEnrollment : ProgramEnrollmentConfig {
        return ProgramEnrollmentConfig(dictionary: self[EnrollmentKeys.program] as? [String:AnyObject] ?? [:])
    }
}
