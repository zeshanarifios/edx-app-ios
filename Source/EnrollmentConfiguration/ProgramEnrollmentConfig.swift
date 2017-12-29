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
    
    override var isEnabled: Bool {
        return type == .webview
    }
    
}

extension OEXConfig {
    var programEnrollment : ProgramEnrollmentConfig {
        return ProgramEnrollmentConfig(dictionary: self[EnrollmentKeys.program] as? [String:AnyObject] ?? [:])
    }
}
