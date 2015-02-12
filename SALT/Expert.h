//
//  Expert.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Witness;

@interface Expert : NSManagedObject

@property (nonatomic, retain) NSNumber * expert_id;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * role;
@property (nonatomic, retain) Witness *worked;

@end
