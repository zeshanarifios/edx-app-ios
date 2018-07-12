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
    case type = "TYPE"
    case webview = "WEBVIEW"
    case searchURL = "SEARCH_URL"
    case course = "COURSE_ENROLLMENT"
    case program = "PROGRAM_ENROLLMENT"
    case detailTemplate = "DETAIL_TEMPLATE"
    case searchBarEnabled = "SEARCH_BAR_ENABLED"
    case subjectDiscoveryEnabled = "SUBJECT_DISCOVERY_ENABLED"
    case exploreSubjectsURL = "EXPLORE_SUBJECTS_URL"
}

class EnrollmentWebviewConfig: NSObject {
    
    let searchURL: URL?
    let detailTemplate: String?
    let searchbarEnabled: Bool
    let exploreSubjectsURL: URL?
    let subjectDiscoveryEnabled: Bool
    
    init(dictionary: [String: AnyObject]) {
        searchURL = (dictionary[EnrollmentKeys.searchURL] as? String).flatMap { URL(string:$0)}
        detailTemplate = dictionary[EnrollmentKeys.detailTemplate] as? String
        searchbarEnabled = dictionary[EnrollmentKeys.searchBarEnabled] as? Bool ?? false
        subjectDiscoveryEnabled = dictionary[EnrollmentKeys.subjectDiscoveryEnabled] as? Bool ?? false

        exploreSubjectsURL = (dictionary[EnrollmentKeys.exploreSubjectsURL] as? String).flatMap { URL(string:$0)}
        super.init()
    }
    
}

class EnrollmentConfig: NSObject {
    
    let type: EnrollmentType
    var webview: EnrollmentWebviewConfig
    
    var isEnabled: Bool{
        return type != .none
    }
    var discoveryTitle: String{
        return Strings.discover
    }
    
    init(dictionary: [String: AnyObject]) {
        type = (dictionary[EnrollmentKeys.type] as? String).flatMap { EnrollmentType(rawValue: $0) } ?? .none
        webview = EnrollmentWebviewConfig(dictionary: dictionary[EnrollmentKeys.webview] as? [String: AnyObject] ?? [:])
    }
    
}
