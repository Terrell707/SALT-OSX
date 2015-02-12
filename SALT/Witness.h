//
//  Witness.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Expert, Ticket;

@interface Witness : NSManagedObject

@property (nonatomic, retain) NSNumber * expert_id;
@property (nonatomic, retain) NSNumber * ticket_no;
@property (nonatomic, retain) NSSet *testified;
@property (nonatomic, retain) NSSet *ticket;
@end

@interface Witness (CoreDataGeneratedAccessors)

- (void)addTestifiedObject:(Expert *)value;
- (void)removeTestifiedObject:(Expert *)value;
- (void)addTestified:(NSSet *)values;
- (void)removeTestified:(NSSet *)values;

- (void)addTicketObject:(Ticket *)value;
- (void)removeTicketObject:(Ticket *)value;
- (void)addTicket:(NSSet *)values;
- (void)removeTicket:(NSSet *)values;

@end
