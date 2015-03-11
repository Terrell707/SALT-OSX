//
//  Business.m
//  SALT
//
//  Created by Adrian T. Chambers on 3/10/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "Business.h"

@implementation Business

@synthesize name;
@synthesize tin;
@synthesize soc;
@synthesize bpa_no;
@synthesize duns_no;
@synthesize contractor_id;

- (id)initWithData: (NSDictionary *)data
{
    self = [super init];
    if (self) {
        // Create a business object out of json data.
        NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
        
        name = data[@"name"];
        tin = data[@"tin"];
        soc = data[@"soc"];
        bpa_no = data[@"bpa_no"];
        duns_no = data[@"duns_no"];
        contractor_id = [numFormat numberFromString:data[@"contractor_id"]];
    }
    
    return self;
}

@end
