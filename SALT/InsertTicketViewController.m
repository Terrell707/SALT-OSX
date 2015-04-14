//
//  InsertTicketViewController.m
//  SALT
//
//  Created by Adrian T. Chambers on 2/14/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "InsertTicketViewController.h"

@interface InsertTicketViewController ()
@end

@implementation InsertTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    fieldFormatter = [[FieldFormatter alloc] initWithLastNameFirst:*(_lastNameFirst)];
    
    // If a user adds a new expert, we need to know so that we can update the combo boxes.
    [[DataController sharedDataController] addObserver:self
                                            forKeyPath:@"experts"
                                               options:NSKeyValueObservingOptionNew
                                               context:nil];
    
    // Sets the colors that will be used for "Success" and "Error".
    successColor = [NSColor blueColor];
    errorColor = [NSColor redColor];
    
    // Grabs the needed information from the Data controller.
    hearingStatus = [[DataController sharedDataController] hearingStatus];
    employees = [[DataController sharedDataController] employees];
    judges = [[DataController sharedDataController] judges];
    experts = [[DataController sharedDataController] experts];
    sites = [[DataController sharedDataController] sites];
    
    // Sets defaults for the date pickers.
    [_orderDatePicker setDateValue:[NSDate date]];
    [_hearingDatePicker setDateValue:[NSDate date]];
    
    // Fill in the "status" combo box.
    for (int x = 0; x < [hearingStatus count]; x++) {
        [_statusCombo addItemWithObjectValue:hearingStatus[x]];
    }
    
    // Fill in the "worked by" combo box.
    [fieldFormatter fillComboBox:_workedByCombo withItems:employees];
    
    // Fill in the "judges" combo box.
    [fieldFormatter fillComboBox:_judgePresidingCombo withItems:judges];
    
    // Fill in the "held at office" combo box.
    for (int x = 0; x < [sites count]; x++) {
        NSString *officeCode = [sites[x] valueForKey:@"office_code"];
        NSString *name = [sites[x] valueForKey:@"name"];
        NSString *site = [NSString stringWithFormat:@"%@, %@", name, officeCode];
        [_officeCombo addItemWithObjectValue:site];
    }
    
    // Populates all the expert combo boxes with their relevant data.
    [self fillExpertComboBoxes];
}

- (void)viewDidAppear
{
    NSLog(@"Update Boolean = %d", _updateTicket);
    
    if (_updateTicket) {
        // Populates each of the fields if "Update" was clicked and there is information for that field.
        [_titleLabel setStringValue:@"Update Hearing Ticket"];
        [_clearBtn setTitle:@"Revert"];
        [self revertForm];
    }
    else {
        [_titleLabel setStringValue:@"Create Hearing Ticket"];
        [_clearBtn setTitle:@"Clear"];
    }

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"experts"]) {
        [self fillExpertComboBoxes];
    }
}

- (IBAction)clearBtn:(NSButton *)sender {
    // If the "Update" button was clicked, set all the fields to what the ticket contains.
    if (_updateTicket) {
        [self clearForm];
        [self revertForm];
    }
    // Otherwise, present a clear form.
    else {
        [self clearForm];
    }
}

- (IBAction)dismissBtn:(NSButton *)sender {
    [[[self view] window] close];
}

