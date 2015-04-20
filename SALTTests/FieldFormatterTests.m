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

- (void)testFormatName {
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
    XCTAssertEqualObjects(actualNameDict, expectedNameDict, @"Last Name first unformatted name returned does not have same keys and values.");
    
    // Tests that name is unformatted correctly with first name first.
    [_fieldFormatter setLastNameFirst:NO];
    name = @"First Last";
    actualNameDict = [_fieldFormatter unformatName:name];
    expectedNameDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Last", @"last_name", @"First", @"first_name", nil];
    XCTAssertEqualObjects(actualNameDict, expectedNameDict, @"First Name first unformatted returned does not have same keys and values.");
}

- (void)testTicketNumber {
    NSString *ticketNumber;
    NSString *expectedNumber;
    NSString *actualNumber;
    
    ticketNumber = @"";
    expectedNumber = @"";
    actualNumber = [_fieldFormatter ticketNumberFormat:ticketNumber];
    XCTAssertEqualObjects(actualNumber, expectedNumber, @"Formatted Ticket Number should be blank.");
    
    ticketNumber = @"1234567";
    expectedNumber = @"1234567";
    actualNumber = [_fieldFormatter ticketNumberFormat:ticketNumber];
    XCTAssertEqualObjects(actualNumber, expectedNumber, @"Formatted Ticket Number shouldn't of been changed.");
    
    ticketNumber = @"123456789";
    expectedNumber = @"12345678";
    actualNumber = [_fieldFormatter ticketNumberFormat:ticketNumber];
    XCTAssertEqualObjects(actualNumber, expectedNumber, @"Formatted Ticket Number should of been truncated by one char.");
}

- (void)testCallOrderFormat {
    NSString *callNumber;
    NSString *expectedCallNumber;
    NSString *actualCallNumber;
    
    callNumber = @"1234567890123";
    expectedCallNumber = @"1234-56-7890123";
    actualCallNumber = [_fieldFormatter callOrderFormat:callNumber];
    XCTAssertEqualObjects(actualCallNumber, expectedCallNumber, @"Formatted Call Order Number should not be truncated.");
    
    callNumber = @"1234567890123456";
    expectedCallNumber = @"1234-56-7890123";
    actualCallNumber = [_fieldFormatter callOrderFormat:callNumber];
    XCTAssertEqualObjects(actualCallNumber, expectedCallNumber, @"Formatted Call Order Number should be a max of 20 chars.");
}

- (void)testBPAFormat {
    NSString *bpaNumber;
    NSString *expectedNumber;
    NSString *actualNumber;
    
    bpaNumber = @"12345678901";
    expectedNumber = @"1234-56-78901";
    actualNumber = [_fieldFormatter bpaFormat:bpaNumber];
    XCTAssertEqualObjects(actualNumber, expectedNumber, @"Formatted BPA Number should not be truncated.");
    
    bpaNumber = @"123456789012";
    expectedNumber = @"1234-56-78901";
    actualNumber = [_fieldFormatter bpaFormat:bpaNumber];
    XCTAssertEqualObjects(actualNumber, expectedNumber, @"Formatted BPA Number should be truncated by one char.");
}

// Tests that test both call order and bpa format.
- (void)testBPAandCallOrderFormat {
    NSString *text;
    NSString *expectedText;
    NSString *actualText;
    
    text = @"";
    expectedText = @"";
    actualText = [_fieldFormatter callOrderFormat:text];
    XCTAssertEqualObjects(actualText, expectedText, @"Formatted Call Order/BPA should be blank.");
    
    text = @"12345";
    expectedText = @"1234-5";
    actualText = [_fieldFormatter callOrderFormat:text];
    XCTAssertEqualObjects(actualText, expectedText, @"Formatted Call Order/BPA does not have hyphen after 4th char.");
    
    text = @"1234";
    expectedText = @"1234";
    actualText = [_fieldFormatter callOrderFormat:text];
    XCTAssertEqualObjects(actualText, expectedText, @"Formatted Call Order/BPA should not have any hyphens.");
    
    text = @"123456";
    expectedText = @"1234-56";
    actualText = [_fieldFormatter callOrderFormat:text];
    XCTAssertEqualObjects(actualText, expectedText, @"Formatted Call Order/BPA should only have hyphen after 4th char.");
    
    text = @"1234567";
    expectedText = @"1234-56-7";
    actualText = [_fieldFormatter callOrderFormat:text];
    XCTAssertEqualObjects(actualText, expectedText, @"Formatted Call Order/BPA should have hyphen after 4th and 7th char.");
    
    text = @"12345678901";
    expectedText = @"1234-56-78901";
    actualText = [_fieldFormatter callOrderFormat:text];
    XCTAssertEqualObjects(actualText, expectedText, @"Formatted Call Order/BPA should have hyphen after 4th and 7th char.");
    
    text = @"12-3";
    expectedText = @"123";
    actualText = [_fieldFormatter callOrderFormat:text];
    XCTAssertEqualObjects(actualText, expectedText, @"Formatted Call Order/BPA should remove out of place hyphen.");
}

