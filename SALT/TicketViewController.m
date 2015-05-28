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

#pragma mark View Controller methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Determines whether to move focus to the Table View or not.
    firstLoad = NO;
    
    // Observes the DataController for any new tickets that were added.
    [[DataController sharedDataController] addObserver:self
                                            forKeyPath:@"tickets"
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
    
    // Populates the context menu with all of the column names.
    [self fillHeaderMenu:ticketTable];
    
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
    [self firstLastNameOrder];
    NSLog(@"Calling Update Fields!");
    
    // Displays the information for the initial selected ticket.
    [self updateFields];
    
    // Moves focus to the ticket table when view first loads and makes sure it doesn't constantly jump back.
    if (firstLoad == NO) {
        [self.view.window makeFirstResponder:ticketTable];
        firstLoad = YES;
    }
    
    // Does a search on the tickets when the view is brought back up.
    [self searchTickets];
}

#pragma mark Observing methods
- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Segue=%@", [segue identifier]);
    
    id controller = segue.destinationController;

    NSLog(@"Segue End Destination = %@", controller);
    
    // Presents the View for a user to insert a ticket.
    if ([segue.identifier isEqualToString:@"InsertTicketSegue"]) {
        InsertTicketViewController *itvcController = controller;
        [itvcController setTitleString:@"Create Hearing Ticket"];
        [itvcController setClearBtnString:@"Clear"];
        [itvcController setUpdateTicket:NO];
        [itvcController setLastNameFirst:&(lastNameFirst)];
    }
    
    // Presents the View for a user to update a ticket.
    if ([segue.identifier isEqualToString:@"UpdateTicketSegue"]) {
        InsertTicketViewController *itvcController = controller;
        [itvcController setTitleString:@"Update Hearing Ticket"];
        [itvcController setClearBtnString:@"Revert"];
        [itvcController setUpdateTicket:YES];
        
        // Grabs the sorted tickets if the user clicked a column to sort the table.
        NSArray *arrangedTickets = [ticketController arrangedObjects];
        NSUInteger selection = [ticketController selectionIndex];
        Ticket *ticket = arrangedTickets[selection];
        
        [itvcController setOldTicket:ticket];
        [itvcController setLastNameFirst:&(lastNameFirst)];
    }
    
    // Presents the View for a user to change settings on the table.
    if ([segue.identifier isEqualToString:@"TicketSettingsSegue"]) {
        TicketSettingsViewController *tsvcController = controller;
        [tsvcController setTicketTable:ticketTable];
        [tsvcController setLastNameFirst:&(lastNameFirst)];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // Will reload the table with new tickets that were added.
    if ([keyPath isEqualToString:@"tickets"]) {
        [self setTickets:[[DataController sharedDataController] tickets]];
        ticketsBeforeFilter = tickets;
        [self searchTickets];
        [self firstLastNameOrder];
        [self updateFields];
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

- (void)firstLastNameOrder
{
    NSTableColumn *clmtNameColumn = [ticketTable tableColumnWithIdentifier:@"clmt_full_name"];
    NSTableColumn *empNameColumn = [ticketTable tableColumnWithIdentifier:@"emp_full_name"];
    NSTableColumn *judgeNameColumn = [ticketTable tableColumnWithIdentifier:@"judge_full_name"];
    
    [self bindFullNameColumn:clmtNameColumn withFirst:@"first_name" andLast:@"last_name"];
    [self bindFullNameColumn:empNameColumn withFirst:@"workedBy.first_name" andLast:@"workedBy.last_name"];
    [self bindFullNameColumn:judgeNameColumn withFirst:@"judgePresided.first_name" andLast:@"judgePresided.last_name"];
}

- (void)bindFullNameColumn:(NSTableColumn *)col withFirst:(NSString *)first andLast:(NSString *)last
{
    NSString *namePattern;
    NSString *sortKey;
    
    // If the last name boolean is set, then the full name will be displayed with last name first,
    //  otherwise it will be first name first. This also determines its sorting order.
    if (lastNameFirst) {
        namePattern = @"%{value2}@, %{value1}@";
        sortKey = last;
    }
    else {
        namePattern = @"%{value1}@ %{value2}@";
        sortKey = first;
    }
    
    NSString *value1 = [NSString stringWithFormat:@"arrangedObjects.%@", first];
    NSString *value2 = [NSString stringWithFormat:@"arrangedObjects.%@", last];
    
    [col bind:@"displayPatternValue1"
                toObject:ticketController
             withKeyPath:value1
                 options:@{NSDisplayPatternBindingOption : namePattern}];
    
    [col bind:@"displayPatternValue2"
                toObject:ticketController
             withKeyPath:value2
                 options:@{NSDisplayPatternBindingOption : namePattern}];
    
    // Sets the sort descriptor for the column.
    [col setSortDescriptorPrototype:[NSSortDescriptor sortDescriptorWithKey:sortKey
                                                                  ascending:YES
                                                                   selector:@selector(caseInsensitiveCompare:)]];
}

#pragma mark NSMenu Methods
- (void)fillHeaderMenu:(NSTableView *)table
{
    // Creates a context menu.
    NSMenu *menu = [[table headerView] menu];
    
    // Grabs each of the column names and adds it to the menu.
    for (NSTableColumn *column in [table tableColumns]) {
        NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:[column.headerCell stringValue]
                                                          action:@selector(toggleColumn:)
                                                   keyEquivalent:@""];
        [menuItem setTarget:self];
        [menuItem setRepresentedObject:column];
        [menu addItem:menuItem];
    }
}

- (void)menuNeedsUpdate:(NSMenu *)menu
{
    for (NSMenuItem *menuItem in [menu itemArray]){
        NSTableColumn *column = [menuItem representedObject];
        [menuItem setState:column.isHidden ? NSOffState : NSOnState];
    }
}

#pragma mark Action Methods
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

- (void)toggleColumn:(id)sender
{
    NSTableColumn *col = [sender representedObject];
    [col setHidden:![col isHidden]];
}

#pragma mark Data Modification methods
- (void)removeTicket
{
    NSArray *selected = [ticketController selectedObjects];
    NSLog(@"Selected = %@", selected);
    
    // Goes through each selected ticket and removes it from the database and list.
    for (Ticket *ticket in selected) {
        // Goes through each expert that is tied to the ticket and removes it from the witness database and list.
        NSArray *experts = [ticket.helpedBy allObjects];
        for (Expert *expert in experts) {
            if ([[DataController sharedDataController] removeExpert:expert forTicket:ticket]) {
                NSLog(@"Witness was removed");
            }
            else {
                NSLog(@"Witness was not removed!");
            }
        }
        // Finally, deletes the ticket.
        if ([[DataController sharedDataController] removeTicket:ticket]) {
            NSLog(@"Ticket was removed");
            [self setTickets:[[DataController sharedDataController] tickets]];
            [ticketTable reloadData];
        }
        else {
            NSLog(@"Failure removing ticket!");
        }
    }
    
    // Updates the search with the modified list of tickets.
    ticketsBeforeFilter = tickets;
    [self searchTickets];
    [ticketTable reloadData];
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
    
    // If nothing is selected, then return.
    if (ticket == nil) {
        return;
    }
    
    // Places the experts with their associated roles in a dictionary.
    NSDictionary *experts = [Expert findExpertsForTicket:ticket];
    NSArray *roles = [NSArray arrayWithObjects:@"REP", @"VE", @"ME", @"OTHER", @"INS", nil];
    NSArray *expertFields = [NSArray arrayWithObjects:_repField, _vocField, _meField, _otherField, _interpreterField, nil];
    NSDictionary *fieldsByRole = [NSDictionary dictionaryWithObjects:expertFields forKeys:roles];
    
    // Decides whether to display: "Last Name, First Name" or "First Name Last Name".
    if (lastNameFirst) {
        // Formats Claimant Name.
        [_claimantNameField setStringValue:[NSString stringWithFormat:@"%@, %@", [ticket last_name], [ticket first_name]]];
        
        // Formats the employee who worked this ticket.
        if ([ticket workedBy] != nil) [_workedByField setStringValue:[NSString stringWithFormat:@"%@, %@", [[ticket workedBy] last_name], [[ticket workedBy] first_name]]];
        else [_workedByField setStringValue:@""];
        
        // Formats the judge who presided over this ticket.
        if ([ticket judge_presided] != nil) [_judgePresidingField setStringValue:[NSString stringWithFormat:@"%@, %@", [[ticket judgePresided] last_name], [[ticket judgePresided] first_name]]];
        else [_judgePresidingField setStringValue:@""];
        
        // Formats each expert and places them in their field.
        for (NSString *role in roles) {
            NSTextField *field = [fieldsByRole valueForKey:role];
            Expert *expert = ([experts valueForKey:role] != [NSNull null]) ? [experts valueForKey:role] : nil;
            if (expert != nil) [field setStringValue:[NSString stringWithFormat:@"%@, %@", [expert last_name], [expert first_name]]];
            else [field setStringValue:@""];
        }
    }
    else {
        // Formats Claimant Name.
        [_claimantNameField setStringValue:[NSString stringWithFormat:@"%@ %@", [ticket first_name], [ticket last_name]]];
        
        // Formats the employee who worked this ticket.
        if ([ticket workedBy] != nil) [_workedByField setStringValue:[NSString stringWithFormat:@"%@ %@", [[ticket workedBy] first_name], [[ticket workedBy] last_name]]];
        else [_workedByField setStringValue:@""];
        
        // Formats the judge who presided over this ticket.
        if ([ticket judgePresided] != nil) [_judgePresidingField setStringValue:[NSString stringWithFormat:@"%@ %@", [[ticket judgePresided] first_name], [[ticket judgePresided] last_name]]];
        else [_judgePresidingField setStringValue:@""];
        
        // Formats each expert and places them in their field.
        for (NSString *role in roles) {
            NSTextField *field = [fieldsByRole valueForKey:role];
            Expert *expert = ([experts valueForKey:role] != [NSNull null]) ? [experts valueForKey:role] : nil;
            if (expert != nil) [field setStringValue:[NSString stringWithFormat:@"%@ %@", [expert first_name], [expert last_name]]];
            else [field setStringValue:@""];
        }
    }
    
    // Sizes the field to fit the text inside of it.
    [_claimantNameField sizeToFit];
    [_workedByField sizeToFit];
    [_judgePresidingField sizeToFit];
    
    // Update the other fields that do not need any formatting.
    if ([ticket heldAt] != nil) {
        [_officeField setStringValue:[NSString stringWithFormat:@"%@, %@", [[ticket heldAt] name], [[ticket heldAt] office_code]]];
        [_canField setStringValue:[[ticket heldAt] can]];
    }
    else {
        [_officeField setStringValue:@""];
        [_canField setStringValue:@""];
    }
    [_callNumberField setStringValue:[ticket call_order_no]];
    [_ticketNumberField setStringValue:[[ticket ticket_no] stringValue]];
    [_socField setStringValue:[ticket soc]];
    [_statusField setStringValue:[ticket status]];
    [_fullAmountBtn setState:[ticket full_pay]];
    
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
    
    NSLog(@"Tickets Full Pay: %d", [ticket full_pay]);
}

- (void)searchTickets
{
    // An array of keys that will be compared against.
    NSArray *keys = @[@"ticket_no.stringValue", @"first_name", @"last_name", @"heldAt.office_code", @"heldAt.name",
                      @"status", @"workedBy.first_name", @"workedBy.last_name"];
    
    // Restores the ticket array to what it was prior to being searched.
    [self setTickets:(NSMutableArray *)ticketsBeforeFilter];
    
    // Searchs the ticket array using the text entered into the search field, then displays it in the table.
    NSMutableArray *filteredTickets = [DataSearch searchData:tickets withKeys:keys withSearchText:[searchField stringValue]];
    [self setTickets:filteredTickets];
}

@end
