//
//  ViewController.h
//  KNURE-Sked
//
//  Created by Влад on 10/24/13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REMenu.h"

@interface ViewController : UIViewController <UIScrollViewDelegate> {
    IBOutlet UILabel *timer;
    IBOutlet UIScrollView *mainSkedView;
    IBOutlet UIView *skedCell;
    IBOutlet UIView *timeLineView;
    int standartScrollPosition;
    NSMutableData *receivedData;
}

@property (strong, readwrite, nonatomic) REMenu *menu;
@property (strong, nonatomic) UIButton *toggleBtn;
@property (strong, nonatomic) UIButton *menuBtn;

- (void)getLastUpdate;

@end

