//
//  GroupListAddGroup.h
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 01.05.2014.
//  Copyright (c) 2014 Shogunate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AddItemsTableView : UITableViewController <UISearchBarDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate, MBProgressHUDDelegate> 

@property (weak, nonatomic) IBOutlet UISearchBar *groupSearchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableViewGroups;

@end

BOOL shoudOffPanGesture;