//
//  ItemsTableViewCell.h
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 11.03.17.
//  Copyright © 2017 Vlad Chapaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item+CoreDataProperties.h"

@protocol ItemsTableViewCellDelegate <NSObject>

@required
- (void)didFinishDownloadWithError:(NSError *)error;

@end

@interface ItemsTableViewCell : UITableViewCell

@property (weak, nonatomic) Item *item;

@property (weak, nonatomic) id <ItemsTableViewCellDelegate> delegate;

- (void)updateItem:(Item *)item;

@end
