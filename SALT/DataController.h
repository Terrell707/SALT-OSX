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
#import "Witness.h"

@interface DataController : NSObject {
    MySQL *mySQL;
    StatusCodes *statusChecker;
}

- (void)loadData;
+ (DataController *)sharedDataController;

// -------------------------------------------------------------------
// Methods dealing with User Login.
// -------------------------------------------------------------------
- (void)logginStatus:(BOOL)login forUser:(NSString *)username;

// -------------------------------------------------------------------
// Methods dealing with Experts.
// -------------------------------------------------------------------
- (BOOL)insertExpert:(Expert *)expert;
- (BOOL)updateExpert:(Expert *)before withChanges:(Expert *)after;

// -------------------------------------------------------------------
// Methods dealing with Tickets.
// -------------------------------------------------------------------
- (void)hearingDateRangeFrom:(NSDate *)from To:(NSDate *)to;
- (BOOL)insertTicket:(Ticket *)ticket;
- (BOOL)updateTicket:(Ticket *)oldTicket withChanges:(Ticket *)ticket;
- (BOOL)removeTicket:(Ticket *)ticket;

// -------------------------------------------------------------------
// Methods dealing with Witness.
// -------------------------------------------------------------------
- (BOOL)insertWitness:(Witness *)witness;
- (BOOL)updateWitness:(Witness *)before withChanges:(Witness *)after;

// -------------------------------------------------------------------
// Properties dealing with Login Status.
// -------------------------------------------------------------------
@property (readonly) BOOL loggedIn;
@property (readonly) NSString *user;

// -------------------------------------------------------------------
// Objects used throughout the application.
// -------------------------------------------------------------------
@property (readonly) NSDate *ticketHearingDateFrom;
@property (readonly) NSDate *ticketHearingDateTo;

@property (readonly, copy) Business *business;
@property (readonly, copy) NSMutableArray *hearingStatus;
@property (readonly, copy) NSMutableArray *employees;
@property (readonly, copy) NSMutableArray *sites;
@property (readonly, copy) NSMutableArray *judges;
@property (readonly, copy) NSMutableArray *experts;
@property (readonly, copy) NSMutableArray *tickets;
@property (readonly, copy) NSMutableArray *witnesses;

@end
