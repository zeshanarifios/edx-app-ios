//
//  CourseEnrollmentConfigTests.swift
//  edX
//
//  Created by Zeeshan Arif on 7/9/18.
//  Copyright © 2018 edX. All rights reserved.
//

import XCTest
@testable import edX

class CourseEnrollmentConfigTests: XCTestCase {
    
    func testCourseEnrollmentNoConfig() {
        let config = OEXConfig(dictionary:[:])
        XCTAssertEqual(config.courseEnrollment.type, .none)
    }
    
    func testCourseEnrollmentEmptyConfig() {
        let config = OEXConfig(dictionary:["COURSE_ENROLLMENT":[:]])
        XCTAssertEqual(config.courseEnrollment.type, .none)
    }
    
    func testCourseEnrollmentWebview() {
        let sampleSearchURL = "http://example.com/course-search"
        let sampleExploreURL = "http://example.com/explore-courses"
        let sampleInfoURLTemplate = "http://example.com/{path_id}"
        
        let configDictionary = [
            "COURSE_ENROLLMENT": [
                "TYPE": "webview",
                "WEBVIEW" : [
                    "SEARCH_URL" : sampleSearchURL,
                    "EXPLORE_SUBJECTS_URL": sampleExploreURL,
                    "DETAIL_TEMPLATE" : sampleInfoURLTemplate,
                    "SEARCH_BAR_ENABLED" : true
                ]
            ]
        ]
        let config = OEXConfig(dictionary: configDictionary)
        XCTAssertEqual(config.courseEnrollment.type, .webview)
        XCTAssertEqual(config.courseEnrollment.webview.searchURL!.absoluteString, sampleSearchURL)
        XCTAssertEqual(config.courseEnrollment.webview.detailTemplate!, sampleInfoURLTemplate)
        XCTAssertEqual(config.courseEnrollment.webview.exploreSubjectsURL!.absoluteString, sampleExploreURL)
        XCTAssertTrue(config.courseEnrollment.webview.searchbarEnabled)
    }
    
}
