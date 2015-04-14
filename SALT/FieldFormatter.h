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

- (NSString *)ticketNumberFormat:(NSString *)text;
- (NSString *)callOrderFormat:(NSString *)text;
- (NSString *)bpaFormat:(NSString *)text;
- (NSString *)tinFormat:(NSString *)text;
- (NSString *)nameFormat:(NSString *)text;
- (NSString *)canFormat:(NSString *)text;
- (NSString *)socFormat:(NSString *)text;

- (BOOL)correctTicketNumberLength:(NSString *)text;
- (BOOL)correctCallOrderLength:(NSString *)text;
- (BOOL)correctSOCLength:(NSString *)text;

- (void)setErrorBackground:(id)field;
- (void)clearErrorBackground:(id)field;
- (void)fillComboBox:(NSComboBox *)combo withItems:(NSArray *)items;

@property BOOL lastNameFirst;

@end
