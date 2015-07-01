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
    [self selectTable];
    
    _sites = [[DataController sharedDataController] sites];
    
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
    else if (selectedIndex == DEFAULT) [self setEmployeeTable];
    
    [self searchData];
    [self updateFields];
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
    
    [self setSiteInfoBox];
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
    
    NSDictionary *boxMetrics = @{@"boxHeight":[NSNumber numberWithFloat:infoBoxHeight]};
    
    // Removes the previous height constraint on the info box if there was one. Will then give it a new height. This will also
    //  force the table to resize itself while keeping the window the same size.
    if (boxHeightConstraint != nil) {
        [self.view removeConstraints:boxHeightConstraint];
    }
    
    boxHeightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_infoBox(boxHeight)]-|"
                                                                  options:0
                                                                  metrics:boxMetrics
                                                                    views:mainViewSubviews];
    
    [self.view addConstraints:boxHeightConstraint];
    
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
    [self setInfoTextFieldProperties:empIDNum];
    [self trackInfoTextField:empIDNum withIdentifier:@"emp_id"];
    
    NSTextField *empNameText = [[NSTextField alloc] init];
    [empNameText setStringValue:@"Name:"];
    [self setInfoTextFieldProperties:empNameText];
    
    NSTextField *empName = [[NSTextField alloc] init];
    [self setInfoTextFieldProperties:empName];
    [self trackInfoTextField:empName withIdentifier:@"emp_name"];
    
    NSTextField *empPhoneText = [[NSTextField alloc] init];
    [empPhoneText setStringValue:@"Phone Number:"];
    [self setInfoTextFieldProperties:empPhoneText];
    
    NSTextField *empPhone = [[NSTextField alloc] init];
    [self setInfoTextFieldProperties:empPhone];
    [self trackInfoTextField:empPhone withIdentifier:@"phone_number"];
    
    NSTextField *empEmailText = [[NSTextField alloc] init];
    [empEmailText setStringValue:@"E-mail:"];
    [self setInfoTextFieldProperties:empEmailText];
    
    NSTextField *empEmail = [[NSTextField alloc] init];
    [self setInfoTextFieldProperties:empEmail];
    [self trackInfoTextField:empEmail withIdentifier:@"email"];
    
    NSTextField *empAddressText = [[NSTextField alloc] init];
    [empAddressText setStringValue:@"Address:"];
    [self setInfoTextFieldProperties:empAddressText];
    
    NSTextField *empAddress1 = [[NSTextField alloc] init];
    [self setInfoTextFieldProperties:empAddress1];
    [self trackInfoTextField:empAddress1 withIdentifier:@"address1"];
    
    NSTextField *empBlankText = [[NSTextField alloc] init];
    [empBlankText setStringValue:@""];
    [self setInfoTextFieldProperties:empBlankText];
    
    NSTextField *empAddress2 = [[NSTextField alloc] init];
    [self setInfoTextFieldProperties:empAddress2];
    [self trackInfoTextField:empAddress2 withIdentifier:@"address2"];
    
    NSTextField *empPayText = [[NSTextField alloc] init];
    [empPayText setStringValue:@"Pay:"];
    [self setInfoTextFieldProperties:empPayText];
    
    NSTextField *empPay = [[NSTextField alloc] init];
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
    [self setInfoTextFieldProperties:judgeName];
    [self trackInfoTextField:judgeName withIdentifier:@"judge_name"];
    
    NSTextField *judgeSiteText = [[NSTextField alloc] init];
    [judgeSiteText setStringValue:@"Office:"];
    [self setInfoTextFieldProperties:judgeSiteText];
    
    NSTextField *judgeSite = [[NSTextField alloc] init];
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

