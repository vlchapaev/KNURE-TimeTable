//
//  TimeTableViewController.h
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 24.10.2013.
//  Copyright (c) 2016 Vlad Chapaev. All rights reserved.
//

@import UIKit;
@import CoreData;

#import "Item+CoreDataClass.h"

@interface TimeTableViewController : UICollectionViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

/**
 Used to redraw collection view after device rotation
*/
- (void)resizeHeightForSize:(CGSize)size;

/**
 Called when application open in split mode on iPad
 */
- (void)traitCollectionDidChange;

- (void)setupFetchRequestWithItem:(Item *)selectedItem;
- (void)setupProperties;
- (void)didSelectItem:(Item *)item;

- (IBAction)refreshCurrentTimeTable;

@end
