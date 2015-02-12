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

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * emp_id;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * middle_init;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * phone_number;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSNumber * pay;
@property (nonatomic, retain) NSSet *worked;
@property (nonatomic, retain) User *username;
@property (nonatomic, retain) NSSet *scheduled;
@end

@interface Employee (CoreDataGeneratedAccessors)

- (void)addWorkedObject:(Ticket *)value;
- (void)removeWorkedObject:(Ticket *)value;
- (void)addWorked:(NSSet *)values;
- (void)removeWorked:(NSSet *)values;

- (void)addScheduledObject:(Schedule *)value;
- (void)removeScheduledObject:(Schedule *)value;
- (void)addScheduled:(NSSet *)values;
- (void)removeScheduled:(NSSet *)values;

@end
