//
//  Settings.h
//  KNURE-Sked
//
//  Created by Влад on 11/2/13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings : UIViewController <UIGestureRecognizerDelegate> {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UILabel *fontLable;
    IBOutlet UISwitch *showEmptyDaysSwith;
}
- (IBAction)fontSizeChanged:(UISlider *)sender;
- (IBAction)showEmptyDaysChanged:(UISwitch *)sender;
- (IBAction)showYearChanged:(UISwitch *)sender;
- (IBAction)showWeekChanged:(UISwitch *)sender;
- (IBAction)automaticUpdateChanged:(UISwitch *)sender;

@property (strong, nonatomic) UIButton *menuBtn;

@end