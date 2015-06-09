//
//  Judge.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Clerk, Ticket;

@interface Judge : NSObject

@property (readwrite, retain) NSNumber * judge_id;
@property (readwrite, retain) NSString * office;
@property (readwrite, retain) NSString * first_name;
@property (readwrite, retain) NSString * last_name;
@property (readwrite) BOOL active;
@property (readwrite, retain) Clerk *assistedBy;
@property (readwrite, retain) NSMutableSet *worked;

//-----------------------------------------------
// Inits
//-----------------------------------------------
- (id)initWithData:(NSDictionary *)data;

//-----------------------------------------------
// Methods For Judge
//-----------------------------------------------
+ (NSArray *)propsForDatabase;
+ (NSArray *)properties;
+ (NSArray *)searchKeys;

//-----------------------------------------------
// Worked Object Methods
//-----------------------------------------------
- (void)addWorkedObject:(Ticket *)value;
- (void)removeWorkedObject:(Ticket *)value;
- (void)addWorked:(NSSet *)values;
- (void)removeWorked:(NSSet *)values;

@end
