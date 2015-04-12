//
//  MainWindowController.m
//  SALT
//
//  Created by Adrian T. Chambers on 3/7/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "MainWindowController.h"

@interface MainWindowController ()

@end

@implementation MainWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    NSLog(@"Window Loaded");
    
    // Gets notified when main window closes.
    [self.window setDelegate:self];
    
    // Gets notified when user login status changes.
    [[DataController sharedDataController] addObserver:self
                                            forKeyPath:@"loggedIn"
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
    
    // If the window loads and user is not logged in, present the login window.
    if ([[DataController sharedDataController] loggedIn] == NO) {
        NSLog(@"Not Logged in!");
        
        // Displays the login view.
        [self displayLoginView];
    }
}

- (void)windowWillClose:(NSNotification *)notification
{
    NSLog(@"Main Window will close!");
    [[DataController sharedDataController] logout];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"loggedIn"]) {
        NSLog(@"Change=%@", change);
        NSLog(@"DataController loggedin = %d", [[DataController sharedDataController] loggedIn]);
        
        if (change[@"new"] != nil && [change[@"new"] integerValue] == 1) {
            [self displayCurrentView];
        }
        
        if (change[@"new"] != nil && [change[@"new"] integerValue] == 0) {
            [self displayLoginView];
        }
    }
}

- (void)displayLoginView
{
    // Save our current view controller and window size that is being displayed for later.
    currentVC = self.contentViewController;
    
    // Grabs the Login View Controller and displays it.
    NSString *storyboardName = @"Main";
    NSString *loginViewName = @"LoginViewController";
    
    // Grabs the login window controller and presents it.
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:storyboardName bundle:nil];
    _loginVC = [storyboard instantiateControllerWithIdentifier:loginViewName];
    [self.window setContentView:_loginVC.view];
    
    NSLog(@"Window Name from MainWindowController=%@", [self window]);
    NSLog(@"Window content view = %@", [self.window contentView]);
}

- (void)displayCurrentView
{
    if (currentVC != nil) {
        // Return to the view the user was at before.
        [self.window setContentView:currentVC.view];
    }
    else {
        // If the user wasn't currently in a view, then load the main tab view.
        NSString *storyboardName = @"Main";
        NSString *tabViewName = @"TabViewController";
        
        NSStoryboard *storyboard = [NSStoryboard storyboardWithName:storyboardName bundle:nil];
        NSViewController *controller = [storyboard instantiateControllerWithIdentifier:tabViewName];
        [self.window setContentView:controller.view];
    }
    
    NSLog(@"Window content view = %@", [self.window contentView]);
}

@end
