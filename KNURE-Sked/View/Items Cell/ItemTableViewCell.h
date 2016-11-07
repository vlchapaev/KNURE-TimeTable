//
//  ItemTableViewCell.h
//  KNURE TimeTable iOS
//
//  Created by Vlad Chapaev on 25.03.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *itemName;
@property (strong, nonatomic) IBOutlet UILabel *lastUpdate;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
