//
//  DataSearch.m
//  SALT
//
//  Created by Adrian T. Chambers on 5/17/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "DataSearch.h"

@implementation DataSearch

+ (NSString *)filterForKeys:(NSArray *)keys
{
    NSMutableString *filter = [[NSMutableString alloc] init];
    
    // Creates a a number of key compares depending on the number of keys passed in.
    for (int x = 0; x < [keys count]; x++) {
        if (x > 0)
            [filter appendString:@" || "];
        [filter appendString:@"%K CONTAINS[cd] %@"];
    }
    
    return filter;
}

+ (NSArray *)insertToken:(NSString *)token forKeys:(NSArray *)keys
{
    NSMutableArray *args = [[NSMutableArray alloc] init];
    
    for (int x = 0; x < [keys count]; x++) {
        [args addObject:[keys objectAtIndex:x]];
        [args addObject:token];
    }
    
    return args;
}

+ (NSMutableArray *)searchData:(NSMutableArray *)data withKeys:(NSArray *)keys withSearchText:(NSString *)searchText
{
    NSMutableArray *filteredData;
    
    // Grab the search string from the search field.
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // Updates the filtered array to the original array.
    filteredData = data;
    
    // Returns if nothing was typed into the search field.
    if ([searchText length] == 0) {
        return data;
    }
    
    // Splits the search text into tokens. We will then search the array for any attributes containing the tokens.
    NSArray *searchTokens = [searchText componentsSeparatedByString:@" "];
    NSLog(@"Tokens=%@", searchTokens);
    
    // An array of keys that will be compared against.
//    NSArray *keys = @[@"ticket_no.stringValue", @"first_name", @"last_name", @"heldAt.office_code", @"heldAt.name",
//                      @"status", @"workedBy.first_name", @"workedBy.last_name"];
    
    // A filter created based on the keys above.
    //    NSString *filter = [self filterForKeys:keys];
    NSString *filter = [self filterForKeys:keys];
    
    for (NSString *token in searchTokens) {
        // Inserts the token to compare against in between each of the above keys.
        //        NSArray *args = [self insertToken:token forKeys:keys];
        NSArray *args = [self insertToken:token forKeys:keys];
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:filter argumentArray:args];
        
        // Work around. If the filtered array is empty, ticketController will through an error because selection index
        //  is outside the bounds of the tickets array. This will update the selection index manually.
        NSMutableArray *filteredArray = (NSMutableArray *)[filteredData filteredArrayUsingPredicate:searchPredicate];
        filteredData = filteredArray;
    }
    
    return filteredData;
}

@end
