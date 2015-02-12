//
//  Judge.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Clerk, Ticket;

@interface Judge : NSManagedObject

@property (nonatomic, retain) NSNumber * judge_id;
@property (nonatomic, retain) NSString * office;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) Clerk *assistedBy;
@property (nonatomic, retain) Ticket *worked;

@end
