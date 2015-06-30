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
    
    _infoTextFields = [[NSMutableArray alloc] init];
    
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
    [self updateFields];
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
    // Updates the info fields for the currently selected row in the table.
    [self updateFields];
}

#pragma mark - Set Table Methods
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
    
    [self setEmployeeInfoBox];
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
    
    [self setJudgeInfoBox];
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

# pragma mark - Set Info Box Methods
- (void)clearInfoBox
{
    NSLog(@"NSBox Subviews: %@", [_infoBox subviews]);
    
    // Finds the view with in the NSBox that has the textfields, buttons, etc, and then removes everything
    //  from that view.
    NSArray *boxSubviews = [_infoBox subviews];
    
    for (NSInteger x = boxSubviews.count-1; x >= 0; x--) {
        NSArray *subviews = [boxSubviews[x] subviews];
        if (subviews.count > 0) {
            for (NSInteger y = subviews.count-1; y >= 0; y--) {
                [subviews[y] removeFromSuperview];
            }
        }
    }
    
    // Removes all the text fields that we are tracking.
    [_infoTextFields removeAllObjects];
}

- (void)resizeInfoBox
{
    NSDictionary *mainViewSubviews = NSDictionaryOfVariableBindings(_infoBox, businessTable);
    
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

- (void)setEmployeeInfoBox
{
    // Prepares the info box for new information.
    [self clearInfoBox];
    
    // Change title of info box.
    [_infoBox setTitle:@"Employee Information"];
    
    // Creates the text fields and places them in their appropriate areas.
    NSTextField *empIDText = [[NSTextField alloc] init];
    [empIDText setStringValue:@"Employee ID:"];
    [self setInfoTextFieldProperties:empIDText];
    
    NSTextField *empIDNum = [[NSTextField alloc] init];
    [empIDNum setStringValue:@"2"];
    [self setInfoTextFieldProperties:empIDNum];
    [self trackInfoTextField:empIDNum withIdentifier:@"emp_id"];
    
    NSTextField *empNameText = [[NSTextField alloc] init];
    [empNameText setStringValue:@"Name:"];
    [self setInfoTextFieldProperties:empNameText];
    
    NSTextField *empName = [[NSTextField alloc] init];
    [empName setStringValue:@"Adrian T. Chambers"];
    [self setInfoTextFieldProperties:empName];
    [self trackInfoTextField:empName withIdentifier:@"emp_name"];
    
    NSTextField *empPhoneText = [[NSTextField alloc] init];
    [empPhoneText setStringValue:@"Phone Number:"];
    [self setInfoTextFieldProperties:empPhoneText];
    
    NSTextField *empPhone = [[NSTextField alloc] init];
    [empPhone setStringValue:@"(707) 657-9012"];
    [self setInfoTextFieldProperties:empPhone];
    [self trackInfoTextField:empPhone withIdentifier:@"phone_number"];
    
    NSTextField *empEmailText = [[NSTextField alloc] init];
    [empEmailText setStringValue:@"E-mail:"];
    [self setInfoTextFieldProperties:empEmailText];
    
    NSTextField *empEmail = [[NSTextField alloc] init];
    [empEmail setStringValue:@"testemailaddress@gmail.com"];
    [self setInfoTextFieldProperties:empEmail];
    [self trackInfoTextField:empEmail withIdentifier:@"email"];
    
    NSTextField *empAddressText = [[NSTextField alloc] init];
    [empAddressText setStringValue:@"Address:"];
    [self setInfoTextFieldProperties:empAddressText];
    
    NSTextField *empAddress1 = [[NSTextField alloc] init];
    [empAddress1 setStringValue:@"4300 Somewhere Over There Street"];
    [self setInfoTextFieldProperties:empAddress1];
    [self trackInfoTextField:empAddress1 withIdentifier:@"address1"];
    
    NSTextField *empBlankText = [[NSTextField alloc] init];
    [empBlankText setStringValue:@""];
    [self setInfoTextFieldProperties:empBlankText];
    
    NSTextField *empAddress2 = [[NSTextField alloc] init];
    [empAddress2 setStringValue:@"San Jose"];
    [self setInfoTextFieldProperties:empAddress2];
    [self trackInfoTextField:empAddress2 withIdentifier:@"address2"];
    
    NSTextField *empPayText = [[NSTextField alloc] init];
    [empPayText setStringValue:@"Pay:"];
    [self setInfoTextFieldProperties:empPayText];
    
    NSTextField *empPay = [[NSTextField alloc] init];
    [empPay setStringValue:@"$60.00"];
    [self setInfoTextFieldProperties:empPay];
    [self trackInfoTextField:empPay withIdentifier:@"pay"];
    
    NSTextField *empActiveText = [[NSTextField alloc] init];
    [empActiveText setStringValue:@"Active:"];
    [self setInfoTextFieldProperties:empActiveText];
    
    NSButton *empActiveCheck = [[NSButton alloc] initWithFrame:NSZeroRect];
    [empActiveCheck setTitle:@""];
    [self setInfoButtonProperties:empActiveCheck];
    [empActiveCheck bind:@"value" toObject:controller withKeyPath:@"selection.active" options:nil];

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
    [_infoBox addSubview:empAddress1];
    [_infoBox addSubview:empBlankText];
    [_infoBox addSubview:empAddress2];
    [_infoBox addSubview:empPayText];
    [_infoBox addSubview:empPay];
    [_infoBox addSubview:empActiveText];
    [_infoBox addSubview:empActiveCheck];
    
    
    NSDictionary *infoBoxSubviews = NSDictionaryOfVariableBindings(empIDText, empIDNum, empNameText, empName, empPhoneText, empPhone, empEmailText, empEmail, empAddressText, empAddress1, empBlankText, empAddress2, empPayText, empPay, empActiveText, empActiveCheck);
    
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
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[empAddressText]-[empAddress1]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[empBlankText]-[empAddress2]"
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
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[empIDNum]-[empName]-[empPhone]-[empEmail]-[empAddress1]-[empAddress2]-[empPay]-[empActiveCheck]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    [self resizeInfoBox];
}

- (void)setJudgeInfoBox
{
    [self clearInfoBox];
    
    [_infoBox setTitle:@"Judge Information"];
    
    // Creates the text fields and places them in their appropriate areas.
    NSTextField *judgeNameText = [[NSTextField alloc] init];
    [judgeNameText setStringValue:@"Name:"];
    [self setInfoTextFieldProperties:judgeNameText];
    
    NSTextField *judgeName = [[NSTextField alloc] init];
    [judgeName setStringValue:@"David Blume"];
    [self setInfoTextFieldProperties:judgeName];
    [self trackInfoTextField:judgeName withIdentifier:@"judge_name"];
    
    NSTextField *judgeSiteText = [[NSTextField alloc] init];
    [judgeSiteText setStringValue:@"Office:"];
    [self setInfoTextFieldProperties:judgeSiteText];
    
    NSTextField *judgeSite = [[NSTextField alloc] init];
    [judgeSite setStringValue:@"Sacramento, X-63"];
    [self setInfoTextFieldProperties:judgeSite];
    [self trackInfoTextField:judgeSite withIdentifier:@"judge_site"];
    
    NSTextField *judgeActiveText = [[NSTextField alloc] init];
    [judgeActiveText setStringValue:@"Active:"];
    [self setInfoTextFieldProperties:judgeActiveText];
    
    NSButton *judgeActiveCheck = [[NSButton alloc] initWithFrame:NSZeroRect];
    [judgeActiveCheck setTitle:@""];
    [self setInfoButtonProperties:judgeActiveCheck];
    [judgeActiveCheck bind:@"value" toObject:controller withKeyPath:@"selection.active" options:nil];
    
    // Add all the text fields and buttons to the view.
    [_infoBox addSubview:judgeNameText];
    [_infoBox addSubview:judgeName];
    [_infoBox addSubview:judgeSiteText];
    [_infoBox addSubview:judgeSite];
    [_infoBox addSubview:judgeActiveText];
    [_infoBox addSubview:judgeActiveCheck];
    
    NSDictionary *infoBoxSubviews = NSDictionaryOfVariableBindings(judgeNameText, judgeName, judgeSiteText, judgeSite, judgeActiveText, judgeActiveCheck);
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[judgeNameText]-[judgeName]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[judgeSiteText]-[judgeSite]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[judgeActiveText]-[judgeActiveCheck]"
                                                                     options:NSLayoutFormatAlignAllCenterY
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[judgeNameText]-[judgeSiteText]-[judgeActiveText]"
                                                                     options:NSLayoutFormatAlignAllTrailing
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[judgeName]-[judgeSite]-[judgeActiveCheck]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    [self resizeInfoBox];
}

- (void)updateFields
{
    // If the user clicked a column to sort the data, this will get the most current sort.
    NSArray *arrangedObjects = [controller arrangedObjects];
    NSUInteger selection = [controller selectionIndex];
    
    NSLog(@"Currently Selected: %ld", selection);
    
    // Blank out all fields.
    for (NSTextField *field in _infoTextFields) {
        [field setStringValue:@""];
    }
    
    // Checks to make sure an item is actually selected.
    if (selection > [arrangedObjects count]) {
        for (NSTextField *textField in _infoTextFields)
        {
            NSString *identifier = textField.identifier;
            if (![identifier isEqualToString:@"address2"])
            {
                [textField setStringValue:@"No Selection"];
            }
        }
    }
    else {
        // Updates the fields depending on the currently selected table.
        NSInteger curTable = [_listOfTables indexOfSelectedItem];
        if (curTable == EMPLOYEES || curTable == DEFAULT) [self updateEmployeeFieldsWithEmployee:arrangedObjects[selection]];
    }
    
}

# pragma mark - Update Info Fields Methods
- (void)updateEmployeeFieldsWithEmployee:(Employee *)employee
{
    for (NSTextField *textField in _infoTextFields) {
        NSString *identifier = textField.identifier;
        
        if ([identifier isEqualToString:@"emp_id"]) [textField setStringValue:[employee.emp_id stringValue]];
        if ([identifier isEqualToString:@"emp_name"]) {
            if ([employee.middle_init isEqualToString:@""]) [textField setStringValue:[NSString stringWithFormat:@"%@ %@", employee.first_name, employee.last_name]];
            else [textField setStringValue:[NSString stringWithFormat:@"%@ %@. %@", employee.first_name, employee.middle_init, employee.last_name]];
        }
        if ([identifier isEqualToString:@"phone_number"]) {
            ECPhoneNumberFormatter *phoneFormatter = [[ECPhoneNumberFormatter alloc] init];
            [textField setStringValue:[phoneFormatter stringForObjectValue:employee.phone_number]];
        }
        if ([identifier isEqualToString:@"email"]) [textField setStringValue:employee.email];
        if ([identifier isEqualToString:@"address1"]) [textField setStringValue:employee.street];
        if ([identifier isEqualToString:@"address2"]) {
            [textField setStringValue:[NSString stringWithFormat:@"%@, %@ %@", employee.city, employee.state, employee.zip]];
        }
        if ([identifier isEqualToString:@"pay"]) {
            NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
            [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
            [textField setStringValue:[NSString stringWithFormat:@"%@", [nf stringFromNumber:employee.pay]]];
        }
    }
}

# pragma mark - Info Box Helper Methods
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

- (void)trackInfoTextField:(NSTextField *)textField withIdentifier:(NSString *)identifier
{
    [textField setIdentifier:identifier];
    [_infoTextFields addObject:textField];
}

- (void)setInfoButtonProperties:(NSButton *)button
{
    [button setButtonType:NSSwitchButton];
    [button setBezelStyle:0];
    [button setEnabled:NO];
    button.translatesAutoresizingMaskIntoConstraints = NO;
}

@end
