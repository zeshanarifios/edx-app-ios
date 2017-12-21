//
//  OEXFindCoursesTest.m
//  edXVideoLocker
//
//  Created by Abhradeep on 13/02/15.
//  Copyright (c) 2015 edX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "edX-Swift.h"
#import "OEXEnvironment.h"
#import "OEXConfig.h"
#import "OEXNetworkManager.h"

// TODO: Refactor so these are either on a separate object owned by the controller and hence testable
// or exposed through a special Test interface
@interface CoursesWebViewController (TestCategory) <DiscoverWebViewHelperDelegate>
-(NSString *)getCoursePathIDFromURL:(NSURL *)url;
@end

@interface CourseDetailsWebViewController (TestCategory) <DiscoverWebViewHelperDelegate>
- (NSString*)courseURLString;
-(void)parseURL:(NSURL *)url getCourseID:(NSString *__autoreleasing *)courseID emailOptIn:(BOOL *)emailOptIn;
@end

@interface OEXFindCoursesTests : XCTestCase

@end

@implementation OEXFindCoursesTests

-(void)testFindCoursesURLRecognition{
    DiscoverCoursesWebViewHelper* helper = [[DiscoverCoursesWebViewHelper alloc] initWithConfig:nil delegate:nil bottomBar:nil];
    CoursesWebViewController *coursesWebViewController = [[CoursesWebViewController alloc] init];
    NSURLRequest *testURLRequestCorrect = [NSURLRequest requestWithURL:[NSURL URLWithString:@"edxapp://course_info?path_id=course/science-happiness-uc-berkeleyx-gg101x"]];
    BOOL successCorrect = ![coursesWebViewController webViewHelperWithHelper:helper shouldLoadLinkWithRequest:testURLRequestCorrect];
    
    XCTAssert(successCorrect, @"Correct URL not recognized");
    
    NSURLRequest *testURLRequestWrong = [NSURLRequest requestWithURL:[NSURL URLWithString:@"edxapps://course_infos?path_id=course/science-happiness-uc-berkeleyx-gg101x"]];
    BOOL successWrong = [coursesWebViewController webViewHelperWithHelper:helper shouldLoadLinkWithRequest:testURLRequestWrong];
    XCTAssert(successWrong, @"Wrong URL not recognized");
}

-(void)testPathIDParsing{
    NSURL *testURL = [NSURL URLWithString:@"edxapp://course_info?path_id=course/science-happiness-uc-berkeleyx-gg101x"];
    CoursesWebViewController *coursesWebViewController = [[CoursesWebViewController alloc] init];
    
    NSString *pathID = [coursesWebViewController getCoursePathIDFromURL:testURL];
    XCTAssertEqualObjects(pathID, @"science-happiness-uc-berkeleyx-gg101x", @"Path ID incorrectly parsed");
}

-(void)testEnrollURLParsing{
    NSURL *testEnrollURL = [NSURL URLWithString:@"edxapp://enroll?course_id=course-v1:BerkeleyX+GG101x-2+1T2015&email_opt_in=false"];
    CourseDetailsWebViewController *courseDetailsWebViewController = [[CourseDetailsWebViewController alloc] initWith:@"abc" and:nil];
    
    NSString* courseID = nil;
    BOOL emailOptIn = true;
    
    [courseDetailsWebViewController parseURL:testEnrollURL getCourseID:&courseID emailOptIn:&emailOptIn];
    
    XCTAssertEqualObjects(courseID, @"course-v1:BerkeleyX+GG101x-2+1T2015", @"Course ID incorrectly parsed");
    XCTAssertEqual(emailOptIn, false, @"Email Opt-In incorrectly parsed");
}


// Disabled for now since this test makes bad assumptions about the current configuration
-(void)disable_testCourseInfoURLTemplateSubstitution{
    CourseDetailsWebViewController *courseDetailsWebViewController = [[CourseDetailsWebViewController alloc] initWith:@"science-happiness-uc-berkeleyx-gg101x" and:nil];
    NSString *courseURLString = courseDetailsWebViewController.courseURLString;
    XCTAssertEqualObjects(courseURLString, @"https://webview.edx.org/course/science-happiness-uc-berkeleyx-gg101x", @"Course Info URL incorrectly determined");
}

- (void) testSearchQueryBare {
    NSString* baseURL = @"http://www.fakex.com/course";
    NSString* queryString = @"mobile linux";

    NSString* expected = @"http://www.fakex.com/course?search_query=mobile+linux";
    NSURL* expectedURL = [NSURL URLWithString:expected];
    NSURL* output = [DiscoverCoursesWebViewHelper buildQueryWithBaseURL:baseURL toolbarString:queryString];
    XCTAssertEqualObjects(output, expectedURL);
}

- (void) testSearchQueryAlreadyHasQuery {
    NSString* baseURL = @"http://www.fakex.com/course?type=mobile";
    NSString* queryString = @"mobile linux";

    NSString* expected = @"http://www.fakex.com/course?type=mobile&search_query=mobile+linux";
    NSURL* expectedURL = [NSURL URLWithString:expected];
    NSURL* output = [DiscoverCoursesWebViewHelper buildQueryWithBaseURL:baseURL toolbarString:queryString];
    XCTAssertEqualObjects(output, expectedURL);
}

@end
