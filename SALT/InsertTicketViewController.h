//
//  InsertTicketViewController.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/14/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DataController.h"

@interface InsertTicketViewController : NSViewController {
    NSMutableArray *hearingStatus;
    NSMutableArray *employees;
    NSMutableArray *sites;
    NSMutableArray *judges;
}

@property (weak) IBOutlet NSDatePicker *orderDatePicker;
@property (weak) IBOutlet NSTextField *orderNumberField;
@property (weak) IBOutlet NSTextField *firstNameField;
@property (weak) IBOutlet NSTextField *lastNameField;
@property (weak) IBOutlet NSTextField *ticketNumberField;
@property (weak) IBOutlet NSTextField *bpaNumberField;
@property (weak) IBOutlet NSTextField *canField;
@property (weak) IBOutlet NSTextField *tinField;
@property (weak) IBOutlet NSTextField *socField;
@property (weak) IBOutlet NSDatePicker *hearingDatePicker;
@property (weak) IBOutlet NSDatePicker *hearingTimePicker;
@property (weak) IBOutlet NSComboBox *statusCombo;
@property (weak) IBOutlet NSComboBox *workedByCombo;
@property (weak) IBOutlet NSComboBox *judgePresidingCombo;
@property (weak) IBOutlet NSComboBox *officeCombo;

- (IBAction)clearBtn:(NSButton *)sender;
- (IBAction)dismissBtn:(NSButton *)sender;
- (IBAction)submitBtn:(NSButton *)sender;

@end
