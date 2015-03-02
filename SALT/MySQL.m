//
//  MySQL.m
//  SALT
//
//  Created by Adrian T. Chambers on 2/6/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "MySQL.h"

@implementation MySQL

- (id)init
{
    self = [super init];
    if (self) {
        server = @"http://localhost/";
    }
    
    return self;
}

- (NSArray *)grabInfoFromFile:(NSString *)fileName
{
    return [self grabInfoFromFile:fileName
                        withItems:nil];
}

- (NSArray *)grabInfoFromFile:(NSString *)fileName withItems:(NSDictionary *)items
{
    // Creates a URL out of the server name and file name. Then grabs the data from the server.
    NSMutableString *sURL = [[NSMutableString alloc] initWithString:[server stringByAppendingString:fileName]];
    NSURLComponents *components = [NSURLComponents componentsWithString:sURL];

    // If the list of query items are not null, we will add them to the url.
    if (items != nil) {
        NSMutableArray *queryItems = [NSMutableArray array];
        for (NSString *key in items) {
            [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:[items valueForKey:key]]];
        }
        [components setQueryItems:queryItems];
    }
    
    // Finalizes the url and queries the server.
    NSURL *url = [components URL];
    NSData *dataURL = [NSData dataWithContentsOfURL:url];
    
    // Tries to parse the json into a dictionary.
    NSError *error = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:dataURL
                                                options:0
                                                  error:&error];
    
    // If there is an error, return nothing. Otherwise, return the json object.
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }

    return json;
}

- (NSArray *)insertIntoFile:(NSString *)fileName withItems:(NSDictionary *)items
{
    // Creates a URL out of the server name and file name.
    NSMutableString *sURL = [[NSMutableString alloc] initWithString:[server stringByAppendingString:fileName]];
    NSURLComponents *components = [NSURLComponents componentsWithString:sURL];
    
    // If the list of items to insert is null, we will return with an error.
    if (items == nil) {
    }
    NSMutableArray *insertItems = [NSMutableArray array];
    for (NSString *key in items) {
        [insertItems addObject:[NSURLQueryItem queryItemWithName:key value:[items valueForKey:key]]];
    }
    [components setQueryItems:insertItems];
    
    // Finalizes the url and attempts to insert the info onto the server.
    NSURL *url = [components URL];
    NSData *dataURL = [NSData dataWithContentsOfURL:url];
    
    // Tries to parse the json into a dictionary.
    NSError *error = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:dataURL
                                                    options:0
                                                      error:&error];
    
    // If there is an error, return nothing. Otherwise, return the json object.
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }
    
    return json;
}

@end
