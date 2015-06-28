//
//  BusinessViewController.m
//  SALT
//
//  Created by Adrian T. Chambers on 4/11/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import "BusinessViewController.h"

@interface BusinessViewController ()

@end

@implementation BusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    fieldFormatter = [[FieldFormatter alloc] init];
    
    dataBeforeFilter = [[NSMutableArray alloc] init];
    _employees = [[NSMutableArray alloc] init];
    _judges = [[NSMutableArray alloc] init];
    _sites = [[NSMutableArray alloc] init];
    _clerks = [[NSMutableArray alloc] init];
    _experts = [[NSMutableArray alloc] init];
    
    controller = [[NSArrayController alloc] init];

}

- (void)viewDidAppear {
    // Grabs the table that user chose to display last time this view was displayed.
    NSInteger selectedIndex = [_listOfTables indexOfSelectedItem];
    
    NSLog(@"Selected Index: %ld", selectedIndex);
    
    // Checks to see if user selected something other than the initial table. If so, it reloads that table. Otherwise,
    //  it loads the default table.
    if (selectedIndex == DEFAULT) [self setEmployeeTable];
    else [self selectTable];
    
    [self setEmployeeInfoBox];
}

- (IBAction)businessCombo:(id)sender {
    [self selectTable];
}

- (void)selectTable
{
    NSInteger selectedIndex = [_listOfTables indexOfSelectedItem];
    if (selectedIndex == EMPLOYEES) [self setEmployeeTable];
    else if (selectedIndex == SITES) [self setSiteTable];
    else if (selectedIndex == JUDGES) [self setJudgeTable];
    else if (selectedIndex == CLERKS) [self setClerkTable];
    else if (selectedIndex == EXPERTS) [self setExpertTable];
    
    [self searchData];
}

- (void)setEmployeeTable
{
    _employees = [[DataController sharedDataController] employees];
    dataBeforeFilter = _employees;
    
    NSArray *columnIdentifers = [NSArray arrayWithObjects:@"emp_id", @"first_name", @"middle_init", @"last_name", @"phone_number", @"email", @"street", @"city", @"state", @"zip", @"pay", @"active", nil];
    NSArray *columnNames = [NSArray arrayWithObjects:@"Emp ID", @"First Name", @"M.I.", @"Last Name", @"Phone Number",
                            @"E-Mail", @"Street", @"City", @"State", @"Zip", @"Pay", @"Active", nil];
    NSArray *columnWidths = [NSArray arrayWithObjects:@"50.0", @"125.0", @"100.0", @"125.0", @"125.0", @"125.0", @"100.0", @"100.0", @"50.0", @"75.0", @"50.0", @"50.0", nil];
    
    [self changeTableWithColumnIdentifiers:columnIdentifers withNames:columnNames withWidths:columnWidths boundToData:@"employees"];
    
    [_infoBox setTitle:@"Employee Information"];
}

- (void)setSiteTable
{
    _sites = [[DataController sharedDataController] sites];
    dataBeforeFilter = _sites;
    
    NSArray *columnIdentifiers = [NSArray arrayWithObjects:@"office_code", @"name", @"address", @"email", @"can", @"pay", @"active", nil];
    NSArray *columnNames = [NSArray arrayWithObjects:@"Office Code", @"Office Name", @"Address", @"E-Mail", @"CAN No.", @"Pay", @"Active", nil];
    NSArray *columnWidths = [NSArray arrayWithObjects:@"75.0", @"125.0", @"175.0", @"125.0", @"100.0", @"100.0", @"75.0", nil];
    
    [self changeTableWithColumnIdentifiers:columnIdentifiers withNames:columnNames withWidths:columnWidths boundToData:@"sites"];
    
    [_infoBox setTitle:@"Office Information"];
}

