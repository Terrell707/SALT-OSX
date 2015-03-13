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
    
    // If true, name is formatted "last, first". Otherwise it is "first last".
    lastNameFirst = YES;
    
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
    [self fillComboBox:_workedByCombo withItems:employees];
    
    // Fill in the "judges" combo box.
    [self fillComboBox:_judgePresidingCombo withItems:judges];
    
    // Fill in the "held at office" combo box.
    for (int x = 0; x < [sites count]; x++) {
        NSString *officeCode = [sites[x] valueForKey:@"office_code"];
        NSString *name = [sites[x] valueForKey:@"name"];
        NSString *site = [NSString stringWithFormat:@"%@, %@", name, officeCode];
        [_officeCombo addItemWithObjectValue:site];
    }
    
    // Fill in the "represenative" combo box.
    NSPredicate *repPredicate = [NSPredicate predicateWithFormat:@"role == \"REP\""];
    NSArray *reps = [experts filteredArrayUsingPredicate:repPredicate];
    [self fillComboBox:_repCombo withItems:reps];
    
    // Fill in the "vocational" combo box.
    NSPredicate *vePredicate = [NSPredicate predicateWithFormat:@"role == \"VE\""];
    NSArray *ves = [experts filteredArrayUsingPredicate:vePredicate];
    [self fillComboBox:_vocationalCombo withItems:ves];
    
    // Fill in the "medical" combo box.
    NSPredicate *mePredicate = [NSPredicate predicateWithFormat:@"role == \"ME\""];
    NSArray *mes = [experts filteredArrayUsingPredicate:mePredicate];
    [self fillComboBox:_medicalCombo withItems:mes];
    
    // Fill in the "other" combo box.
    [self fillComboBox:_otherCombo withItems:experts];
}

- (void)viewDidAppear
{
    // Changes the view based on how this view is presented.
    if (_titleString == nil) {
        [self setTitleString:@"Create Hearing Ticket"];
    }
    if (_clearBtnString == nil) {
        [self setClearBtnString:@"Clear"];
    }
    
    [_titleLabel setStringValue:_titleString];
    [_clearBtn setTitle:_clearBtnString];
}

- (IBAction)clearBtn:(NSButton *)sender {
    [self clearForm];
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
        [self setErrorBackground:_ticketNumberField];
        
        // Moves the focus to the ticket number field.
        [self.view.window makeFirstResponder:_ticketNumberField];
    }
    else {
        [self clearErrorBackground:_ticketNumberField];
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
        [errorDescription appendString:@"A status must be selected from the 'Status' drop down"];
        [self setErrorBackground:_statusCombo];
    }
    else {
        [self clearErrorBackground:_statusCombo];
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
        [errorDescription appendString:@"An employee must be selected from the 'Worked By' drop down!"];
        [self setErrorBackground:_workedByCombo];
    }
    else {
        [self clearErrorBackground:_workedByCombo];
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
        [errorDescription appendString:@"A judge must be selected from the 'Judge Presided' drop down list"];
        [self setErrorBackground:_judgePresidingCombo];
    }
    else {
        [self clearErrorBackground:_judgePresidingCombo];
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
        [errorDescription appendString:@"A office must be selected from the 'Held At Office' drop down list"];
        [self setErrorBackground:_officeCombo];
    }
    else {
        [self clearErrorBackground:_officeCombo];
    }
    
    // Sets the error description and shows it. Otherwise, it clears the error label.
    if (fieldError) {
        [_statusLabel setStringValue:errorDescription];
        [_statusLabel setTextColor:[NSColor redColor]];
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
    [newTicket setCall_order_no:[_orderNumberField stringValue]];
    [newTicket setFirst_name:[_firstNameField stringValue]];
    [newTicket setLast_name:[_lastNameField stringValue]];
    [newTicket setTicket_no:[numFormat numberFromString:[_ticketNumberField stringValue]]];
    [newTicket setSoc:[_socField stringValue]];
    [newTicket setHearing_date:[dateFormat dateFromString:hearingDate]];
    [newTicket setHearing_time:[timeFormat dateFromString:hearingTime]];
    [newTicket setStatus:[_statusCombo stringValue]];
    
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
    NSArray *office = [[_officeCombo stringValue] componentsSeparatedByString:@", "];
    [newTicket setAt_site:office[1]];
    
    // Find the vocational expert that was typed in.
    if ([_vocationalCombo indexOfSelectedItem] != -1) {
        
    }
    
    BOOL inserted = [[DataController sharedDataController] insertTicket:newTicket];
    if (inserted) {
        NSLog(@"It went through");
        [self clearForm];
        [_statusLabel setStringValue:@"Ticket Successfully Added!"];
        [_statusLabel setTextColor:[NSColor blueColor]];
        [_statusLabel setHidden:NO];
    } else {
        NSLog(@"It did not go through");
        [_statusLabel setStringValue:@"Error: Ticket did not go through!"];
        [_statusLabel setTextColor:[NSColor redColor]];
        [_statusLabel setHidden:NO];
    }
}

