//
//  AppDelegate.m
//  SALT
//
//  Created by Adrian T. Chambers on 2/8/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "AppDelegate.h"
#import "TicketViewController.h"

@interface AppDelegate ()
@property NSWindowController *controller;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    // When the application first loads, a login screen will be presented.
    NSString *storyboardName = @"Main";
    NSString *loginWindowName = @"LoginWindowController";
    
    // Grabs the login window controller and presents it.
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:storyboardName bundle:nil];
    _controller = [storyboard instantiateControllerWithIdentifier:loginWindowName];
    
    // Grabs the status of the login.
    BOOL loggedIn = [NSApp runModalForWindow:[_controller window]];
    NSLog(@"Logged in: %d", loggedIn);
    
    if (loggedIn == YES) {
        [[_controller window] close];
        [[DataController sharedDataController] loadData];
    } else {
        [NSApp terminate:self];
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    NSLog(@"Terminating");
}

@end
