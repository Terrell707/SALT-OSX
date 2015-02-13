//
//  Schedule.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Employee, Site;

@interface Schedule : NSObject

@property (readwrite, retain) NSNumber * emp_id;
@property (readwrite, retain) NSString * office_code;
@property (readwrite, retain) NSDate * work_date;
@property (readwrite, retain) Employee *empScheduled;
@property (readwrite, retain) Site *atSite;

@end
