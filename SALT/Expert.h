//
//  Expert.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Witness, Ticket;

@interface Expert : NSObject

@property (readwrite, retain) NSNumber * expert_id;
@property (readwrite, retain) NSString * first_name;
@property (readwrite, retain) NSString * last_name;
@property (readwrite, retain) NSString * role;
@property (readwrite) BOOL active;

//-----------------------------------------------
// Inits
//-----------------------------------------------
- (id)initWithData:(NSDictionary *)data;

//-----------------------------------------------
// Methods for Witness
//-----------------------------------------------
- (NSArray *)propsForDatabase;
- (NSArray *)properties;

//-----------------------------------------------
// Static Methods for Witness
//-----------------------------------------------
+ (NSDictionary *)findExpertsForTicket:(Ticket *)ticket;

@end
