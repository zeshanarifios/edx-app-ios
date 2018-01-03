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
        
        let correctURL = URL(string: "edxapp://course_info?path_id=course/science-happiness-uc-berkeleyx-gg101x")
        let wrongURL = URL(string: "edxapps://course_infos?path_id=course/science-happiness-uc-berkeleyx-gg101x")
        let coursesWebViewController = CoursesWebViewController(with: nil)
        if let correctAppHost = coursesWebViewController.appURLHostIfValid(url: correctURL!) {
            XCTAssertEqual(correctAppHost, .courseDetail);
            XCTAssertNotNil(coursesWebViewController.getCourseDetailPath(from: correctURL!))
        }
        else {
            XCTAssert(false, "Unknown App Host")
        }
        
        if let wrongAppHost = coursesWebViewController.appURLHostIfValid(url: wrongURL!),
            wrongAppHost == .courseDetail,
            let _ = coursesWebViewController.getCourseDetailPath(from: wrongURL!) {
                XCTAssert(false)
        }
        
    }
    
    func testEnrollURLParsing() {
        let testEnrollURL: URL = URL(string:"edxapp://enroll?course_id=course-v1:BerkeleyX+GG101x-2+1T2015&email_opt_in=false")!
        let courseDetailsWebViewController = CourseDetailsWebViewController(with: testEnrollURL, andBottomBar: nil)
        if let testData = courseDetailsWebViewController.parse(url: testEnrollURL){
            if let courseId = testData.courseId {
                XCTAssertEqual(courseId, "course-v1:BerkeleyX+GG101x-2+1T2015", "Course ID incorrectly parsed")
            }
            else {
                XCTAssert(false)
            }
            XCTAssertEqual(testData.emailOptIn, false, "Email Opt-In incorrectly parsed")
        }
    }
    
    func testSearchQueryBare() {
        let baseURL = "http://www.fakex.com/course"
        let queryString = "mobile linux"
        let expected = "http://www.fakex.com/course?search_query=mobile+linux"
        let expectedURL = URL(string: expected)
        let output = WebViewHelper.buildQuery(baseURL: baseURL, toolbarString: queryString)
        XCTAssertEqual(output, expectedURL);
    }
    
    func testSearchQueryAlreadyHasQuery() {
        let baseURL = "http://www.fakex.com/course?type=mobile"
        let queryString = "mobile linux"
        let expected = "http://www.fakex.com/course?type=mobile&search_query=mobile+linux"
        let expectedURL = URL(string: expected)
        let output = WebViewHelper.buildQuery(baseURL: baseURL, toolbarString: queryString)
        XCTAssertEqual(output, expectedURL);
    }
    
}
