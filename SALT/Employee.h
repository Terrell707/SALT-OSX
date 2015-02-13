//
//  Employee.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Schedule, Ticket, User;

@interface Employee : NSManagedObject

@property (readwrite, copy) NSNumber * database_id;
@property (readwrite, copy) NSNumber * emp_id;
@property (readwrite, copy) NSString * first_name;
@property (readwrite, copy) NSString * middle_init;
@property (readwrite, copy) NSString * last_name;
@property (readwrite, copy) NSString * phone_number;
@property (readwrite, copy) NSString * email;
@property (readwrite, copy) NSString * street;
@property (readwrite, copy) NSString * city;
@property (readwrite, copy) NSString * state;
@property (readwrite, copy) NSString * zip;
@property (readwrite, copy) NSNumber * pay;
@property (readwrite, copy) NSSet *worked;
@property (readwrite, copy) User *username;
@property (readwrite, copy) NSSet *scheduled;

- (id)initWithData:(NSDictionary *)data;

- (void)addWorkedObject:(Ticket *)value;
- (void)removeWorkedObject:(Ticket *)value;
- (void)addWorked:(NSSet *)values;
- (void)removeWorked:(NSSet *)values;

- (void)addScheduledObject:(Schedule *)value;
- (void)removeScheduledObject:(Schedule *)value;
- (void)addScheduled:(NSSet *)values;
- (void)removeScheduled:(NSSet *)values;

@end
