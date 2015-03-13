//
//  InsertTicketViewController.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/14/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DataController.h"

@interface InsertTicketViewController : NSViewController <NSTextFieldDelegate> {
    BOOL lastNameFirst;
    NSMutableArray *hearingStatus;
    NSMutableArray *employees;
    NSMutableArray *sites;
    NSMutableArray *judges;
    NSMutableArray *experts;
}

@property (readwrite, copy) NSString *titleString;
@property (readwrite, copy) NSString *clearBtnString;

@property (weak) IBOutlet NSDatePicker *orderDatePicker;
@property (weak) IBOutlet NSTextField *orderNumberField;
@property (weak) IBOutlet NSTextField *firstNameField;
@property (weak) IBOutlet NSTextField *lastNameField;
@property (weak) IBOutlet NSTextField *ticketNumberField;
@property (weak) IBOutlet NSTextField *canField;
@property (weak) IBOutlet NSTextField *socField;
@property (weak) IBOutlet NSDatePicker *hearingDatePicker;
@property (weak) IBOutlet NSDatePicker *hearingTimePicker;
@property (weak) IBOutlet NSComboBox *statusCombo;
@property (weak) IBOutlet NSComboBox *workedByCombo;
@property (weak) IBOutlet NSComboBox *judgePresidingCombo;
@property (weak) IBOutlet NSComboBox *officeCombo;
@property (weak) IBOutlet NSComboBox *repCombo;
@property (weak) IBOutlet NSComboBox *vocationalCombo;
@property (weak) IBOutlet NSComboBox *medicalCombo;
@property (weak) IBOutlet NSComboBox *otherCombo;
@property (weak) IBOutlet NSButton *interpreterCheck;

@property (weak) IBOutlet NSTextField *titleLabel;
@property (weak) IBOutlet NSTextField *statusLabel;
@property (weak) IBOutlet NSButton *clearBtn;

- (IBAction)clearBtn:(NSButton *)sender;
- (IBAction)dismissBtn:(NSButton *)sender;
- (IBAction)submitBtn:(NSButton *)sender;


@end
