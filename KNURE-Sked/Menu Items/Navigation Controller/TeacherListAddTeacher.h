//
//  TeacherListAddTeacher.h
//  KNURE-Sked
//
//  Created by Влад on 1/5/14.
//  Copyright (c) 2014 Влад. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherListAddTeacher : UITableViewController <UISearchBarDelegate, UITableViewDataSource> {
    NSMutableArray *allResults;
    NSMutableArray *searchResults;
    NSMutableArray *selectedTeachers;
    BOOL isFiltred;
}

@property (weak, nonatomic) IBOutlet UISearchBar *teacherSearchBar;

@end