- (void)setJudgeTable
{
    _judges = [[DataController sharedDataController] judges];
    dataBeforeFilter = _judges;
    
    NSArray *columnIdentifiers = [NSArray arrayWithObjects:@"office", @"first_name", @"last_name", @"active", nil];
    NSArray *columnNames  = [NSArray arrayWithObjects:@"Office", @"First Name", @"Last Name", @"Active", nil];
    NSArray *columnWidths = [NSArray arrayWithObjects:@"125.0", @"125.0", @"125.0", @"50.0", nil];
    
    [self changeTableWithColumnIdentifiers:columnIdentifiers withNames:columnNames withWidths:columnWidths boundToData:@"judges"];
    
    [_infoBox setTitle:@"Judge Information"];
}

- (void)setClerkTable
{
    // ADD CLERK ARRAY INFORMATION HERE!!!
//    _clerks = [[DataController sharedDataController] clerks];
//    dataBeforeFilter = _clerks;
    
    NSArray *columnIdentifiers = [NSArray arrayWithObjects:@"first_name", @"last_name", @"email", nil];
    NSArray *columnNames = [NSArray arrayWithObjects:@"First Name", @"Last Name", @"E-Mail", nil];
    NSArray *columnWidths = [NSArray arrayWithObjects:@"125.0", @"125.0", @"125.0", nil];
    
//    [self changeTableWithColumnIdentifiers:columnIdentifiers withNames:columnNames boundToData:_clerks withEnitity:@"Clerk"];
    
    [_infoBox setTitle:@"Clerk Information"];
}

- (void)setExpertTable
{
    _experts = [[DataController sharedDataController] experts];
    dataBeforeFilter = _experts;
    
    NSArray *columnIdentifiers = [NSArray arrayWithObjects:@"first_name", @"last_name", @"role", @"active", nil];
    NSArray *columnNames = [NSArray arrayWithObjects:@"First Name", @"Last Name", @"Role", @"Active", nil];
    NSArray *columnWidths = [NSArray arrayWithObjects:@"125.0", @"125.0", @"50.0", @"50.0", nil];
    
    [self changeTableWithColumnIdentifiers:columnIdentifiers withNames:columnNames withWidths:columnWidths boundToData:@"experts"];
    
    [_infoBox setTitle:@"Expert Information"];
}

