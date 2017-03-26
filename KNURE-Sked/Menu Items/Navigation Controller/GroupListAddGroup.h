//
//  GroupListAddGroup.h
//  KNURE-Sked
//
//  Created by Влад on 1/5/14.
//  Copyright (c) 2014 Влад. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupListAddGroup : UITableViewController <UISearchBarDelegate, UITableViewDataSource> {
    NSMutableArray *allResults;
    NSMutableArray *searchResults;
    NSMutableArray *selectedGroups;
    BOOL isFiltred;
}

@property (weak, nonatomic) IBOutlet UISearchBar *groupSearchBar;

@end