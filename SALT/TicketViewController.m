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
    
    // Observes the DataController for any new tickets that were added.
    [[DataController sharedDataController] addObserver:self
                                            forKeyPath:@"tickets"
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    
    NSLog(@"Window Name from TicketViewController=%@", [[self view] window]);
    NSLog(@"Ticket View Controller viewDidAppear");
    
    lastNameFirst = YES;
    
    // Populates the table with tickets returned from the server.
    [self setTickets:[[DataController sharedDataController] tickets]];
    
    // Keeps a copy of the tickets so that they are not overwritten by searching.
    ticketsBeforeFilter = tickets;
    
    // Displays the title for each details box.
    [_ticketInfoBox setTitle:@"Ticket Details"];
    [_hearingInfoBox setTitle:@"Hearing Details"];
    
    // Populates the ticket table.
    [ticketTable reloadData];
    NSLog(@"Calling Update Fields!");
    [self updateFields];
    [self.view.window makeFirstResponder:ticketTable];
}

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Segue=%@", [segue identifier]);
    
    id controller = segue.destinationController;
    
    NSLog(@"Segue End Destination = %@", controller);
    
    // Presents the View for a user to insert a ticket.
    if ([segue.identifier isEqualToString:@"InsertTicketSegue"]) {
        [controller setTitleString:@"Create Hearing Ticket"];
        [controller setClearBtnString:@"Clear"];
        [controller setUpdateTicket:NO];
    }
    
    // Presents the View for a user to update a ticket.
    if ([segue.identifier isEqualToString:@"UpdateTicketSegue"]) {
        [controller setTitleString:@"Update Hearing Ticket"];
        [controller setClearBtnString:@"Revert"];
        [controller setUpdateTicket:YES];
        
        NSUInteger selection = [ticketController selectionIndex];
        Ticket *ticket = tickets[selection];
        
        [controller setOldTicket:ticket];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // Will reload the table with new tickets that were added.
    if ([keyPath isEqualToString:@"tickets"]) {
        [self setTickets:[[DataController sharedDataController] tickets]];
        ticketsBeforeFilter = tickets;
        [self searchTickets];
        [ticketTable reloadData];
    }
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    // Watches to see if the user changed rows, if so, update the fields with the selected ticket.
    [self updateFields];
}

- (void)controlTextDidChange:(NSNotification *)notification
{
    // Will update the search whenever something is typed into the search field.
    if ([notification object] == searchField) {
        [self searchTickets];
    }
}

- (IBAction)removeButton:(id)sender {
    NSUInteger count = [[ticketController selectedObjects] count];
    NSString *infoMessage = [NSString stringWithFormat:@"You are about to delete %ld ticket(s)! Are you sure you want to delete?", count];
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Delete Ticket(s)!"];
    [alert setInformativeText:infoMessage];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert addButtonWithTitle:@"Delete"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert beginSheetModalForWindow:[[self view] window] completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSAlertFirstButtonReturn) {
            [self removeTicket];
        }
    }];
}

- (IBAction)printButton:(id)sender {
    [self print];
}

- (void)print
{
    NSPrintInfo *printInfo;
    NSPrintInfo *sharedInfo;
    NSPrintOperation *printOp;
    
    sharedInfo = [NSPrintInfo sharedPrintInfo];
    printInfo = [[NSPrintInfo alloc] initWithDictionary:[NSMutableDictionary dictionaryWithDictionary:[sharedInfo dictionary]]];
    
    TicketPrintView *view = [[TicketPrintView alloc] initWithTickets:(NSArray *)tickets];
    printOp = [NSPrintOperation printOperationWithView:view
                                             printInfo:printInfo];
    
    [printOp setShowsPrintPanel:YES];
    [printOp runOperation];
}

- (void)removeTicket
{
    NSArray *selected = [ticketController selectedObjects];
    NSLog(@"Selected = %@", selected);
    
    if ([[DataController sharedDataController] removeTicket:[selected objectAtIndex:0]]) {
        NSLog(@"Ticket was removed");
        [self setTickets:[[DataController sharedDataController] tickets]];
        ticketsBeforeFilter = tickets;
        [self searchTickets];
        [ticketTable reloadData];
    }
    else {
        NSLog(@"Failure removing ticket!");
    }
}

