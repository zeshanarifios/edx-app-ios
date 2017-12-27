//
//  EnrollmentConfig.swift
//  edX
//
//  Created by Akiva Leffert on 1/5/16.
//  Copyright © 2016 edX. All rights reserved.
//

import Foundation
import edXCore

enum EnrollmentType : String {
    case native = "native"
    case webview = "webview"
    case none = "none"
}

enum EnrollmentKeys: String, RawStringExtractable {
    case program = "PROGRAM_ENROLLMENT"
    case course = "COURSE_ENROLLMENT"
    case searchBarEnabled = "SEARCH_BAR_ENABLED"
    case detailTemplate = "DETAIL_TEMPLATE"
    case searchURL = "SEARCH_URL"
    case enrollmentType = "TYPE"
    case webview = "WEBVIEW"
}

class EnrollmentWebviewConfig: NSObject {
    
    let searchURL: URL?
    let detailTemplate: String?
    let searchbarEnabled: Bool
    
    init(dictionary: [String: AnyObject]) {
        searchURL = (dictionary[EnrollmentKeys.searchURL] as? String).flatMap { URL(string:$0)}
        detailTemplate = dictionary[EnrollmentKeys.detailTemplate] as? String
        searchbarEnabled = dictionary[EnrollmentKeys.searchBarEnabled] as? Bool ?? false
        super.init()
    }
    
}

class EnrollmentConfig : NSObject {
    
    let type: EnrollmentType
    var isEnabled : Bool{
        return type != .none
    }
    
    init(dictionary: [String: AnyObject]) {
        type = (dictionary[EnrollmentKeys.enrollmentType] as? String).flatMap { EnrollmentType(rawValue: $0) } ?? .none
    }
    
}
