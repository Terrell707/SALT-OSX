//
//  TicketPrintViewController.h
//  SALT
//
//  Created by Adrian T. Chambers on 3/22/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TicketPrintView.h"

@interface TicketPrintViewController : NSViewController <NSComboBoxDelegate> {
    NSArray *sites;
}

@property (weak) IBOutlet NSTextField *invoiceTitleField;
@property (weak) IBOutlet NSDatePicker *fromDatePicker;
@property (weak) IBOutlet NSDatePicker *toDatePicker;
@property (weak) IBOutlet NSComboBox *officeCombo;
@property (weak) IBOutlet NSTextField *invoiceNumField;

@property (weak) IBOutlet NSTextField *statusLabel;

- (IBAction)printBtn:(id)sender;

@end
