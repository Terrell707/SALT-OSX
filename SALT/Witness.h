//
//  Witness.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Expert, Ticket;

@interface Witness : NSObject

@property (readwrite, retain) NSNumber *expert_id;
@property (readwrite, retain) NSNumber *ticket_no;
@property (readwrite, retain) Expert *expert;
@property (readwrite, retain) Ticket *ticket;

//-----------------------------------------------
// Inits
//-----------------------------------------------
- (id)initWithData:(NSDictionary *)data;

//-----------------------------------------------
// Methods for Witness
//-----------------------------------------------
+ (NSArray *)propsForDatabase;
+ (NSArray *)properties;

@end
