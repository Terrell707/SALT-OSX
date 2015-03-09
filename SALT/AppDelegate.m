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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // When the application first loads, the main window will be presented.
    NSString *storyboardName = @"Main";
    NSString *mainWindowName = @"MainWindowController";
    
    // Grabs the main window controller and presents it.
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:storyboardName bundle:nil];
    _controller = [storyboard instantiateControllerWithIdentifier:mainWindowName];
    [_controller showWindow:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
    NSLog(@"Terminating");
}

@end
