//
//  TicketViewController.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/9/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DataController.h"
#import "InsertTicketViewController.h"

@interface TicketViewController : NSViewController {
    BOOL lastNameFirst;
    NSArray *ticketsBeforeFilter;
    NSPredicate *searchPredicate;
    
    IBOutlet NSTableView *ticketTable;
    IBOutlet NSSearchField *searchField;
    IBOutlet NSArrayController *ticketController;
}

@property (readwrite, copy) NSMutableArray *tickets;

@property (weak) IBOutlet NSDatePicker *orderDatePicker;
@property (weak) IBOutlet NSDatePicker *hearingDatePicker;
@property (weak) IBOutlet NSDatePicker *hearingTimePicker;
@property (weak) IBOutlet NSTextField *ticketNumberField;
@property (weak) IBOutlet NSTextField *claimantNameField;
@property (weak) IBOutlet NSTextField *callNumberField;
@property (weak) IBOutlet NSTextField *socField;
@property (weak) IBOutlet NSTextField *statusField;
@property (weak) IBOutlet NSTextField *canField;

@property (weak) IBOutlet NSTextField *workedByField;
@property (weak) IBOutlet NSTextField *judgePresidingField;
@property (weak) IBOutlet NSTextField *officeField;
@property (weak) IBOutlet NSTextField *repNameField;
@property (weak) IBOutlet NSTextField *vocNameField;
@property (weak) IBOutlet NSTextField *medNameField;
@property (weak) IBOutlet NSTextField *otherNameField;

- (IBAction)removeButton:(id)sender;

@end
