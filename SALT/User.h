//
//  User.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Employee;

@interface User : NSObject

@property (readwrite, retain) NSString * username;
@property (readwrite, retain) NSNumber * emp;
@property (readwrite, retain) Employee *heldBy;

@end
