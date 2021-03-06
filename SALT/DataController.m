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
        
        // Initialize date objects to today's date and some months prior.
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        comps.month = -3;
        
        _ticketHearingDateTo = [NSDate date];
        _ticketHearingDateFrom = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
        
        // Initalize data arrays.
        _hearingStatus = [[NSMutableArray alloc] init];
        _employees = [[NSMutableArray alloc] init];
        _judges = [[NSMutableArray alloc] init];
        _sites = [[NSMutableArray alloc] init];
        _experts = [[NSMutableArray alloc] init];
        _tickets = [[NSMutableArray alloc] init];
        _witnesses = [[NSMutableArray alloc] init];
        
        // Start the user as logged out.
        _loggedIn = NO;
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
    [self grabExpertData];
    [self grabWitnessData];
    
    // Merges data together.
    [self hearingTicketInformation];
    [self witnessInformation];
    
    // Grabs the information for the business.
    [self grabBusinessData];
}

- (void)grabBusinessData
{
    if (_business != nil)
        return;
    
    NSArray *businessData = [mySQL grabInfoFromFile:@"queries/business.php"];
    businessData = [statusChecker grabStatusFromJson:businessData];
    NSInteger status = [statusChecker errorCode];
    
    if ([self checkStatus:status]) {
        for (int x = 0; x < [businessData count]; x++) {
            NSDictionary *data = [businessData objectAtIndex:x];
            _business = [[Business alloc] initWithData:data];
        }
    }
    
    [self businessInformation];
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
    employeeData = [statusChecker grabStatusFromJson:employeeData];
    NSInteger status = [statusChecker errorCode];
    
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
    judgeData = [statusChecker grabStatusFromJson:judgeData];
    NSInteger status = [statusChecker errorCode];
    
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
    siteData = [statusChecker grabStatusFromJson:siteData];
    NSInteger status = [statusChecker errorCode];
    
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
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *from = [dateFormatter stringFromDate:_ticketHearingDateFrom];
    NSString *to = [dateFormatter stringFromDate:_ticketHearingDateTo];
    
    // Limits the number of results we recieve.
    NSArray *keys = [NSArray arrayWithObjects:@"from", @"to", nil];
    NSArray *values = [NSArray arrayWithObjects:from, to, nil];
    NSDictionary *dateRange = [NSDictionary dictionaryWithObjects:values
                                                      forKeys:keys];
    
    // Query the database and get the response.
    NSArray *ticketData = [mySQL grabInfoFromFile:@"queries/tickets.php" withItems:dateRange];
    ticketData = [statusChecker grabStatusFromJson:ticketData];
    NSInteger status = [statusChecker errorCode];
    
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
    expertData = [statusChecker grabStatusFromJson:expertData];
    NSInteger status = [statusChecker errorCode];
    
    // If there were no errors, array will be filled with data.
    if ([self checkStatus:status]) {
        for (int x = 0; x < [expertData count]; x++) {
            NSDictionary *data = [expertData objectAtIndex:x];
            Expert *expert = [[Expert alloc] initWithData:data];
            [_experts addObject:expert];
        }
    }
}

- (void)grabWitnessData
{
    [_witnesses removeAllObjects];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *from = [dateFormatter stringFromDate:_ticketHearingDateFrom];
    NSString *to = [dateFormatter stringFromDate:_ticketHearingDateTo];
    
    // Limits the number of results we recieve.
    NSArray *keys = [NSArray arrayWithObjects:@"from", @"to", nil];
    NSArray *values = [NSArray arrayWithObjects:from, to, nil];
    NSDictionary *dateRange = [NSDictionary dictionaryWithObjects:values
                                                          forKeys:keys];
    
    // Query the database and get the response.
    NSArray *witnessData = [mySQL grabInfoFromFile:@"queries/witnesses.php" withItems:dateRange];
    witnessData = [statusChecker grabStatusFromJson:witnessData];
    NSInteger status = [statusChecker errorCode];
    
    // If there were no errors, array will be filled with data.
    if ([self checkStatus:status]) {
        for (int x = 0; x < [witnessData count]; x++) {
            NSDictionary *data = [witnessData objectAtIndex:x];
            Witness *witness = [[Witness alloc] initWithData:data];
            [_witnesses addObject:witness];
            NSLog(@"Witness: Expert=%@, Ticket=%@", [witness expert_id], [witness ticket_no]);
        }
    }
}

