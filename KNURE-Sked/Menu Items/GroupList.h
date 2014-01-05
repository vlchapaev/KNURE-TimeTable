//
//  HistoryList.h
//  KNURE-Sked
//
//  Created by Oksana Kubiria on 08.11.13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupList : UITableViewController <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
- (void) getGroupId:(NSString *)grName;
@end
NSMutableArray *historyList;
NSMutableArray *fullList;
NSInteger thisYear;
NSInteger nextYear;
NSInteger previousYear;
NSInteger thisMonth;