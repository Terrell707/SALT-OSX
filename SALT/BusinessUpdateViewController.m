//
//  BusinessUpdateViewController.m
//  SALT
//
//  Created by Adrian T. Chambers on 7/2/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "BusinessUpdateViewController.h"

@interface BusinessUpdateViewController ()

@end

@implementation BusinessUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Business Update View Load");
    [self setUpdateEmployeeView];
}

- (void)setUpdateEmployeeView
{
    NSTextField *empIDText = [[NSTextField alloc] initWithFrame:NSZeroRect];
    [empIDText setStringValue:@"Employee ID:"];
    [self setTextFieldProperties:empIDText withEditable:NO];
    
    NSTextField *empID = [[NSTextField alloc] initWithFrame:NSZeroRect];
    [self setTextFieldProperties:empID withEditable:YES];
    
    NSTextField *firstNameText = [[NSTextField alloc] initWithFrame:NSZeroRect];
    [firstNameText setStringValue:@"First Name:"];
    [self setTextFieldProperties:firstNameText withEditable:NO];
    
    NSTextField *firstName = [[NSTextField alloc] initWithFrame:NSZeroRect];
    [self setTextFieldProperties:firstName withEditable:YES];
    
    NSTextField *middleInitText = [[NSTextField alloc] initWithFrame:NSZeroRect];
    [middleInitText setStringValue:@"M.I.:"];
    [self setTextFieldProperties:middleInitText withEditable:NO];
    
    NSTextField *middleInit = [[NSTextField alloc] initWithFrame:NSZeroRect];
    [self setTextFieldProperties:middleInit withEditable:YES];
    
    NSTextField *lastNameText = [[NSTextField alloc] initWithFrame:NSZeroRect];
    [lastNameText setStringValue:@"Last Name:"];
    [self setTextFieldProperties:lastNameText withEditable:NO];
    
    NSTextField *lastName = [[NSTextField alloc] initWithFrame:NSZeroRect];
    [self setTextFieldProperties:lastName withEditable:YES];
    
    NSTextField *phoneNumberText = [[NSTextField alloc] initWithFrame:NSZeroRect];
    [phoneNumberText setStringValue:@"Phone Number:"];
    [self setTextFieldProperties:phoneNumberText withEditable:NO];
    
    NSTextField *phoneNumber = [[NSTextField alloc] initWithFrame:NSZeroRect];
    [self setTextFieldProperties:phoneNumber withEditable:YES];
    
    NSTextField *emailText = [[NSTextField alloc] initWithFrame:NSZeroRect];
    [emailText setStringValue:@"E-Mail:"];
    [self setTextFieldProperties:emailText withEditable:NO];
    
    NSTextField *email = [[NSTextField alloc] initWithFrame:NSZeroRect];
    [self setTextFieldProperties:email withEditable:YES];
    
    NSTextField *streetText = [[NSTextField alloc] initWithFrame:NSZeroRect];
    [streetText setStringValue:@"Street:"];
    [self setTextFieldProperties:streetText withEditable:NO];
    
    NSTextField *street = [[NSTextField alloc] initWithFrame:NSZeroRect];
    [self setTextFieldProperties:street withEditable:YES];
    
    NSTextField *cityText = [[NSTextField alloc] initWithFrame:NSZeroRect];
    [cityText setStringValue:@"City:"];
    [self setTextFieldProperties:cityText withEditable:NO];
    
    NSTextField *city = [[NSTextField alloc] initWithFrame:NSZeroRect];
    [self setTextFieldProperties:city withEditable:YES];
    
    NSTextField *stateText = [[NSTextField alloc] initWithFrame:NSZeroRect];
    [stateText setStringValue:@"State:"];
    [self setTextFieldProperties:stateText withEditable:NO];
    
    NSTextField *state = [[NSTextField alloc] initWithFrame:NSZeroRect];
    [self setTextFieldProperties:state withEditable:YES];
    
    NSTextField *zipText = [[NSTextField alloc] initWithFrame:NSZeroRect];
    [zipText setStringValue:@"Zip:"];
    [self setTextFieldProperties:zipText withEditable:NO];
    
    NSTextField *zip = [[NSTextField alloc] initWithFrame:NSZeroRect];
    [self setTextFieldProperties:zip withEditable:YES];
    
    // Add all the text fields to the view.
    [self.view addSubview:empIDText];
    [self.view addSubview:empID];
    [self.view addSubview:firstNameText];
    [self.view addSubview:firstName];
    [self.view addSubview:middleInitText];
    [self.view addSubview:middleInit];
    [self.view addSubview:lastNameText];
    [self.view addSubview:lastName];
    [self.view addSubview:phoneNumberText];
    [self.view addSubview:phoneNumber];
    [self.view addSubview:emailText];
    [self.view addSubview:email];
    [self.view addSubview:streetText];
    [self.view addSubview:street];
    [self.view addSubview:cityText];
    [self.view addSubview:city];
    [self.view addSubview:stateText];
    [self.view addSubview:state];
    [self.view addSubview:zipText];
    [self.view addSubview:zip];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(empIDText, empID, firstNameText, firstName, middleInitText, middleInit, lastNameText, lastName, phoneNumberText, phoneNumber, emailText, email, streetText, street, cityText, city, stateText, state, zipText, zip);
    
    // Pairs all the textfields with their associated labels.
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[empIDText]-[empID(50)]"
                                                                      options:NSLayoutFormatAlignAllCenterY
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[firstNameText]-[firstName(215)]-|"
                                                                      options:NSLayoutFormatAlignAllCenterY
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[middleInitText]-[middleInit(25)]"
                                                                      options:NSLayoutFormatAlignAllCenterY
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[lastNameText]-[lastName(215)]"
                                                                      options:NSLayoutFormatAlignAllCenterY
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[phoneNumberText(97)]-[phoneNumber(109)]"
                                                                      options:NSLayoutFormatAlignAllCenterY
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[emailText]-[email(215)]"
                                                                      options:NSLayoutFormatAlignAllCenterY
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[streetText]-[street(215)]"
                                                                      options:NSLayoutFormatAlignAllCenterY
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cityText]-[city(134)]"
                                                                      options:NSLayoutFormatAlignAllCenterY
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[stateText]-[state(35)]"
                                                                      options:NSLayoutFormatAlignAllCenterY
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[zipText]-[zip(50)]"
                                                                      options:NSLayoutFormatAlignAllCenterY
                                                                      metrics:nil
                                                                        views:views]];
    
    // Lines up the textfields.
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[empIDText]-[firstNameText]-[middleInitText]-[lastNameText]-[phoneNumberText]-[emailText]-[streetText]-[cityText]-[stateText]-[zipText]-|"
                                                                      options:NSLayoutFormatAlignAllTrailing
                                                                      metrics:nil
                                                                        views:views]];
    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[empID]-[firstName]-[middleInit]-[lastName]-[phoneNumber]-[email]-[street]-[city]-[state]-[zip]-|"
//                                                                      options:NSLayoutFormatAlignAllLeading
//                                                                      metrics:nil
//                                                                        views:views]];
    
}

- (void)setTextFieldProperties:(NSTextField *)textField withEditable:(BOOL)editable
{
    if (editable == YES) {
        [textField setDrawsBackground:YES];
        [textField setBordered:YES];
        [textField setBezeled:YES];
    } else {
        [textField setDrawsBackground:NO];
        [textField setBordered:NO];
        [textField setBezeled:NO];
    }
    
    NSFont *defaultFont = [NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:[[textField cell] controlSize]]];
    [textField setEditable:editable];
    [textField setFont:defaultFont];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
}

@end
