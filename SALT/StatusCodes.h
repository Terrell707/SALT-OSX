//
//  StatusCodes.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/7/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusCodes : NSObject

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

// Takes a json array and return an integer representing the status.
- (NSInteger) checkStatus:(NSArray *)data;

@end
