//
//  LoginViewController.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/8/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MySQL.h"
#import "StatusCodes.h"
#import "DataController.h"

@interface LoginViewController : NSViewController {
    MySQL *mySQL;
    StatusCodes *statusChecker;
}

@property (weak) IBOutlet NSTextField *userField;
@property (weak) IBOutlet NSSecureTextField *passwordField;
@property (weak) IBOutlet NSTextField *statusLabel;
- (IBAction)cancelButton:(id)sender;
- (IBAction)loginButton:(id)sender;

@property (readonly) BOOL loggedin;

@end
