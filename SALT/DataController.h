//
//  DataController.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/12/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MySQL.h"
#import "StatusCodes.h"

#import "Business.h"
#import "Employee.h"
#import "Site.h"
#import "Judge.h"
#import "Expert.h"
#import "Ticket.h"

@interface DataController : NSObject {
    MySQL *mySQL;
    StatusCodes *statusChecker;
}

+ (DataController *)sharedDataController;

// -------------------------------------------------------------------
// Methods dealing with User Login.
// -------------------------------------------------------------------
- (void)logginStatus:(BOOL)login forUser:(NSString *)username;

// -------------------------------------------------------------------
// Methods dealing with Tickets.
// -------------------------------------------------------------------
- (BOOL)insertTicket:(Ticket *)ticket;
- (BOOL)updateTicket:(Ticket *)oldTicket withChanges:(Ticket *)ticket;
- (BOOL)removeTicket:(Ticket *)ticket;
- (void)loadData;

// -------------------------------------------------------------------
// Properties dealing with Login Status.
// -------------------------------------------------------------------
@property (readonly) BOOL loggedIn;
@property (readonly) NSString *user;

// -------------------------------------------------------------------
// Objects used throughout the application.
// -------------------------------------------------------------------
@property (readwrite, copy) Business *business;
@property (readwrite, copy) NSMutableArray *hearingStatus;
@property (readwrite, copy) NSMutableArray *employees;
@property (readwrite, copy) NSMutableArray *sites;
@property (readwrite, copy) NSMutableArray *judges;
@property (readwrite, copy) NSMutableArray *experts;
@property (readwrite, copy) NSMutableArray *tickets;

@end
