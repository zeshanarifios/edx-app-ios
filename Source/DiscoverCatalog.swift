//
//  DiscoverCatalog.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 21/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import Foundation
import UIKit

enum DiscoverCatalog {
    
    static let appURLScheme = "edxapp"
    static let pathPlaceHolder = "{path_id}"
    static let emailOptInKey = "email_opt_in"
    static let pathKey = "path_id";
    
    enum Course {
        static let enrollPath = "enroll/"
        static let courseIdKey = "course_id"
        static let detailPath = "course_info/"
    }
    
    enum Program {
        static let detailPath = "program_info/"
    }
    
}
