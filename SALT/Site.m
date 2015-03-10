//
//  Site.m
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "Site.h"
#import "Schedule.h"
#import "Ticket.h"


@implementation Site

@synthesize office_code;
@synthesize name;
@synthesize address;
@synthesize phone_number;
@synthesize email;
@synthesize scheduled;
@synthesize tickets;

//-----------------------------------------------
// Inits
//-----------------------------------------------
- (id)init
{
    self = [super init];
    if (self) {
        scheduled = [[NSMutableSet alloc] init];
        tickets = [[NSMutableSet alloc] init];
    }
    
    return self;
}

- (id)initWithData:(NSDictionary *)data
{
    self = [self init];
    if (self) {
        office_code = data[@"office_code"];
        name = data[@"name"];
        address = data[@"address"];
        phone_number = data[@"phone_number"];
        email = data[@"email"];
    }
    return self;
}

//-----------------------------------------------
// Ticket Object Methods
//-----------------------------------------------
- (void)addTicketObject:(Ticket *)value
{
    [tickets addObject:value];
}

- (void)removeTicketObject:(Ticket *)value
{
    [tickets removeObject:value];
}

- (void)addTicket:(NSSet *)values
{
    for (Ticket *ticket in values) {
        [tickets addObject:ticket];
    }
}

- (void)removeTicket:(NSSet *)values
{
    for (Ticket *ticket in values) {
        [tickets removeObject:ticket];
    }
}

//-----------------------------------------------
// Schedule Object Methods
//-----------------------------------------------
- (void)addScheduledObject:(Schedule *)value
{
    [scheduled addObject:value];
}

- (void)removeScheduledObject:(Schedule *)value
{
    [scheduled removeObject:value];
}

- (void)addScheduled:(NSSet *)values
{
    for (Schedule *schedule in values) {
        [scheduled removeObject:schedule];
    }
}

- (void)removeScheduled:(NSSet *)values
{
    for (Schedule *schedule in values) {
        [scheduled removeObject:schedule];
    }
}

@end
