//
//  InsertTicketViewController.m
//  SALT
//
//  Created by Adrian T. Chambers on 2/14/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "InsertTicketViewController.h"

@interface InsertTicketViewController ()
- (void)fillComboBox:(NSComboBox *)combo withItems:(NSArray *)items;
- (NSString *)formatFirstName:(NSString *)first lastName:(NSString *)last;
- (NSDictionary *)unformatName:(NSString *)name;
- (NSString *)callOrderBpaFormat:(NSString *)text;
- (NSString *)tinFormat:(NSString *)text;
- (void)controlTextDidChange:(NSNotification *)notification;
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
    
    // Sets defaults for the date and time pickers.
    [_orderDatePicker setDateValue:[NSDate date]];
    [_hearingDatePicker setDateValue:[NSDate date]];
    [_hearingTimePicker setStringValue:@"8:30 AM"];
    
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

- (IBAction)clearBtn:(NSButton *)sender {
    [self clearForm];
}

- (IBAction)dismissBtn:(NSButton *)sender {
    [[[self view] window] close];
}

- (IBAction)submitBtn:(NSButton *)sender {
    // Checks to make sure needed information is populated.
    if ([[_ticketNumberField stringValue] length] < 8) {
        [self ticketAlert];
        return;
    }
    if ([_workedByCombo indexOfSelectedItem] == -1) {
        [self employeeAlert];
        return;
    }
    if ([_judgePresidingCombo indexOfSelectedItem] == -1) {
        [self judgeAlert];
        return;
    }
    if ([_statusCombo indexOfSelectedItem] == -1) {
        [self statusAlert];
        return;
    }
    if ([_officeCombo indexOfSelectedItem] == -1) {
        [self officeAlert];
        return;
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
    [newTicket setBpa_no:[_bpaNumberField stringValue]];
    [newTicket setCan:[_canField stringValue]];
    [newTicket setTin:[_tinField stringValue]];
    [newTicket setSoc:[_socField stringValue]];
    [newTicket setHearing_date:[dateFormat dateFromString:hearingDate]];
    [newTicket setHearing_time:[timeFormat dateFromString:hearingTime]];
    [newTicket setStatus:[_statusCombo stringValue]];
    
    // Find the employee that was typed in and get his/her id number. If they don't exist, throw an error.
    NSArray *empResult = [self findInfoFromList:employees forCombo:_workedByCombo];
    if ([empResult count] <= 0) {
        [self employeeAlert];
        return;
    }
    [newTicket setEmp_worked:[empResult[0] database_id]];
    [newTicket setWorkedBy:empResult[0]];
    
    // Find the judge that was typed in and get his/her id number. If they don't exist, throw an error.
    NSArray *judgeResult = [self findInfoFromList:judges forCombo:_judgePresidingCombo];
    if ([judgeResult count] <= 0) {
        [self judgeAlert];
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
    
    [self willChangeValueForKey:@"tickets"];
    BOOL inserted = [[DataController sharedDataController] insertTicket:newTicket];
    if (inserted) {
        NSLog(@"It went through");
    } else {
        NSLog(@"It did not go through");
    }
    [self didChangeValueForKey:@"tickets"];
    
    [self clearForm];
}

- (NSArray *)findInfoFromList:(NSArray *)list forCombo:(NSComboBox *)combo
{
    NSDictionary *name = [self unformatName:[combo stringValue]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"first_name == %@ && last_name == %@",
                                   name[@"first_name"], name[@"last_name"]];
    NSArray *result = [list filteredArrayUsingPredicate:predicate];
    
    return result;
}

- (void)controlTextDidChange:(NSNotification *)notification
{
    NSTextField *field = [notification object];
    NSString *identifer = [field identifier];
    NSString *text = [field stringValue];
    
    NSString *formatted;
    NSInteger maxLength;
    
    NSLog(@"Identifer=%@", identifer);
    
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
    [_bpaNumberField setStringValue:@""];
    [_canField setStringValue:@""];
    [_tinField setStringValue:@""];
    [_socField setStringValue:@""];
    [_statusCombo setStringValue:@""];
    [_interpreterCheck setState:0];
//    [_workedByCombo setStringValue:@""];
//    [_judgePresidingCombo setStringValue:@""];
//    [_officeCombo setStringValue:@""];
    [_repCombo setStringValue:@""];
//    [_vocationalCombo setStringValue:@""];
    [_medicalCombo setStringValue:@""];
    [_otherCombo setStringValue:@""];
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
    
    NSLog(@"Format=%@", formatted);
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
    
    NSLog(@"Format=%@", formatted);
    return formatted;
}

- (void)employeeAlert
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Invalid Selection in Worked By!"];
    [alert setInformativeText:@"Need to select an employee from the 'Worked By' drop down list!"];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];
}

- (void)judgeAlert
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Invalid Selection in Judge Presided!"];
    [alert setInformativeText:@"Need to select a judge from the 'Judge Presided' drop down list!"];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];
}

- (void)ticketAlert
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Invalid Ticket Number!"];
    [alert setInformativeText:@"Ticket Number must be exactly 8 numbers long!"];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];
}

- (void)statusAlert
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Invalid Status!"];
    [alert setInformativeText:@"Need to select a status from the 'Status' drop down list!"];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];
}

- (void)officeAlert
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Invalid Office!"];
    [alert setInformativeText:@"Need to select a office from the 'Held At Office' drop down list!"];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];
}

@end
