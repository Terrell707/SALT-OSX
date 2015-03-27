//
//  TicketPrintViewController.m
//  SALT
//
//  Created by Adrian T. Chambers on 3/22/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "TicketPrintViewController.h"

@interface TicketPrintViewController ()

@end

@implementation TicketPrintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Loads the "Office" combobox with the list of possible offices.
    sites = [[DataController sharedDataController] sites];
    for (Site *office in sites) {
        NSString *officeItem = [NSString stringWithFormat:@"%@, %@", [office name], [office office_code]];
        [_officeCombo addItemWithObjectValue:officeItem];
    }
    
    // Sets the defaults.
    [_officeCombo selectItemAtIndex:0];
    
    // Gets today's date.
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:today];
    
    // Gets the end of last month.
    [comps setMonth:[comps month]];
    [comps setDay:0];
    NSDate *endLastMonth = [calendar dateFromComponents:comps];
    
    // Gets the beginning of last month.
    [comps setMonth:[comps month]-1];
    [comps setDay:1];
    NSDate *beginningLastMonth = [calendar dateFromComponents:comps];
    
    // Sets the dates.
    [_fromDatePicker setDateValue:beginningLastMonth];
    [_toDatePicker setDateValue:endLastMonth];
}

- (IBAction)printBtn:(id)sender {
    
    // Gets all the tickets.
    NSArray *tickets = [[DataController sharedDataController] tickets];
    
    // Finds all the tickets that were took place at the selected office.
    NSArray *officeInfo = [[_officeCombo stringValue] componentsSeparatedByString:@", "];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"at_site == %@", officeInfo[1]];
    tickets = [tickets filteredArrayUsingPredicate:predicate];
    
    // Finds the selected office in the list of offices.
    predicate = [NSPredicate predicateWithFormat:@"name == %@ && office_code == %@",
                              officeInfo[0], officeInfo[1]];
    NSArray *office = [sites filteredArrayUsingPredicate:predicate];
    
    NSLog(@"Selected Office = %@", office[0]);
    NSLog(@"Tickets=%ld", [tickets count]);
    
    // Passes the list of tickets to be printed.
    [self printWithTickets:tickets fromSite:office[0]];
}

- (void)comboBoxSelectionDidChange:(NSNotification *)notification
{
    // Grabs the selected office.
    NSString *office = [_officeCombo objectValueOfSelectedItem];
    NSLog(@"Office Selected = %@", office);
    
    // Creates a date formatter that makes a string out of the month and the year.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMyyyy"];
    NSString *today = [dateFormatter stringFromDate:[NSDate date]];
    
    // Concatenates the office name to the first three letters if its one word, and the first letter of each word if more than one word.
    NSArray *officeInfo = [office componentsSeparatedByString:@", "];
    office = officeInfo[0];
    NSString *officeAbbreviation;
    if ([[office componentsSeparatedByString:@" "] count] > 1) {
        NSArray *officeSplit = [office componentsSeparatedByString:@" "];
        officeAbbreviation = [[officeSplit[0] substringWithRange:NSMakeRange(0, 1)] stringByAppendingString:[officeSplit[1] substringWithRange:NSMakeRange(0, 1)]];
        NSLog(@"More than one word. Abbreviation: %@", officeAbbreviation);
    } else {
        officeAbbreviation = [office substringWithRange:NSMakeRange(0, 3)];
        NSLog(@"Its not more than one word. Abbreviation: %@", officeAbbreviation);
    }
    
    // Merges the short office name and the date to create the invoice number.
    [_invoiceNumField setStringValue:[NSString stringWithFormat:@"SALT%@%@", [officeAbbreviation uppercaseString], today]];
}

- (void)printWithTickets:(NSArray *)tickets fromSite:(Site *)office
{
    NSString *invoiceTitle = [_invoiceTitleField stringValue];
    NSString *invoiceNumber = [_invoiceNumField stringValue];
    
    NSPrintInfo *printInfo;
    NSPrintInfo *sharedInfo;
    NSPrintOperation *printOp;
    
    sharedInfo = [NSPrintInfo sharedPrintInfo];
    printInfo = [[NSPrintInfo alloc] initWithDictionary:[NSMutableDictionary dictionaryWithDictionary:[sharedInfo dictionary]]];
    
    NSLog(@"Tickets Again =%ld", [tickets count]);
    TicketPrintView *view = [[TicketPrintView alloc] initWithTickets:tickets
                                                            fromSite:office
                                                           withTitle:invoiceTitle
                                                           andNumber:invoiceNumber];
    
//    TicketPrintView *view = [[TicketPrintView alloc] initWithTickets:tickets];
    printOp = [NSPrintOperation printOperationWithView:view];
    
    [printOp setShowsPrintPanel:YES];
    [printOp runOperation];
}

@end
