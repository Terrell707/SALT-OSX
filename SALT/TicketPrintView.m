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
        business = [[DataController sharedDataController] business];
        tickets = [t copy];
        invoiceTitle = @"VHR INVOICE";
        invoiceNumber = @"SALTSAC032015";
        combinedTotal = 0;
        
        // The attributes of the text to be printed.
        attributes = [[NSMutableDictionary alloc] init];
        NSFont *font = [NSFont fontWithName:@"Helvetica" size:9.0];
        lineHeight = [font capHeight] * 1.7;
        [attributes setObject:font forKey:NSFontAttributeName];
    }
    
    return self;
}

- (id)initWithTickets:(NSArray *)t fromSite:(Site *)s withTitle:(NSString *)title andNumber:(NSString *)number
{
    NSLog(@"Ticket Print View Init With Tickets, Site, Title, and Number");
    // Call the superclass's designated initializer with some dummy frame.
    self = [super initWithFrame:NSMakeRect(0, 0, 700, 700)];
    if (self) {
        business = [[DataController sharedDataController] business];
        tickets = [t copy];
        office = s;
        invoiceTitle = title;
        invoiceNumber = number;
        combinedTotal = 0;
        
        // The attributes of the text to be printed.
        attributes = [[NSMutableDictionary alloc] init];
        NSFont *font = [NSFont fontWithName:@"Helvetica" size:9.0];
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
    
    maxPages = range->length;
    
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
    
    NSRect blank;
    
    NSRect invoiceTitleRect;
    NSRect bpaNumber;
    NSRect companyName;
    NSRect contractor;
    NSRect invoiceNumberRect;
    NSRect contractorStreet;
    NSRect contractorCity;
    NSRect contractorPhoneNumber;
    NSRect contractorEmail;
    NSRect reportPrintDate;
    NSRect taxID;
    NSRect dunsNumber;
    NSRect toFinance;
    NSRect toSite;
    NSRect locationRect;
    
    NSRect callOrderHeader;
    NSRect ticketNumberHeader;
    NSRect claimantNameHeader;
    NSRect orderDateHeader;
    NSRect serviceDateHeader;
    NSRect amountClaimedHeader;
    
    NSRect callOrderRect;
    NSRect ticketNumberRect;
    NSRect claimantNameRect;
    NSRect orderDateRect;
    NSRect serviceDateRect;
    NSRect amountClaimedRect;
    NSRect pageTotalRect;
    
    NSRect combinedTotalRect;
    NSRect submitOriginalRect;
    NSRect signatureRect;
    NSRect signatureDateRect;
    NSRect certificationRect;
    NSRect printNameRect;
    NSRect printNameDateRect;
    NSRect nameTitleRect;
    NSRect nameTitleSignatureRect;
    
    NSUInteger pageTotal = 0;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    
    // If the first page, print title, headers, etc.
    if (currentPage == 0) {
        // Reset the combined total.
        combinedTotal = 0;
        
        // First line being the title.
        invoiceTitleRect.size.width = pageRect.size.width;
        invoiceTitleRect.size.height = lineHeight;
        invoiceTitleRect.origin.x = pageRect.origin.x;
        invoiceTitleRect.origin.y = pageRect.origin.y;
        NSString *title = [NSString stringWithFormat:@"%@", invoiceTitle];
        NSSize titleSize = [title sizeWithAttributes:attributes];
        NSPoint titleOrigin;
        titleOrigin.x = invoiceTitleRect.origin.x + (invoiceTitleRect.size.width - titleSize.width)/2;
        titleOrigin.y = invoiceTitleRect.origin.y + (invoiceTitleRect.size.height - titleSize.height)/2;
        [title drawAtPoint:titleOrigin withAttributes:attributes];
        
        // Second line is blank space.
        blank.origin.x = pageRect.origin.x;
        blank.origin.y = NSMaxY(invoiceTitleRect);
        blank.size = invoiceTitleRect.size;
        
        // Third line is bpa number.
        bpaNumber.size.width = pageRect.size.width / 4;
        bpaNumber.size.height = lineHeight;
        bpaNumber.origin.x = pageRect.origin.x;
        bpaNumber.origin.y = NSMaxY(blank);
        NSString *bpa = [NSString stringWithFormat:@"BPA#: %@", [business bpa_no]];
        [bpa drawInRect:bpaNumber withAttributes:attributes];
        
        // Fourth line is company name and invoice number.
        companyName.size.width = pageRect.size.width / 3;
        companyName.size.height = lineHeight;
        companyName.origin.x = pageRect.origin.x;
        companyName.origin.y = NSMaxY(bpaNumber);
        NSString *company = [NSString stringWithFormat:@"%@", [[business name] uppercaseString]];
        [company drawInRect:companyName withAttributes:attributes];
        
        invoiceNumberRect.size.width = pageRect.size.width / 3;
        invoiceNumberRect.size.height = lineHeight;
        invoiceNumberRect.origin.x = NSMaxX(companyName) * 2;
        invoiceNumberRect.origin.y = companyName.origin.y;
        NSString *invoice = [NSString stringWithFormat:@"INVOICE #: %@", invoiceNumber];
        [invoice drawInRect:invoiceNumberRect withAttributes:attributes];
        
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
        [@"TO: Social Security Administration\nOffice of Finance\nPO Box 47\nBaltimore, MD 21235-0047" drawInRect:toFinance withAttributes:attributes];
        
        toSite.origin.x = NSMaxX(toFinance) * 2;
        toSite.origin.y = toFinance.origin.y;
        toSite.size.width = pageRect.size.width / 3;
        toSite.size.height = lineHeight * 5;
        NSArray *siteAddress = [[office address] componentsSeparatedByString:@", "];
        NSString *orderingOffice = @"Ordering Office: Social Security Administration";
        NSString *socialSecurity = @"Office of Disability Adjudication and Review";
        NSString *address = [NSString stringWithFormat:@"%@\n%@\n%@\n%@, %@", orderingOffice, socialSecurity, siteAddress[0], siteAddress[1], siteAddress[2]];
        [address drawInRect:toSite withAttributes:attributes];
        
        locationRect.origin.x = toSite.origin.x;
        locationRect.origin.y = NSMaxY(toSite);
        locationRect.size.width = pageRect.size.width;
        locationRect.size.height = lineHeight;
        NSString *location = [NSString stringWithFormat:@"Location: %@; CAN: %@", [office office_code], [office can]];
        [location drawInRect:locationRect withAttributes:attributes];
        
        // Twelveth line is a blank line.
        blank.origin.x = pageRect.origin.x;
        blank.origin.y = NSMaxY(locationRect);
        blank.size.width = pageRect.size.width;
        blank.size.height = lineHeight;
        
        // Eleventh line is the header.
        // Defines the width of each of the rectangles.
        callOrderHeader.size.width = 100.0;
        ticketNumberHeader.size.width = 90.0;
        claimantNameHeader.size.width = 180.0;
        orderDateHeader.size.width = 80.0;
        serviceDateHeader.size.width = 80.0;
        amountClaimedHeader.size.width = 90.0;
        
        // Makes all the rectangles the same height.
        callOrderHeader.size.height = 2 * lineHeight;
        ticketNumberHeader.size.height = 2 * lineHeight;
        claimantNameHeader.size.height = 2 * lineHeight;
        orderDateHeader.size.height = 2 * lineHeight;
        serviceDateHeader.size.height = 2 * lineHeight;
        amountClaimedHeader.size.height = 2 * lineHeight;
        
        callOrderHeader.origin.x = pageRect.origin.x;
        callOrderHeader.origin.y = NSMaxY(blank);
        ticketNumberHeader.origin.x = NSMaxX(callOrderHeader);
        ticketNumberHeader.origin.y = NSMaxY(blank);
        claimantNameHeader.origin.x = NSMaxX(ticketNumberHeader);
        claimantNameHeader.origin.y = NSMaxY(blank);
        orderDateHeader.origin.x = NSMaxX(claimantNameHeader);
        orderDateHeader.origin.y = NSMaxY(blank);
        serviceDateHeader.origin.x = NSMaxX(orderDateHeader);
        serviceDateHeader.origin.y = NSMaxY(blank);
        amountClaimedHeader.origin.x = NSMaxX(serviceDateHeader);
        amountClaimedHeader.origin.y = NSMaxY(blank);
        
        [@"Call Order\nNumber" drawInRect:callOrderHeader withAttributes:attributes];
        [@"Delivery Ticket\nNumber" drawInRect:ticketNumberHeader withAttributes:attributes];
        [@"Description" drawInRect:claimantNameHeader withAttributes:attributes];
        [@"Order Date" drawInRect:orderDateHeader withAttributes:attributes];
        [@"Service Date" drawInRect:serviceDateHeader withAttributes:attributes];
        [@"Amount\nClaimed" drawInRect:amountClaimedHeader withAttributes:attributes];
    }
    
    // Makes all the rectangles the same width.
    callOrderRect.size.width = 100.0;
    ticketNumberRect.size.width = 90.0;
    claimantNameRect.size.width = 180.0;
    orderDateRect.size.width = 80.0;
    serviceDateRect.size.width = 80.0;
    amountClaimedRect.size.width = 90.0;
    
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
    
    // If the first page, move first row of data beneath the headers.
    if (currentPage == 0) {
        // Places the call order rect beneth the header.
        callOrderRect.origin.y = NSMaxY(callOrderHeader);
    }
    else {
        callOrderRect.origin.y = pageRect.origin.y;
    }
        
    // Prints them all out.
    for (NSInteger i = 0; i < linesPerPage; i++) {
        NSInteger index = (currentPage * linesPerPage) + i;
        if (index >= [tickets count]) {
            break;
        }
        
        Ticket *t = [tickets objectAtIndex:index];
        
        // Draw each of the needed components of the ticket into the rectangle.
        callOrderRect.origin.y = NSMaxY(callOrderRect);
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
        NSString *orderDate = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:t.order_date]];
        [orderDate drawInRect:orderDateRect withAttributes:attributes];
        
        serviceDateRect.origin.y = orderDateRect.origin.y;
        NSString *serviceDate = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:t.hearing_date]];
        [serviceDate drawInRect:serviceDateRect withAttributes:attributes];
        
        amountClaimedRect.origin.y = serviceDateRect.origin.y;
        NSString *amountClaimed = [NSString stringWithFormat:@"%@", t.heldAt.pay];
        [amountClaimed drawInRect:amountClaimedRect withAttributes:attributes];
        
        // Keeps the running total of amount claimed.
        combinedTotal += [amountClaimed integerValue];
        pageTotal += [amountClaimed integerValue];
    }
    
    // Places a blank line beneath the last ticket.
    blank.size.width = pageRect.size.width;
    blank.size.height = lineHeight;
    blank.origin.x = pageRect.origin.x;
    blank.origin.y = NSMaxY(amountClaimedRect);

    // Prints the page total at the bottom of each page.