- (NSArray *)findInfoFromList:(NSArray *)list forCombo:(NSComboBox *)combo
{
    // Searchs the passed in list for the name selected in the passed in combobox.
    NSDictionary *name = [self unformatName:[combo stringValue]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"first_name == %@ && last_name == %@",
                                   name[@"first_name"], name[@"last_name"]];
    NSArray *result = [list filteredArrayUsingPredicate:predicate];
    
    return result;
}

- (void)controlTextDidChange:(NSNotification *)notification
{
    if ([_statusLabel.stringValue isEqualToString:@"Ticket Successfully Added!"]) {
        [_statusLabel setStringValue:@""];
        [_statusLabel setHidden:YES];
    }
    
    NSTextField *field = [notification object];
    NSString *identifer = [field identifier];
    NSString *text = [field stringValue];
    
    NSString *formatted;
    NSInteger maxLength;
    
    // Formats the string within the specified fields by adding a hyphen after so many characters. Will also
    //  limit the number of characters that are allowed in the text field.
    if ([identifer isEqualToString:@"call_order_no_field"]) {
        maxLength = 15;
        formatted = [self callOrderBpaFormat:text];
        if ([formatted length] > maxLength) {
            formatted = [formatted substringToIndex:maxLength];
        }
    }
    else if ([identifer isEqualToString:@"bpa_no_field"]) {
        maxLength = 13;
        formatted = [self callOrderBpaFormat:text];
        if ([formatted length] > maxLength) {
            formatted = [formatted substringToIndex:maxLength];
        }
    }
    else if ([identifer isEqualToString:@"tin_field"])
    {
        maxLength = 11;
        formatted = [self tinFormat:text];
        if ([formatted length] > maxLength) {
            formatted = [formatted substringToIndex:maxLength];
        }
    }
    else if ([identifer isEqualToString:@"ticket_no_field"])
    {
        maxLength = 8;
        formatted = text;
        if ([formatted length] > maxLength) {
            formatted = [formatted substringToIndex:maxLength];
        }
    }
    else if ([identifer isEqualToString:@"claimant_first_field"])
    {
        maxLength = 20;
        formatted = text;
        if ([formatted length] > maxLength) {
            formatted = [formatted substringToIndex:maxLength];
        }
    }
    else if ([identifer isEqualToString:@"claimant_last_field"])
    {
        maxLength = 20;
        formatted = text;
        if ([formatted length] > maxLength) {
            formatted = [formatted substringToIndex:maxLength];
        }
    }
    else if ([identifer isEqualToString:@"can_field"])
    {
        maxLength = 7;
        formatted = text;
        if ([formatted length] > maxLength) {
            formatted = [formatted substringToIndex:maxLength];
        }
    }
    else if ([identifer isEqualToString:@"soc_field"])
    {
        maxLength = 4;
        formatted = text;
        if ([formatted length] > maxLength) {
            formatted = [formatted substringToIndex:maxLength];
        }
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
    [_interpreterCheck setState:0];
    [_repCombo setStringValue:@""];
    [_medicalCombo setStringValue:@""];
    [_otherCombo setStringValue:@""];
    
    // Clears all errors on the form.
    [self clearErrorBackground:_ticketNumberField];
    [self clearErrorBackground:_statusCombo];
    [self clearErrorBackground:_workedByCombo];
    [self clearErrorBackground:_judgePresidingCombo];
    [self clearErrorBackground:_officeCombo];
    
    // Moves the focus to the date picker.
    [[[self view] window] makeFirstResponder:_orderDatePicker];
    
    // Clears the status label.
    [_statusLabel setStringValue:@""];
    [_statusLabel setHidden:YES];
}

- (void)fillComboBox:(NSComboBox *)combo withItems:(NSArray *)items
{
    // Fills a combo box with all the items in the array.
    for (int x = 0; x < [items count]; x++) {
        NSString *first = [[items objectAtIndex:x] valueForKey:@"first_name"];
        NSString *last = [[items objectAtIndex:x] valueForKey:@"last_name"];
        NSString *name = [self formatFirstName:first lastName:last];
        [combo addItemWithObjectValue:name];
    }
}

- (NSString *)formatFirstName:(NSString *)first lastName:(NSString *)last
{
    NSString *name;
    if (lastNameFirst == YES) {
        name = [NSString stringWithFormat:@"%@, %@", last, first];
    } else {
        name = [NSString stringWithFormat:@"%@ %@", first, last];
    }
    
    return name;
}

- (NSDictionary *)unformatName:(NSString *)name
{
    NSArray *nameSplit;
    NSDictionary *nameDict;
    
    if (name == nil) {
        nameDict = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"last_name", @"", @"first_name", nil];
        return nameDict;
    }
    
    if (lastNameFirst == YES) {
        nameSplit = [name componentsSeparatedByString:@", "];
        nameDict = [NSDictionary dictionaryWithObjectsAndKeys:nameSplit[0], @"last_name",
                    nameSplit[1], @"first_name", nil];
    }
    else
    {
        nameSplit = [name componentsSeparatedByString:@" "];
        nameDict = [NSDictionary dictionaryWithObjectsAndKeys:nameSplit[0], @"last_name",
                    nameSplit[1], @"first_name", nil];
    }
    
    return nameDict;
}

