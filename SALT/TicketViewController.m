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
@synthesize tickets;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[[self view] window] makeFirstResponder:_ticketTable];
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    
    NSLog(@"Ticket View Controller viewDidAppear");
    
    [self willChangeValueForKey:@"tickets"];
    [self setTickets:[[DataController sharedDataController] tickets]];
    ticketsBeforeFilter = tickets;
    [self didChangeValueForKey:@"tickets"];

    [_ticketTable reloadData];
}

- (void)controlTextDidChange:(NSNotification *)notification
{
    // Grabs search text from the search field.
    NSSearchField *searchField = [notification object];
    NSString *searchText = [[searchField stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    // Updates the filtered array to the original array.
    tickets = (NSMutableArray *)ticketsBeforeFilter;
    
    // Returns if nothing was typed into the search field.
    if ([searchText length] == 0) {
        return;
    }
    
    // Splits the search text into tokens. We will then search the array for any attributes containing the tokens.
    NSArray *searchTokens = [searchText componentsSeparatedByString:@" "];
    NSLog(@"Tokens=%@", searchTokens);
    
    NSString *filter = @"%K CONTAINS[cd] %@ || %K CONTAINS[cd] %@ || %K CONTAINS[cd] %@ || %K CONTAINS[cd] %@";
    for (NSString *token in searchTokens) {
        NSArray *args = @[@"first_name", token, @"last_name", token,
                          @"workedBy.first_name", token, @"workedBy.last_name", token];
        searchPredicate = [NSPredicate predicateWithFormat:filter argumentArray:args];
        [self setTickets:(NSMutableArray *)[tickets filteredArrayUsingPredicate:searchPredicate]];
    }
    
    NSLog(@"Search Result=%@", tickets);
}

@end
