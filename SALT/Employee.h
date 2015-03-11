//
//  Employee.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Schedule, Ticket, User;

@interface Employee : NSObject

@property (readwrite, retain) NSNumber * database_id;
@property (readwrite, retain) NSNumber * emp_id;
@property (readwrite, retain) NSString * first_name;
@property (readwrite, retain) NSString * middle_init;
@property (readwrite, retain) NSString * last_name;
@property (readwrite, retain) NSString * phone_number;
@property (readwrite, retain) NSString * email;
@property (readwrite, retain) NSString * street;
@property (readwrite, retain) NSString * city;
@property (readwrite, retain) NSString * state;
@property (readwrite, retain) NSString * zip;
@property (readwrite, retain) NSNumber * pay;
@property (readwrite) BOOL active;
@property (readwrite, retain) NSMutableSet *worked;
@property (readwrite, retain) User *username;
@property (readwrite, retain) NSMutableSet *scheduled;

//-----------------------------------------------
// Inits
//-----------------------------------------------
- (id)initWithData:(NSDictionary *)data;

//-----------------------------------------------
// Methods for Employee
//-----------------------------------------------
- (NSArray *)propsForDatabase;
- (NSArray *)properties;

//-----------------------------------------------
// Worked Object Methods
//-----------------------------------------------
- (void)addWorkedObject:(Ticket *)value;
- (void)removeWorkedObject:(Ticket *)value;
- (void)addWorked:(NSSet *)values;
- (void)removeWorked:(NSSet *)values;

//-----------------------------------------------
// Schedule Object Methods
//-----------------------------------------------
- (void)addScheduledObject:(Schedule *)value;
- (void)removeScheduledObject:(Schedule *)value;
- (void)addScheduled:(NSSet *)values;
- (void)removeScheduled:(NSSet *)values;

@end
