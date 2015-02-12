//
//  Clerk.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Judge;

@interface Clerk : NSManagedObject

@property (nonatomic, retain) NSNumber * clerk_id;
@property (nonatomic, retain) NSNumber * helps_judge;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) Judge *worksFor;

@end
