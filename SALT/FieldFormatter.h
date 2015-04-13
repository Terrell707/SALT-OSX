//
//  FieldFormatter.h
//  SALT
//
//  Created by Adrian T. Chambers on 4/13/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface FieldFormatter : NSObject

- (id)initWithLastNameFirst:(BOOL)lastFirst;

- (NSString *)formatFirstName:(NSString *)first lastName:(NSString *)last;
- (NSDictionary *)unformatName:(NSString *)name;
- (NSString *)callOrderBpaFormat:(NSString *)text;
- (NSString *)tinFormat:(NSString *)text;
- (void)setErrorBackground:(id)field;
- (void)clearErrorBackground:(id)field;
- (void)fillComboBox:(NSComboBox *)combo withItems:(NSArray *)items;

@property BOOL lastNameFirst;

@end
