//
//  MySQL.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/6/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySQL : NSObject {
    NSString *server;
}

// Calls the php script containing the query needed and returns the results.
- (NSArray *)grabInfoFromFile:(NSString *)fileName;
- (NSArray *)grabInfoFromFile:(NSString *)fileName withItems:(NSDictionary *)items;

@end
