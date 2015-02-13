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
@synthesize worked;
@synthesize username;
@synthesize scheduled;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        NSLog(@"Employee initWithData");
        
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
    }
    return self;
}

@end
