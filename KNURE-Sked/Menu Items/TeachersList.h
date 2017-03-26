//
//  TeachersList.h
//  KNURE-Sked
//
//  Created by Влад on 11/10/13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeachersList : UITableViewController <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *teacherField;
@property (strong, nonatomic) UIButton *menuBtn;
- (void) getTeacherId:(NSString *)tchrName;
@end
NSMutableArray *teachersList;
NSMutableArray *fullList;
NSInteger thisYear;
NSInteger nextYear;
NSInteger previousYear;
NSInteger thisMonth;