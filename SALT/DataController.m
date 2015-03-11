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
- (void)grabExpertData;
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
        _experts = [[NSMutableArray alloc] init];
        _tickets = [[NSMutableArray alloc] init];
        
        // Start the user as logged out.
        _loggedIn = NO;
    }
    return self;
}

- (void)loadData
{
    NSLog(@"Data Controller loadData");
    
    // Populate the data arrays with the data from the mysql database.
    [self grabBusinessData];
    [self grabHearingStatusData];
    [self grabEmployeeData];
    [self grabJudgeData];
    [self grabSiteData];
    [self grabTicketData];
    [self grabExpertData];
    [self hearingTicketInformation];
}

- (void)grabBusinessData
{
    if (_business != nil)
        return;
    
    NSArray *businessData = [mySQL grabInfoFromFile:@"queries/business.php"];
    NSInteger status = [statusChecker checkStatus:businessData];
    
    if ([self checkStatus:status]) {
        for (int x = 0; x < [businessData count]; x++) {
            NSDictionary *data = [businessData objectAtIndex:x];
            _business = [[Business alloc] initWithData:data];
        }
    }
}

- (void)grabHearingStatusData
{
    NSArray *statuses = [NSArray arrayWithObjects:@"ALPO", @"POST", @"UNWR", @"RTS", nil];
    _hearingStatus = [NSMutableArray arrayWithArray:statuses];
}

- (void)grabEmployeeData
{
    [_employees removeAllObjects];
    
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
    [_judges removeAllObjects];
    
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
    [_sites removeAllObjects];
    
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
    [_tickets removeAllObjects];
    
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
            [self willChangeValueForKey:@"tickets"];
            [_tickets addObject:ticket];
            [self didChangeValueForKey:@"tickets"];
        }
    }
}

- (void)grabExpertData
{
    [_experts removeAllObjects];
    
    // Query the database and get the response.
    NSArray *expertData = [mySQL grabInfoFromFile:@"queries/experts.php"];
    NSInteger status = [statusChecker checkStatus:expertData];
    
    // If there were no errors, array will be filled with data.
    if ([self checkStatus:status]) {
        for (int x = 0; x < [expertData count]; x++) {
            NSDictionary *data = [expertData objectAtIndex:x];
            Expert *expert = [[Expert alloc] initWithData:data];
            [_experts addObject:expert];
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
        if (arr.count > 0) {
            Employee *emp = arr[0];
            [ticket setWorkedBy:emp];
            [emp addWorkedObject:ticket];
        }
        
        // Finds the judge that presided over the hearing and add the judge's information to the ticket.
        NSPredicate *judgePresided = [NSPredicate predicateWithFormat:@"judge_id == %@", ticket.judge_presided];
        arr = [_judges filteredArrayUsingPredicate:judgePresided];
        // If there was a judge that presided over the hearing of the ticket, then their information is added to the
        //  ticket and the ticket is added to the judge.
        if (arr.count > 0) {
            Judge *judge = arr[0];
            [ticket setJudgePresided:judge];
            [judge addWorkedObject:ticket];
        }
        
        NSPredicate *heldAtSite = [NSPredicate predicateWithFormat:@"office_code == %@", ticket.at_site];
        arr = [_sites filteredArrayUsingPredicate:heldAtSite];
        // If the site the hearing was held at was recorded for the ticket, then the office info is added to the
        //  ticket and the ticket is added to the office.
        if (arr.count > 0) {
            Site *site = arr[0];
            [ticket setHeldAt:site];
            [site addTicketObject:ticket];
            
            [ticket setCan:site.can];
        }
    }
}

- (void)logginStatus:(BOOL)login forUser:(NSString *)username
{
    // Updates the logged in status for the specified user.
    [self willChangeValueForKey:@"loggedIn"];
    [self willChangeValueForKey:@"user"];
    _loggedIn = login;
    _user = username;
    [self didChangeValueForKey:@"loggedIn"];
    [self didChangeValueForKey:@"user"];
}

- (BOOL)insertTicket:(Ticket *)ticket
{
    // Creates formatters that will be needed.
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
    
    // Creates a dictionary out of an array of keys and values. This dictionary is used to insert the Ticket
    //  to the database.
    NSArray *keys = [ticket propsForDatabase];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (NSString *key in keys) {
        if ([key isEqualToString:@"order_date"] || [key isEqualToString:@"hearing_date"]) {
            [values addObject:[dateFormat stringFromDate:[ticket valueForKey:key]]];
        }
        else if ([key isEqualToString:@"hearing_time"]) {
            [values addObject:[timeFormat stringFromDate:[ticket valueForKey:key]]];
        }
        else if ([key isEqualToString:@"ticket_no"] || [key isEqualToString:@"emp_worked"]
                 || [key isEqualToString:@"judge_presided"]) {
            [values addObject:[[ticket valueForKey:key] stringValue]];
        }
        else {
            [values addObject:[ticket valueForKey:key]];
        }
    }
    NSDictionary *ticketInfo = [NSDictionary dictionaryWithObjects:values
                                                           forKeys:keys];
    
    // Insert into the database and get the response.
    NSArray *ticketData = [mySQL grabInfoFromFile:@"inserts/ticket.php" withItems:ticketInfo];
    NSInteger status = [statusChecker checkStatus:ticketData];
    
    NSLog(@"Status=%ld", status);
    // If there were no errors, add the ticket to the list of tickets and return a success.
    if ([self checkStatus:status]) {
        [self willChangeValueForKey:@"tickets"];
        [_tickets addObject:ticket];
        [self didChangeValueForKey:@"tickets"];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)removeTicket:(Ticket *)ticket
{
    NSDictionary *ticketInfo = [NSDictionary dictionaryWithObjectsAndKeys:[[ticket ticket_no] stringValue], @"ticket_no", nil];
    
    NSLog(@"Ticket_info = %@", ticketInfo);
    
    NSArray *ticketData = [mySQL grabInfoFromFile:@"remove/ticket.php" withItems:ticketInfo];
    NSInteger status = [statusChecker checkStatus:ticketData];
    
    NSLog(@"Status=%ld", status);
    
    // If there were no errors, remove the ticket from the list of tickets and return success.
    if ([self checkStatus:status]) {
        [self willChangeValueForKey:@"tickets"];
        [_tickets removeObject:ticket];
        [self didChangeValueForKey:@"tickets"];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)checkStatus:(NSInteger)status
{
    BOOL noError = NO;
    
    switch (status) {
        case SUCCESS:
            NSLog(@"Success!");
            noError = YES;
            break;
        case ERROR:
            NSLog(@"Something went wrong with the query!");
            break;
        case QUERY_FAILED:
            NSLog(@"Query Failed for some reason!");
            break;
        case MYSQL_CONNECTION:
        case NOT_LOGGED_IN:
            NSLog(@"Lost connection to MySQL Database!");
            break;
        default:
            NSLog(@"Nothing was returned from the query.");
            noError = NO;
            break;
    }
    
    return noError;
}

@end
