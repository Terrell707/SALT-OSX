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
    
    NSLog(@"Ticket View Controller viewDidAppear");
    
    [self willChangeValueForKey:@"tickets"];
    tickets = [[DataController sharedDataController] tickets];
    [self didChangeValueForKey:@"tickets"];
    
    [_ticketTable reloadData];
    
    NSLog(@"Ticket Table = %@", _ticketTable);
}

@end
