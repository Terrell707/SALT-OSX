//
//  DataSearch.h
//  SALT
//
//  Created by Adrian T. Chambers on 5/17/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSearch : NSObject

+ (NSMutableArray *)searchData:(NSMutableArray *)data withKeys:(NSArray *)keys withSearchText:(NSString *)searchText;

@end
