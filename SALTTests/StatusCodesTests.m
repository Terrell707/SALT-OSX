//
//  StatusCodesTests.m
//  SALT
//
//  Created by Adrian T. Chambers on 4/20/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "StatusCodes.h"

@interface StatusCodesTests : XCTestCase
@property (nonatomic) StatusCodes *statusChecker;
@end

@implementation StatusCodesTests

- (void)setUp {
    [super setUp];
    
    _statusChecker = [[StatusCodes alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGrabStatusFromJson {
    NSDictionary *status = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"error_code", @"Test Status", @"error_message", nil];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:@"12345", @"sample_number", @"A", @"sample_letter", nil];
    NSArray *json, *expectedJson, *actualJson;
    NSInteger expectedCode, actualCode;
    NSString *expectedMessage, *actualMessage;
    
    // Tests that the status information is removed from the array no matter where its located.
    json = [NSArray arrayWithObjects:status, data, nil];
    expectedJson = [NSArray arrayWithObjects:data, nil];
    actualJson = [_statusChecker grabStatusFromJson:json];
    XCTAssertEqualObjects(actualJson, expectedJson, @"Status was not removed from the array.");
    
    json = [NSArray arrayWithObjects:data, status, nil];
    expectedJson = [NSArray arrayWithObjects:data, nil];
    actualJson = [_statusChecker grabStatusFromJson:json];
    XCTAssertEqualObjects(actualJson, expectedJson, @"Status was not removed from the array.");
    
    json = [NSArray arrayWithObject:data];
    expectedJson = [NSArray arrayWithObjects:data, nil];
    actualJson = [_statusChecker grabStatusFromJson:json];
    XCTAssertEqualObjects(actualJson, expectedJson, @"Status was not removed from the array.");
    
    // Tests that the error code and error message is grabbed correctly.
    json = [NSArray arrayWithObjects:status, data, nil];
    [_statusChecker grabStatusFromJson:json];
    
    expectedCode = 0;
    actualCode = [_statusChecker errorCode];
    expectedMessage = @"Test Status";
    actualMessage = [_statusChecker errorMessage];
    XCTAssertEqual(actualCode, expectedCode, @"Status Code was not grabbed from the array.");
    XCTAssertEqualObjects(actualMessage, expectedMessage, @"Status Message was not grabbed from the array.");
    
}

@end
