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
@synthesize can;
@synthesize soc;
@synthesize hearing_date;
@synthesize hearing_time;
@synthesize status;
@synthesize full_pay;
@synthesize emp_worked;
@synthesize judge_presided;
@synthesize at_site;
@synthesize workedBy;
@synthesize judgePresided;
@synthesize heldAt;
@synthesize helpedBy;

//-----------------------------------------------
// Inits
//-----------------------------------------------
- (id)init {
    self = [super init];
    if (self) {
        helpedBy = [[NSMutableSet alloc] init];
    }
    
    return self;
}

- (id)initWithData:(NSDictionary *)data
{
    self = [self init];
    if (self) {;
        // Creates a ticket out of data from a json object.
        NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"hh:mm:ss"];
        
        // Formats the dates and times.
        NSDate *orderDate = [dateFormat dateFromString:data[@"order_date"]];
        NSDate *hearingDate = [dateFormat dateFromString:data[@"hearing_date"]];
        NSDate *hearingTime = [timeFormat dateFromString:data[@"hearing_time"]];
        
        // Places the data in the appropriate properties.
        ticket_no = [numFormat numberFromString:data[@"ticket_no"]];
        order_date = orderDate;
        call_order_no = data[@"call_order_no"];
        first_name = data[@"first_name"];
        last_name = data[@"last_name"];
        can = data[@"can"];
        soc = data[@"soc"];
        hearing_date = hearingDate;
        hearing_time = hearingTime;
        status = data[@"status"];
        full_pay = [data[@"full_pay"] boolValue];
        emp_worked = [numFormat numberFromString:data[@"emp_worked"]];
        judge_presided = [numFormat numberFromString:data[@"judge_presided"]];
        at_site = data[@"at_site"];
    }
    
    return self;
}

//-----------------------------------------------
// Methods for Ticket
//-----------------------------------------------
- (NSArray *)propsForDatabase
{
    NSArray *props = [NSArray arrayWithObjects:@"ticket_no", @"order_date", @"call_order_no", @"first_name",
                           @"last_name", @"soc", @"hearing_date", @"hearing_time",
                           @"status", @"full_pay", @"emp_worked", @"judge_presided", @"at_site", nil];
    
    return props;
}

- (NSArray *)properties
{
    NSArray *propsForDatabase = [self propsForDatabase];
    NSArray *props = [NSArray arrayWithObjects:@"workedBy", @"judgePresided", @"heldAt", @"helpedBy", nil];
    
    return [propsForDatabase arrayByAddingObjectsFromArray:props];
}

//-----------------------------------------------
// HelpedBy Methods
//-----------------------------------------------
- (void)addHelpedByObject:(Expert *)value
{
    [helpedBy addObject:value];
}

- (void)removeHelpedByObject:(Expert *)value
{
    [helpedBy removeObject:value];
}

- (void)addHelpedBy:(NSSet *)values
{
    for (Witness *witness in values) {
        [helpedBy addObject:witness];
    }
}

- (void)removeHelpedBy:(NSSet *)values
{
    for (Witness *witness in values) {
        [helpedBy removeObject:witness];
    }
}
@end
