//
//  GroupListAddGroup.h
//  KNURE-Sked
//
//  Created by Влад on 1/5/14.
//  Copyright (c) 2014 Влад. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AddGroup : UIViewController <UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource, MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
    NSMutableArray *allResults;
    NSMutableArray *searchResults;
    NSMutableArray *selectedGroups;
    BOOL isFiltred;
}

@property (weak, nonatomic) IBOutlet UISearchBar *groupSearchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableViewGroups;

@end

BOOL shoudOffPanGesture;