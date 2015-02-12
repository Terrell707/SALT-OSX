//
//  Schedule.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Employee, Site;

@interface Schedule : NSManagedObject

@property (nonatomic, retain) NSNumber * emp_id;
@property (nonatomic, retain) NSString * office_code;
@property (nonatomic, retain) NSDate * work_date;
@property (nonatomic, retain) Employee *empScheduled;
@property (nonatomic, retain) Site *atSite;

@end
