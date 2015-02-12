//
//  Ticket.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Employee, Judge, Site, Witness;

@interface Ticket : NSManagedObject

@property (nonatomic, retain) NSNumber * ticket_no;
@property (nonatomic, retain) NSDate * order_date;
@property (nonatomic, retain) NSString * call_order_no;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * bpa_no;
@property (nonatomic, retain) NSNumber * can;
@property (nonatomic, retain) NSString * tin;
@property (nonatomic, retain) NSString * soc;
@property (nonatomic, retain) NSDate * hearing_date;
@property (nonatomic, retain) NSString * hearing_time;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSNumber * emp_worked;
@property (nonatomic, retain) NSNumber * judge_presided;
@property (nonatomic, retain) NSString * at_site;
@property (nonatomic, retain) Employee *workedBy;
@property (nonatomic, retain) Judge *judgePresided;
@property (nonatomic, retain) Site *heldAt;
@property (nonatomic, retain) NSSet *helpedBy;
@end

@interface Ticket (CoreDataGeneratedAccessors)

- (void)addHelpedByObject:(Witness *)value;
- (void)removeHelpedByObject:(Witness *)value;
- (void)addHelpedBy:(NSSet *)values;
- (void)removeHelpedBy:(NSSet *)values;

@end
