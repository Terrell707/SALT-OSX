//
//  BusinessViewController.h
//  SALT
//
//  Created by Adrian T. Chambers on 4/11/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DataController.h"

@interface BusinessViewController : NSViewController <NSTableViewDelegate> {
    IBOutlet NSArrayController *employeeController;
    IBOutlet NSArrayController *controller;
    IBOutlet NSTableView *businessTable;
}

@property NSMutableArray *employees;
@property NSMutableArray *judges;
@property NSMutableArray *sites;
@property NSMutableArray *clerks;
@property NSMutableArray *experts;

@property (weak) IBOutlet NSComboBox *listOfTables;
@property (weak) IBOutlet NSTextField *numRowsLabel;
@property (weak) IBOutlet NSBox *infoBox;

- (IBAction)businessCombo:(id)sender;

@end
