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
@synthesize ticket;

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        office_code = data[@"office_code"];
        name = data[@"name"];
        address = data[@"address"];
        phone_number = data[@"phone_number"];
        email = data[@"email"];
    }
    return self;
}

@end
