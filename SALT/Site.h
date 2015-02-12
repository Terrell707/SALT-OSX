//
//  Site.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Schedule, Ticket;

@interface Site : NSManagedObject

@property (nonatomic, retain) NSString * office_code;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * phone_number;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSSet *scheduled;
@property (nonatomic, retain) NSSet *ticket;
@end

@interface Site (CoreDataGeneratedAccessors)

- (void)addScheduledObject:(Schedule *)value;
- (void)removeScheduledObject:(Schedule *)value;
- (void)addScheduled:(NSSet *)values;
- (void)removeScheduled:(NSSet *)values;

- (void)addTicketObject:(Ticket *)value;
- (void)removeTicketObject:(Ticket *)value;
- (void)addTicket:(NSSet *)values;
- (void)removeTicket:(NSSet *)values;

@end