// Updates all the fields with the currently selected ticket's information.
- (void)updateFields
{
    // If the user clicked a column to sort the data, this will get the most current sort.
    NSArray *arrangedTickets = [ticketController arrangedObjects];
    
    NSUInteger selection = [ticketController selectionIndex];
    
    NSArray *dateFields = [NSArray arrayWithObjects:_orderDateField, _hearingDateField, _hearingTimeField, nil];
    NSArray *fields = [NSArray arrayWithObjects:_ticketNumberField, _callNumberField, _socField, _canField, _statusField, nil];
    NSArray *nameFields = [NSArray arrayWithObjects:_claimantNameField, _workedByField, _judgePresidingField, _officeField,
                       _repField, _vocField, _meField, _otherField, nil];
    
    // Blank out all fields.
    for (NSTextField *field in fields) {
        [field setStringValue:@""];
    }
    for (NSTextField *field in nameFields) {
        [field setStringValue:@""];
    }
    
    if (selection == -1 || selection > [tickets count]) {
        // Nothing is selected so unenable the Remove Button and the Update Button.
        [_removeButton setEnabled:NO];
        [_updateButton setEnabled:NO];
        
        // Nothing is selected, so fill each of the date fields with "XX/XX/XXXX"
        for (NSTextField *field in dateFields) {
            [field setStringValue:@"XX/XX/XXXX"];
            [field sizeToFit];
        }
        // Nothing is selected, so fill each of the fields with "XXX".
        for (NSTextField *field in fields) {
            [field setStringValue:@"XXXX"];
            [field sizeToFit];
        }
        // Nothing is selected, so fill each of the fields with "No Selection".
        for (NSTextField *field in nameFields) {
            [field setStringValue:@"No Selection"];
            [field sizeToFit];
        }
        
        return;
    }
    else if ([[ticketController selectedObjects] count] > 1) {
        // Something is selected so enable the Remove button.
        [_removeButton setEnabled:YES];
        
        // More than one thing is selected so unenable the Update button.
        [_updateButton setEnabled:NO];
        
        // More than one thing was selected, so fill each of the fields with "Multiple Values" and make the fields
        //  unedittable.
        for (NSTextField *field in dateFields) {
            [field setStringValue:@"XX/XX/XXXX"];
            [field sizeToFit];
        }
        for (NSTextField *field in fields) {
            [field setStringValue:@"XXXX"];
            [field sizeToFit];
        }
        for (NSTextField *field in nameFields) {
            [field setStringValue:@"Multiple Values"];
            [field sizeToFit];
        }
        
        return;
    }
    else {
        // Something is selected so enable the Remove button.
        [_removeButton setEnabled:YES];
        
        // Only one thing is selected so enable the update button
        [_updateButton setEnabled:YES];
    }
    
    // Grabs the selected ticket.
    Ticket *ticket = arrangedTickets[selection];
    
    // Decides whether to display: "Last Name, First Name" or "First Name Last Name".
    if (lastNameFirst) {
        [_claimantNameField setStringValue:[NSString stringWithFormat:@"%@, %@", [ticket last_name], [ticket first_name]]];
        
        if ([ticket workedBy] != nil) [_workedByField setStringValue:[NSString stringWithFormat:@"%@, %@", [[ticket workedBy] last_name], [[ticket workedBy] first_name]]];
        else [_workedByField setStringValue:@""];
        
        if ([ticket judge_presided] != nil) [_judgePresidingField setStringValue:[NSString stringWithFormat:@"%@, %@", [[ticket judgePresided] last_name], [[ticket judgePresided] first_name]]];
        else [_judgePresidingField setStringValue:@""];
    }
    else {
        [_claimantNameField setStringValue:[NSString stringWithFormat:@"%@ %@", [ticket first_name], [ticket last_name]]];
        
        if ([ticket workedBy] != nil) [_workedByField setStringValue:[NSString stringWithFormat:@"%@ %@", [[ticket workedBy] first_name], [[ticket workedBy] last_name]]];
        else [_workedByField setStringValue:@""];
        
        if ([ticket workedBy] != nil) [_judgePresidingField setStringValue:[NSString stringWithFormat:@"%@ %@", [[ticket judgePresided] first_name], [[ticket judgePresided] last_name]]];
        else [_workedByField setStringValue:@""];
    }
    
    // Sizes the field to fit the text inside of it.
    [_claimantNameField sizeToFit];
    [_workedByField sizeToFit];
    [_judgePresidingField sizeToFit];
    
    // Update the other fields that do not need any formatting.
    [_officeField setStringValue:[NSString stringWithFormat:@"%@, %@", [[ticket heldAt] name], [[ticket heldAt] office_code]]];
    [_callNumberField setStringValue:[ticket call_order_no]];
    [_ticketNumberField setStringValue:[[ticket ticket_no] stringValue]];
    [_socField setStringValue:[ticket soc]];
    [_statusField setStringValue:[ticket status]];
    if ([ticket heldAt] != nil) [_canField setStringValue:[[ticket heldAt] can]];
    else [_canField setStringValue:@""];
    
    // Creates the formats for the dates and times.
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/YYYY"];
    [timeFormat setDateFormat:@"h:mm a"];
    
    [_orderDateField setStringValue:[dateFormat stringFromDate:[ticket order_date]]];
    [_hearingDateField setStringValue:[dateFormat stringFromDate:[ticket hearing_date]]];
    [_hearingTimeField setStringValue:[timeFormat stringFromDate:[ticket hearing_time]]];
    
    // Makes sure the label is big enough to fit everything inside it.
    for (NSTextField *field in dateFields) {
        [field sizeToFit];
    }
    for (NSTextField *field in fields) {
        [field sizeToFit];
    }
    for (NSTextField *field in nameFields) {
        [field sizeToFit];
    }
}

- (void)searchTickets
{
    // Grab the search string from the search field.
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
    NSArray *keys = @[@"ticket_no.stringValue", @"first_name", @"last_name", @"heldAt.office_code", @"heldAt.name",
                      @"status", @"workedBy.first_name", @"workedBy.last_name"];
    
    // A filter created based on the keys above.
    NSString *filter = [self filterForKeys:keys];
    
    for (NSString *token in searchTokens) {
        // Inserts the token to compare against in between each of the above keys.
        NSArray *args = [self insertToken:token forKeys:keys];
        searchPredicate = [NSPredicate predicateWithFormat:filter argumentArray:args];
        
        // Work around. If the filtered array is empty, ticketController will through an error because selection index
        //  is outside the bounds of the tickets array. This will update the selection index manually.
        NSMutableArray *filteredArray = (NSMutableArray *)[tickets filteredArrayUsingPredicate:searchPredicate];
        [self setTickets:filteredArray];
        
        NSLog(@"Selection Index After Search = %ld", [ticketController selectionIndex]);
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
