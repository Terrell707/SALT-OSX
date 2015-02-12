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

@property (readwrite, copy) NSNumber * ticket_no;
@property (readwrite, copy) NSDate * order_date;
@property (readwrite, copy) NSString * call_order_no;
@property (readwrite, copy) NSString * first_name;
@property (readwrite, copy) NSString * last_name;
@property (readwrite, copy) NSString * bpa_no;
@property (readwrite, copy) NSNumber * can;
@property (readwrite, copy) NSString * tin;
@property (readwrite, copy) NSString * soc;
@property (readwrite, copy) NSDate * hearing_date;
@property (readwrite, copy) NSString * hearing_time;
@property (readwrite, copy) NSString * status;
@property (readwrite, copy) NSNumber * emp_worked;
@property (readwrite, copy) NSNumber * judge_presided;
@property (readwrite, copy) NSString * at_site;
@property (readwrite, copy) Employee *workedBy;
@property (readwrite, copy) Judge *judgePresided;
@property (readwrite, copy) Site *heldAt;
@property (readwrite, copy) NSSet *helpedBy;

- (id)initWithData:(NSDictionary *)data;

- (void)addHelpedByObject:(Witness *)value;
- (void)removeHelpedByObject:(Witness *)value;
- (void)addHelpedBy:(NSSet *)values;
- (void)removeHelpedBy:(NSSet *)values;

@end
