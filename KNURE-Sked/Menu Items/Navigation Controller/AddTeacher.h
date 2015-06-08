//
//  TeacherListAddTeacher.h
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 01.05.2014.
//  Copyright (c) 2014 Shogunate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AddTeacher : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
    NSMutableArray *allResults;
    NSMutableArray *searchResults;
    NSMutableArray *selectedTeachers;
    BOOL isFiltred;
}

@property (weak, nonatomic) IBOutlet UISearchBar *teacherSearchBar;
@property (strong, nonatomic) IBOutlet UITableView *teachersTableView;

@end

BOOL shoudOffPanGesture;