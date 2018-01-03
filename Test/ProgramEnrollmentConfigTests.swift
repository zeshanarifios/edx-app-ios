//
//  ProgramEnrollmentConfigTests.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 18/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import XCTest
@testable import edX

class ProgramEnrollmentConfigTests: XCTestCase {
    
    func testProgramEnrollmentNoConfig() {
        let config = OEXConfig(dictionary:[:])
        XCTAssertEqual(config.programEnrollment.type, .none)
    }
    
    func testProgramEnrollmentEmptyConfig() {
        let config = OEXConfig(dictionary:["PROGRAM_ENROLLMENT":[:]])
        XCTAssertEqual(config.programEnrollment.type, .none)
    }
    
    func testProgramEnrollmentWebview() {
        let sampleSearchURL = "http://example.com/program-search"
        let sampleDetailTemplate = "http://example.com/{path_id}"
        let configDictionary = [
            "PROGRAM_ENROLLMENT": [
                "TYPE": "webview",
                "WEBVIEW" : [
                    "SEARCH_URL" : sampleSearchURL,
                    "DETAIL_TEMPLATE" : sampleDetailTemplate,
                    "SEARCH_BAR_ENABLED" : true
                ]
            ]
        ]
        let config = OEXConfig(dictionary: configDictionary)
        XCTAssertEqual(config.programEnrollment.type, .webview)
        XCTAssertEqual(config.programEnrollment.webview.detailTemplate!, sampleDetailTemplate)
        XCTAssertEqual(config.programEnrollment.webview.searchURL!.absoluteString, sampleSearchURL)
        XCTAssertTrue(config.programEnrollment.webview.searchbarEnabled)
    }
    
}
