//
//  Expert.m
//  SALT
//
//  Created by Adrian T. Chambers on 2/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "Expert.h"
#import "Ticket.h"

@implementation Expert

@synthesize expert_id;
@synthesize first_name;
@synthesize last_name;
@synthesize role;
@synthesize active;

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        
        // Creates an employee out of a json object.
        NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
        
        expert_id = [numFormat numberFromString:data[@"expert_id"]];
        first_name = data[@"first_name"];
        last_name = data[@"last_name"];
        role = data[@"role"];
        active = [data[@"active"] boolValue];
    }
    return self;
}

// Static Method that will find every expert for every role within a ticket and return it as a dictionary.
+ (NSDictionary *)findExpertsForTicket:(Ticket *)ticket
{
    // Can't place nils into objects, so will place "nulls" instead.
    NSNull *nothing = [NSNull null];
    // Makes a dictionary with keys that represent the possible roles for experts.
    NSArray *roles = [NSArray arrayWithObjects:@"REP", @"VE", @"ME", @"OTHER", @"INS", nil];
    NSArray *values = [NSArray arrayWithObjects:nothing, nothing, nothing, nothing, nothing, nil];
    NSMutableDictionary *experts = [NSMutableDictionary dictionaryWithObjects:values forKeys:roles];
    
    // Goes through each of the possible roles.
    for (NSString *r in roles) {
        // Looks for any expert(s) with the current role.
        NSPredicate *expertWithRole = [NSPredicate predicateWithFormat:@"role == %@", r];
        NSSet *expertResult = [ticket.helpedBy filteredSetUsingPredicate:expertWithRole];
        // If any are found, we will iterate over all of them.
        if (expertResult.count > 0) {
            for (Expert *expert in expertResult) {
                // If the role is already filled with an expert, then we will place the second expert in other.
                if ([experts valueForKey:r] != nothing) [experts setObject:expert forKey:@"OTHER"];
                else [experts setObject:expert forKey:r];
            }
        }
    }
    
    return experts;
}

@end
