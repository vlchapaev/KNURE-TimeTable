//
//  HistoryList.h
//  KNURE-Sked
//
//  Created by Oksana Kubiria on 08.11.13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryList : UITableViewController
@property (strong, nonatomic) UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
- (IBAction)addName:(id)sender;
- (void) getGroupId:(NSString *)grName;
@end
NSMutableArray *historyList;
NSInteger thisYear;
NSInteger nextYear;
NSInteger thisMonth;