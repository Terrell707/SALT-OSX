//
//  DataSearchTests.m
//  SALT
//
//  Created by Adrian T. Chambers on 5/28/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "Employee.h"
#import "DataSearch.h"

@interface DataSearchTests : XCTestCase
@property (nonatomic) NSMutableArray *employees;
@property (nonatomic) Employee *a;
@property (nonatomic) Employee *b;
@end

@implementation DataSearchTests

- (void)setUp {
    [super setUp];
    
    // Creates two employees with unique data and then adds them to an array.
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    NSDictionary *a_data = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"database_id",
                          @"2", @"emp_id",
                          @"Adrian", @"first_name", @"X", @"middle_init", @"Benjamin", @"last_name", @"7073214567", @"phone_number", @"xyz@gmail.com", @"email", @"177 Stockton Street", @"street", @"Salinas", @"city", @"CA", @"state", @"95141", @"zip", @"55.50", @"pay", @"1", @"active", nil];
    
    NSDictionary *b_data = [NSDictionary dictionaryWithObjectsAndKeys:@"7", @"database_id",
                          @"5", @"emp_id",
                          @"Mario", @"first_name", @"Y", @"middle_init", @"Chambers", @"last_name", @"9168821129", @"phone_number", @"mc_mario@yahoo.com", @"email", @"9312 Response Street Apt 321", @"street", @"Sacramento", @"city", @"CA", @"state", @"94533", @"zip", @"60", @"pay", @"0", @"active", nil];
    
    _a = [[Employee alloc] initWithData:a_data];
    _b = [[Employee alloc] initWithData:b_data];
    
    _employees = [[NSMutableArray alloc] initWithObjects:_a, _b, nil];
    NSLog(@"Employees = %@", _employees);
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSearch {
    // Creates an array of keys that are searchable in the Employee object.
    NSArray *keys = [NSArray arrayWithObjects:@"emp_id.stringValue", @"first_name", @"middle_init", @"last_name", @"phone_number", @"email", @"street", @"city", @"state", @"zip", @"pay.stringValue", nil];
    
    Employee *expected, *actual;
    NSInteger expectedCount, actualCount;
    NSMutableArray *results;
    
    // Makes sure that Mario Chambers is returned after doing a search of "Mario".
    expected = _b;
    expectedCount = 1;
    results = [DataSearch searchData:_employees withKeys:keys withSearchText:@"Mario"];
    actualCount = [results count];
    XCTAssertEqual(actualCount, expectedCount, @"Data Search with text 'Mario' should only return 1 result.");
    actual = results[0];
    XCTAssertEqualObjects(actual, _b, @"The incorrect employee was returned. Mario should of been returned from search because first name matches 'Mario'.");
    
    // Makes sure that both employees are returned after doing a search of ".com 321 CA".
    expectedCount = 2;
    results = [DataSearch searchData:_employees withKeys:keys withSearchText:@".com 321 CA"];
    actualCount = [results count];
    XCTAssertEqual(actualCount, expectedCount, @"Data Search with text '.com 321 CA' should return 2 results.");
    XCTAssertEqualObjects(results, _employees, @"All employees should of been returned from the search.");
    
    // Makes sure that no employees are returned after doing a search of "Adrian Chambers".
    expectedCount = 0;
    results = [DataSearch searchData:_employees withKeys:keys withSearchText:@"Adrian Chambers"];
    actualCount = [results count];
    XCTAssertEqual(actualCount, expectedCount, @"Data Search with text 'Adrian Chambers' should return 0 results.");
    
    // Makes sure that Adrian Benjamin is returned after doing a search of ".50".
    // EXPECTED FAILURE
    expected = _a;
    expectedCount = 1;
    results = [DataSearch searchData:_employees withKeys:keys withSearchText:@".50"];
    actualCount = [results count];
    XCTAssertEqual(actualCount, expectedCount, @"Data Search with text '.50' should only return 1 result.");
    actual = results[0];
    XCTAssertEqualObjects(actual, _b, @"The incorrect employee was returned. Adrian should of been returned from search because pay matches search of '.50'.");
}

@end
