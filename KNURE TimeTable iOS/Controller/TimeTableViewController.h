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
extern NSString *const TimetableBouncingCells;
extern NSString *const TimetableDidUpdateDataNotification;

@interface TimeTableViewController : UICollectionViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

/**
 Используется для перерисовки интерфейса при повороте экрана
*/
- (void)resizeHeightForSize:(CGSize)size;

- (void)setupFetchRequestWithItem:(NSDictionary *)selectedItem;
- (void)setupProperties;
- (void)didSelectItemWithParameters:(NSDictionary *)parameters;

- (IBAction)refreshCurrentTimeTable;

@end
