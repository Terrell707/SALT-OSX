//
//  TicketSettingsViewController.m
//  SALT
//
//  Created by Adrian T. Chambers on 3/26/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "TicketSettingsViewController.h"

@interface TicketSettingsViewController ()

@end

@implementation TicketSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *from = [[DataController sharedDataController] ticketHearingDateFrom];
    NSDate *to = [[DataController sharedDataController] ticketHearingDateTo];
    
    [_fromDatePicker setDateValue:from];
    [_toDatePicker setDateValue:to];
    
    NSLog(@"Table Columns = %@", _tableColumns);
    
}

- (IBAction)confirmBtn:(id)sender {
    NSDate *fromDate = [_fromDatePicker dateValue];
    NSDate *toDate = [_toDatePicker dateValue];
    
    [[DataController sharedDataController] hearingDateRangeFrom:fromDate To:toDate];
    [self dismissViewController:self];
}

@end
