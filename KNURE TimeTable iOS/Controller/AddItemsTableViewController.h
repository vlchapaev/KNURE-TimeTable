//
//  AddItemsTableViewController.h
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 01.05.2014.
//  Copyright (c) 2016 Vlad Chapaev. All rights reserved.
//

@import UIKit;

#import <MagicalRecord/MagicalRecord.h>

#import "EventParser.h"

@protocol AddItemsTableViewControllerDelegate <NSObject>

@required
- (void)didSelectItem:(NSDictionary *)record ofType:(ItemType)type;

@end

@interface AddItemsTableViewController : UITableViewController

@property (assign, nonatomic) ItemType itemType;

@property (weak, nonatomic) id <AddItemsTableViewControllerDelegate> delegate;

@end
