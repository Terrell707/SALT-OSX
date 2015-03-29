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
#import "TicketPrintView.h"
#import "TicketSettingsViewController.h"

@interface TicketViewController : NSViewController <NSTableViewDelegate, NSMenuDelegate> {
    BOOL lastNameFirst;
    
    NSArray *ticketsBeforeFilter;
    NSPredicate *searchPredicate;
    
    IBOutlet NSTableView *ticketTable;
    IBOutlet NSSearchField *searchField;
    IBOutlet NSArrayController *ticketController;
}

@property NSMutableArray *tickets;

@property (weak) IBOutlet NSTextField *orderDateField;
@property (weak) IBOutlet NSTextField *hearingDateField;
@property (weak) IBOutlet NSTextField *hearingTimeField;
@property (weak) IBOutlet NSTextField *callNumberField;
@property (weak) IBOutlet NSTextField *ticketNumberField;
@property (weak) IBOutlet NSTextField *claimantNameField;
@property (weak) IBOutlet NSTextField *socField;
@property (weak) IBOutlet NSTextField *canField;
@property (weak) IBOutlet NSTextField *statusField;
@property (weak) IBOutlet NSButton *onRecordCheckBox;

@property (weak) IBOutlet NSTextField *officeField;
@property (weak) IBOutlet NSTextField *workedByField;
@property (weak) IBOutlet NSTextField *judgePresidingField;
@property (weak) IBOutlet NSTextField *repField;
@property (weak) IBOutlet NSTextField *vocField;
@property (weak) IBOutlet NSTextField *meField;
@property (weak) IBOutlet NSTextField *otherField;
@property (weak) IBOutlet NSTextField *interpreterField;

@property (weak) IBOutlet NSBox *ticketInfoBox;
@property (weak) IBOutlet NSBox *hearingInfoBox;

- (IBAction)removeButton:(id)sender;

@property (weak) IBOutlet NSButton *removeButton;
@property (weak) IBOutlet NSButton *updateButton;

@end