//    if (maxPages > 1) {
//        // Lines the text "Page X Total:" up with the service date.
//        pageTotalRect.size.width = serviceDateRect.size.width;
//        pageTotalRect.size.height = lineHeight;
//        pageTotalRect.origin.x = serviceDateRect.origin.x;
//        pageTotalRect.origin.y = NSMaxY(blank);
//        NSString *pageClaimed = [NSString stringWithFormat:@"Page %ld Total:", currentPage+1];
//        [pageClaimed drawInRect:pageTotalRect withAttributes:attributes];
//        
//        // Lines the actual dollar amount total up with amount claimed.
//        pageTotalRect.size.width = amountClaimedRect.size.width;
//        pageTotalRect.origin.x = amountClaimedRect.origin.x;
//        NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
//        [numFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//        NSString *formattedTotal = [numFormatter stringFromNumber:[NSNumber numberWithInteger:pageTotal]];
//        [formattedTotal drawInRect:pageTotalRect withAttributes:attributes];
//        
//        // Places a blank line beneath the last ticket.
//        blank.size.width = pageRect.size.width;
//        blank.size.height = lineHeight;
//        blank.origin.x = pageRect.origin.x;
//        blank.origin.y = NSMaxY(pageTotalRect);
//    }
    
    if (currentPage == maxPages-1) {
        
        // Lines the text "Combined Total:" up with the service date.
        combinedTotalRect.size.width = serviceDateRect.size.width;
        combinedTotalRect.size.height = lineHeight;
        combinedTotalRect.origin.x = serviceDateRect.origin.x;
        combinedTotalRect.origin.y = NSMaxY(blank);
        [@"Combined Total: " drawInRect:combinedTotalRect withAttributes:attributes];

        // Lines the actual dollar amount total up with amount claimed.
        combinedTotalRect.size.width = amountClaimedRect.size.width;
        combinedTotalRect.origin.x = amountClaimedRect.origin.x;
        NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
        [numFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        NSString *formattedTotal = [numFormatter stringFromNumber:[NSNumber numberWithInteger:combinedTotal]];
        [formattedTotal drawInRect:combinedTotalRect withAttributes:attributes];

        // Places a blank line beneath the combined total.
        blank.size.width = pageRect.size.width;
        blank.size.height = lineHeight;
        blank.origin.x = pageRect.origin.x;
        blank.origin.y = NSMaxY(combinedTotalRect);

        submitOriginalRect.origin.x = pageRect.origin.x;
        submitOriginalRect.origin.y = NSMaxY(blank);
        submitOriginalRect.size.width = pageRect.size.width;
        submitOriginalRect.size.height = lineHeight;
        [@"SUBMIT ORIGINAL TO SSA/ODAR OFFICE. Complete Continuation Sheet if additonal space is needed." drawInRect:submitOriginalRect withAttributes:attributes];

        // Places two blank lines beneath the "Submit Original" line.
        blank.origin.x = pageRect.origin.x;
        blank.origin.y = NSMaxY(submitOriginalRect);
        blank.size.height = lineHeight * 2;
        blank.size.width = pageRect.size.width;
        
        // Places the area for Contractor to sign and date.
        signatureRect.size.width = pageRect.size.width / 2;
        signatureRect.size.height = lineHeight;
        signatureRect.origin.x = pageRect.origin.x;
        signatureRect.origin.y = NSMaxY(blank);
        [@"CONTRACTOR'S SIGNATURE:" drawInRect:signatureRect withAttributes:attributes];
        
        signatureDateRect.size.width = pageRect.size.width / 4;
        signatureDateRect.size.height = lineHeight;
        signatureDateRect.origin.x = serviceDateRect.origin.x;
        signatureDateRect.origin.y = signatureRect.origin.y;
        [@"DATE:" drawInRect:signatureDateRect withAttributes:attributes];
        
        blank.size.height = lineHeight;
        blank.origin.y = NSMaxY(signatureRect);
        
        // Prints the company's "Certification"
        NSString *certification = @"CERTIFICATION OF PAYMENT:   ";
        NSSize certSize = [certification sizeWithAttributes:attributes];
        certificationRect.size.width = certSize.width;
        certificationRect.size.height = lineHeight;
        certificationRect.origin.x = pageRect.origin.x;
        certificationRect.origin.y = NSMaxY(blank);
        [certification drawInRect:certificationRect withAttributes:attributes];
        
        NSMutableDictionary *attr = [[NSMutableDictionary alloc] init];
        NSFont *font = [NSFont fontWithName:@"Helvetica" size:8.0];
        [attr setObject:font forKey:NSFontAttributeName];
        certification = @"The information provided on this invoice has been reviewed against the original "
        "call order(s) and is certified to be correct.";
        
        certSize = [certification sizeWithAttributes:attr];
        certificationRect.origin.x = NSMaxX(certificationRect);
        certificationRect.origin.y = NSMaxY(blank);
        certificationRect.size.width = certSize.width;
        certificationRect.size.height = lineHeight;
        NSPoint certOrigin;
        certOrigin.x = certificationRect.origin.x + (certificationRect.size.width - certSize.width)/2;
        certOrigin.y = certificationRect.origin.y + (certificationRect.size.height - certSize.height)/2;
        [certification drawAtPoint:certOrigin withAttributes:attr];
        
        // Places a blank line beneath the certification.
        blank.origin.x = pageRect.origin.x;
        blank.origin.y = NSMaxY(certificationRect);
        blank.size.width = pageRect.size.width;
        blank.size.height = lineHeight;
        
        // Prints line for Certifying Official to print their name.
        printNameRect.origin.x = pageRect.origin.x;
        printNameRect.origin.y = NSMaxY(blank);
        printNameRect.size.width = pageRect.size.width / 2;
        printNameRect.size.height = lineHeight;
        [@"PRINT NAME (Certifying Official):" drawInRect:printNameRect withAttributes:attributes];
        
        // Print line for official to date it.
        printNameDateRect.size.width = pageRect.size.width / 4;
        printNameDateRect.size.height = lineHeight;
        printNameDateRect.origin.x = serviceDateRect.origin.x;
        printNameDateRect.origin.y = printNameRect.origin.y;
        [@"DATE:" drawInRect:printNameDateRect withAttributes:attributes];
        
        nameTitleSignatureRect.origin.x = pageRect.origin.x;
        nameTitleSignatureRect.origin.y = NSMaxY(printNameDateRect);
        nameTitleSignatureRect.size.width = pageRect.size.width / 4;
        nameTitleSignatureRect.size.height = lineHeight;
        [@"SIGNATURE:" drawInRect:nameTitleSignatureRect withAttributes:attributes];
    }
}


@end
