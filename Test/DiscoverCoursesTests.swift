//
//  DiscoverCoursesTests.swift
//  edXTests
//
//  Created by Muhammad Zeeshan Arif on 21/12/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import XCTest
@testable import edX

class DiscoverCoursesTests: XCTestCase {
    
    func testDiscoverCoursesURLRecognition() {
        guard let correctURL = URL(string: "edxapp://course_info?path_id=course/science-happiness-uc-berkeleyx-gg101x"),
            let wrongURL = URL(string: "edxapps://course_infos?path_id=course/science-happiness-uc-berkeleyx-gg101x") else {
                XCTAssert(true, "Invalid URL Provided")
                return
        }
        let helper = DiscoverCoursesWebViewHelper(config:nil, delegate: nil, dataSource: nil, bottomBar: nil)
        let coursesWebViewController = CoursesWebViewController(with: nil)
        let testCorrectURLRequest = URLRequest(url: correctURL)
        let testShouldLoadLinkWithCorrectRequest = !coursesWebViewController.webViewHelper(helper: helper, shouldLoadLinkWithRequest: testCorrectURLRequest)
        XCTAssert(testShouldLoadLinkWithCorrectRequest, "Correct URL not recognized")
        let testWrongURLRequest = URLRequest(url: wrongURL)
        let testShouldLoadLinkWithWrongRequest = coursesWebViewController.webViewHelper(helper: helper, shouldLoadLinkWithRequest: testWrongURLRequest)
        XCTAssert(testShouldLoadLinkWithWrongRequest, "Wrong URL not recognized")
    }
    
    func testPathIdParsing() {
        guard let testURL: URL = URL(string:"edxapp://course_info?path_id=course/science-happiness-uc-berkeleyx-gg101x") else {
            XCTAssert(true, "Invalid URL Provided")
            return
        }
        let coursesWebViewController = CoursesWebViewController(with: nil)
        let pathId = coursesWebViewController.getCourseDetailPath(from: testURL)
        XCTAssertEqual(pathId, "science-happiness-uc-berkeleyx-gg101x", "Path Id incorrectly parsed");
    }
    
//    func testEnrollURLParsing() {
//        guard let testEnrollURL: URL = URL(string:"edxapp://enroll?course_id=course-v1:BerkeleyX+GG101x-2+1T2015&email_opt_in=false") else {
//            XCTAssert(true, "Invalid URL Provided")
//            return
//        }
//        let courseDetailsWebViewController = CourseDetailsWebViewController(with: "abc", andBottomBar: nil)
//        if let testData = courseDetailsWebViewController.parse(url: testEnrollURL){
//            if let courseId = testData.courseId {
//                XCTAssertEqual(courseId, "course-v1:BerkeleyX+GG101x-2+1T2015", "Course ID incorrectly parsed")
//            }
//            else {
//                XCTAssert(true, "Course Id Not Found")
//            }
//            XCTAssertEqual(testData.emailOptIn, false, "Email Opt-In incorrectly parsed")
//        }
//    }
    // Disabled for now since this test makes bad assumptions about the current configuration
    // TODO: Needs to Discuss crash.
//    func disable_testCourseInfoURLTemplateSubstitution() {
//        let courseDetailsWebViewController = CourseDetailsWebViewController(with:"science-happiness-uc-berkeleyx-gg101x", andBottomBar:nil)
//        let courseURLString = courseDetailsWebViewController.courseDetailURL?.absoluteString
//        XCTAssertEqual(courseURLString, "https://webview.edx.org/course/science-happiness-uc-berkeleyx-gg101x", "Course Info URL incorrectly determined");
//    }
    
    func testSearchQueryBare() {
        let baseURL = "http://www.fakex.com/course"
        let queryString = "mobile linux"
        let expected = "http://www.fakex.com/course?search_query=mobile+linux"
        let expectedURL = URL(string: expected)
        let output = DiscoverWebViewHelper.buildQuery(baseURL: baseURL, toolbarString: queryString)
        XCTAssertEqual(output, expectedURL);
    }
    
    func testSearchQueryAlreadyHasQuery() {
        let baseURL = "http://www.fakex.com/course?type=mobile"
        let queryString = "mobile linux"
        let expected = "http://www.fakex.com/course?type=mobile&search_query=mobile+linux"
        let expectedURL = URL(string: expected)
        let output = DiscoverWebViewHelper.buildQuery(baseURL: baseURL, toolbarString: queryString)
        XCTAssertEqual(output, expectedURL);
    }
    
}
