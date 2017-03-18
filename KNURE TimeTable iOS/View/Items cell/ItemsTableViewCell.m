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
#import "EventParser.h"

@interface ItemsTableViewCell () <URLRequestDelegate>

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
    NSDictionary *parameters = @{@"id": item.id, @"title": item.title, @"type": [NSNumber numberWithInt:item.type]};
    [Request loadTimeTableWithParameters:parameters delegate:self];
}

#pragma mark - URLRequestDelegate

- (void)requestDidLoadTimeTable:(id)data info:(NSDictionary *)selectedItem {
    [[EventParser sharedInstance]parseTimeTable:data itemID:selectedItem[@"id"] callBack:^{
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", selectedItem[@"id"]];
        Item *item = [Item MR_findFirstWithPredicate:predicate];
        
        NSDate *lastUpdate = [NSDate date];
        
        self.detailTextLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"ItemList_Updated", nil), [lastUpdate timeAgoSinceNow]];
        
        [[NSUserDefaults standardUserDefaults]setObject:selectedItem forKey:@"TimetableSelectedItem"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.Shogunate.KNURE-Sked"];
        [sharedDefaults setObject:selectedItem forKey:@"TimetableSelectedItem"];
        [sharedDefaults synchronize];
        
        item.last_update = lastUpdate;
        [[item managedObjectContext] MR_saveToPersistentStoreAndWait];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"TimetableDidUpdateDataNotification" object:selectedItem];
        }
        
        [self.indicator stopAnimating];
    }];
}

- (void)requestDidFailWithError:(NSError *)error {
    [self.indicator stopAnimating];
    [self.delegate didFinishDownloadWithError:error];
}

@end
