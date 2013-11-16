//
//  ViewController.h
//  KNURE-Sked
//
//  Created by Влад on 10/24/13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    IBOutlet UILabel *currentTime;
    NSMutableData *receivedData;
}

@property (strong, nonatomic) IBOutlet UIView *hadView;
@property (strong, nonatomic) UIButton *menuBtn;
@property (strong, nonatomic) IBOutlet UILabel *timerView;
- (void)getLastUpdate;

@end

