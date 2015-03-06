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
    NSArray *ticketsBeforeFilter;
    NSPredicate *searchPredicate;
    
    IBOutlet NSTableView *ticketTable;
    IBOutlet NSSearchField *searchField;
    IBOutlet NSArrayController *ticketController;
}

@property (readwrite, copy) NSMutableArray *tickets;

- (IBAction)removeButton:(id)sender;

@end
