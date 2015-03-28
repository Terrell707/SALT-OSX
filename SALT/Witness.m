//
//  Witness.m
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "Witness.h"
#import "Expert.h"
#import "Ticket.h"


@implementation Witness

@synthesize expert_id;
@synthesize ticket_no;
@synthesize expert;
@synthesize ticket;

//-----------------------------------------------
// Inits
//-----------------------------------------------
- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        
        NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
        
        expert_id = [numFormat numberFromString:data[@"expert_id"]];
        ticket_no = [numFormat numberFromString:data[@"ticket_no"]];
    }
    
    return self;
}

//-----------------------------------------------
// Methods for Witness
//-----------------------------------------------
- (NSArray *)propsForDatabase
{
    NSArray *props = [NSArray arrayWithObjects:@"expert_id", @"ticket_no", nil];
    
    return props;
}

- (NSArray *)properties
{
    NSArray *propsForDatabase = [self propsForDatabase];
    NSArray *props = [NSArray arrayWithObjects:@"expert", @"ticket", nil];
    
    return [propsForDatabase arrayByAddingObjectsFromArray:props];
}

@end
