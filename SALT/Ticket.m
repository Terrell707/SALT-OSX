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
    if (self) {;
        // Creates a ticket out of data from a json object.
        NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"HH:mm:ss"];
        
        // Formats the dates and times.
        NSDate *orderDate = [dateFormat dateFromString:data[@"order_date"]];
        NSDate *hearingDate = [dateFormat dateFromString:data[@"hearing_date"]];
        NSDate *hearingTime = [timeFormat dateFromString:data[@"hearing_time"]];
        
        NSLog(@"Data Time=%@", data[@"hearing_time"]);
        NSLog(@"Time=%@", hearingTime);
        
        ticket_no = [numFormat numberFromString:data[@"ticket_no"]];
        order_date = orderDate;
        call_order_no = data[@"call_order_no"];
        first_name = data[@"first_name"];
        last_name = data[@"last_name"];
        bpa_no = data[@"bpa_no"];
        can = data[@"can"];
        tin = data[@"tin"];
        soc = data[@"soc"];
        hearing_date = hearingDate;
        hearing_time = hearingTime;
        status = data[@"status"];
        emp_worked = [numFormat numberFromString:data[@"emp_worked"]];
        judge_presided = [numFormat numberFromString:data[@"judge_presided"]];
        at_site = data[@"at_site"];
    }
    
    return self;
}

- (NSArray *)propsForDatabase
{
    NSArray *props = [NSArray arrayWithObjects:@"ticket_no", @"order_date", @"call_order_no", @"first_name",
                           @"last_name", @"bpa_no", @"can", @"tin", @"soc", @"hearing_date", @"hearing_time",
                           @"status", @"emp_worked", @"judge_presided", @"at_site", nil];
    
    return props;
}
@end
