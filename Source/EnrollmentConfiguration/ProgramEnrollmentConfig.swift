//
//  ProgramEnrollmentConfig.swift
//  edX
//
//  Created by Zeeshan Arif on 7/9/18.
//  Copyright © 2018 edX. All rights reserved.
//

import Foundation
import edXCore

class ProgramEnrollmentConfig: EnrollmentConfig {
    
    override var isEnabled: Bool {
        return type == .webview
    }
    
}

extension OEXConfig {
    var programEnrollment: ProgramEnrollmentConfig {
        return ProgramEnrollmentConfig(dictionary: self[EnrollmentKeys.program] as? [String:AnyObject] ?? [:])
    }
}
