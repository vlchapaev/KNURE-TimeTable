//
//  GroupListAddGroup.h
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 01.05.2014.
//  Copyright (c) 2014 Shogunate. All rights reserved.
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