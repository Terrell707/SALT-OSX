//
//  Employee.m
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "Employee.h"
#import "Schedule.h"
#import "Ticket.h"
#import "User.h"


@implementation Employee

@synthesize database_id;
@synthesize emp_id;
@synthesize first_name;
@synthesize middle_init;
@synthesize last_name;
@synthesize phone_number;
@synthesize email;
@synthesize street;
@synthesize city;
@synthesize state;
@synthesize zip;
@synthesize pay;
@synthesize active;
@synthesize worked;
@synthesize username;
@synthesize scheduled;

#pragma mark - Inits
//-----------------------------------------------
// Inits
//-----------------------------------------------
- (id)init
{
    self = [super init];
    if (self) {
        worked = [[NSMutableSet alloc] init];
        scheduled = [[NSMutableSet alloc] init];
    }
    return self;
}

- (id)initWithData:(NSDictionary *)data
{
    self = [self init];
    if (self) {
        // Initializes the sets.
        worked = [[NSMutableSet alloc] init];
        scheduled = [[NSMutableSet alloc] init];
        
        // Creates an employee out of a json object.
        NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];

        database_id = [numFormat numberFromString:data[@"id"]];
        emp_id = [numFormat numberFromString:data[@"emp_id"]];
        first_name = data[@"first_name"];
        middle_init = data[@"middle_init"];
        last_name = data[@"last_name"];
        phone_number = data[@"phone_number"];
        email = data[@"email"];
        street = data[@"street"];
        city = data[@"city"];
        state = data[@"state"];
        zip = data[@"zip"];
        pay = [numFormat numberFromString:data[@"pay"]];
        active = [data[@"active"] boolValue];
    }
    return self;
}

#pragma mark - Methods for Employee
//-----------------------------------------------
// Methods for Employee
//-----------------------------------------------
+ (NSArray *)propsForDatabase
{
    NSArray *props = [NSArray arrayWithObjects:@"database_id", @"emp_id", @"first_name", @"middle_init",
                      @"last_name", @"phone_number", @"email", @"street", @"city", @"state", @"zip", @"pay", @"active", nil];
    return props;
}

+ (NSArray *)properties
{
    NSArray *props = [self propsForDatabase];
    NSArray *sets = [NSArray arrayWithObjects:@"worked", @"username", @"scheduled", nil];
    
    return [props arrayByAddingObject:sets];
}

+ (NSArray *)searchableKeys
{
    return [NSArray arrayWithObjects:@"emp_id.stringValue", @"first_name", @"middle_init", @"last_name", @"phone_number", @"email", @"street", @"city", @"state", @"zip", @"pay.stringValue", nil];
}

#pragma mark - Worked Object Methods
//-----------------------------------------------
// Worked Object Methods
//-----------------------------------------------
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

#pragma mark - Schedule Object Methods
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
        [scheduled addObject:schedule];
    }
}

- (void)removeScheduled:(NSSet *)values
{
    for (Schedule *schedule in values) {
        [scheduled removeObject:schedule];
    }
}

@end
