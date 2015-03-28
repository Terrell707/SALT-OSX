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
    NSInteger tag = *(_lastNameFirst);
    
    [_fromDatePicker setDateValue:from];
    [_toDatePicker setDateValue:to];
    [_nameOrderRadio selectCellWithTag:tag];
    [self valuesForCheckBoxes];
}

- (IBAction)confirmBtn:(id)sender {
    NSDate *fromDate = [_fromDatePicker dateValue];
    NSDate *toDate = [_toDatePicker dateValue];
    
    // Grabs the tickets that are in this date range.
    [[DataController sharedDataController] hearingDateRangeFrom:fromDate To:toDate];
    
    // Updates the lastNameFirst boolean value.
    *(_lastNameFirst) = [[_nameOrderRadio selectedCell] tag];
    
    // Shows/Hides columns that are checked/unchecked and then dismisses the view.
    [self showHideTableColumns];
    [self dismissViewController:self];
}

- (void)valuesForCheckBoxes
{
    // Checks all columns that are currently being displayed in the ticket table and unchecks all columns not being shown.
    [_ticketNumber setState:![[_ticketTable tableColumnWithIdentifier:@"ticket_no"] isHidden]];
    [_orderDateBtn setState:![[_ticketTable tableColumnWithIdentifier:@"order_date"] isHidden]];
    [_callOrderBtn setState:![[_ticketTable tableColumnWithIdentifier:@"call_order_no"] isHidden]];
    [_hearingDateBtn setState:![[_ticketTable tableColumnWithIdentifier:@"hearing_date"] isHidden]];
    [_hearingTimeBtn setState:![[_ticketTable tableColumnWithIdentifier:@"hearing_time"] isHidden]];
    [_statusBtn setState:![[_ticketTable tableColumnWithIdentifier:@"status"] isHidden]];
    [_canBtn setState:![[_ticketTable tableColumnWithIdentifier:@"can"] isHidden]];
    [_socBtn setState:![[_ticketTable tableColumnWithIdentifier:@"soc"] isHidden]];
    
    [_clmtFullBtn setState:![[_ticketTable tableColumnWithIdentifier:@"clmt_full_name"] isHidden]];
    [_clmtFirstBtn setState:![[_ticketTable tableColumnWithIdentifier:@"first_name"] isHidden]];
    [_clmtLastBtn setState:![[_ticketTable tableColumnWithIdentifier:@"last_name"] isHidden]];
    [_empFullBtn setState:![[_ticketTable tableColumnWithIdentifier:@"emp_full_name"] isHidden]];
    [_empFirstBtn setState:![[_ticketTable tableColumnWithIdentifier:@"emp_first"] isHidden]];
    [_empLastBtn setState:![[_ticketTable tableColumnWithIdentifier:@"emp_last"] isHidden]];
    [_judgeFullBtn setState:![[_ticketTable tableColumnWithIdentifier:@"judge_full_name"] isHidden]];
    [_judgeFirstBtn setState:![[_ticketTable tableColumnWithIdentifier:@"judge_first"] isHidden]];
    [_judgeLastBtn setState:![[_ticketTable tableColumnWithIdentifier:@"judge_last"] isHidden]];
    [_siteFullBtn setState:![[_ticketTable tableColumnWithIdentifier:@"office_full_info"] isHidden]];
    [_siteCodeBtn setState:![[_ticketTable tableColumnWithIdentifier:@"office_code"] isHidden]];
    [_siteNameBtn setState:![[_ticketTable tableColumnWithIdentifier:@"office_name"] isHidden]];
}

- (void)showHideTableColumns
{
    // Shows/Hides columns in the ticket table depending on what is checked and not checked.
    [[_ticketTable tableColumnWithIdentifier:@"ticket_no"] setHidden:![_ticketNumber state]];
    [[_ticketTable tableColumnWithIdentifier:@"order_date"] setHidden:![_orderDateBtn state]];
    [[_ticketTable tableColumnWithIdentifier:@"call_order_no"] setHidden:![_callOrderBtn state]];
    [[_ticketTable tableColumnWithIdentifier:@"hearing_date"] setHidden:![_hearingDateBtn state]];
    [[_ticketTable tableColumnWithIdentifier:@"hearing_time"] setHidden:![_hearingTimeBtn state]];
    [[_ticketTable tableColumnWithIdentifier:@"status"] setHidden:![_statusBtn state]];
    [[_ticketTable tableColumnWithIdentifier:@"can"] setHidden:![_canBtn state]];
    [[_ticketTable tableColumnWithIdentifier:@"soc"] setHidden:![_socBtn state]];
    
    [[_ticketTable tableColumnWithIdentifier:@"clmt_full_name"] setHidden:![_clmtFullBtn state]];
    [[_ticketTable tableColumnWithIdentifier:@"first_name"] setHidden:![_clmtFirstBtn state]];
    [[_ticketTable tableColumnWithIdentifier:@"last_name"] setHidden:![_clmtLastBtn state]];
    [[_ticketTable tableColumnWithIdentifier:@"emp_full_name"] setHidden:![_empFullBtn state]];
    [[_ticketTable tableColumnWithIdentifier:@"emp_first"] setHidden:![_empFirstBtn state]];
    [[_ticketTable tableColumnWithIdentifier:@"emp_last"] setHidden:![_empLastBtn state]];
    [[_ticketTable tableColumnWithIdentifier:@"judge_full_name"] setHidden:![_judgeFullBtn state]];
    [[_ticketTable tableColumnWithIdentifier:@"judge_first"] setHidden:![_judgeFirstBtn state]];
    [[_ticketTable tableColumnWithIdentifier:@"judge_last"] setHidden:![_judgeLastBtn state]];
    [[_ticketTable tableColumnWithIdentifier:@"office_full_info"] setHidden:![_siteFullBtn state]];
    [[_ticketTable tableColumnWithIdentifier:@"office_code"] setHidden:![_siteCodeBtn state]];
    [[_ticketTable tableColumnWithIdentifier:@"office_name"] setHidden:![_siteNameBtn state]];
}

@end
