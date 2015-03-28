//
//  TicketSettingsViewController.h
//  SALT
//
//  Created by Adrian T. Chambers on 3/26/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DataController.h"

@interface TicketSettingsViewController : NSViewController

@property (weak) IBOutlet NSDatePicker *fromDatePicker;
@property (weak) IBOutlet NSDatePicker *toDatePicker;

@property (weak) IBOutlet NSButton *ticketNumber;
@property (weak) IBOutlet NSButton *orderDateBtn;
@property (weak) IBOutlet NSButton *callOrderBtn;
@property (weak) IBOutlet NSButton *hearingDateBtn;
@property (weak) IBOutlet NSButton *hearingTimeBtn;
@property (weak) IBOutlet NSButton *statusBtn;
@property (weak) IBOutlet NSButton *canBtn;
@property (weak) IBOutlet NSButton *socBtn;

@property (weak) IBOutlet NSButton *clmtFullBtn;
@property (weak) IBOutlet NSButton *clmtFirstBtn;
@property (weak) IBOutlet NSButton *clmtLastBtn;
@property (weak) IBOutlet NSButton *empFullBtn;
@property (weak) IBOutlet NSButton *empFirstBtn;
@property (weak) IBOutlet NSButton *empLastBtn;
@property (weak) IBOutlet NSButton *judgeFullBtn;
@property (weak) IBOutlet NSButton *judgeFirstBtn;
@property (weak) IBOutlet NSButton *judgeLastBtn;
@property (weak) IBOutlet NSButton *siteFullBtn;
@property (weak) IBOutlet NSButton *siteCodeBtn;
@property (weak) IBOutlet NSButton *siteNameBtn;

@property (weak) IBOutlet NSMatrix *nameOrderRadio;

@property (readwrite) NSTableView *ticketTable;
@property (readwrite) BOOL *lastNameFirst;

- (IBAction)confirmBtn:(id)sender;

@end
