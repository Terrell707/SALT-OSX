//
//  Site.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Schedule, Ticket;

@interface Site : NSObject

@property (readwrite, retain) NSString * office_code;
@property (readwrite, retain) NSString * name;
@property (readwrite, retain) NSString * address;
@property (readwrite, retain) NSString * phone_number;
@property (readwrite, retain) NSString * email;
@property (readwrite, retain) NSSet *scheduled;
@property (readwrite, retain) NSSet *ticket;

- (id)initWithData:(NSDictionary *)data;

- (void)addScheduledObject:(Schedule *)value;
- (void)removeScheduledObject:(Schedule *)value;
- (void)addScheduled:(NSSet *)values;
- (void)removeScheduled:(NSSet *)values;

- (void)addTicketObject:(Ticket *)value;
- (void)removeTicketObject:(Ticket *)value;
- (void)addTicket:(NSSet *)values;
- (void)removeTicket:(NSSet *)values;

@end
