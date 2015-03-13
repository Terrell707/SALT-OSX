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
    
    NSLog(@"Window Name from TicketViewController=%@", [[self view] window]);
    NSLog(@"Ticket View Controller viewDidAppear");
    
    lastNameFirst = YES;
    
    // Populates the table with tickets returned from the server.
    [self setTickets:[[DataController sharedDataController] tickets]];
    
    // Observes the DataController for any new tickets that were added.
    [[DataController sharedDataController] addObserver:self
                                            forKeyPath:@"tickets"
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
    
    // Observes the TicketController for any time the selection is changed.
    [ticketController addObserver:self forKeyPath:@"selectionIndex" options:NSKeyValueObservingOptionNew context:nil];
    
    // Keeps a copy of the tickets so that they are not overwritten by searching.
    ticketsBeforeFilter = tickets;
    
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
    
    if ([segue.identifier isEqualToString:@"InsertTicketSegue"]) {
        [controller setTitleString:@"Create Hearing Ticket"];
        [controller setClearBtnString:@"Clear"];
    }
    if ([segue.identifier isEqualToString:@"UpdateTicketSegue"]) {
        [controller setTitleString:@"Update Hearing Ticket"];
        [controller setClearBtnString:@"Revert"];
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
    
    if ([keyPath isEqualToString:@"selectionIndex"]) {
        NSLog(@"Selection = %ld", [ticketController selectionIndex]);
        [self updateFields];
    }
}

- (void)controlTextDidChange:(NSNotification *)notification
{
    // Will update the search whenever something is typed into the search field.
    if ([notification object] == searchField) {
        [self searchTickets];
    }
    else {
        [self changeTicketInfoFromField:[notification object]];
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

- (void)updateFields
{
    NSUInteger selection = [ticketController selectionIndex];
    
    NSArray *numberFields = [NSArray arrayWithObjects:_ticketNumberField, _callNumberField, _socField, _canField, _statusField, nil];
    NSArray *nameFields = [NSArray arrayWithObjects:_claimantNameField, _workedByField, _judgePresidingField, _officeField,
                       _repNameField, _vocNameField, _medNameField, _otherNameField, nil];
    
    // Blank out all fields.
    for (NSTextField *field in numberFields) {
        [field setStringValue:@""];
    }
    for (NSTextField *field in nameFields) {
        [field setStringValue:@""];
    }
    
    if (selection == -1 || selection > [tickets count]) {
        // Nothing is selected, so fill each of the fields with "XXX" and make the field unedittable.
        for (NSTextField *field in numberFields) {

        }
        // Nothing is selected, so fill each of the fields with "No Selection" and make the field unedittable.
        for (NSTextField *field in nameFields) {
            [field setPlaceholderString:@"No Selection"];
            [field setEditable:NO];
        }
        return;
    }
    else if ([[ticketController selectedObjects] count] > 1) {
        // More than one thing was selected, so fill each of the fields with "Multiple Values" and make the fields
        //  unedittable.
        for (NSTextField *field in nameFields) {
            [field setPlaceholderString:@"Multiple Values"];
            [field setEditable:NO];
        }
        return;
    }
    else {
        // Only one thing is selected, so make all the fields edittable.
        for (NSTextField *field in nameFields) {
            [field setPlaceholderString:@""];
            [field setEditable:YES];
        }
    }
    
    // Decides whether to display: "Last Name, First Name" or "First Name Last Name".
    if (lastNameFirst) {
        [_claimantNameField setStringValue:[NSString stringWithFormat:@"%@, %@", [tickets[selection] last_name], [tickets[selection] first_name]]];
        [_workedByField setStringValue:[NSString stringWithFormat:@"%@, %@", [[tickets[selection] workedBy] last_name], [[tickets[selection] workedBy] first_name]]];
        [_judgePresidingField setStringValue:[NSString stringWithFormat:@"%@, %@", [[tickets[selection] judgePresided] last_name], [[tickets[selection] judgePresided] first_name]]];
    }
    else {
        [_claimantNameField setStringValue:[NSString stringWithFormat:@"%@ %@", [tickets[selection] first_name], [tickets[selection] last_name]]];
        [_workedByField setStringValue:[NSString stringWithFormat:@"%@ %@", [[tickets[selection] workedBy] first_name], [[tickets[selection] workedBy] last_name]]];
        [_judgePresidingField setStringValue:[NSString stringWithFormat:@"%@ %@", [[tickets[selection] judgePresided] first_name], [[tickets[selection] judgePresided] last_name]]];
    }
    
    // Add the office to the text field.
    [_officeField setStringValue:[NSString stringWithFormat:@"%@, %@", [[tickets[selection] heldAt] name], [[tickets[selection] heldAt] office_code]]];
}

- (void)changeTicketInfoFromField:(NSTextField *)field
{
    NSArray *nameSplit;
    NSDictionary *name;
    NSUInteger selection = [ticketController selectionIndex];
    
    if (lastNameFirst) {
        nameSplit = [[field stringValue] componentsSeparatedByString:@", "];
        name = [NSDictionary dictionaryWithObjectsAndKeys:nameSplit[1], @"first_name", nameSplit[0], @"last_name", nil];
    }
    else {
        nameSplit = [[field stringValue] componentsSeparatedByString:@" "];
        name = [NSDictionary dictionaryWithObjectsAndKeys:nameSplit[0], @"first_name", nameSplit[1], @"last_name", nil];
    }
    
    NSLog(@"Selected Ticket = %@", [tickets objectAtIndex:selection]);
    
    if (field == _claimantNameField) {
        
    }
    else if (field == _repNameField) {
        
    }
    else if (field == _vocNameField) {
        
    }
    else if (field == _medNameField) {
        
    }
    else if (field == _otherNameField) {
        
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
//        if (filteredArray.count <= 0) {
//            [ticketController setSelectionIndex:0];
//        }
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
