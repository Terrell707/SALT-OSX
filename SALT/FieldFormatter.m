//
//  FieldFormatter.m
//  SALT
//
//  Created by Adrian T. Chambers on 4/13/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "FieldFormatter.h"

@implementation FieldFormatter

- (id)init
{
    return [self initWithLastNameFirst:YES];
}

- (id)initWithLastNameFirst:(BOOL)lastFirst
{
    self = [super init];
    if (self) {
        _lastNameFirst = lastFirst;
    }
    
    return self;
}

- (void)fillComboBox:(NSComboBox *)combo withItems:(NSArray *)items
{
    [combo removeAllItems];
    
    // Fills a combo box with all the items in the array.
    for (int x = 0; x < [items count]; x++) {
        NSString *first = [[items objectAtIndex:x] valueForKey:@"first_name"];
        NSString *last = [[items objectAtIndex:x] valueForKey:@"last_name"];
        NSString *name = [self formatFirstName:first lastName:last];
        [combo addItemWithObjectValue:name];
    }
}

- (NSString *)formatFirstName:(NSString *)first lastName:(NSString *)last
{
    NSString *name;
    
    if (_lastNameFirst == YES) {
        name = [NSString stringWithFormat:@"%@, %@", last, first];
    } else {
        name = [NSString stringWithFormat:@"%@ %@", first, last];
    }
    
    return [name capitalizedString];
}

- (NSDictionary *)unformatName:(NSString *)name
{
    NSMutableArray *nameSplit;
    NSArray *keys;
    
    // Trims all spaces from beginning and end of name.
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // Nothing was entered in, so return blanks for first and last name.
    if ([name isEqualToString:@""]) {
        return [NSDictionary dictionaryWithObjectsAndKeys:@"", @"first_name", @"", @"last_name", nil];
    }
    
    // Grabs the first and last name depending on the format.
    if (_lastNameFirst == YES) {
        nameSplit = (NSMutableArray *)[name componentsSeparatedByString:@","];
        keys = [NSArray arrayWithObjects:@"last_name", @"first_name", nil];
    }
    else
    {
        nameSplit = (NSMutableArray *)[name componentsSeparatedByString:@" "];
        keys = [NSArray arrayWithObjects:@"first_name", @"last_name", nil];
    }
    
    // Removes all whitespace at the beginning and end of each name.
    for (int x = 0; x < nameSplit.count ; x++) {
        NSString *trimmedName = [nameSplit[x] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [nameSplit replaceObjectAtIndex:x withObject:trimmedName];
    }
    
    // If there are more than 2 elements, that means the user typed in a middle name as well. We will combine the middle name with the first name.
    if (nameSplit.count > 2) {
        NSMutableString *combinedFirstName = [[NSMutableString alloc] init];
        NSString *lastName;
        
        if (_lastNameFirst == YES) {
            // Combines all names except the first element. This will make a combined first name.
            for (int x = 1; x < nameSplit.count; x++) {
                [combinedFirstName appendString:nameSplit[x]];
                [combinedFirstName appendString:@" "];
            }
            lastName = nameSplit[0];
            
            // Removes spaces from the beginning and end of the combined first name.
            NSString *firstName = [combinedFirstName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            // Adds the combined first name and last name into an array in the order that it will be added to the dictionary.
            [nameSplit removeAllObjects];
            [nameSplit addObject:lastName];
            [nameSplit addObject:firstName];
        }
        else {
            // Combined all names except the last element. This will make a combined first name.
            for (int x = 0; x < nameSplit.count-1; x++) {
                [combinedFirstName appendString:nameSplit[x]];
                [combinedFirstName appendString:@" "];
            }
            lastName = nameSplit[nameSplit.count-1];
            
            // Removes spaces from the beginning and end of the combined first name.
            NSString *firstName = [combinedFirstName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            // Adds the combined first name and last name into an array in the order that it will be added to the dictionary.
            [nameSplit removeAllObjects];
            [nameSplit addObject:firstName];
            [nameSplit addObject:lastName];
        }
        
    }
    
    // Adds spaces to the array anywhere there is a missing component.
    if (nameSplit.count == 1) {
        [nameSplit addObject:@""];
    }
    
    // Creates a dictionary out of the names.
    NSDictionary *nameDict = [NSDictionary dictionaryWithObjects:nameSplit forKeys:keys];
    
    return nameDict;
}

- (NSString *)ticketNumberFormat:(NSString *)text
{
    // Return a truncated ticket number if longer then max length.
    return [self string:text withMaxLength:8];
}

- (BOOL)correctTicketNumberLength:(NSString *)text
{
    // Returns true if passed in text matches the length ticket number should be.
    return (text.length == 8);
}

- (NSString *)callOrderFormat:(NSString *)text
{
    // Adds hyphens as appropriate and then truncates the text if longer than max length.
    text = [self callOrderBpaFormat:text];
    return [self string:text withMaxLength:15];
}

- (BOOL)correctCallOrderLength:(NSString *)text
{
    // Returns true if passed in text matches the length call order number should be.
    return (text.length == 15);
}

- (NSString *)bpaFormat:(NSString *)text
{
    // Adds hyphens as appropriate and then truncates the text if longer than max length.
    text = [self callOrderBpaFormat:text];
    return [self string:text withMaxLength:13];
}

- (NSString *)tinFormat:(NSString *)text
{
    text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    // Adds a '-' after the 4th character.
    NSMutableString *formatted = [[NSMutableString alloc] init];
    
    for (int x = 0; x < [text length]; x++) {
        if (x == 4) {
            [formatted appendString:@"-"];
        }
        NSString *nextChar = [NSString stringWithFormat:@"%c", [text characterAtIndex:x]];
        [formatted appendString:nextChar];
    }
    
    return [self string:formatted withMaxLength:11];
}

- (NSString *)nameFormat:(NSString *)text
{
    // Returns a truncated name if longer then max length.
    return [self string:text withMaxLength:20];
}

- (NSString *)canFormat:(NSString *)text
{
    // Return a truncated can if longer then max length.
    return [self string:text withMaxLength:7];
}

- (NSString *)socFormat:(NSString *)text
{
    // Returns a truncated soc if longer then max length.
    return [self string:text withMaxLength:4];
}

- (BOOL)correctSOCLength:(NSString *)text
{
    // Returns true if passed in text matches the length soc should be.
    return (text.length == 4);
}

- (NSString *)callOrderBpaFormat:(NSString *)text
{
    text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    // Adds a '-' after every 4th and 7th character.
    NSMutableString *formatted = [[NSMutableString alloc] init];
    
    for (int x = 0; x < [text length]; x++) {
        if (x == 4 || x == 6) {
            [formatted appendString:@"-"];
        }
        NSString *nextChar = [NSString stringWithFormat:@"%c", [text characterAtIndex:x]];
        [formatted appendString:nextChar];
    }
    
    return formatted;
}


- (NSString *)string:(NSString *)string withMaxLength:(NSInteger)maxLength
{
    if ([string length] > maxLength) {
        return [string substringToIndex:maxLength];
    } else {
        return string;
    }
    
}

- (void)setErrorBackground:(id)field
{
    // Sets the field's background to a slight red so that the user knows there is an error.
    [field setBackgroundColor:[NSColor colorWithRed:1 green:0 blue:0 alpha:0.20]];
}

- (void)clearErrorBackground:(id)field
{
    // Reverts field to normal color.
    [field setBackgroundColor:[NSColor colorWithRed:0 green:0 blue:0 alpha:0]];
}

@end
