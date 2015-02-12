//
//  TicketViewController.m
//  SALT
//
//  Created by Adrian T. Chambers on 2/9/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "TicketViewController.h"

@interface TicketViewController ()

@end

@implementation TicketViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    
    NSLog(@"Ticket View Controller viewDidLoad");
    mySQL = [[MySQL alloc] init];
    statusChecker = [[StatusCodes alloc] init];
    tickets = [[NSMutableArray alloc] init];
    
    // Get the date 30 days ago.
    NSTimeInterval monthInSeconds = 30 * 24 * 60 * 60;
    NSDate *now = [NSDate date];
    NSDate *monthEarlier = [NSDate dateWithTimeInterval:monthInSeconds
                                              sinceDate:now];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-mm-dd"];
    NSString *monthAgo = [dateFormat stringFromDate:monthEarlier];
    
//    NSArray *keys = [NSArray arrayWithObjects:@"from", @"limit", nil];
//    NSArray *values = [NSArray arrayWithObjects:monthAgo, @"20", nil];
//    NSDictionary *dateInfo = [NSDictionary dictionaryWithObjects:values
//                                                         forKeys:keys];
    
    // Query the database and get the response.
    NSArray *ticketData = [mySQL grabInfoFromFile:@"tickets.php"];
    NSInteger status = [statusChecker checkStatus:ticketData];
    
    switch (status) {
        case QUERY_FAILED:
            NSLog(@"Query Failed for some reason!");
            break;
        case MYSQL_CONNECTION:
        case NOT_LOGGED_IN:
            NSLog(@"Lost connection!");
            break;
    }
    
    for (int x = 0; x < [ticketData count]; x++) {
        NSDictionary *data = [ticketData objectAtIndex:x];
        Ticket *ticket = [[Ticket alloc] initWithData:data];
        [tickets addObject:ticket];
    }
    
    NSLog(@"Tickets: %@", [[tickets objectAtIndex:0] valueForKey:@"ticket_no"]);

}

@end
