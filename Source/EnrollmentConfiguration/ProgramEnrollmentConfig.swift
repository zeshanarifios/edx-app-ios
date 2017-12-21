//
//  ProgramEnrollmentConfig.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 18/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import Foundation
import edXCore



class ProgramEnrollmentWebviewConfig : EnrollmentWebviewConfig {
    
}

class ProgramEnrollmentConfig: EnrollmentConfig {
    
    var webviewConfig: ProgramEnrollmentWebviewConfig
    var discoveryTitle: String{
        return Strings.discover
    }
    override var isEnabled: Bool {
        return type == .webview
    }
    
    override init(dictionary: [String: AnyObject]) {
        webviewConfig = ProgramEnrollmentWebviewConfig(dictionary: dictionary[EnrollmentKeys.webview] as? [String: AnyObject] ?? [:])
        super.init(dictionary: dictionary)
    }
    
}

private let key = "PROGRAM_ENROLLMENT"
extension OEXConfig {
    
    var programEnrollmentConfig : ProgramEnrollmentConfig {
        return ProgramEnrollmentConfig(dictionary: self[key] as? [String:AnyObject] ?? [:])
    }
    
}
