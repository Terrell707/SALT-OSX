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
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    
    NSLog(@"Ticket View Controller viewDidAppear");
    
    // Populates the table with tickets returned from the server.
    [self setTickets:[[DataController sharedDataController] tickets]];
    [[DataController sharedDataController] addObserver:self
                                            forKeyPath:@"tickets"
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
    ticketsBeforeFilter = tickets;

    [_ticketTable reloadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"Change is good");
    
    if ([keyPath isEqualToString:@"tickets"]) {
        [self setTickets:[[DataController sharedDataController] tickets]];
        [_ticketTable reloadData];
    }
}

- (void)controlTextDidChange:(NSNotification *)notification
{
    // Grabs search text from the search field.
    NSSearchField *searchField = [notification object];
    NSString *searchText = [[searchField stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    // Updates the filtered array to the original array.
    [self setTickets:(NSMutableArray *)ticketsBeforeFilter];
    
    // Returns if nothing was typed into the search field.
    if ([searchText length] == 0) {
        return;
    }
    
    // Splits the search text into tokens. We will then search the array for any attributes containing the tokens.
    NSArray *searchTokens = [searchText componentsSeparatedByString:@" "];
    NSLog(@"Tokens=%@", searchTokens);
    
    // An array of keys that will be compared against.
    NSArray *keys = @[@"ticket_no.stringValue", @"first_name", @"last_name",
                      @"status", @"workedBy.first_name", @"workedBy.last_name"];
    
    // A filter created based on the keys above.
    NSString *filter = [self filterForKeys:keys];
    
    for (NSString *token in searchTokens) {
        // Inserts the token to compare against in between each of the above keys.
        NSArray *args = [self insertToken:token forKeys:keys];
        searchPredicate = [NSPredicate predicateWithFormat:filter argumentArray:args];
        [self setTickets:(NSMutableArray *)[tickets filteredArrayUsingPredicate:searchPredicate]];
    }
}

- (NSString *)filterForKeys:(NSArray *)keys
{
    NSMutableString *filter = [[NSMutableString alloc] init];
    
    // Creates a a number of key compares depending on the number of keys passed in.
    for (int x = 0; x < [keys count]; x++) {
        if (x > 0)
            [filter appendString:@" || "];
        [filter appendString:@"%K CONTAINS[cd] %@"];
    }
    
    return filter;
}

- (NSArray *)insertToken:(NSString *)token forKeys:(NSArray *)keys
{
    NSMutableArray *args = [[NSMutableArray alloc] init];
    
    for (int x = 0; x < [keys count]; x++) {
        [args addObject:[keys objectAtIndex:x]];
        [args addObject:token];
    }
    
    return args;
}

@end
