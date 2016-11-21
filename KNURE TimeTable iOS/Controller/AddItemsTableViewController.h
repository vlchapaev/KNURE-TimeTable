//
//  AddItemsTableViewController.h
//  KNURE TimeTable iOS
//
//  Created by Vlad Chapaev on 01.05.2014.
//  Copyright (c) 2016 Vlad Chapaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MagicalRecord/MagicalRecord.h>

#import "EventParser.h"

@interface AddItemsTableViewController : UITableViewController

@property (assign, nonatomic) ItemType itemType;

@end
