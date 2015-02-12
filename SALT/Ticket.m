//
//  Ticket.m
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "Ticket.h"
#import "Employee.h"
#import "Judge.h"
#import "Site.h"
#import "Witness.h"


@implementation Ticket

@synthesize ticket_no;
@synthesize order_date;
@synthesize call_order_no;
@synthesize first_name;
@synthesize last_name;
@synthesize bpa_no;
@synthesize can;
@synthesize tin;
@synthesize soc;
@synthesize hearing_date;
@synthesize hearing_time;
@synthesize status;
@synthesize emp_worked;
@synthesize judge_presided;
@synthesize at_site;
@synthesize workedBy;
@synthesize judgePresided;
@synthesize heldAt;
@synthesize helpedBy;

- (id)init {
    self = [super init];
    if (self) {
        // Sets defaults for newly created Tickets.
        hearing_date = [NSDate date];
    }
    
    return self;
}

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        // Creates a ticket out of data from a json object.
        ticket_no = data[@"ticket_no"];
        order_date = data[@"order_date"];
        call_order_no = data[@"call_order_no"];
        first_name = data[@"first_name"];
        last_name = data[@"last_name"];
        bpa_no = data[@"bpa_no"];
        can = data[@"can"];
        tin = data[@"tin"];
        soc = data[@"soc"];
        hearing_date = data[@"hearing_date"];
        hearing_time = data[@"hearing_time"];
        status = data[@"status"];
        emp_worked = data[@"emp_worked"];
        judge_presided = data[@"judge_presided"];
        at_site = data[@"at_site"];
    }
    
    return self;
}
@end
