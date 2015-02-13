//
//  Witness.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Expert, Ticket;

@interface Witness : NSObject

@property (readwrite, retain) NSNumber * expert_id;
@property (readwrite, retain) NSNumber * ticket_no;
@property (readwrite, retain) NSSet *testified;
@property (readwrite, retain) NSSet *ticket;

- (void)addTestifiedObject:(Expert *)value;
- (void)removeTestifiedObject:(Expert *)value;
- (void)addTestified:(NSSet *)values;
- (void)removeTestified:(NSSet *)values;

- (void)addTicketObject:(Ticket *)value;
- (void)removeTicketObject:(Ticket *)value;
- (void)addTicket:(NSSet *)values;
- (void)removeTicket:(NSSet *)values;

@end