- (void)changeTableWithColumnIdentifiers:(NSArray *)columnIdentifiers withNames:(NSArray *)columnNames withWidths:(NSArray *)columnWidths boundToData:(NSString *)data
{
    // Removes each column from the business table.
    [businessTable setDelegate:self];
    NSArray *columns = [businessTable tableColumns];
    for (NSInteger x = columns.count - 1; x >= 0; x--) {
        [businessTable removeTableColumn:columns[x]];
    }
    
    // Binds the data to a controller so that the data will be displayed in the table.
//    [controller setContent:data];
    [controller setEditable:NO];
    [controller bind:@"contentArray" toObject:self withKeyPath:data options:nil];
    
    // Binds the controller to the table.
    [businessTable bind:@"content" toObject:controller withKeyPath:@"arrangedObjects" options:nil];
    
    // Creates and adds columns to the table using the data information.
    for (NSInteger x = 0; x < columnIdentifiers.count; x++) {
        NSString *identifier = columnIdentifiers[x];
        
        // Creates the column with an identifier and a header name.
        NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:identifier];
        [column.headerCell setStringValue:columnNames[x]];
        
        // Binds the column to its specified data in the array controller.
        NSString *keyPath = [NSString stringWithFormat:@"arrangedObjects.%@", identifier];
        [column bind:NSValueBinding toObject:controller withKeyPath:keyPath options:nil];
        [column setHidden:NO];
        [column setEditable:NO];
        
        // Adds sorting description to the column in case user wants to sort the column.
        NSString *selector;
        if ([identifier isEqualToString:@"emp_id"] || [identifier isEqualToString:@"pay"] || [identifier isEqualToString:@"active"]) {
            selector = @"compare:";
        } else {
            selector = @"caseInsensitiveCompare:";
        }
        [column setSortDescriptorPrototype:[NSSortDescriptor sortDescriptorWithKey:identifier
                                                                         ascending:YES
                                                                          selector:NSSelectorFromString(selector)]];
        
        // If the column is a phone number, format it accordingly.
        if ([identifier isEqualToString:@"phone_number"]) {
            ECPhoneNumberFormatter *phoneFormatter = [[ECPhoneNumberFormatter alloc] init];
            [column.dataCell setFormatter:phoneFormatter];
        }
        
        // Formats pay columns to a currency style.
        if ([identifier isEqualToString:@"pay"]) {
            NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
            [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [column.dataCell setFormatter:currencyFormatter];
        }
        
        // Represents boolean values as check boxes.
        if ([identifier isEqualToString:@"active"]) {
            NSButtonCell *checkBox = [[NSButtonCell alloc] init];
            [checkBox setButtonType:NSSwitchButton];
            [checkBox setTitle:@""];
            [column setDataCell:checkBox];
        }
        
        // Sets the column width to the default specified width. If it can not be converted, will give it a different
        //  default.
        NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
        NSNumber *numWidth = [numFormatter numberFromString:columnWidths[x]];
        if (numWidth == nil) {
            NSLog(@"Could not convert column width for column identifier: %@.", identifier);
            numWidth = [NSNumber numberWithDouble:100.0];
        }
        [column setWidth:[numWidth doubleValue]];
        
        // Finally add the column to the table.
        [businessTable addTableColumn:column];
    }
    
    // Binds the selected items in the table to the items they represent in the array controller.
    [businessTable bind:@"selectionIndexes" toObject:controller withKeyPath:@"selectionIndexes" options:nil];
    [businessTable setNeedsDisplay:YES];
    [businessTable reloadData];
    
    // Binds the label to the number of items in the array controller.
    NSString *label = @"%{value1}@ Rows";
    [_numRowsLabel bind:@"displayPatternValue1"
               toObject:controller
            withKeyPath:@"arrangedObjects.@count"
                options:@{NSDisplayPatternBindingOption : label}];
    
}

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
    // Sets the sort descriptor on the current controller and reloads the table.
    [controller setSortDescriptors:[businessTable sortDescriptors]];
    [businessTable reloadData];
}

- (void)controlTextDidChange:(NSNotification *)notification
{
    // Will update the search whenever something is typed into the search field.
    if ([notification object] == searchField) {
        [self searchData];
        [businessTable reloadData];
    }
}

- (void)searchData
{
    NSString *searchText = [searchField stringValue];
    NSInteger curTable = [_listOfTables indexOfSelectedItem];
    NSArray *keys;
    
    NSLog(@"Search Field: %@", searchText);
    
    // Creates a list of attributes to compare the entered text against depending on the currently selected table.
    if (curTable == EMPLOYEES || curTable == DEFAULT) {
        NSLog(@"Searching Employees");
        keys = [Employee searchableKeys];
        [self setEmployees:(NSMutableArray *)dataBeforeFilter];
        NSMutableArray *filteredData = [DataSearch searchData:_employees withKeys:keys withSearchText:searchText];
        [self setEmployees:filteredData];
    }
    else if (curTable == JUDGES) {
        NSLog(@"Searching Judges");
        keys = [Judge searchableKeys];
        [self setJudges:(NSMutableArray *)dataBeforeFilter];
        NSMutableArray *filteredData = [DataSearch searchData:_judges withKeys:keys withSearchText:searchText];
        [self setJudges:filteredData];
    }
    else if (curTable == EXPERTS) {
        NSLog(@"Searching Experts");
        keys = [Expert searchableKeys];
        [self setExperts:(NSMutableArray *)dataBeforeFilter];
        NSMutableArray *filteredData = [DataSearch searchData:_experts withKeys:keys withSearchText:searchText];
        [self setExperts:filteredData];
    }
    else if (curTable == SITES) {
        NSLog(@"Searching Sites");
        keys = [Site searchableKeys];
        [self setSites:(NSMutableArray *)dataBeforeFilter];
        NSMutableArray *filteredData = [DataSearch searchData:_sites withKeys:keys withSearchText:searchText];
        [self setSites:filteredData];
    }
    else if (curTable == CLERKS) {
        NSLog(@"Searching Clerks");
        keys = [Clerk searchableKeys];
        [self setClerks:(NSMutableArray *)dataBeforeFilter];
        NSMutableArray *filteredData = [DataSearch searchData:_clerks withKeys:keys withSearchText:searchText];
        [self setClerks:filteredData];
    }
    
}

