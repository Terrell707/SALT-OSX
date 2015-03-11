//
//  Expert.m
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "Expert.h"
#import "Witness.h"

@implementation Expert

@synthesize expert_id;
@synthesize first_name;
@synthesize last_name;
@synthesize role;
@synthesize active;
@synthesize worked;

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        
        // Creates an employee out of a json object.
        NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
        
        expert_id = [numFormat numberFromString:data[@"expert_id"]];
        first_name = data[@"first_name"];
        last_name = data[@"last_name"];
        role = data[@"role"];
        active = [data[@"active"] boolValue];
    }
    return self;
}

@end
