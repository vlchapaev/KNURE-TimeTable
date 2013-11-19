//
//  ViewController.h
//  KNURE-Sked
//
//  Created by Влад on 10/24/13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIScrollViewDelegate> {
    IBOutlet UILabel *timer;
    IBOutlet UIScrollView *mainSkedView;
    IBOutlet UIView *timeLineView;
    CGPoint staticViewDefaultCenter;
    NSMutableData *receivedData;
}

@property (strong, nonatomic) UIButton *menuBtn;
- (void)getLastUpdate;

@end

