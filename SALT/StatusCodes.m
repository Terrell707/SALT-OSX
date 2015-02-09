//
//  StatusCodes.m
//  SALT
//
//  Created by Adrian T. Chambers on 2/7/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "StatusCodes.h"

@implementation StatusCodes

- (id) init
{
    self = [super init];
    return self;
}

- (NSInteger)checkStatus:(NSArray *)data
{
    // Checks that the json data has an error code key. If not, then no error was returned.
    if ([[data objectAtIndex:0] valueForKey:@"error_code"] == nil) {
        return SUCCESS;
    }
    
    // Grabs the error code value from the array and returns it.
    NSInteger code = [[[data objectAtIndex:0] valueForKey:@"error_code"] integerValue];
    NSLog(@"Error: %@", [[data objectAtIndex:0] valueForKey:@"error_message"]);
    return code;
}

@end