- (void)businessInformation
{
    // Places the appropriate employee as the contractor of the business object.
    NSPredicate *contractor = [NSPredicate predicateWithFormat:@"database_id == %@", _business.contractor_id];
    NSArray *arr = [_employees filteredArrayUsingPredicate:contractor];
    if (arr.count == 1) {
        [_business setContractor:arr[0]];
    }
}

// -------------------------------------------------------------------
// Methods dealing with User Login.
// -------------------------------------------------------------------
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

- (void)logout
{
    // Logs out the current user.
    [self logginStatus:NO forUser:_user];
    _user = @"";
}

// -------------------------------------------------------------------
// Methods dealing with Experts.
// -------------------------------------------------------------------
#pragma mark Expert methods.
- (BOOL)insertExpert:(Expert *)expert
{
    // Creates a dictionary using the properties as keys and each of its corresponding values.
    NSArray *keys = [Expert propsForDatabase];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (NSString *key in keys) {
        if ([key isEqualToString:@"expert_id"] || [key isEqualToString:@"active"]) {
            [values addObject:[[expert valueForKey:key] stringValue]];
        }
        else {
            [values addObject:[expert valueForKey:key]];
        }
    }
    NSDictionary *expertInfo = [NSDictionary dictionaryWithObjects:values
                                                           forKeys:keys];
    
    NSLog(@"Inserted Expert = %@", expertInfo);
    
    // Insert the Expert into the database and get a response.
    NSArray *expertData = [mySQL grabInfoFromFile:@"inserts/expert.php" withItems:expertInfo];
    expertData = [statusChecker grabStatusFromJson:expertData];
    NSInteger status = [statusChecker errorCode];
    
    NSLog(@"Status = %ld", status);
    // If there were no errors, add the Expert to the list of experts.
    if ([self checkStatus:status]) {
        [self willChangeValueForKey:@"experts"];
        NSDictionary *data = [expertData objectAtIndex:1];
        [expert expertIDFromJSON:data];
        [_experts addObject:expert];
        [self didChangeValueForKey:@"experts"];
        return YES;
    }
    else {
        return NO;
    }
    
}

- (BOOL)removeExpert:(Expert *)expert forTicket:(Ticket *)ticket
{
    // Looks for the witness object with the passed in expert's id and passed in ticket's number.
    NSPredicate *witnessPredicate = [NSPredicate predicateWithFormat:@"expert_id == %@ && ticket_no == %@", expert.expert_id, ticket.ticket_no];
    NSArray *witnessResult = [_witnesses filteredArrayUsingPredicate:witnessPredicate];
    
    // If a witness object was found, delete it from the database and the list of witnesses.
    if (witnessResult.count != 0) {
        return [self removeWitness:witnessResult[0]];
    }
    else {
        return NO;
    }
}

// -------------------------------------------------------------------
// Methods dealing with Tickets.
// -------------------------------------------------------------------
#pragma mark Ticket methods.
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

- (void)hearingDateRangeFrom:(NSDate *)from To:(NSDate *)to
{
    // Changes the date range of the tickets to grab from the server.
    _ticketHearingDateFrom = from;
    _ticketHearingDateTo = to;
    
    [self willChangeValueForKey:@"tickets"];
    [self grabTicketData];
    [self grabWitnessData];
    [self hearingTicketInformation];
    [self witnessInformation];
    [self didChangeValueForKey:@"tickets"];
}

