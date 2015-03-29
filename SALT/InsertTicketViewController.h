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
    NSMutableArray *hearingStatus;
    NSMutableArray *employees;
    NSMutableArray *sites;
    NSMutableArray *judges;
    NSMutableArray *experts;
    
    NSColor *successColor;
    NSColor *errorColor;
}

// --------------------------------------------------------------
// Strings that are passed from TicketViewController to this one.
// --------------------------------------------------------------
@property (readwrite, copy) NSString *titleString;
@property (readwrite, copy) NSString *clearBtnString;
@property (readwrite) BOOL updateTicket;    // Whether this view is being presented from the "Update" or "Add" button.
@property (readwrite) Ticket *oldTicket;    // The ticket before changes are applied to it.

//@property (readwrite) Employee *workedBy;
//@property (readwrite) Site *heldAt;
//@property (readwrite) Judge *judgePresided;
//@property (readwrite) Expert *rep;
//@property (readwrite) Expert *voc;
//@property (readwrite) Expert *me;
//@property (readwrite) Expert *other;
//@property (readwrite) BOOL interpreter;

@property BOOL *lastNameFirst;

// --------------------------------------------------------------
// Fields that are part of this view.
// --------------------------------------------------------------
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
@property (weak) IBOutlet NSButton *fullAmountBtn;

@property (weak) IBOutlet NSComboBox *workedByCombo;
@property (weak) IBOutlet NSComboBox *judgePresidingCombo;
@property (weak) IBOutlet NSComboBox *officeCombo;
@property (weak) IBOutlet NSComboBox *repCombo;
@property (weak) IBOutlet NSComboBox *vocationalCombo;
@property (weak) IBOutlet NSComboBox *medicalCombo;
@property (weak) IBOutlet NSComboBox *otherCombo;
@property (weak) IBOutlet NSComboBox *interpreterCombo;

@property (weak) IBOutlet NSTextField *titleLabel;
@property (weak) IBOutlet NSTextField *statusLabel;
@property (weak) IBOutlet NSButton *clearBtn;

// --------------------------------------------------------------
// Actions that this view can take.
// --------------------------------------------------------------
- (IBAction)clearBtn:(NSButton *)sender;
- (IBAction)dismissBtn:(NSButton *)sender;
- (IBAction)submitBtn:(NSButton *)sender;


@end
