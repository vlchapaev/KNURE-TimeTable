//
//  TimeTableViewController.h
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 24.10.2013.
//  Copyright (c) 2016 Vlad Chapaev. All rights reserved.
//

@import UIKit;
@import CoreData;

@interface TimeTableViewController : UICollectionViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

/**
 Used to redraw collection view after device rotation
*/
- (void)resizeHeightForSize:(CGSize)size;

/**
 Called when application open in split mode on iPad
 */
- (void)traitCollectionDidChange;

- (void)setupFetchRequestWithItem:(NSDictionary *)selectedItem;
- (void)setupProperties;
- (void)didSelectItemWithParameters:(NSDictionary *)parameters;

- (IBAction)refreshCurrentTimeTable;

@end
