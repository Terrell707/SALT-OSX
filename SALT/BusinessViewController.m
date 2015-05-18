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
    if (selectedIndex == -1) [self setEmployeeTable];
    else [self selectTable];
    
}

- (IBAction)businessCombo:(id)sender {
    [self selectTable];
}

- (void)selectTable
{
    NSInteger selectedIndex = [_listOfTables indexOfSelectedItem];
    if (selectedIndex == 0) [self setEmployeeTable];
    else if (selectedIndex == 1) [self setSiteTable];
    else if (selectedIndex == 2) [self setJudgeTable];
    else if (selectedIndex == 3) [self setClerkTable];
    else if (selectedIndex == 4) [self setExpertTable];
}

- (void)setEmployeeTable
{
    _employees = [[DataController sharedDataController] employees];
    
    NSArray *columnIdentifers = [NSArray arrayWithObjects:@"emp_id", @"first_name", @"middle_init", @"last_name", @"phone_number", @"email", @"street", @"city", @"state", @"zip", @"pay", @"active", nil];
    NSArray *columnNames = [NSArray arrayWithObjects:@"Emp ID", @"First Name", @"M.I.", @"Last Name", @"Phone Number",
                            @"E-Mail", @"Street", @"City", @"State", @"Zip", @"Pay", @"Active", nil];
    NSArray *columnWidths = [NSArray arrayWithObjects:@"50.0", @"125.0", @"100.0", @"125.0", @"125.0", @"125.0", @"100.0", @"100.0", @"50.0", @"75.0", @"50.0", @"50.0", nil];
    
    [self changeTableWithColumnIdentifiers:columnIdentifers withNames:columnNames withWidths:columnWidths boundToData:_employees];
    
    [_infoBox setTitle:@"Employee Information"];
}

- (void)setSiteTable
{
    _sites = [[DataController sharedDataController] sites];
    
    NSArray *columnIdentifiers = [NSArray arrayWithObjects:@"office_code", @"name", @"address", @"email", @"can", @"pay", @"active", nil];
    NSArray *columnNames = [NSArray arrayWithObjects:@"Office Code", @"Office Name", @"Address", @"E-Mail", @"CAN No.", @"Pay", @"Active", nil];
    NSArray *columnWidths = [NSArray arrayWithObjects:@"75.0", @"125.0", @"175.0", @"125.0", @"100.0", @"100.0", @"75.0", nil];
    
    [self changeTableWithColumnIdentifiers:columnIdentifiers withNames:columnNames withWidths:columnWidths boundToData:_sites];
    
    [_infoBox setTitle:@"Office Information"];
}

- (void)setJudgeTable
{
    _judges = [[DataController sharedDataController] judges];
    
    NSArray *columnIdentifiers = [NSArray arrayWithObjects:@"office", @"first_name", @"last_name", @"active", nil];
    NSArray *columnNames  = [NSArray arrayWithObjects:@"Office", @"First Name", @"Last Name", @"Active", nil];
    NSArray *columnWidths = [NSArray arrayWithObjects:@"125.0", @"125.0", @"125.0", @"50.0", nil];
    
    [self changeTableWithColumnIdentifiers:columnIdentifiers withNames:columnNames withWidths:columnWidths boundToData:_judges];
    
    [_infoBox setTitle:@"Judge Information"];
}

- (void)setClerkTable
{
    // ADD CLERK ARRAY INFORMATION HERE!!!
//    _clerks = [[DataController sharedDataController] clerks];
    
    NSArray *columnIdentifiers = [NSArray arrayWithObjects:@"first_name", @"last_name", @"email", nil];
    NSArray *columnNames = [NSArray arrayWithObjects:@"First Name", @"Last Name", @"E-Mail", nil];
    NSArray *columnWidths = [NSArray arrayWithObjects:@"125.0", @"125.0", @"125.0", nil];
    
//    [self changeTableWithColumnIdentifiers:columnIdentifiers withNames:columnNames boundToData:_clerks withEnitity:@"Clerk"];
    
    [_infoBox setTitle:@"Clerk Information"];
}

- (void)setExpertTable
{
    _experts = [[DataController sharedDataController] experts];
    
    NSArray *columnIdentifiers = [NSArray arrayWithObjects:@"first_name", @"last_name", @"role", @"active", nil];
    NSArray *columnNames = [NSArray arrayWithObjects:@"First Name", @"Last Name", @"Role", @"Active", nil];
    NSArray *columnWidths = [NSArray arrayWithObjects:@"125.0", @"125.0", @"50.0", @"50.0", nil];
    
    [self changeTableWithColumnIdentifiers:columnIdentifiers withNames:columnNames withWidths:columnWidths boundToData:_experts];
    
    [_infoBox setTitle:@"Expert Information"];
}

- (void)changeTableWithColumnIdentifiers:(NSArray *)columnIdentifiers withNames:(NSArray *)columnNames withWidths:(NSArray *)columnWidths boundToData:(NSArray *)data
{
    // Removes each column from the business table.
    [businessTable setDelegate:self];
    NSArray *columns = [businessTable tableColumns];
    for (NSInteger x = columns.count - 1; x >= 0; x--) {
        [businessTable removeTableColumn:columns[x]];
    }
    
    // Binds the data to a controller so that the data will be displayed in the table.
    [controller setContent:data];
    [controller setEditable:NO];
    
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

//- (void)setEmployeeInfoBox
//{
//    NSTextField *name = [[NSTextField alloc] init];
//    NSFont *defaultFont = [NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:[[name cell] controlSize]]];
//    [name setStringValue:@"Testing:"];
//    [name setEditable:NO];
//    [name setBordered:NO];
//    [name setBezeled:NO];
//    [name setDrawsBackground:NO];
//    [name setFont:defaultFont];
//    [name sizeToFit];
//    [_infoBox addSubview:name];
//    
//    NSLog(@"Test Label Width %f, Height: %f", name.fittingSize.width, name.fittingSize.height);
//    NSLog(@"Id Label: X: %f Y: %f", _idLabel.frame.origin.x, _idLabel.frame.origin.y);
//    NSLog(@"Info Box Height: %f, Width %f", _infoBox.fittingSize.height, _infoBox.fittingSize.width);
//    
//    CGFloat x = NSMaxX(_idLabel.frame) - name.fittingSize.width;
//    CGFloat y = _idLabel.frame.origin.y - name.fittingSize.height;
//    
//    [name setFrame:CGRectMake(x, y, name.fittingSize.width, name.fittingSize.height)];
//}

@end
