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
    
    var webviewConfig: EnrollmentWebviewConfig
    var discoveryTitle: String{
        return Strings.discover
    }
    override var isEnabled: Bool {
        return type == .webview
    }
    
    override init(dictionary: [String: AnyObject]) {
        webviewConfig = EnrollmentWebviewConfig(dictionary: dictionary[EnrollmentKeys.webview] as? [String: AnyObject] ?? [:])
        super.init(dictionary: dictionary)
    }
    
}

extension OEXConfig {
    var programEnrollmentConfig : ProgramEnrollmentConfig {
        return ProgramEnrollmentConfig(dictionary: self[EnrollmentKeys.program] as? [String:AnyObject] ?? [:])
    }
}
