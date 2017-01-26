//
//  TimeTableViewController.h
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 24.10.2013.
//  Copyright (c) 2016 Vlad Chapaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecord.h>

extern NSString *const TimetableSelectedItem;
extern NSString *const TimetableVerticalMode;
extern NSString *const TimetableIsDarkMode;
extern NSString *const TimetableDrawEmptyDays;

@interface TimeTableViewController : UICollectionViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

/**
 Используется для перерисовки интерфейса при повороте экрана
*/
- (void)resizeHeightForSize:(CGSize)size;

- (IBAction)refreshCurrentTimeTable;

@end