- (void)setEmployeeInfoBox
{
    NSLog(@"NSBox Subviews: %@", [_infoBox subviews]);
//    NSArray *subviews = [_infoBox subviews];
//    for (NSUInteger x = subviews.count-1; x > 1; x--) {
//        [subviews[x] removeFromSuperview];
//    }
    
    [_infoBox setTitle:@"Employee Information"];
    
    // Creates the text fields and places them in their appropriate areas.
    NSTextField *empIDText = [[NSTextField alloc] init];
    [empIDText setStringValue:@"Employee ID:"];
    [self setInfoTextFieldProperties:empIDText];
    
    NSTextField *empIDNum = [[NSTextField alloc] init];
    [empIDNum setStringValue:@"2"];
    [self setInfoTextFieldProperties:empIDNum];
    
    NSTextField *empNameText = [[NSTextField alloc] init];
    [empNameText setStringValue:@"Name:"];
    [self setInfoTextFieldProperties:empNameText];
    
    NSTextField *empName = [[NSTextField alloc] init];
    [empName setStringValue:@"Adrian T. Chambers"];
    [self setInfoTextFieldProperties:empName];
    
    NSTextField *empPhoneText = [[NSTextField alloc] init];
    [empPhoneText setStringValue:@"Phone Number:"];
    [self setInfoTextFieldProperties:empPhoneText];
    
    NSTextField *empPhone = [[NSTextField alloc] init];
    [empPhone setStringValue:@"(707) 657-9012"];
    [self setInfoTextFieldProperties:empPhone];
    
    NSTextField *empEmailText = [[NSTextField alloc] init];
    [empEmailText setStringValue:@"E-mail:"];
    [self setInfoTextFieldProperties:empEmailText];
    
    NSTextField *empEmail = [[NSTextField alloc] init];
    [empEmail setStringValue:@"testemailaddress@gmail.com"];
    [self setInfoTextFieldProperties:empEmail];
    
    NSTextField *empAddressText = [[NSTextField alloc] init];
    [empAddressText setStringValue:@"Address:"];
    [self setInfoTextFieldProperties:empAddressText];
    
    NSTextField *empStreet = [[NSTextField alloc] init];
    [empStreet setStringValue:@"4300 Somewhere Over There Street"];
    [self setInfoTextFieldProperties:empStreet];
    
    NSTextField *empBlankText = [[NSTextField alloc] init];
    [empBlankText setStringValue:@""];
    [self setInfoTextFieldProperties:empBlankText];
    
    NSTextField *empCity = [[NSTextField alloc] init];
    [empCity setStringValue:@"San Jose"];
    [self setInfoTextFieldProperties:empCity];
    
    NSTextField *empState = [[NSTextField alloc] init];
    [empState setStringValue:@"CA"];
    [self setInfoTextFieldProperties:empState];
    
    NSTextField *empZip = [[NSTextField alloc] init];
    [empZip setStringValue:@"95136"];
    [self setInfoTextFieldProperties:empZip];
    
    NSTextField *empPayText = [[NSTextField alloc] init];
    [empPayText setStringValue:@"Pay:"];
    [self setInfoTextFieldProperties:empPayText];
    
    NSTextField *empPay = [[NSTextField alloc] init];
    [empPay setStringValue:@"$60.00"];
    [self setInfoTextFieldProperties:empPay];
    
    NSTextField *empActiveText = [[NSTextField alloc] init];
    [empActiveText setStringValue:@"Active:"];
    [self setInfoTextFieldProperties:empActiveText];
    
    NSButton *empActiveCheck = [[NSButton alloc] initWithFrame:NSZeroRect];
    [empActiveCheck setTitle:@""];
    [self setInfoButtonProperties:empActiveCheck];

    // Adds the views to the info box.
    [_infoBox addSubview:empIDText];
    [_infoBox addSubview:empIDNum];
    [_infoBox addSubview:empNameText];
    [_infoBox addSubview:empName];
    [_infoBox addSubview:empPhoneText];
    [_infoBox addSubview:empPhone];
    [_infoBox addSubview:empEmailText];
    [_infoBox addSubview:empEmail];
    [_infoBox addSubview:empAddressText];
    [_infoBox addSubview:empStreet];
    [_infoBox addSubview:empBlankText];
    [_infoBox addSubview:empCity];
    [_infoBox addSubview:empState];
    [_infoBox addSubview:empZip];
    [_infoBox addSubview:empPayText];
    [_infoBox addSubview:empPay];
    [_infoBox addSubview:empActiveText];
    [_infoBox addSubview:empActiveCheck];
    
//    NSLog(@"Box Constraints: %@", [_infoBox constraints]);
    
    NSDictionary *infoBoxSubviews = NSDictionaryOfVariableBindings(empIDText, empIDNum, empNameText, empName, empPhoneText, empPhone, empEmailText, empEmail, empAddressText, empStreet, empBlankText, empCity, empState, empZip, empPayText, empPay, empActiveText, empActiveCheck);
    
    NSDictionary *mainViewSubviews = NSDictionaryOfVariableBindings(_infoBox, businessTable);
    
    // Lays out each row of the employee's properties.
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[empIDText]-[empIDNum]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[empNameText]-[empName]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[empPhoneText]-[empPhone]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[empEmailText]-[empEmail]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[empAddressText]-[empStreet]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[empBlankText]-[empCity]-[empState]-[empZip]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[empPayText]-[empPay]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[empActiveText]-[empActiveCheck]"
                                                                     options:NSLayoutFormatAlignAllCenterY
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    
    // Aligns each of the properties vertically.
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[empIDText]-[empNameText]-[empPhoneText]-[empEmailText]-[empAddressText]-[empBlankText]-[empPayText]-[empActiveText]"
                                                                     options:NSLayoutFormatAlignAllTrailing
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[empIDNum]-[empName]-[empPhone]-[empEmail]-[empStreet]-[empCity]-[empPay]-[empActiveCheck]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[empStreet]-[empState]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[empStreet]-[empZip]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    // Forces the infobox to layout the constraints for all of its textfields. This is so we can calculate the height
    //  we need to set the box to.
    [_infoBox setNeedsLayout:YES];
    [_infoBox layoutSubtreeIfNeeded];
    [_infoBox sizeToFit];
    
    float infoBoxHeight = 0;
    infoBoxHeight = _infoBox.frame.size.height + 20;
    NSDictionary *boxMetrics = @{@"boxWidth":@383, @"boxHeight":[NSNumber numberWithFloat:infoBoxHeight]};
    
    // Sets the height and width of the info box.
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_infoBox(>=boxWidth)]"
                                                                      options:NSLayoutFormatAlignAllCenterX
                                                                      metrics:boxMetrics
                                                                        views:mainViewSubviews]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_infoBox(boxHeight)]"
                                                                      options:0
                                                                      metrics:boxMetrics
                                                                        views:mainViewSubviews]];
    
}

- (void)setInfoTextFieldProperties:(NSTextField *)textField
{
    BOOL debug = NO;
    
    NSFont *defaultFont = [NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:[[textField cell] controlSize]]];
    [textField setEditable:NO];
    [textField setBordered:NO];
    [textField setBezeled:NO];
    [textField setDrawsBackground:debug];
    [textField setFont:defaultFont];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setInfoButtonProperties:(NSButton *)button
{
    [button setButtonType:NSSwitchButton];
    [button setBezelStyle:0];
    [button setEnabled:NO];
    button.translatesAutoresizingMaskIntoConstraints = NO;
}

@end
