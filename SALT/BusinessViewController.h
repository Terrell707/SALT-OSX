//
//  BusinessViewController.h
//  SALT
//
//  Created by Adrian T. Chambers on 4/11/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DataController.h"
#import "FieldFormatter.h"
#import "ECPhoneNumberFormatter.h"

@interface BusinessViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource> {
    IBOutlet NSArrayController *employeeController;
    IBOutlet NSArrayController *controller;
    IBOutlet NSTableView *businessTable;
    
    FieldFormatter *fieldFormatter;
}

@property NSMutableArray *employees;
@property NSMutableArray *judges;
@property NSMutableArray *sites;
@property NSMutableArray *clerks;
@property NSMutableArray *experts;

@property (weak) IBOutlet NSComboBox *listOfTables;
@property (weak) IBOutlet NSTextField *numRowsLabel;
@property (weak) IBOutlet NSBox *infoBox;
@property (weak) IBOutlet NSTextField *idLabel;
@property (weak) IBOutlet NSTextField *numLabel;

- (IBAction)businessCombo:(id)sender;

@end
