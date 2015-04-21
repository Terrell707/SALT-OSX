//
//  StatusCodes.m
//  SALT
//
//  Created by Adrian T. Chambers on 2/7/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "StatusCodes.h"

@implementation StatusCodes

- (id)init
{
    self = [super init];
    if (self) {
        _errorCode = ERROR;
        _errorMessage = @"No operation performed yet.";
    }
    return self;
}

- (NSArray *)grabStatusFromJson:(NSArray *)json
{
    NSDictionary *status;
    NSMutableArray *data = [NSMutableArray arrayWithArray:json];
    
    if (data == nil) {
        NSLog(@"NOTHING WAS RETURNED FROM THE SERVER!");
        _errorCode = ERROR;
        _errorMessage = @"Nothing was returned from the server.";
        return [NSArray arrayWithArray:data];
    }
    
    // Searchs the array for the status information and removes it from the array.
    for (int x = 0; x < data.count; x++) {
        if ([[data objectAtIndex:x] valueForKey:@"error_code"] != nil) {
            status = [data objectAtIndex:x];
            [data removeObjectAtIndex:x];
        }
        
    }
    
    // Sets the error code and message to what was returned by the server.
    if (status != nil) {
        // Grabs the error code value from the array and returns it.
        _errorCode = [[status valueForKey:@"error_code"] integerValue];
        _errorMessage = [status valueForKey:@"error_message"];
        NSLog(@"Status From JSON: %@", _errorMessage);
    } else {
        _errorCode = ERROR;
        _errorMessage = @"No status was returned.";
    }
    
    // Returns the data with the status information removed.
    json = [NSArray arrayWithArray:data];
    return json;
}

@end
