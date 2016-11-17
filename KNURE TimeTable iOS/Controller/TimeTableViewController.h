//
//  TimeTableViewController.h
//  KNURE TimeTable iOS
//
//  Created by Vlad Chapaev on 24.10.2013.
//  Copyright (c) 2016 Vlad Chapaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecord.h>

extern NSString *const TimetableSelectedItem;
extern NSString *const TimetableHorizontalMode;
extern NSString *const TimetableIsDarkMode;
extern NSString *const TimetableDrawEmptyDays;

@interface TimeTableViewController : UICollectionViewController

@property (strong, nonatomic) IBOutlet UIButton *groupButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

- (IBAction)refreshCurrentTimeTable;
- (IBAction)groupButtonTap;

@end
