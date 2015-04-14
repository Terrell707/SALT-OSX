//
//  FieldFormatterTests.m
//  SALT
//
//  Created by Adrian T. Chambers on 4/13/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "FieldFormatter.h"

@interface FieldFormatterTests : XCTestCase
@property (nonatomic) FieldFormatter *fieldFormatter;
@end

@implementation FieldFormatterTests

- (void)setUp {
    [super setUp];
    
    _fieldFormatter = [[FieldFormatter alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFormatFirstName {
    NSString *firstName = @"First";
    NSString *lastName = @"Last";
    NSString *expectedName, *formattedName;
    
    // Tests that name is formatted correctly with last name first.
    [_fieldFormatter setLastNameFirst:YES];
    expectedName = @"Last, First";
    formattedName = [_fieldFormatter formatFirstName:firstName lastName:lastName];
    XCTAssertEqualObjects(expectedName, formattedName, @"Last Name first is true but not formatted as 'Last, First'");
    
    // Tests that name is formatted correctly with first name first.
    [_fieldFormatter setLastNameFirst:NO];
    expectedName = @"First Last";
    formattedName = [_fieldFormatter formatFirstName:firstName lastName:lastName];
    XCTAssertEqualObjects(expectedName, formattedName, @"Last Name first is false but not formatted as 'First Last'");
}

- (void)testUnformatName {
    NSString *name;
    NSDictionary *actualNameDict;
    NSDictionary *expectedNameDict;
    
    // Tests that name is unformatted correctly with last name first.
    [_fieldFormatter setLastNameFirst:YES];
    name = @"Last, First";
    actualNameDict = [_fieldFormatter unformatName:name];
    expectedNameDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Last", @"last_name", @"First", @"first_name", nil];
    XCTAssertEqualObjects(actualNameDict, expectedNameDict, "Last Name first unformatted name returned does not have same keys and values.");
    
    // Tests that name is unformatted correctly with first name first.
    [_fieldFormatter setLastNameFirst:NO];
    name = @"First Last";
    actualNameDict = [_fieldFormatter unformatName:name];
    expectedNameDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Last", @"last_name", @"First", @"first_name", nil];
    XCTAssertEqualObjects(actualNameDict, expectedNameDict, "First Name first unformatted returned does not have same keys and values.");
}

- (void)testCallOrderBPAFormat {
    NSString *bpaNumber;
    NSString *expectedBPA;
    NSString *actualBPA;
    
    bpaNumber = @"";
    expectedBPA = @"";
    actualBPA = [_fieldFormatter callOrderFormat:bpaNumber];
    XCTAssertEqualObjects(actualBPA, expectedBPA, "Formatted BPA Number should be blank.");
    
    bpaNumber = @"12345";
    expectedBPA = @"1234-5";
    actualBPA = [_fieldFormatter callOrderFormat:bpaNumber];
    XCTAssertEqualObjects(actualBPA, expectedBPA, "Formatted BPA Number does not have hyphen after 4th char.");
    
    bpaNumber = @"1234";
    expectedBPA = @"1234";
    actualBPA = [_fieldFormatter callOrderFormat:bpaNumber];
    XCTAssertEqualObjects(actualBPA, expectedBPA, "Formatted BPA Number should not have any hyphens.");
    
    bpaNumber = @"123456";
    expectedBPA = @"1234-56";
    actualBPA = [_fieldFormatter callOrderFormat:bpaNumber];
    XCTAssertEqualObjects(actualBPA, expectedBPA, "Formatted BPA Number should only have hyphen after 4th char.");
    
    bpaNumber = @"1234567";
    expectedBPA = @"1234-56-7";
    actualBPA = [_fieldFormatter callOrderFormat:bpaNumber];
    XCTAssertEqualObjects(actualBPA, expectedBPA, "Formatted BPA Number should have hyphen after 4th and 7th char.");
    
    bpaNumber = @"12345678901";
    expectedBPA = @"1234-56-78901";
    actualBPA = [_fieldFormatter callOrderFormat:bpaNumber];
    XCTAssertEqualObjects(actualBPA, expectedBPA, "Formatted BPA Number should have hyphen after 4th and 7th char.");
}

- (void)testTinFormat {
    NSString *tinNumber;
    NSString *expectedTin;
    NSString *actualTin;
    
    tinNumber = @"";
    expectedTin = @"";
    actualTin = [_fieldFormatter tinFormat:tinNumber];
    XCTAssertEqualObjects(actualTin, expectedTin, "Formatted Tin Number should be blank.");
    
    tinNumber = @"1234";
    expectedTin = @"1234";
    actualTin = [_fieldFormatter tinFormat:tinNumber];
    XCTAssertEqualObjects(actualTin, expectedTin, "Formatted Tin Number should have no hyphens.");
    
    tinNumber = @"12345";
    expectedTin = @"1234-5";
    actualTin = [_fieldFormatter tinFormat:tinNumber];
    XCTAssertEqualObjects(actualTin, expectedTin, "Formatted Tin Number should have a hyphen after 4th char.");
}

@end
