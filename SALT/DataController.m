//
//  DataController.m
//  SALT
//
//  Created by Adrian T. Chambers on 2/12/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "DataController.h"

@interface DataController ()
- (void)grabHearingStatusData;
- (void)grabEmployeeData;
- (void)grabJudgeData;
- (void)grabTicketData;
- (BOOL)checkStatus:(NSInteger)status;
@end

@implementation DataController

// Static Instance variable.
static DataController *sharedDataController = nil;

+ (DataController *)sharedDataController {
    if (sharedDataController == nil) {
            sharedDataController = [[super allocWithZone:NULL] init];
    }
    return sharedDataController;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialize utility objects.
        mySQL = [[MySQL alloc] init];
        statusChecker = [[StatusCodes alloc] init];
        
        // Initalize data arrays.
        _hearingStatus = [[NSMutableArray alloc] init];
        _employees = [[NSMutableArray alloc] init];
        _judges = [[NSMutableArray alloc] init];
        _sites = [[NSMutableArray alloc] init];
        _tickets = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadData
{
    NSLog(@"Data Controller loadData");
    
    // Populate the data arrays with the data from the mysql database.
    [self grabHearingStatusData];
    [self grabEmployeeData];
    [self grabJudgeData];
    [self grabSiteData];
    [self grabTicketData];
    [self hearingTicketInformation];
}

- (void)grabHearingStatusData
{
    NSArray *statuses = [NSArray arrayWithObjects:@"ALPO", @"POST", @"UNWR", @"RTS", nil];
    _hearingStatus = [NSMutableArray arrayWithArray:statuses];
}

- (void)grabEmployeeData
{
    NSArray *employeeData = [mySQL grabInfoFromFile:@"queries/employees.php"];
    NSInteger status = [statusChecker checkStatus:employeeData];
    
    if ([self checkStatus:status]) {
        for (int x = 0; x < [employeeData count]; x++) {
            NSDictionary *data = [employeeData objectAtIndex:x];
            Employee *employee = [[Employee alloc] initWithData:data];
            [_employees addObject:employee];
        }
    }
}

- (void)grabJudgeData
{
    NSArray *judgeData = [mySQL grabInfoFromFile:@"queries/judges.php"];
    NSInteger status = [statusChecker checkStatus:judgeData];
    
    if ([self checkStatus:status]) {
        for (int x = 0; x < [judgeData count]; x++) {
            NSDictionary *data = [judgeData objectAtIndex:x];
            Judge *judge = [[Judge alloc] initWithData:data];
            [_judges addObject:judge];
        }
    }
}

- (void)grabSiteData
{
    NSArray *siteData = [mySQL grabInfoFromFile:@"queries/sites.php"];
    NSInteger status = [statusChecker checkStatus:siteData];
    
    if ([self checkStatus:status]) {
        for (int x = 0; x < [siteData count]; x++) {
            NSDictionary *data = [siteData objectAtIndex:x];
            Site *site = [[Site alloc] initWithData:data];
            [_sites addObject:site];
        }
    }
}

- (void)grabTicketData
{
    // Limits the number of results we recieve.
    NSArray *keys = [NSArray arrayWithObjects:@"limit", nil];
    NSArray *values = [NSArray arrayWithObjects:@"50", nil];
    NSDictionary *limit = [NSDictionary dictionaryWithObjects:values
                                                      forKeys:keys];
    
    // Query the database and get the response.
    NSArray *ticketData = [mySQL grabInfoFromFile:@"queries/tickets.php" withItems:limit];
    NSInteger status = [statusChecker checkStatus:ticketData];
    
    // If there were no errors, array will be filled with data.
    if ([self checkStatus:status]) {
        for (int x = 0; x < [ticketData count]; x++) {
            NSDictionary *data = [ticketData objectAtIndex:x];
            Ticket *ticket = [[Ticket alloc] initWithData:data];
            [_tickets addObject:ticket];
        }
    }
}

- (void)hearingTicketInformation
{
    // Populates the relevant information for every ticket object.
    for (Ticket *ticket in _tickets) {
        // Finds the employee information for the employee that worked the current ticket.
        NSPredicate *workedByEmployee = [NSPredicate predicateWithFormat:@"database_id == %@", ticket.emp_worked];
        NSArray *arr = [_employees filteredArrayUsingPredicate:workedByEmployee];
        // If there was an employee that worked the ticket, then their information is added to the ticket and the
        //  ticket is added to the employee.
        if ([arr count] > 0) {
            Employee *emp = arr[0];
            [ticket setWorkedBy:emp];
            [emp addWorkedObject:ticket];
        }
        
        // Finds the judge that presided over the hearing and add the judge's information to the ticket.
        NSPredicate *judgePresided = [NSPredicate predicateWithFormat:@"judge_id == %@", ticket.judge_presided];
        arr = [_judges filteredArrayUsingPredicate:judgePresided];
        NSLog(@"Judge=%@", ticket.judge_presided);
        if ([arr count] > 0) {
            Judge *judge = arr[0];
            [ticket setJudgePresided:judge];
            [judge addWorkedObject:ticket];
        }
    }
}

- (BOOL)checkStatus:(NSInteger)status
{
    BOOL noError = NO;
    
    switch (status) {
        case QUERY_FAILED:
            NSLog(@"Ticket Query Failed for some reason!");
            break;
        case MYSQL_CONNECTION:
        case NOT_LOGGED_IN:
            NSLog(@"Lost connection to MySQL Database!");
            break;
        default:
            noError = YES;
            break;
    }
    
    return noError;
}

@end
