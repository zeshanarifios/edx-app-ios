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
    
    static let linkURLScheme = "edxapp"
    static let pathIdPlaceHolder = "{path_id}"
    static let emailOptInKey = "email_opt_in"
    static let pathIdKey = "path_id";
    
    enum Course {
        static let enrollPath = "enroll/"
        static let courseIdKey = "course_id"
        static let detailsPath = "course_info/";
        static var pathPrefix = "course/";
    }
    
}
