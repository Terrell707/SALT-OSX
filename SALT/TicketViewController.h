//
//  TicketViewController.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/9/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Ticket.h"
#import "MySQL.h"
#import "StatusCodes.h"

@interface TicketViewController : NSViewController {
    MySQL *mySQL;
    StatusCodes *statusChecker;
    
    NSMutableArray *tickets;
    IBOutlet NSArrayController *ticketsController;
}

@property (weak) IBOutlet NSTableView *ticketTable;

@end