- (void)setSiteInfoBox
{
    [self clearInfoBox];
    
    [_infoBox setTitle:@"Office Information"];
    
    // Creates the text fields and places them in their appropriate areas.
    NSTextField *siteCodeText = [[NSTextField alloc] init];
    [siteCodeText setStringValue:@"Office Code:"];
    [self setInfoTextFieldProperties:siteCodeText];
    
    NSTextField *siteCode = [[NSTextField alloc] init];
    [self setInfoTextFieldProperties:siteCode];
    [self trackInfoTextField:siteCode withIdentifier:@"office_code"];
    
    NSTextField *siteNameText = [[NSTextField alloc] init];
    [siteNameText setStringValue:@"Name:"];
    [self setInfoTextFieldProperties:siteNameText];
    
    NSTextField *siteName = [[NSTextField alloc] init];
    [self setInfoTextFieldProperties:siteName];
    [self trackInfoTextField:siteName withIdentifier:@"name"];
    
    NSTextField *siteAddressText = [[NSTextField alloc] init];
    [siteAddressText setStringValue:@"Address:"];
    [self setInfoTextFieldProperties:siteAddressText];
    
    NSTextField *siteAddress1 = [[NSTextField alloc] init];
    [self setInfoTextFieldProperties:siteAddress1];
    [self trackInfoTextField:siteAddress1 withIdentifier:@"address1"];
    
    NSTextField *siteBlankText = [[NSTextField alloc] init];
    [siteBlankText setStringValue:@""];
    [self setInfoTextFieldProperties:siteBlankText];
    
    NSTextField *siteAddress2 = [[NSTextField alloc] init];
    [self setInfoTextFieldProperties:siteAddress2];
    [self trackInfoTextField:siteAddress2 withIdentifier:@"address2"];
    
    NSTextField *sitePhoneNumberText = [[NSTextField alloc] init];
    [sitePhoneNumberText setStringValue:@"Phone Number:"];
    [self setInfoTextFieldProperties:sitePhoneNumberText];
    
    NSTextField *sitePhoneNumber = [[NSTextField alloc] init];
    [self setInfoTextFieldProperties:sitePhoneNumber];
    [self trackInfoTextField:sitePhoneNumber withIdentifier:@"phone_number"];
    
    NSTextField *siteEmailText = [[NSTextField alloc] init];
    [siteEmailText setStringValue:@"Email:"];
    [self setInfoTextFieldProperties:siteEmailText];
    
    NSTextField *siteEmail = [[NSTextField alloc] init];
    [self setInfoTextFieldProperties:siteEmail];
    [self trackInfoTextField:siteEmail withIdentifier:@"email"];
    
    NSTextField *siteCanText = [[NSTextField alloc] init];
    [siteCanText setStringValue:@"CAN:"];
    [self setInfoTextFieldProperties:siteCanText];
    
    NSTextField *siteCan = [[NSTextField alloc] init];
    [self setInfoTextFieldProperties:siteCan];
    [self trackInfoTextField:siteCan withIdentifier:@"can"];
    
    NSTextField *sitePayText = [[NSTextField alloc] init];
    [sitePayText setStringValue:@"Pay:"];
    [self setInfoTextFieldProperties:sitePayText];
    
    NSTextField *sitePay = [[NSTextField alloc] init];
    [self setInfoTextFieldProperties:sitePay];
    [self trackInfoTextField:sitePay withIdentifier:@"pay"];
    
    NSTextField *siteActiveText = [[NSTextField alloc] init];
    [siteActiveText setStringValue:@"Active:"];
    [self setInfoTextFieldProperties:siteActiveText];
    
    NSButton *siteActiveCheck = [[NSButton alloc] initWithFrame:NSZeroRect];
    [siteActiveCheck setTitle:@""];
    [self setInfoButtonProperties:siteActiveCheck];
    [siteActiveCheck bind:@"value" toObject:controller withKeyPath:@"selection.active" options:nil];
    
    // Add all the text fields and buttons to the view.
    [_infoBox addSubview:siteCodeText];
    [_infoBox addSubview:siteCode];
    [_infoBox addSubview:siteNameText];
    [_infoBox addSubview:siteName];
    [_infoBox addSubview:siteAddressText];
    [_infoBox addSubview:siteAddress1];
    [_infoBox addSubview:siteBlankText];
    [_infoBox addSubview:siteAddress2];
    [_infoBox addSubview:sitePhoneNumberText];
    [_infoBox addSubview:sitePhoneNumber];
    [_infoBox addSubview:siteEmailText];
    [_infoBox addSubview:siteEmail];
    [_infoBox addSubview:siteCanText];
    [_infoBox addSubview:siteCan];
    [_infoBox addSubview:sitePayText];
    [_infoBox addSubview:sitePay];
    [_infoBox addSubview:siteActiveText];
    [_infoBox addSubview:siteActiveCheck];
    
    NSDictionary *infoBoxSubviews = NSDictionaryOfVariableBindings(siteCodeText, siteCode, siteNameText, siteName, siteAddressText,
                                                                   siteAddress1, siteBlankText, siteAddress2, sitePhoneNumberText, sitePhoneNumber,
                                                                   siteEmailText, siteEmail, siteCanText, siteCan, sitePayText, sitePay, siteActiveText,
                                                                   siteActiveCheck);
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[siteCodeText]-[siteCode]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[siteNameText]-[siteName]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[siteAddressText]-[siteAddress1]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[siteBlankText]-[siteAddress2]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[sitePhoneNumberText]-[sitePhoneNumber]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[siteEmailText]-[siteEmail]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[siteCanText]-[siteCan]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[sitePayText]-[sitePay]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[siteActiveText]-[siteActiveCheck]"
                                                                     options:NSLayoutFormatAlignAllCenterY
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[siteCodeText]-[siteNameText]-[siteAddressText]-[siteBlankText]-[sitePhoneNumberText]-[siteEmailText]-[siteCanText]-[sitePayText]-[siteActiveText]"
                                                                     options:NSLayoutFormatAlignAllTrailing
                                                                     metrics:nil
                                                                       views:infoBoxSubviews]];
    [_infoBox addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[siteCode]-[siteName]-[siteAddress1]-[siteAddress2]-[sitePhoneNumber]-[siteEmail]-[siteCan]-[sitePay]-[siteActiveCheck]"
                                                                     options:NSLayoutFormatAlignAllTrailing
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
        if (curTable == JUDGES) [self updateJudgeFieldsWithJudge:arrangedObjects[selection]];
        if (curTable == SITES) [self updateSiteFieldsWithSite:arrangedObjects[selection]];
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

- (void)updateJudgeFieldsWithJudge:(Judge *)judge
{
    for (NSTextField *textField in _infoTextFields) {
        NSString *identifier = textField.identifier;
        
        if ([identifier isEqualToString:@"judge_name"]) {
            [textField setStringValue:[NSString stringWithFormat:@"%@ %@", judge.first_name, judge.last_name]];
        }
        if ([identifier isEqualToString:@"judge_site"]) {
            Site *site;
            
            if (judge.office != nil) {
                NSPredicate *matchingSite = [NSPredicate predicateWithFormat:@"office_code == %@", judge.office];
                NSArray *results = [_sites filteredArrayUsingPredicate:matchingSite];
                if (results.count > 0) {
                    site = results[0];
                }
                if (site != nil) [textField setStringValue:[NSString stringWithFormat:@"%@, %@", site.name, site.office_code]];
                else [textField setStringValue:[NSString stringWithFormat:@"%@", judge.office]];
            }
        }
    }
}

- (void)updateSiteFieldsWithSite:(Site *)site
{
    for (NSTextField *textField in _infoTextFields) {
        NSString *identifer = textField.identifier;
        
        if ([identifer isEqualToString:@"office_code"]) [textField setStringValue:site.office_code];
        if ([identifer isEqualToString:@"name"]) [textField setStringValue:site.name];
        if ([identifer isEqualToString:@"address1"] || [identifer isEqualToString:@"address2"]) {
            // Seperates the string by commas so that it can be placed on two lines.
            NSArray *address = [site.address componentsSeparatedByString:@","];
            if (address.count > 0) {
                if ([identifer isEqualToString:@"address1"]) [textField setStringValue:address[0]];
                else {
                    // Builds the string piece by piece in case the address isn't broken apart correctly.
                    NSMutableString *address2 = [NSMutableString stringWithString:@""];
                    if (address.count > 1) [address2 appendString:
                                            [address[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    if (address.count > 2) [address2 appendFormat:@", %@",
                                            [address[2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    [textField setStringValue:address2];
                }
            }
        }
        if ([identifer isEqualToString:@"phone_number"]) {
            ECPhoneNumberFormatter *phoneFormatter = [[ECPhoneNumberFormatter alloc] init];
            [textField setStringValue:[phoneFormatter stringForObjectValue:site.phone_number]];
        }
        if ([identifer isEqualToString:@"email"]) [textField setStringValue:site.email];
        if ([identifer isEqualToString:@"can"]) [textField setStringValue:site.can];
        if ([identifer isEqualToString:@"pay"]) {
            NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
            [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
            [textField setStringValue:[NSString stringWithFormat:@"%@", [nf stringFromNumber:site.pay]]];
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
