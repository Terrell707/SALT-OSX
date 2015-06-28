//
//  BusinessViewController.h
//  SALT
//
//  Created by Adrian T. Chambers on 4/11/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Employee.h"
#import "Judge.h"
#import "Site.h"
#import "Clerk.h"
#import "Expert.h"
#import "DataController.h"
#import "DataSearch.h"
#import "FieldFormatter.h"
#import "ECPhoneNumberFormatter.h"

@interface BusinessViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource> {
    IBOutlet NSArrayController *controller;
    IBOutlet NSTableView *businessTable;
    IBOutlet NSSearchField *searchField;
    
    FieldFormatter *fieldFormatter;
    
    NSArray *dataBeforeFilter;
    
    enum {
        DEFAULT = -1,
        EMPLOYEES = 0,
        JUDGES = 1,
        EXPERTS = 2,
        SITES = 3,
        CLERKS = 4
    };
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
