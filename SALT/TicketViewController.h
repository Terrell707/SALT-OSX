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
}

@property (readwrite, copy) NSMutableArray *tickets;
@property (weak) IBOutlet NSTableView *ticketTable;

@end
