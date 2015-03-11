//
//  Judge.m
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "Judge.h"
#import "Clerk.h"
#import "Ticket.h"


@implementation Judge

@synthesize judge_id;
@synthesize office;
@synthesize first_name;
@synthesize last_name;
@synthesize active;
@synthesize assistedBy;
@synthesize worked;

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        // Creates a judge out of a json object.
        NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
        
        judge_id = [numFormat numberFromString:data[@"judge_id"]];
        office = data[@"office"];
        first_name = data[@"first_name"];
        last_name = data[@"last_name"];
        active = [data[@"active"] boolValue];
    }
    return self;
}

#pragma Worked Objects
- (void)addWorkedObject:(Ticket *)value
{
    [worked addObject:value];
}

- (void)removeWorkedObject:(Ticket *)value
{
    [worked removeObject:value];
}

- (void)addWorked:(NSSet *)values
{
    for (Ticket *ticket in values) {
        [worked addObject:ticket];
    }
}

- (void)removeWorked:(NSSet *)values
{
    for (Ticket *ticket in values) {
        [worked removeObject:ticket];
    }
}

@end
