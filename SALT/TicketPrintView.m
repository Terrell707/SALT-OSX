//
//  TicketPrintView.m
//  SALT
//
//  Created by Adrian T. Chambers on 3/13/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "TicketPrintView.h"

@implementation TicketPrintView

- (id)initWithTickets:(NSArray *)t
{
    // Call the superclass's designated initializer with some dummy frame.
    self = [super initWithFrame:NSMakeRect(0, 0, 700, 700)];
    if (self) {
        business = [[DataController sharedDataController] business];
        tickets = [t copy];
        // The attributes of the text to be printed.
        attributes = [[NSMutableDictionary alloc] init];
        NSFont *font = [NSFont fontWithName:@"Monaco" size:11.0];
        lineHeight = [font capHeight] * 1.7;
        [attributes setObject:font forKey:NSFontAttributeName];
    }
    
    return self;
}

#pragma mark Pagination

- (BOOL)knowsPageRange:(NSRangePointer)range
{
    NSPrintOperation *po = [NSPrintOperation currentOperation];
    NSPrintInfo *printInfo = [po printInfo];
    
    // Where can I draw?
    pageRect = [printInfo imageablePageBounds];
    NSRect newFrame;
    newFrame.origin = NSZeroPoint;
    newFrame.size = [printInfo paperSize];
    [self setFrame:newFrame];
    
    // How many lines per page?
    linesPerPage = pageRect.size.height / lineHeight;
    
    // Pages are 1-based
    range->location = 1;
    
    // How many pages will it take?
    range->length = [tickets count] / linesPerPage;
    if ([tickets count] % linesPerPage) {
        range->length = range->length + 1;
    }
    
    return YES;
}

- (NSRect)rectForPage:(NSInteger)page
{
    // Note the current page.
    currentPage = page - 1;
    
    // Return the same page rect everytime
    return pageRect;
}

#pragma mark Drawing

// The origin of the view is at the upper-left corner.
- (BOOL)isFlipped
{
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSRect invoiceTitle;
    NSRect bpaNumber;
    NSRect companyName;
    NSRect contractor;
    NSRect invoiceNumber;
    NSRect contractorStreet;
    NSRect contractorCity;
    NSRect contractorPhoneNumber;
    NSRect contractorEmail;
    NSRect reportPrintDate;
    NSRect taxID;
    NSRect dunsNumber;
    NSRect toSite;
    
    NSRect callOrderRect;
    NSRect ticketNumberRect;
    NSRect claimantNameRect;
    NSRect orderDateRect;
    NSRect serviceDateRect;
    NSRect amountClaimedRect;
    
    // Makes all the rectangles the same height.
    callOrderRect.size.height = lineHeight;
    ticketNumberRect.size.height = lineHeight;
    claimantNameRect.size.height = lineHeight;
    orderDateRect.size.height = lineHeight;
    serviceDateRect.size.height = lineHeight;
    amountClaimedRect.size.height = lineHeight;
    
    // Defines the width of each of the rectangles.
    callOrderRect.size.width = 125.0;
    ticketNumberRect.size.width = 100.0;
    claimantNameRect.size.width = 150.0;
    orderDateRect.size.width = 100.0;
    serviceDateRect.size.width = 100.0;
    amountClaimedRect.size.width = 50.0;
    
    // Places each of the rectangles side by side.
    callOrderRect.origin.x = pageRect.origin.x;
    ticketNumberRect.origin.x = NSMaxX(callOrderRect);
    claimantNameRect.origin.x = NSMaxX(ticketNumberRect);
    orderDateRect.origin.x = NSMaxX(claimantNameRect);
    serviceDateRect.origin.x = NSMaxX(orderDateRect);
    amountClaimedRect.origin.x = NSMaxX(serviceDateRect);
    
    // Prints them all out.
    for (NSInteger i = 0; i < linesPerPage; i++) {
        NSInteger index = (currentPage * linesPerPage) + i;
        if (index >= [tickets count]) {
            break;
        }
        
        Ticket *t = [tickets objectAtIndex:index];
        
        // Draw each of the needed components of the ticket into the rectangle.
        callOrderRect.origin.y = pageRect.origin.y + (i * lineHeight);
        NSString *callOrderNo = [NSString stringWithFormat:@"%@", t.call_order_no];
        [callOrderNo drawInRect:callOrderRect withAttributes:attributes];
        
        ticketNumberRect.origin.y = callOrderRect.origin.y;
        NSString *ticketNumber = [NSString stringWithFormat:@"%@", t.ticket_no];
        [ticketNumber drawInRect:ticketNumberRect withAttributes:attributes];
        
        claimantNameRect.origin.y = ticketNumberRect.origin.y;
        NSString *claimantName;
        if (t.first_name != nil && t.last_name != nil)
            claimantName = [NSString stringWithFormat:@"%@, %@", t.last_name, t.first_name];
        else if (t.first_name == nil)
            claimantName = [NSString stringWithFormat:@"%@", t.last_name];
        else
            claimantName = [NSString stringWithFormat:@"%@", t.first_name];
        [claimantName drawInRect:claimantNameRect withAttributes:attributes];
        
        orderDateRect.origin.y = claimantNameRect.origin.y;
        NSString *orderDate = [NSString stringWithFormat:@"%@", t.order_date];
        [orderDate drawInRect:orderDateRect withAttributes:attributes];
        
        serviceDateRect.origin.y = orderDateRect.origin.y;
        NSString *serviceDate = [NSString stringWithFormat:@"%@", t.hearing_date];
        [serviceDate drawInRect:serviceDateRect withAttributes:attributes];
        
        amountClaimedRect.origin.y = serviceDateRect.origin.y;
        NSString *amountClaimed = [NSString stringWithFormat:@"%@", t.heldAt.pay];
        [amountClaimed drawInRect:amountClaimedRect withAttributes:attributes];
    }
}

@end
