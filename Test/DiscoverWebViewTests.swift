//
//  DiscoverWebViewTests.swift
//  edX
//
//  Created by Muhammad Zeeshan Arif on 01/01/2018.
//  Copyright © 2018 edX. All rights reserved.
//

import XCTest
@testable import edX

class DiscoverWebViewTests: XCTestCase {
    
    func testAppURLScheme() {
        let correctURL = URL(string: "edxapp://course_info?path_id=course/science-happiness-uc-berkeleyx-gg101x")
        let wrongURL = URL(string: "edxapps://course_info?path_id=course/science-happiness-uc-berkeleyx-gg101x")
        
        XCTAssert(correctURL!.isValidAppURLScheme, "Valid URL Scheme is not recognised")
        XCTAssertFalse(wrongURL!.isValidAppURLScheme, "Invalid URL Scheme is not recognised")
    }
    
    func testAppHost() {
        let correctURL = URL(string: "edxapp://course_info?path_id=course/science-happiness-uc-berkeleyx-gg101x")
        let wrongURL = URL(string: "edxapp://course_infos?path_id=course/science-happiness-uc-berkeleyx-gg101x")
        let discoverWebViewController = DiscoverWebViewController(with: nil)
        XCTAssertNotNil(discoverWebViewController.appURLHostIfValid(url: correctURL!))
        XCTAssertNil(discoverWebViewController.appURLHostIfValid(url: wrongURL!))
    }
    
    func testPathIdParsing() {
        guard let testURL: URL = URL(string:"edxapp://course_info?path_id=course/science-happiness-uc-berkeleyx-gg101x") else {
            XCTAssert(false, "Invalid URL Provided")
            return
        }
        let coursesWebViewController = CoursesWebViewController(with: nil)
        let pathId = coursesWebViewController.getCourseDetailPath(from: testURL)
        XCTAssertEqual(pathId, "course/science-happiness-uc-berkeleyx-gg101x", "Path Id incorrectly parsed");
    }
    
}
