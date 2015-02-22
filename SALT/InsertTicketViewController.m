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
    [_hearingTimePicker setStringValue:@"8:00 AM"];
    
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

- (IBAction)clearBtn:(NSButton *)sender {
    // Resets all the fields to their default values.
    [_orderNumberField setStringValue:@""];
    [_firstNameField setStringValue:@""];
    [_lastNameField setStringValue:@""];
    [_ticketNumberField setStringValue:@""];
    [_bpaNumberField setStringValue:@""];
    [_canField setStringValue:@""];
    [_tinField setStringValue:@""];
    [_socField setStringValue:@""];
    [_interpreterCheck setState:0];
    [_workedByCombo setStringValue:@""];
    [_judgePresidingCombo setStringValue:@""];
    [_officeCombo setStringValue:@""];
    [_repCombo setStringValue:@""];
    [_vocationalCombo setStringValue:@""];
    [_medicalCombo setStringValue:@""];
    [_otherCombo setStringValue:@""];
    
    // Moves focus to the order date picker.
    [_orderDatePicker becomeFirstResponder];
}

- (IBAction)dismissBtn:(NSButton *)sender {
    [[[self view] window] close];
}

- (IBAction)submitBtn:(NSButton *)sender {
    if ([[_ticketNumberField stringValue] length] < 8) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Invalid Ticket Number!"];
        [alert setInformativeText:@"Ticket Number must be exactly 8 numbers long!"];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
        
        return;
    }
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
             
@end
