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
    
    hearingStatus = [[DataController sharedDataController] hearingStatus];
    employees = [[DataController sharedDataController] employees];
    judges = [[DataController sharedDataController] judges];
    sites = [[DataController sharedDataController] sites];
    
    [_orderDatePicker setDateValue:[NSDate date]];
    [_hearingDatePicker setDateValue:[NSDate date]];
    [_hearingTimePicker setStringValue:@"8:00 AM"];
    
    // Fill in the "status" combo box.
    for (int x = 0; x < [hearingStatus count]; x++) {
        [_statusCombo addItemWithObjectValue:hearingStatus[x]];
        NSLog(@"Status=%@", hearingStatus[x]);
    }
    
    // Fill in the "worked by" combo box.
    for (int x = 0; x < [employees count]; x++) {
        NSString *firstName = [employees[x] valueForKey:@"first_name"];
        NSString *lastName = [employees[x] valueForKey:@"last_name"];
        NSString *name = [NSString stringWithFormat:@"%@, %@", lastName, firstName];
        [_workedByCombo addItemWithObjectValue:name];
    }
    
    // Fill in the "judges" combo box.
    for (int x = 0; x < [judges count]; x++) {
        NSString *firstName = [judges[x] valueForKey:@"first_name"];
        NSString *lastName = [judges[x] valueForKey:@"last_name"];
        NSString *name = [NSString stringWithFormat:@"%@, %@", lastName, firstName];
        [_judgePresidingCombo addItemWithObjectValue:name];
    }
    
    for (int x = 0; x < [sites count]; x++) {
        NSString *officeCode = [sites[x] valueForKey:@"office_code"];
        NSString *name = [sites[x] valueForKey:@"name"];
        NSString *site = [NSString stringWithFormat:@"%@, %@", name, officeCode];
        [_officeCombo addItemWithObjectValue:site];
        NSLog(@"Site=%@", site);
    }
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
}

- (IBAction)dismissBtn:(NSButton *)sender {
    [self dismissViewController:self];
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