- (BOOL)insertTicket:(Ticket *)ticket
{
    // Creates formatters that will be needed.
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"hh:mm"];
    
    // Creates a dictionary out of an array of keys and values. This dictionary is used to insert the Ticket
    //  to the database.
    NSArray *keys = [Ticket propsForDatabase];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (NSString *key in keys) {
        if ([key isEqualToString:@"order_date"] || [key isEqualToString:@"hearing_date"]) {
            [values addObject:[dateFormat stringFromDate:[ticket valueForKey:key]]];
        }
        else if ([key isEqualToString:@"hearing_time"]) {
            [values addObject:[timeFormat stringFromDate:[ticket valueForKey:key]]];
        }
        else if ([key isEqualToString:@"ticket_no"] || [key isEqualToString:@"emp_worked"]
                 || [key isEqualToString:@"judge_presided"] || [key isEqualToString:@"full_pay"]) {
            [values addObject:[[ticket valueForKey:key] stringValue]];
        }
        else {
            [values addObject:[ticket valueForKey:key]];
        }
    }
    NSDictionary *ticketInfo = [NSDictionary dictionaryWithObjects:values
                                                           forKeys:keys];
    
    NSLog(@"Inserted Ticket = %@", ticketInfo);
    
    // Insert into the database and get the response.
    NSArray *ticketData = [mySQL grabInfoFromFile:@"inserts/ticket.php" withItems:ticketInfo];
    ticketData = [statusChecker grabStatusFromJson:ticketData];
    NSInteger status = [statusChecker errorCode];
    
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

