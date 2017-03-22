//
//  ItemsTableViewCell.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 11.03.17.
//  Copyright © 2017 Vlad Chapaev. All rights reserved.
//

#import "ItemsTableViewCell.h"
#import "NSDate+DateTools.h"
#import "Request.h"
#import "Configuration.h"

@interface ItemsTableViewCell () <URLRequestDelegate, EventParserDelegate>

@property (strong, nonatomic) UIActivityIndicatorView *indicator;

@end

@implementation ItemsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.accessoryView = self.indicator;
    }
    return self;
}
#pragma mark - Setup

- (void)setItem:(Item *)item {
    _item = item;
    self.textLabel.text = item.title;
    self.textLabel.numberOfLines = 0;
    self.textLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
    self.textLabel.textColor = [UIColor blackColor];
    
    self.detailTextLabel.text = (item.last_update) ? [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"ItemList_Updated", nil), [item.last_update timeAgoSinceNow]] : NSLocalizedString(@"ItemList_Not_Updated", nil);
    self.detailTextLabel.textColor = [UIColor lightGrayColor];
}

#pragma mark - Implementation

- (void)updateItem:(Item *)item {
    [self.indicator startAnimating];
    [Request loadTimeTableForItem:item delegate:self];
}

- (void)exportToCalendar:(Item *)item inRange:(CalendarExportRange)range {
    [self.indicator startAnimating];
    [[EventParser sharedInstance]setDelegate:self];
    [[EventParser sharedInstance]exportToCalendar:item inRange:range];
}

#pragma mark - URLRequestDelegate

- (void)requestDidLoadTimeTable:(id)data forItem:(Item *)item {
    [[EventParser sharedInstance]parseTimeTable:data itemID:item.id callBack:^{
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", item.id];
        Item *item = [Item MR_findFirstWithPredicate:predicate];
        
        NSDate *lastUpdate = [NSDate date];
        
        self.detailTextLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"ItemList_Updated", nil), [lastUpdate timeAgoSinceNow]];
        
        item.last_update = lastUpdate;
        [item saveAsSelectedItem];
        [[item managedObjectContext] MR_saveToPersistentStoreAndWait];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [[NSNotificationCenter defaultCenter]postNotificationName:TimetableDidUpdateDataNotification object:item];
        }
        
        [self.indicator stopAnimating];
    }];
}

- (void)requestDidFailWithError:(NSError *)error {
    [self.indicator stopAnimating];
    [self.delegate didFinishDownloadWithError:error];
}

#pragma mark - EventParserDelegate

- (void)didFinishExportToCalendar {
    [self.indicator stopAnimating];
}

- (void)exportToCalendaerFailedWithError:(NSError *)error {
    [self.indicator stopAnimating];
    [self.delegate calendarExportDidFinishWithError:error];
}

@end
