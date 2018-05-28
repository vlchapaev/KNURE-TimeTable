//
//  ItemsTableViewCell.h
//  KNURE TimeTable
//
//  Created by Vladislav Chapaev on 11.03.17.
//  Copyright © 2017 Vladislav Chapaev. All rights reserved.
//

@import UIKit;

#import "Item.h"
#import "EventParser.h"

@protocol ItemsTableViewCellDelegate <NSObject>

@optional
- (void)calendarExportDidFinishWithError:(NSError *)error;
- (void)didFinishDownloadWithError:(NSError *)error;

@end

@interface ItemsTableViewCell : UITableViewCell

@property (weak, nonatomic) Item *item;

@property (weak, nonatomic) id <ItemsTableViewCellDelegate> delegate;

/**
 Update the timetable of selected item

 @param item
 */
- (void)updateItem:(Item *)item;

/**
 Events that belong to listed item will be export to iOS calendar
 
 @param item listed item
 @param range range of date to export
 */
- (void)exportToCalendar:(Item *)item inRange:(CalendarExportRange)range;

@end
