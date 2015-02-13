//
//  DataController.m
//  SALT
//
//  Created by Adrian T. Chambers on 2/12/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "DataController.h"

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
        _tickets = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadData
{
    
    NSLog(@"Data Controller loadData");
    
    // Limits the number of results we recieve.
    NSArray *keys = [NSArray arrayWithObjects:@"limit", nil];
    NSArray *values = [NSArray arrayWithObjects:@"50", nil];
    NSDictionary *limit = [NSDictionary dictionaryWithObjects:values
                                                      forKeys:keys];
    
    // Query the database and get the response.
    NSArray *ticketData = [mySQL grabInfoFromFile:@"queries/tickets.php" withItems:limit];
    NSInteger status = [statusChecker checkStatus:ticketData];
    
    switch (status) {
        case QUERY_FAILED:
            NSLog(@"Query Failed for some reason!");
            break;
        case MYSQL_CONNECTION:
        case NOT_LOGGED_IN:
            NSLog(@"Lost connection!");
            break;
        default:
            for (int x = 0; x < [ticketData count]; x++) {
                NSDictionary *data = [ticketData objectAtIndex:x];
                Ticket *ticket = [[Ticket alloc] initWithData:data];
                [_tickets addObject:ticket];
            }
    }
}
@end
