//
//  ItemsTableViewController.h
//  KNURE TimeTable iOS
//
//  Created by Oksana Kubiria on 08.11.13.
//  Copyright (c) 2013 Vlad Chapaev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EventParser.h"

@interface ItemsTableViewController : UITableViewController

@property (assign, nonatomic) ItemType itemType;
@property (strong, nonatomic) NSString *headerTitle;

@end
