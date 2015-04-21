//
//  StatusCodes.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/7/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusCodes : NSObject {
    NSInteger code;
    NSString *message;
}

// Takes a json array and return an integer representing the status.
- (NSArray *)grabStatusFromJson:(NSArray *)data;

@property (readonly) NSInteger errorCode;      // Returns the status code for the last operation.
@property (readonly) NSString *errorMessage;   // Returns the status message for the last operation.

// Constants containing the different statuses.
typedef NS_ENUM(NSInteger, StatusCode) {
    SUCCESS = 0,
    ERROR = 1,
    NOT_LOGGED_IN = 121,
    TIMED_OUT = 122,
    INVALID_USER = 123,
    INCORRECT_PASSWORD = 124,
    MYSQL_CONNECTION = 125,
    QUERY_FAILED = 126
};

@end
