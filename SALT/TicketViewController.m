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
    
    // Limits the number of results we recieve.
    NSArray *keys = [NSArray arrayWithObjects:@"limit", nil];
    NSArray *values = [NSArray arrayWithObjects:@"50", nil];
    NSDictionary *limit = [NSDictionary dictionaryWithObjects:values
                                                         forKeys:keys];
    
    // Query the database and get the response.
    NSArray *ticketData = [mySQL grabInfoFromFile:@"queries/tickets.php" withItems:limit];
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
