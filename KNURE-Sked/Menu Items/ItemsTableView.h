//
//  GroupList.h
//  KNURE-Sked
//
//  Created by Oksana Kubiria on 08.11.13.
//  Copyright (c) 2013 Shogunate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsTableView : UITableViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    NSMutableData *responseData;
}

@property (strong, nonatomic) UIButton *menuButton;

@end