- (void)testTinFormat {
    NSString *tinNumber;
    NSString *expectedTin;
    NSString *actualTin;
    
    tinNumber = @"";
    expectedTin = @"";
    actualTin = [_fieldFormatter tinFormat:tinNumber];
    XCTAssertEqualObjects(actualTin, expectedTin, @"Formatted Tin Number should be blank.");
    
    tinNumber = @"1234";
    expectedTin = @"1234";
    actualTin = [_fieldFormatter tinFormat:tinNumber];
    XCTAssertEqualObjects(actualTin, expectedTin, @"Formatted Tin Number should have no hyphens.");
    
    tinNumber = @"12345";
    expectedTin = @"1234-5";
    actualTin = [_fieldFormatter tinFormat:tinNumber];
    XCTAssertEqualObjects(actualTin, expectedTin, @"Formatted Tin Number should have a hyphen after 4th char.");
}

- (void)testNameFormat {
    NSString *name;
    NSString *expectedName;
    NSString *actualName;
    
    name = @"";
    expectedName = @"";
    actualName = [_fieldFormatter nameFormat:name];
    XCTAssertEqualObjects(actualName, expectedName, @"Formatted Name should be blank.");
    
    name = @"Robinson";
    expectedName = @"Robinson";
    actualName = [_fieldFormatter nameFormat:name];
    XCTAssertEqualObjects(actualName, expectedName, @"Formatted Name should be returned the same.");
    
    name = @"Robinson-Floyd-Chambers";
    expectedName = @"Robinson-Floyd-Chamb";
    actualName = [_fieldFormatter nameFormat:name];
    XCTAssertEqualObjects(actualName, expectedName, @"Formatted Name should be truncated by three chars.");
}

- (void)testCANFormat {
    NSString *canNumber;
    NSString *expectedNumber;
    NSString *actualNumber;
    
    canNumber = @"";
    expectedNumber = @"";
    actualNumber = [_fieldFormatter canFormat:canNumber];
    XCTAssertEqualObjects(actualNumber, expectedNumber, @"Formatted CAN Number should be blank.");
    
    canNumber = @"4003932";
    expectedNumber = @"4003932";
    actualNumber = [_fieldFormatter canFormat:canNumber];
    XCTAssertEqualObjects(actualNumber, expectedNumber, @"Formatted CAN Number should be returned the same.");
    
    canNumber = @"400393201";
    expectedNumber = @"4003932";
    actualNumber = [_fieldFormatter canFormat:canNumber];
    XCTAssertEqualObjects(actualNumber, expectedNumber, @"Formatted CAN Number should be truncated by 2 chars.");
}

- (void)testSOCFormat {
    NSString *text;
    NSString *expectedText;
    NSString *actualText;
    
    text = @"";
    expectedText = @"";
    actualText = [_fieldFormatter socFormat:text];
    XCTAssertEqualObjects(actualText, expectedText, @"Formatted SOC should be blank.");
    
    text = @"252E";
    expectedText = @"252E";
    actualText = [_fieldFormatter socFormat:text];
    XCTAssertEqualObjects(actualText, expectedText, @"Formatted SOC should be returned the same.");
    
    text = @"252EX";
    expectedText = @"252E";
    actualText = [_fieldFormatter socFormat:text];
    XCTAssertEqualObjects(actualText, expectedText, @"Formatted SOC should be truncated by 1 char.");
}

@end
