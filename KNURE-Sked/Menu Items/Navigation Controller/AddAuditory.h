//
//  AddAuditory.h
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 23.01.15.
//  Copyright (c) 2015 Влад. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AddAuditory : UIViewController <UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource, MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
    NSMutableArray *allResults;
    NSMutableArray *searchResults;
    NSMutableArray *selectedAuditory;
    BOOL isFiltred;
}

@property (weak, nonatomic) IBOutlet UISearchBar *auditorySearchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableViewAuditories;

@end

BOOL shoudOffPanGesture;
