//
//  Business.h
//  SALT
//
//  Created by Adrian T. Chambers on 3/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Employee.h"

@interface Business : NSObject

@property (readwrite, retain) NSString *name;
@property (readwrite, retain) NSString *tin;
@property (readwrite, retain) NSString *soc;
@property (readwrite, retain) NSString *bpa_no;
@property (readwrite, retain) NSString *duns_no;
@property (readwrite, retain) NSNumber *contractor_id;
@property (readwrite, retain) Employee *contractor;

- (id)initWithData:(NSDictionary *)data;

@end
