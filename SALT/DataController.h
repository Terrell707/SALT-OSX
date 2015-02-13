//
//  DataController.h
//  SALT
//
//  Created by Adrian T. Chambers on 2/12/15.
//  Copyright (c) 2015 Adrian T. Chambers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MySQL.h"
#import "StatusCodes.h"
#import "Ticket.h"

@interface DataController : NSObject {
    MySQL *mySQL;
    StatusCodes *statusChecker;
}

+ (DataController *)sharedDataController;
- (void)loadData;

@property (readwrite, copy) NSMutableArray *tickets;

@end
