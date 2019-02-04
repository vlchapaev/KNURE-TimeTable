//
//  PopoverModalViewController.h
//  KNURE TimeTable
//
//  Created by Vladislav Chapaev on 01.03.17.
//  Copyright © 2017 Vladislav Chapaev. All rights reserved.
//

@import UIKit;

#import "EventParser.h"
#import "Lesson.h"

@protocol PopoverModalViewControllerDelegate <NSObject>

- (void)didSelectItem:(Item *)item;

/**
 Triggered by viewWillDisappear function, use body do deselect cell at given index path

 @param indexPath cell that must be deselected
 */
- (void)didDismissViewControllerWithSelectedIndexPath:(NSIndexPath *)indexPath;

@end

@interface PopoverModalViewController : UITableViewController

@property (weak, nonatomic) id <PopoverModalViewControllerDelegate> delegate;

/**
 Index path of selected cell used to fire deselect function on collection view after view disappear
 */
@property (strong, nonatomic) NSIndexPath *indexPath;

- (instancetype)initWithLesson:(Lesson *)lesson;

@end
