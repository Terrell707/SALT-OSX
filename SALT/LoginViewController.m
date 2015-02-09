//
//  LoginViewController.m
//  SALT
//
//  Created by Adrian T. Chambers on 2/8/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initializes the MySQL and StatusCodes class.
    mySQL = [[MySQL alloc] init];
    statusChecker = [[StatusCodes alloc] init];
    _loggedin = NO;
}

- (IBAction)cancelButton:(id)sender {
    [NSApp terminate:self];
}

- (IBAction)loginButton:(id)sender {
    // Grabs user info from the text fields.
    NSString *user = [_userField stringValue];
    NSString *password = [_passwordField stringValue];
    
    NSLog(@"User = %@", user);
    NSLog(@"Pass = %@", password);
    
    // Creates a key value pairs for the user name and password.
    NSArray *keys = [NSArray arrayWithObjects:@"user", @"password", nil];
    NSArray *values = [NSArray arrayWithObjects:user, password, nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:values
                                                         forKeys:keys];
    
    // Queries the database to see if the correct info was given.
    NSArray *login = [mySQL grabInfoFromFile:@"login.php" withItems:userInfo];
    
    // Checks to see the status given back by the server.
    NSInteger status = [statusChecker checkStatus:login];
    
    switch (status) {
        case INVALID_USER:
        case INCORRECT_PASSWORD:
            [_statusLabel setStringValue:@"Incorrect Username/Password!"];
            [_passwordField setStringValue:@""];
            break;
        case SUCCESS:
            [_statusLabel setStringValue:@""];
            _loggedin = YES;
            [NSApp stopModalWithCode:SUCCESS];
            [[[self view] window] close];
    }
}

@end
