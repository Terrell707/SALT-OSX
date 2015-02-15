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

//- (void)controlTextDidChange:(NSNotification *)notification {
//    NSTextField *textField = [notification object];
//    if ([notification object] == _orderNumberField) {
//        [_orderNumberField setStringValue:[self formatCallOrderNumber:[_orderNumberField stringValue]]];
//    }
//    NSLog(@"controlTextDidChange: %@", [textField stringValue]);
//}
//
//- (NSString *)formatCallOrderNumber:(NSString *)text
//{
//    if (text.length == 5 || text.length == 8) {
//        NSString *beforeHyphen = [text substringToIndex:(text.length - 1)];
//        NSString *afterHyphen = [text substringFromIndex:(text.length - 1)];
//        return [NSString stringWithFormat:@"%@-%@", beforeHyphen, afterHyphen];
//    }
//    
//    return text;
//}

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
        NSAlert *alert = [NSAlert alertWithMessageText: @"Invalid Ticket Number!"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:@"Ticket Number needs to be exactly 8 digits long."];
        [alert runModal];
    }
}
@end