- (NSString *)callOrderBpaFormat:(NSString *)text
{
    text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    // Adds a '-' after every 4th and 7th character.
    NSMutableString *formatted = [[NSMutableString alloc] init];
    
    for (int x = 0; x < [text length]; x++) {
        if (x == 4 || x == 6) {
            [formatted appendString:@"-"];
        }
        NSString *nextChar = [NSString stringWithFormat:@"%c", [text characterAtIndex:x]];
        [formatted appendString:nextChar];
    }
    
    return formatted;
}

- (NSString *)tinFormat:(NSString *)text
{
    text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    // Adds a '-' after the 4th character.
    NSMutableString *formatted = [[NSMutableString alloc] init];
    
    for (int x = 0; x < [text length]; x++) {
        if (x == 4) {
            [formatted appendString:@"-"];
        }
        NSString *nextChar = [NSString stringWithFormat:@"%c", [text characterAtIndex:x]];
        [formatted appendString:nextChar];
    }
    
    return formatted;
}

- (void)setErrorBackground:(id)field
{
    // Sets the field's background to a slight red so that the user knows there is an error.
    [field setBackgroundColor:[NSColor colorWithRed:1 green:0 blue:0 alpha:0.20]];
}

- (void)clearErrorBackground:(id)field
{
    // Reverts field to normal color.
    [field setBackgroundColor:[NSColor colorWithRed:0 green:0 blue:0 alpha:0]];
}

@end
