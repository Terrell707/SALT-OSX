//
//  Clerk.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Judge;

@interface Clerk : NSObject

@property (readwrite, retain) NSNumber * clerk_id;
@property (readwrite, retain) NSNumber * helps_judge;
@property (readwrite, retain) NSString * first_name;
@property (readwrite, retain) NSString * last_name;
@property (readwrite, retain) NSString * email;
@property (nonatomic, retain) Judge *worksFor;

+ (NSArray *)searchableKeys;

@end
