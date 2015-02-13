//
//  DataController.m
//  SALT
//
//  Created by Adrian T. Chambers on 2/12/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "DataController.h"

@interface DataController ()
- (void)grabEmployeeData;
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
        mySQL = [[MySQL alloc] init];
        statusChecker = [[StatusCodes alloc] init];
        _employees = [[NSMutableArray alloc] init];
        _tickets = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadData
{
    NSLog(@"Data Controller loadData");
    
    [self grabEmployeeData];
    [self grabTicketData];
    [self hearingTicketInformation];
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
    for (Ticket *ticket in _tickets) {
        NSPredicate *workedByEmployee = [NSPredicate predicateWithFormat:@"database_id == %@", ticket.emp_worked];
        NSArray *arr = [_employees filteredArrayUsingPredicate:workedByEmployee];
        if ([arr count] > 0) {
            NSLog(@"%@", [[arr objectAtIndex:0] valueForKey:@"first_name"]);
            [ticket setWorkedBy:(Employee *)arr[0]];
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
