//
//  Ticket.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Employee, Judge, Site, Witness;

@interface Ticket : NSObject

@property (readwrite, retain) NSNumber * ticket_no;
@property (readwrite, retain) NSDate * order_date;
@property (readwrite, retain) NSString * call_order_no;
@property (readwrite, retain) NSString * first_name;
@property (readwrite, retain) NSString * last_name;
@property (readwrite, retain) NSString * bpa_no;
@property (readwrite, retain) NSString * can;
@property (readwrite, retain) NSString * tin;
@property (readwrite, retain) NSString * soc;
@property (readwrite, retain) NSDate * hearing_date;
@property (readwrite, retain) NSDate * hearing_time;
@property (readwrite, retain) NSString * status;
@property (readwrite, retain) NSNumber * emp_worked;
@property (readwrite, retain) NSNumber * judge_presided;
@property (readwrite, retain) NSString * at_site;
@property (readwrite, retain) Employee *workedBy;
@property (readwrite, retain) Judge *judgePresided;
@property (readwrite, retain) Site *heldAt;
@property (readwrite, retain) NSMutableSet *helpedBy;

//-----------------------------------------------
// Inits
//-----------------------------------------------
- (id)initWithData:(NSDictionary *)data;

//-----------------------------------------------
// Methods for Ticket
//-----------------------------------------------
- (NSArray *)propsForDatabase;
- (NSArray *)properties;

//-----------------------------------------------
// HelpedBy Methods
//-----------------------------------------------
- (void)addHelpedByObject:(Witness *)value;
- (void)removeHelpedByObject:(Witness *)value;
- (void)addHelpedBy:(NSSet *)values;
- (void)removeHelpedBy:(NSSet *)values;

@end
