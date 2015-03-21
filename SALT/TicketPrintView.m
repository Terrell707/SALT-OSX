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
    NSLog(@"Ticket Print View Init With Tickets");
    // Call the superclass's designated initializer with some dummy frame.
    self = [super initWithFrame:NSMakeRect(0, 0, 700, 700)];
    if (self) {
        printTitle = NO;
        business = [[DataController sharedDataController] business];
        tickets = [t copy];
        // The attributes of the text to be printed.
        attributes = [[NSMutableDictionary alloc] init];
        NSFont *font = [NSFont fontWithName:@"Helvetica" size:12.0];
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

- (float)calculatePageHeight
{
    // Obtain the print info object for the current print operation.
    NSPrintInfo *printInfo = [[NSPrintOperation currentOperation] printInfo];
    
    // Calculate the page height in points.
    NSSize paperSize = [printInfo paperSize];
    float pageHeight = paperSize.height - [printInfo topMargin] - [printInfo bottomMargin];
    
    // Convert height to the scaled view.
    float scale = [[[printInfo dictionary] objectForKey:NSPrintScalingFactor] floatValue];
    
    return pageHeight / scale;
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
    NSRect toFinance;
    NSRect toSite;
    
    NSRect callOrderRect;
    NSRect ticketNumberRect;
    NSRect claimantNameRect;
    NSRect orderDateRect;
    NSRect serviceDateRect;
    NSRect amountClaimedRect;
    
    // First line being the title.
    invoiceTitle.size.width = pageRect.size.width;
    invoiceTitle.size.height = lineHeight;
    invoiceTitle.origin.x = pageRect.origin.x;
    invoiceTitle.origin.y = pageRect.origin.y;
    NSString *title = [NSString stringWithFormat:@"%@", @"VHR INVOICE"];
    NSSize titleSize = [title sizeWithAttributes:attributes];
    NSPoint titleOrigin;
    titleOrigin.x = invoiceTitle.origin.x + (invoiceTitle.size.width - titleSize.width)/2;
    titleOrigin.y = invoiceTitle.origin.y + (invoiceTitle.size.height - titleSize.height)/2;
    [title drawAtPoint:titleOrigin withAttributes:attributes];
    
    // Second line is blank space.
    NSRect blank;
    blank.origin.x = pageRect.origin.x;
    blank.origin.y = NSMaxY(invoiceTitle);
    blank.size = invoiceTitle.size;
    
    // Third line is bpa number.
    bpaNumber.size.width = pageRect.size.width / 4;
    bpaNumber.size.height = lineHeight;
    bpaNumber.origin.x = pageRect.origin.x;
    bpaNumber.origin.y = NSMaxY(blank);
    NSString *bpa = [NSString stringWithFormat:@"BPA# %@", [business bpa_no]];
    [bpa drawInRect:bpaNumber withAttributes:attributes];
    
    // Fourth line is company name and invoice number.
    companyName.size.width = pageRect.size.width / 3;
    companyName.size.height = lineHeight;
    companyName.origin.x = pageRect.origin.x;
    companyName.origin.y = NSMaxY(bpaNumber);
    NSString *company = [NSString stringWithFormat:@"%@", [[business name] uppercaseString]];
    [company drawInRect:companyName withAttributes:attributes];
    
    invoiceNumber.size.width = pageRect.size.width / 3;
    invoiceNumber.size.height = lineHeight;
    invoiceNumber.origin.x = NSMaxX(companyName) * 2;
    invoiceNumber.origin.y = companyName.origin.y;
    NSString *invoice = [NSString stringWithFormat:@"INVOICE # %@", @"SALTSAC032015"];
    [invoice drawInRect:invoiceNumber withAttributes:attributes];
    
    // Fifth line is contractor.
    contractor.size.width = pageRect.size.width / 2;
    contractor.size.height = lineHeight;
    contractor.origin.x = pageRect.origin.x;
    contractor.origin.y = NSMaxY(companyName);
    NSString *contractorName = [NSString stringWithFormat:@"%@ %@", [[business contractor] first_name], [[business contractor] last_name]];
    NSString *contractorString = [NSString stringWithFormat:@"CONTRACTOR: %@", contractorName];
    [contractorString drawInRect:contractor withAttributes:attributes];
    
    // Sixth line is contractor's street and current date.
    contractorStreet.size.width = pageRect.size.width / 3;
    contractorStreet.size.height = lineHeight;
    contractorStreet.origin.x = pageRect.origin.x;
    contractorStreet.origin.y = NSMaxY(contractor);
    NSString *street = [NSString stringWithFormat:@"%@", [[business contractor] street]];
    [street drawInRect:contractorStreet withAttributes:attributes];
    
    reportPrintDate.size.width = pageRect.size.width / 3;
    reportPrintDate.size.height = lineHeight;
    reportPrintDate.origin.x = NSMaxX(contractorStreet) * 2;
    reportPrintDate.origin.y = contractorStreet.origin.y;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M/dd/yyyy"];
    NSString *reportDate = [NSString stringWithFormat:@"DATE: %@", [dateFormatter stringFromDate:[NSDate date]]];
    [reportDate drawInRect:reportPrintDate withAttributes:attributes];
    
    // Seventh line is contractor's city, state, zip, and tax ID.
    contractorCity.size.width = pageRect.size.width / 3;
    contractorCity.size.height = lineHeight;
    contractorCity.origin.x = pageRect.origin.x;
    contractorCity.origin.y = NSMaxY(contractorStreet);
    NSString *cityState = [NSString stringWithFormat:@"%@, %@ %@", [[business contractor] city], [[business contractor] state], [[business contractor] zip]];
    [cityState drawInRect:contractorCity withAttributes:attributes];
    
    taxID.size.width = pageRect.size.width / 3;
    taxID.size.height = lineHeight;
    taxID.origin.x = NSMaxX(contractorCity) * 2;
    taxID.origin.y = contractorCity.origin.y;
    NSString *tax = [NSString stringWithFormat:@"TAX ID: %@", [business tin]];
    [tax drawInRect:taxID withAttributes:attributes];
    
    // Eighth line is contractor's phone number and the duns number.
    contractorPhoneNumber.size.width = pageRect.size.width / 3;
    contractorPhoneNumber.size.height = lineHeight;
    contractorPhoneNumber.origin.x = pageRect.origin.x;
    contractorPhoneNumber.origin.y = NSMaxY(taxID);
    NSString *phoneNumber = [[business contractor] phone_number];
    NSString *formattedPhoneNumber = [NSString stringWithFormat:@"(%@) %@-%@", [phoneNumber substringWithRange:NSMakeRange(0, 3)], [phoneNumber substringWithRange:NSMakeRange(3, 3)], [phoneNumber substringFromIndex:6]];
    [formattedPhoneNumber drawInRect:contractorPhoneNumber withAttributes:attributes];
    
    dunsNumber.size.width = pageRect.size.width / 3;
    dunsNumber.size.height = lineHeight;
    dunsNumber.origin.x = NSMaxX(contractorPhoneNumber) * 2;
    dunsNumber.origin.y = contractorPhoneNumber.origin.y;
    NSString *duns = [NSString stringWithFormat:@"DUNS # %@", [business duns_no]];
    [duns drawInRect:dunsNumber withAttributes:attributes];
    
    // Ninth line is contractor e-mail and invoice period.
    contractorEmail.size.width = pageRect.size.width / 3;
    contractorEmail.size.height = lineHeight;
    contractorEmail.origin.x = pageRect.origin.x;
    contractorEmail.origin.y = NSMaxY(contractorPhoneNumber);
    NSString *email = [NSString stringWithFormat:@"%@", [[business contractor] email]];
    [email drawInRect:contractorEmail withAttributes:attributes];
    
    // Tenth line is a blank line.
    blank.origin.x = pageRect.origin.x;
    blank.origin.y = NSMaxY(contractorEmail);
    blank.size.height = lineHeight;
    
    // Eleventh line is "To Social Security Admin" and "The office for the invoice".
    toFinance.origin.x = pageRect.origin.x;
    toFinance.origin.y = NSMaxY(blank);
    toFinance.size.width = pageRect.size.width / 3;
    toFinance.size.height = lineHeight * 5;
    [@"TO:\tSocial Security Administration\nOffice of Finance\nPO Box 47\nBaltimore, MD 21235-0047" drawInRect:toFinance withAttributes:attributes];
    
    toSite.origin.x = NSMaxX(toFinance) * 2;
    toSite.origin.y = toFinance.origin.y;
    toSite.size.width = pageRect.size.width / 3;
    toSite.size.height = lineHeight * 5;
    [@"Office: Social Security Administration\nODAR\nSuite 230\n4040 Civic Center Drive\nSan Rafael, CA 94903" drawInRect:toSite withAttributes:attributes];
    
    // Twelveth line is a blank line.
    blank.origin.x = pageRect.origin.x;
    blank.origin.y = NSMaxY(toFinance);
    blank.size.height = lineHeight;
    
    // Defines the width of each of the rectangles.
    callOrderRect.size.width = 125.0;
    ticketNumberRect.size.width = 100.0;
    claimantNameRect.size.width = 150.0;
    orderDateRect.size.width = 80.0;
    serviceDateRect.size.width = 80.0;
    amountClaimedRect.size.width = 90.0;
    
    // Eleventh line is the header.
    callOrderRect.size.height = 2 * lineHeight;
    ticketNumberRect.size.height = 2 * lineHeight;
    claimantNameRect.size.height = 2 * lineHeight;
    orderDateRect.size.height = 2 * lineHeight;
    serviceDateRect.size.height = 2 * lineHeight;
    amountClaimedRect.size.height = 2 * lineHeight;
    
    callOrderRect.origin.x = pageRect.origin.x;
    callOrderRect.origin.y = NSMaxY(blank);
    ticketNumberRect.origin.x = NSMaxX(callOrderRect);
    ticketNumberRect.origin.y = NSMaxY(blank);
    claimantNameRect.origin.x = NSMaxX(ticketNumberRect);
    claimantNameRect.origin.y = NSMaxY(blank);
    orderDateRect.origin.x = NSMaxX(claimantNameRect);
    orderDateRect.origin.y = NSMaxY(blank);
    serviceDateRect.origin.x = NSMaxX(orderDateRect);
    serviceDateRect.origin.y = NSMaxY(blank);
    amountClaimedRect.origin.x = NSMaxX(serviceDateRect);
    amountClaimedRect.origin.y = NSMaxY(blank);
    
    [@"Call Order No." drawInRect:callOrderRect withAttributes:attributes];
    [@"Ticket Number" drawInRect:ticketNumberRect withAttributes:attributes];
    [@"Description" drawInRect:claimantNameRect withAttributes:attributes];
    [@"Order\nDate" drawInRect:orderDateRect withAttributes:attributes];
    [@"Service\nDate" drawInRect:serviceDateRect withAttributes:attributes];
    [@"Amount\nClaimed" drawInRect:amountClaimedRect withAttributes:attributes];
    
    // Makes all the rectangles the same height.
    callOrderRect.size.height = lineHeight;
    ticketNumberRect.size.height = lineHeight;
    claimantNameRect.size.height = lineHeight;
    orderDateRect.size.height = lineHeight;
    serviceDateRect.size.height = lineHeight;
    amountClaimedRect.size.height = lineHeight;
    
    // Places each of the rectangles side by side.
    callOrderRect.origin.x = pageRect.origin.x;
    ticketNumberRect.origin.x = NSMaxX(callOrderRect);
    claimantNameRect.origin.x = NSMaxX(ticketNumberRect);
    orderDateRect.origin.x = NSMaxX(claimantNameRect);
    serviceDateRect.origin.x = NSMaxX(orderDateRect);
    amountClaimedRect.origin.x = NSMaxX(serviceDateRect);
    
    // Prints them all out.
    for (NSInteger i = 19; i < linesPerPage + 19; i++) {
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