- (BOOL)updateTicket:(Ticket *)oldTicket withChanges:(Ticket *)ticket
{
    // Creates formatters that will be needed.
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"hh:mm"];
    
    // Creates a dictionary out of an array of keys and values. This dictionary is used to insert the Ticket
    //  to the database.
    NSArray *keys = [Ticket propsForDatabase];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (NSString *key in keys) {
        if ([key isEqualToString:@"order_date"] || [key isEqualToString:@"hearing_date"]) {
            [values addObject:[dateFormat stringFromDate:[ticket valueForKey:key]]];
        }
        else if ([key isEqualToString:@"hearing_time"]) {
            [values addObject:[timeFormat stringFromDate:[ticket valueForKey:key]]];
        }
        else if ([key isEqualToString:@"ticket_no"] || [key isEqualToString:@"emp_worked"]
                 || [key isEqualToString:@"judge_presided"] || [key isEqualToString:@"full_pay"]) {
            [values addObject:[[ticket valueForKey:key] stringValue]];
        }
        else {
            [values addObject:[ticket valueForKey:key]];
        }
    }
    
    // Update the ticket that has (or had) this ticket number.
    keys = [keys arrayByAddingObject:@"ref_ticket_no"];
    [values addObject:[[oldTicket ticket_no] stringValue]];
    
    NSDictionary *ticketInfo = [NSDictionary dictionaryWithObjects:values
                                                           forKeys:keys];
    
    NSLog(@"Updated Ticket = %@", ticketInfo);
    
    // Insert into the database and get the response.
    NSArray *ticketData = [mySQL grabInfoFromFile:@"updates/ticket.php" withItems:ticketInfo];
    ticketData = [statusChecker grabStatusFromJson:ticketData];
    NSInteger status = [statusChecker errorCode];
    
    NSLog(@"Status=%ld", status);
    // If there were no errors, replace the old ticket with the updated one.
    if ([self checkStatus:status]) {
        [self willChangeValueForKey:@"tickets"];
        NSUInteger index = [_tickets indexOfObject:oldTicket];
        [_tickets insertObject:ticket atIndex:index];
        [_tickets removeObject:oldTicket];
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
    ticketData = [statusChecker grabStatusFromJson:ticketData];
    NSInteger status = [statusChecker errorCode];
    
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

// -------------------------------------------------------------------
// Methods dealing with Witness.
// -------------------------------------------------------------------
#pragma mark Witness methods
- (void)witnessInformation
{
    for (Witness *witness in _witnesses) {
        [self findInformationForWitness:witness];
    }
}

- (void)findInformationForWitness:(Witness *)witness
{
    // Finds the ticket that matches the ticket_no of the Witness Object.
    NSPredicate *witnessTicket = [NSPredicate predicateWithFormat:@"ticket_no == %@", witness.ticket_no];
    NSArray *ticketResults = [_tickets filteredArrayUsingPredicate:witnessTicket];
    // Finds the ticket that matches the expert_id of the Witness Object.
    NSPredicate *expertWhoHelped = [NSPredicate predicateWithFormat:@"expert_id == %@", witness.expert_id];
    NSArray *expertResults = [_experts filteredArrayUsingPredicate:expertWhoHelped];
    
    // Places the expert within the "HelpedBy" set in the specified ticket.
    if (ticketResults.count > 0 && expertResults.count > 0) {
        Ticket *ticket = ticketResults[0];
        Expert *expert = expertResults[0];
        [ticket addHelpedByObject:expert];
    }
}

- (BOOL)insertWitness:(Witness *)witness
{
    // Creates a dictionary out of an array of keys and values. This dictionary is used to insert the Witness
    //  to the database.
    NSArray *keys = [Witness propsForDatabase];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (NSString *key in keys) {
        [values addObject:[[witness valueForKey:key] stringValue]];
    }
    NSDictionary *witnessInfo = [NSMutableDictionary dictionaryWithObjects:values
                                                                   forKeys:keys];
    
    NSLog(@"Inserted Witness = %@", witnessInfo);
    
    NSArray *witnessData = [mySQL grabInfoFromFile:@"inserts/witness.php" withItems:witnessInfo];
    witnessData = [statusChecker grabStatusFromJson:witnessData];
    NSInteger status = [statusChecker errorCode];
    
    // If there are no errors, add the Witness to the list of witnesses 
    NSLog(@"Status = %ld", status);
    if ([self checkStatus:status]) {
        // Adds this witness object to the list of witnesses after finding its associated objects.
        [self willChangeValueForKey:@"witnesses"];
        [self findInformationForWitness:witness];
        [_witnesses addObject:witness];
        [self didChangeValueForKey:@"witnesses"];
        // Add the witness data to the list of tickets.
        [self willChangeValueForKey:@"tickets"];
        [self hearingTicketInformation];
        [self didChangeValueForKey:@"tickets"];
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)removeWitness:(Witness *)witness
{
    NSArray *keys = [NSArray arrayWithObjects:@"expert_id", @"ticket_no", nil];
    NSArray *values = [NSArray arrayWithObjects:[witness.expert_id stringValue], [witness.ticket_no stringValue], nil];
    NSDictionary *witnessInfo = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    NSArray *witnessData = [mySQL grabInfoFromFile:@"remove/witness.php" withItems:witnessInfo];
    witnessData = [statusChecker grabStatusFromJson:witnessData];
    NSInteger status = [statusChecker errorCode];
    
    // If there were no errors, then return the status of the removal.
    if ([self checkStatus:status]) {
        [self willChangeValueForKey:@"witnesses"];
        [_witnesses removeObject:witness];
        [self didChangeValueForKey:@"witnesses"];
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
            NSLog(@"Success! Status=%ld", status);
            noError = YES;
            break;
        case ERROR:
            NSLog(@"Something went wrong with the query! Status=%ld", status);
            break;
        case QUERY_FAILED:
            NSLog(@"Query Failed for some reason! Status=%ld", status);
            break;
        case MYSQL_CONNECTION:
            NSLog(@"Lost connection to MySQL Database! Status=%ld", status);
            break;
        case NOT_LOGGED_IN:
            NSLog(@"User Not Logged In! Status=%ld", status);
            [self logginStatus:NO forUser:_user];
            break;
        case TIMED_OUT:
            NSLog(@"User timed out! Status=%ld", status);
            [self logginStatus:NO forUser:_user];
            break;
        default:
            NSLog(@"Nothing was returned from the query. Status=%ld", status);
            noError = NO;
            break;
    }
    
    return noError;
}

@end
