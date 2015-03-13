//
//  TicketPrintView.h
//  SALT
//
//  Created by Adrian T. Chambers on 3/13/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Business.h"
#import "Ticket.h"
#import "DataController.h"

@interface TicketPrintView : NSView {
    Business *business;
    NSArray *tickets;
    NSMutableDictionary *attributes;
    float lineHeight;
    NSRect pageRect;
    NSInteger linesPerPage;
    NSInteger currentPage;
}

- (id)initWithTickets:(NSArray *)array;
@end