- (IBAction)submitBtn:(NSButton *)sender {
    BOOL fieldError = NO;
    NSMutableString *errorDescription = [[NSMutableString alloc] init];
    
    // Checks to make sure needed information is populated.
    if ([[_ticketNumberField stringValue] length] < 8) {
        fieldError = YES;
        
        // Add the error description to the string.
        [errorDescription appendString:@"Ticket Number must be exactly 8 numbers long"];

        // Will highlight the field in a slight red.
        [fieldFormatter setErrorBackground:_ticketNumberField];
        
        // Moves the focus to the ticket number field.
        [self.view.window makeFirstResponder:_ticketNumberField];
    }
    else {
        [fieldFormatter clearErrorBackground:_ticketNumberField];
    }
    
    if ([_statusCombo indexOfSelectedItem] == -1) {
        if (fieldError == YES) {
            // Append a new line so that the label expands.
            [errorDescription appendString:@"\n"];
        }
        else {
            // Otherwise, set the error value to true and move the user to the status combo.
            fieldError = YES;
            [self.view.window makeFirstResponder:_statusCombo];
        }
        // Add the error description to the string and highlight the combo box.
        if ([_statusCombo.stringValue isEqualToString:@""])
            [errorDescription appendString:@"A status must be selected from the 'Status' drop down"];
        else
            [errorDescription appendString:@"The entered status doesn't exist as a possible choice. Select one from the 'Status' drop down"];
        [fieldFormatter setErrorBackground:_statusCombo];
    }
    else {
        [fieldFormatter clearErrorBackground:_statusCombo];
    }
    
    if ([_workedByCombo indexOfSelectedItem] == -1) {
        if (fieldError == YES) {
            // Append a new line so that the label expands.
            [errorDescription appendString:@"\n"];
        }
        else {
            // Otherwise, set the error value to true and move the user to the worked by combo.
            fieldError = YES;
            [self.view.window makeFirstResponder:_workedByCombo];
        }
        // Display the error label.
        if ([_workedByCombo.stringValue isEqualToString:@""])
            [errorDescription appendString:@"An employee must be selected from the 'Worked By' drop down"];
        else
            [errorDescription appendString:@"The entered employee doesn't exist as a possible choice. Select one from the 'Worked By' drop down"];
        [fieldFormatter setErrorBackground:_workedByCombo];
    }
    else {
        [fieldFormatter clearErrorBackground:_workedByCombo];
    }
    
    if ([_judgePresidingCombo indexOfSelectedItem] == -1) {
        if (fieldError == YES) {
            // Append a new line so that the label expands.
            [errorDescription appendString:@"\n"];
        }
        else {
            // Otherwise, set the error value to true and move the user to judge combo.
            fieldError = YES;
            [self.view.window makeFirstResponder:_judgePresidingCombo];
        }
        // Add the error description to the string and highlight the combo box.
        if ([_judgePresidingCombo.stringValue isEqualToString:@""])
            [errorDescription appendString:@"A judge must be selected from the 'Judge Presided' drop down list"];
        else
            [errorDescription appendString:@"The entered judge doesn't exist as a possible choice. Select one from the 'Judge Presided' drop down list"];
        [fieldFormatter setErrorBackground:_judgePresidingCombo];
    }
    else {
        [fieldFormatter clearErrorBackground:_judgePresidingCombo];
    }
    
    if ([_officeCombo indexOfSelectedItem] == -1) {
        if (fieldError == YES) {
            // Append a new line so that the label expands.
            [errorDescription appendString:@"\n"];
        }
        else {
            // Otherwise, set the error value to true and move the user to office combo.
            fieldError = YES;
            [self.view.window makeFirstResponder:_officeCombo];
        }
        // Add the error description to the string and highlight the combo box.
        if ([_officeCombo.stringValue isEqualToString:@""])
            [errorDescription appendString:@"A office must be selected from the 'Held At Office' drop down list"];
        else
            [errorDescription appendString:@"The entered office doesn't exist as a possible choice. Select one from the 'Held At Office' drop down list"];
        [fieldFormatter setErrorBackground:_officeCombo];
    }
    else {
        [fieldFormatter clearErrorBackground:_officeCombo];
    }
    
    // Sets the error description and shows it. Otherwise, it clears the error label.
    if (fieldError) {
        [_statusLabel setStringValue:errorDescription];
        [_statusLabel setTextColor:errorColor];
        [_statusLabel setHidden:NO];
        
        return;
    }
    else {
        [_statusLabel setHidden:YES];
        [_statusLabel setStringValue:@""];
    }
    
    // Creates the formatters that we will need.
    NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
    
    // Converts the dates and times to our needed values.
    NSString *orderDate = [dateFormat stringFromDate:[_orderDatePicker dateValue]];
    NSString *hearingDate = [dateFormat stringFromDate:[_hearingDatePicker dateValue]];
    NSString *hearingTime = [timeFormat stringFromDate:[_hearingTimePicker dateValue]];
    
    NSLog(@"Order Date = %@", orderDate);
    NSLog(@"Hearing Date = %@", hearingDate);
    NSLog(@"Hearing Time = %@", hearingTime);
    
    // Creates a new ticket using the entered information.
    Ticket *newTicket = [[Ticket alloc] init];
    [newTicket setOrder_date:[dateFormat dateFromString:orderDate]];
    [newTicket setCall_order_no:[_orderNumberField.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    [newTicket setFirst_name:[_firstNameField.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    [newTicket setLast_name:[_lastNameField.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    [newTicket setTicket_no:[numFormat numberFromString:[_ticketNumberField.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
    [newTicket setSoc:[_socField.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    [newTicket setHearing_date:[dateFormat dateFromString:hearingDate]];
    [newTicket setHearing_time:[timeFormat dateFromString:hearingTime]];
    [newTicket setStatus:[_statusCombo.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    [newTicket setFull_pay:[_fullAmountBtn state]];
    
    // Find the employee that was typed in and get his/her id number. If they don't exist, throw an error.
    NSArray *empResult = [self findInfoFromList:employees forCombo:_workedByCombo];
    if ([empResult count] <= 0) {
        NSLog(@"Couldn't find the selected employee!");
        return;
    }
    [newTicket setEmp_worked:[empResult[0] database_id]];
    [newTicket setWorkedBy:empResult[0]];
    
    // Find the judge that was typed in and get his/her id number. If they don't exist, throw an error.
    NSArray *judgeResult = [self findInfoFromList:judges forCombo:_judgePresidingCombo];
    if ([judgeResult count] <= 0) {
        NSLog(@"Couldn't find the selected judge!");
        return;
    }
    [newTicket setJudge_presided:[judgeResult[0] judge_id]];
    [newTicket setJudgePresided:judgeResult[0]];
    
    // Grabs the office code from the 'Worked At' combo box.
    NSArray *officeResult = [self findOfficeFromList:sites forCombo:_officeCombo];
    if ([officeResult count] <= 0) {
        NSLog(@"Couldn't find the selected office!");
        return;
    }
    [newTicket setAt_site:[officeResult[0] office_code]];
    [newTicket setHeldAt:officeResult[0]];
    
    // Find each of the experts that were typed in. If they don't exist, add them to the database.
    NSArray *expertCombos = [NSArray arrayWithObjects:_repCombo, _vocationalCombo, _medicalCombo, _interpreterCombo, nil];
    NSArray *expertRoles = [NSArray arrayWithObjects:@"REP", @"VE", @"ME", @"INS", nil];
    NSDictionary *expertDict = [NSDictionary dictionaryWithObjects:expertCombos forKeys:expertRoles];
    // Goes through each role's combo box.
    for (NSString *role in expertRoles) {
        NSComboBox *combo = [expertDict valueForKey:role];
        NSString *comboValue = [combo.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        // If nothing was typed into the combobox, skip it.
        if ([comboValue isEqualToString:@""]) {
            continue;
        }
        
        // Looks for the person typed into the specified role.
        NSArray *expertResult = [self findInfoFromList:experts forCombo:combo];
        
        // If it isn't found, then the user typed an unknown expert into the field so we will try
        //  to add it to the database and then look for it again in the updated list.
        Expert *expert;
        if (expertResult.count <= 0) {
            NSLog(@"Couldn't find the expert for %@!", role);
            expert = [self addNewExpertFromCombo:combo withRole:role];
            if (expert == nil) {
                [_statusLabel setStringValue:@"Could not add the expert to the database!"];
                [_statusLabel setTextColor:errorColor];
                [_statusLabel setHidden:NO];
                return;
            }
        }
        else {
            expert = expertResult[0];
        }
    
        // Tie the expert to the ticket.
        [newTicket addHelpedByObject:expert];
    }
    
    NSLog(@"Experts associated with this ticket.");
    for (Expert *e in newTicket.helpedBy) {
        NSLog(@"%@", e.first_name);
    }
    
    // If the user clicked the "Add" button, this will create a new hearing Ticket.
    if (_updateTicket == NO) {
        BOOL inserted = [[DataController sharedDataController] insertTicket:newTicket];
        if (inserted) {
            NSLog(@"It went through");
            [self clearForm];
            [_statusLabel setStringValue:@"Ticket Successfully Added!"];
            [_statusLabel setTextColor:successColor];
            [_statusLabel setHidden:NO];
        } else {
            NSLog(@"It did not go through");
            [_statusLabel setStringValue:@"Error: Ticket did not go through!"];
            [_statusLabel setTextColor:errorColor];
            [_statusLabel setHidden:NO];
        }
        
        NSArray *witnesses = [newTicket.helpedBy allObjects];
        for (Expert *expert in witnesses) {
            // Creates a new Witness with this current expert and new ticket information to send to the database.
            Witness *newWitness = [[Witness alloc] init];
            [newWitness setExpert_id:expert.expert_id];
            [newWitness setExpert:expert];
            [newWitness setTicket_no:newTicket.ticket_no];
            [newWitness setTicket:newTicket];
            inserted = [[DataController sharedDataController] insertWitness:newWitness];
            if (inserted) {
                NSLog(@"Witness %@ %@ went through.", expert.first_name, expert.last_name);
            } else {
                NSLog(@"Witness %@ %@ did not go through.", expert.first_name, expert.last_name);
            }
        }
    }
    // Otherwise, we will update the old ticket.
    else {
        BOOL updated = [[DataController sharedDataController] updateTicket:_oldTicket withChanges:newTicket];
        if (updated) {
            NSLog(@"Ticket was updated.");
            // Sets the old ticket to the updated ticket.
            _oldTicket = newTicket;
            // Updates all the fields to the new updated ticket.
            [self clearForm];
            [self revertForm];
            
            [_statusLabel setStringValue:@"Ticket Successfully Updated!"];
            [_statusLabel setTextColor:successColor];
            [_statusLabel setHidden:NO];
        } else {
            NSLog(@"Ticket was not successfully updated!");
            [_statusLabel setStringValue:@"Error: Ticket was not updated!"];
            [_statusLabel setTextColor:errorColor];
            [_statusLabel setHidden:NO];
        }
    }
}

- (NSArray *)findInfoFromList:(NSArray *)list forCombo:(NSComboBox *)combo
{
    // Searchs the passed in list for the name selected in the passed in combobox.
    NSDictionary *name = [fieldFormatter unformatName:[combo stringValue]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"first_name == %@ && last_name == %@",
                                   name[@"first_name"], name[@"last_name"]];
    NSArray *result = [list filteredArrayUsingPredicate:predicate];
    
    return result;
}

- (NSArray *)findOfficeFromList:(NSArray *)list forCombo:(NSComboBox *)combo
{
    // Searchs the passed in list for the office selected in the passed in combobox.
    NSArray *office = [[_officeCombo stringValue] componentsSeparatedByString:@", "];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@ && office_code == %@",
                              office[0], office[1]];
    NSArray *result = [list filteredArrayUsingPredicate:predicate];
    
    return result;
}

- (Expert *)addNewExpertFromCombo:(NSComboBox *)combo withRole:(NSString *)role
{
    // Takes the string value from the combobox and trims it.
    NSString *comboString = combo.stringValue;
    comboString = [comboString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([comboString isEqualToString:@""]) {
        return nil;
    }
    
    // Reformats the name so that it is presentable to the user.
    NSDictionary *unformatted = [fieldFormatter unformatName:combo.stringValue];
    NSString *name = [fieldFormatter formatFirstName:unformatted[@"first_name"] lastName:unformatted[@"last_name"]];
    NSString *infoMessage = [NSString stringWithFormat:@"The expert, \"%@\", does not exist! Do you want to add, \"%@\", into the list of experts as a %@?", name, name, role];
    
    // Creates a dialog so that the user can decide whether to add the expert or not.
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Add New Expert!"];
    [alert setInformativeText:infoMessage];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert addButtonWithTitle:@"Add"];
    [alert addButtonWithTitle:@"Cancel"];
    NSInteger response = [alert runModal];
    
    // If the user clicks "Add" then the expert will be added.
    if (response == NSAlertFirstButtonReturn) {
        NSDictionary *name = [fieldFormatter unformatName:combo.stringValue];
        Expert *expert = [[Expert alloc] init];
        [expert setExpert_id:[NSNumber numberWithInt:0]];
        [expert setFirst_name:[name valueForKey:@"first_name"]];
        [expert setLast_name:[name valueForKey:@"last_name"]];
        [expert setRole:role];
        [expert setActive:YES];
        BOOL inserted = [[DataController sharedDataController] insertExpert:expert];
        if (inserted) {
            NSLog(@"It went through!");
            return expert;
        } else {
            NSLog(@"It didn't go through!");
            return nil;
        }
    }
    else {
        return nil;
    }
}

- (void)controlTextDidChange:(NSNotification *)notification
{
    if (_statusLabel.textColor == successColor) {
        [_statusLabel setStringValue:@""];
        [_statusLabel setHidden:YES];
    }
    
    NSTextField *field = [notification object];
    NSString *identifer = [field identifier];
    NSString *text = [field stringValue];
    
    NSLog(@"ID: %@", identifer);
    
    NSString *formatted;
    
    // Formats the string within the specified fields by adding a hyphen after so many characters. Will also
    //  limit the number of characters that are allowed in the text field.
    if ([identifer isEqualToString:@"call_order_no_field"]) {
        formatted = [fieldFormatter callOrderFormat:text];
    }
    else if ([identifer isEqualToString:@"bpa_no_field"]) {
        formatted = [fieldFormatter bpaFormat:text];
    }
    else if ([identifer isEqualToString:@"tin_field"])
    {
        formatted = [fieldFormatter tinFormat:text];
    }
    else if ([identifer isEqualToString:@"ticket_no_field"])
    {
        formatted = [fieldFormatter ticketNumberFormat:text];
    }
    else if ([identifer isEqualToString:@"claimant_first_field"])
    {
        formatted = [fieldFormatter nameFormat:text];
    }
    else if ([identifer isEqualToString:@"claimant_last_field"])
    {
        formatted = [fieldFormatter nameFormat:text];
    }
    else if ([identifer isEqualToString:@"can_field"])
    {
        formatted = [fieldFormatter canFormat:text];
    }
    else if ([identifer isEqualToString:@"soc_field"])
    {
        formatted = [fieldFormatter socFormat:text];
    }
    
    [field setStringValue:formatted];
}

- (void)clearForm
{
    // Resets all the fields to their default values.
    [_orderNumberField setStringValue:@""];
    [_firstNameField setStringValue:@""];
    [_lastNameField setStringValue:@""];
    [_ticketNumberField setStringValue:@""];
    [_canField setStringValue:@""];
    [_socField setStringValue:@""];
    [_statusCombo setStringValue:@""];
    [_interpreterCombo setStringValue:@""];
    [_repCombo setStringValue:@""];
    [_medicalCombo setStringValue:@""];
    [_otherCombo setStringValue:@""];
    [_fullAmountBtn setState:1];
    
    // Clears all errors on the form.
    [fieldFormatter clearErrorBackground:_ticketNumberField];
    [fieldFormatter clearErrorBackground:_statusCombo];
    [fieldFormatter clearErrorBackground:_workedByCombo];
    [fieldFormatter clearErrorBackground:_judgePresidingCombo];
    [fieldFormatter clearErrorBackground:_officeCombo];
    
    // Moves the focus to the date picker.
    [[[self view] window] makeFirstResponder:_orderDatePicker];
    
    // Clears the status label.
    [_statusLabel setStringValue:@""];
    [_statusLabel setHidden:YES];
}

- (void)revertForm
{
    NSArray *comboboxes = [NSArray arrayWithObjects:_statusCombo, _workedByCombo, _officeCombo,
                           _judgePresidingCombo, _repCombo, _vocationalCombo, _medicalCombo, _otherCombo, nil];
    
    // Sets each of the fields to what is currently present in the ticket.
    if ([_oldTicket order_date] != nil) [_orderDatePicker setDateValue:[_oldTicket order_date]];
    if ([_oldTicket hearing_date] != nil) [_hearingDatePicker setDateValue:[_oldTicket hearing_date]];
    if ([_oldTicket hearing_time] != nil) [_hearingTimePicker setDateValue:[_oldTicket hearing_time]];
    
    if ([_oldTicket ticket_no] != nil) [_ticketNumberField setStringValue:[[_oldTicket ticket_no] stringValue]];
    if ([_oldTicket call_order_no] != nil) [_orderNumberField setStringValue:[_oldTicket call_order_no]];
    if ([_oldTicket first_name] != nil) [_firstNameField setStringValue:[_oldTicket first_name]];
    if ([_oldTicket last_name] != nil) [_lastNameField setStringValue:[_oldTicket last_name]];
    if ([_oldTicket soc] != nil) [_socField setStringValue:[_oldTicket soc]];
    if ([_oldTicket heldAt] != nil) [_canField setStringValue:[[_oldTicket heldAt] can]];
    if ([_oldTicket status] != nil) [_statusCombo setStringValue:[_oldTicket status]];
    [_fullAmountBtn setState:[_oldTicket full_pay]];
    
    if ([_oldTicket workedBy] != nil) [_workedByCombo setStringValue:[fieldFormatter formatFirstName:[[_oldTicket workedBy] first_name] lastName:[[_oldTicket workedBy] last_name]]];
    if ([_oldTicket heldAt] != nil) [_officeCombo setStringValue:[NSString stringWithFormat:@"%@, %@", [[_oldTicket heldAt] name], [[_oldTicket heldAt] office_code]]];
    if ([_oldTicket judge_presided] != nil) [_judgePresidingCombo setStringValue:[fieldFormatter formatFirstName:[[_oldTicket judgePresided] first_name] lastName:[[_oldTicket judgePresided] last_name]]];
    
    // Places the correct expert for each expert combo box.
    NSDictionary *expertsForTicket = [Expert findExpertsForTicket:_oldTicket];
    NSArray *roles = [NSArray arrayWithObjects:@"REP", @"VE", @"ME", @"OTHER", @"INS", nil];
    NSArray *expertFields = [NSArray arrayWithObjects:_repCombo, _vocationalCombo, _medicalCombo, _otherCombo, _interpreterCombo, nil];
    NSDictionary *fieldsByRole = [NSDictionary dictionaryWithObjects:expertFields forKeys:roles];
    
    // Formats each expert and places them in their field.
    for (NSString *role in roles) {
        NSComboBox *combo = [fieldsByRole valueForKey:role];
        Expert *expert = ([expertsForTicket valueForKey:role] != [NSNull null]) ? [expertsForTicket valueForKey:role] : nil;
        if (expert != nil) [combo setStringValue:[fieldFormatter formatFirstName:[expert first_name] lastName:[expert last_name]]];
        else [combo setStringValue:@""];
    }
    
    // Will make sure the selected index matches that of the string value inside the combo. If the string value does not have
    //  a corresponding index, then the selection will remain at -1.
    for (NSComboBox *combo in comboboxes) {
        NSInteger index = 0;
        for (NSString *value in [combo objectValues]) {
            if ([value isEqualToString:[combo stringValue]]) {
                [combo selectItemAtIndex:index];
                break;
            }
            index++;
        }
    }
}

//- (void)fillComboBox:(NSComboBox *)combo withItems:(NSArray *)items
//{
//    [combo removeAllItems];
//    
//    // Fills a combo box with all the items in the array.
//    for (int x = 0; x < [items count]; x++) {
//        NSString *first = [[items objectAtIndex:x] valueForKey:@"first_name"];
//        NSString *last = [[items objectAtIndex:x] valueForKey:@"last_name"];
//        NSString *name = [self formatFirstName:first lastName:last];
//        [combo addItemWithObjectValue:name];
//    }
//}
//
- (void)fillExpertComboBoxes
{
    // Fill in the "represenative" combo box.
    NSPredicate *repPredicate = [NSPredicate predicateWithFormat:@"role == \"REP\""];
    NSArray *reps = [experts filteredArrayUsingPredicate:repPredicate];
    [fieldFormatter fillComboBox:_repCombo withItems:reps];
    
    // Fill in the "vocational" combo box.
    NSPredicate *vePredicate = [NSPredicate predicateWithFormat:@"role == \"VE\""];
    NSArray *ves = [experts filteredArrayUsingPredicate:vePredicate];
    [fieldFormatter fillComboBox:_vocationalCombo withItems:ves];
    
    // Fill in the "medical" combo box.
    NSPredicate *mePredicate = [NSPredicate predicateWithFormat:@"role == \"ME\""];
    NSArray *mes = [experts filteredArrayUsingPredicate:mePredicate];
    [fieldFormatter fillComboBox:_medicalCombo withItems:mes];
    
    // Fill in the "interpreter" combo box.
    NSPredicate *insPredicate = [NSPredicate predicateWithFormat:@"role == \"INS\""];
    NSArray *ins = [experts filteredArrayUsingPredicate:insPredicate];
    [fieldFormatter fillComboBox:_interpreterCombo withItems:ins];
    
    // Fill in the "other" combo box.
    [fieldFormatter fillComboBox:_otherCombo withItems:experts];
}
//
//- (NSString *)formatFirstName:(NSString *)first lastName:(NSString *)last
//{
//    NSString *name;
//    
//    if (*_lastNameFirst == YES) {
//        name = [NSString stringWithFormat:@"%@, %@", last, first];
//    } else {
//        name = [NSString stringWithFormat:@"%@ %@", first, last];
//    }
//    
//    return [name capitalizedString];
//}
//
//- (NSDictionary *)unformatName:(NSString *)name
//{
//    NSMutableArray *nameSplit;
//    NSArray *keys;
//    
//    // Trims all spaces from beginning and end of name.
//    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    
//    // Nothing was entered in, so return blanks for first and last name.
//    if ([name isEqualToString:@""]) {
//        return [NSDictionary dictionaryWithObjectsAndKeys:@"", @"first_name", @"", @"last_name", nil];
//    }
//    
//    // Grabs the first and last name depending on the format.
//    if (*_lastNameFirst == YES) {
//        nameSplit = (NSMutableArray *)[name componentsSeparatedByString:@","];
//        keys = [NSArray arrayWithObjects:@"last_name", @"first_name", nil];
//    }
//    else
//    {
//        nameSplit = (NSMutableArray *)[name componentsSeparatedByString:@" "];
//        keys = [NSArray arrayWithObjects:@"first_name", @"last_name", nil];
//    }
//    
//    // Removes all whitespace at the beginning and end of each name.
//    for (int x = 0; x < nameSplit.count ; x++) {
//        NSString *trimmedName = [nameSplit[x] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        [nameSplit replaceObjectAtIndex:x withObject:trimmedName];
//    }
//    
//    // If there are more than 2 elements, that means the user typed in a middle name as well. We will combine the middle name with the first name.
//    if (nameSplit.count > 2) {
//        NSMutableString *combinedFirstName = [[NSMutableString alloc] init];
//        NSString *lastName;
//        
//        if (*_lastNameFirst == YES) {
//            // Combines all names except the first element. This will make a combined first name.
//            for (int x = 1; x < nameSplit.count; x++) {
//                [combinedFirstName appendString:nameSplit[x]];
//                [combinedFirstName appendString:@" "];
//            }
//            lastName = nameSplit[0];
//            
//            // Removes spaces from the beginning and end of the combined first name.
//            NSString *firstName = [combinedFirstName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            // Adds the combined first name and last name into an array in the order that it will be added to the dictionary.
//            [nameSplit removeAllObjects];
//            [nameSplit addObject:lastName];
//            [nameSplit addObject:firstName];
//        }
//        else {
//            // Combined all names except the last element. This will make a combined first name.
//            for (int x = 0; x < nameSplit.count-1; x++) {
//                [combinedFirstName appendString:nameSplit[x]];
//                [combinedFirstName appendString:@" "];
//            }
//            lastName = nameSplit[nameSplit.count-1];
//            
//            // Removes spaces from the beginning and end of the combined first name.
//            NSString *firstName = [combinedFirstName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            // Adds the combined first name and last name into an array in the order that it will be added to the dictionary.
//            [nameSplit removeAllObjects];
//            [nameSplit addObject:firstName];
//            [nameSplit addObject:lastName];
//        }
//        
//    }
//    
//    // Adds spaces to the array anywhere there is a missing component.
//    if (nameSplit.count == 1) {
//        [nameSplit addObject:@""];
//    }
//    
//    // Creates a dictionary out of the names.
//    NSDictionary *nameDict = [NSDictionary dictionaryWithObjects:nameSplit forKeys:keys];
//    
//    return nameDict;
//}
//
//- (NSString *)callOrderBpaFormat:(NSString *)text
//{
//    text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    
//    // Adds a '-' after every 4th and 7th character.
//    NSMutableString *formatted = [[NSMutableString alloc] init];
//    
//    for (int x = 0; x < [text length]; x++) {
//        if (x == 4 || x == 6) {
//            [formatted appendString:@"-"];
//        }
//        NSString *nextChar = [NSString stringWithFormat:@"%c", [text characterAtIndex:x]];
//        [formatted appendString:nextChar];
//    }
//    
//    return formatted;
//}
//
//- (NSString *)tinFormat:(NSString *)text
//{
//    text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    
//    // Adds a '-' after the 4th character.
//    NSMutableString *formatted = [[NSMutableString alloc] init];
//    
//    for (int x = 0; x < [text length]; x++) {
//        if (x == 4) {
//            [formatted appendString:@"-"];
//        }
//        NSString *nextChar = [NSString stringWithFormat:@"%c", [text characterAtIndex:x]];
//        [formatted appendString:nextChar];
//    }
//    
//    return formatted;
//}
//
//- (void)setErrorBackground:(id)field
//{
//    // Sets the field's background to a slight red so that the user knows there is an error.
//    [field setBackgroundColor:[NSColor colorWithRed:1 green:0 blue:0 alpha:0.20]];
//}
//
//- (void)clearErrorBackground:(id)field
//{
//    // Reverts field to normal color.
//    [field setBackgroundColor:[NSColor colorWithRed:0 green:0 blue:0 alpha:0]];
//}

@end
