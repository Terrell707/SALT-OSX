//
//  TicketSettingsViewController.h
//  SALT
//
//  Created by Adrian T. Chambers on 3/26/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DataController.h"

@interface TicketSettingsViewController : NSViewController

@property (weak) IBOutlet NSDatePicker *fromDatePicker;
@property (weak) IBOutlet NSDatePicker *toDatePicker;

@property (readwrite, copy) NSArray *tableColumns;

- (IBAction)confirmBtn:(id)sender;

@end
