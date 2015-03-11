//
//  TicketViewController.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/9/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DataController.h"

@interface TicketViewController : NSViewController {
    BOOL lastNameFirst;
    NSArray *ticketsBeforeFilter;
    NSPredicate *searchPredicate;
    
    IBOutlet NSTableView *ticketTable;
    IBOutlet NSSearchField *searchField;
    IBOutlet NSArrayController *ticketController;
}

@property (readwrite, copy) NSMutableArray *tickets;
@property (weak) IBOutlet NSTextField *claimantNameField;
@property (weak) IBOutlet NSTextField *workedByField;
@property (weak) IBOutlet NSTextField *judgePresidingField;
@property (weak) IBOutlet NSTextField *officeField;
@property (weak) IBOutlet NSTextField *repNameField;
@property (weak) IBOutlet NSTextField *vocNameField;
@property (weak) IBOutlet NSTextField *medNameField;
@property (weak) IBOutlet NSTextField *otherNameField;

- (IBAction)removeButton:(id)sender;

@end
