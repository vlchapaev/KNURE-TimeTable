//
//  MainIPhoneController.h
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 10/24/13.
//  Copyright (c) 2013 Shogunate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNBlurModalView.h"
#import "ModalViewController.h"
#import "InitViewController.h"
#import "REMenu.h"
#import "Timer.h"
#import "EventHandler.h"

@interface MainIPhoneController : UIViewController <UIScrollViewDelegate> {
    IBOutlet UILabel *timerLabel;
    IBOutlet UIButton *toggleButton;
    IBOutlet UIScrollView *mainSkedView;
    IBOutlet UIView *timeLineView;
    UIScrollView *remenuScroller;
    UIView *remenuView;
    UIView *timeLineIndicator;
    UIView *skedLineIndicator;
    UIView *newTimeLine;
    RNBlurModalView *modal;
    NSString *REMenuTitle;
    int remenuSize;
    int standartScrollPosition;
    int maxContentSize;
    Timer *timer;
    EventHandler *eventHandler;
}

@property (strong, readwrite, nonatomic) REMenu *menu;
@property (strong, nonatomic) UIButton *menuButton;
@property (nonatomic) UILabel *date;
@property (nonatomic) UILabel *sked;
@property (nonatomic, copy) UIView *skedCell;

- (void)drawMainView;
- (void)initToggleMenu;
- (void)initAnimation;
- (double)getAnimationDuration;
- (double)getYPosition;

@end

BOOL viewNotFirstTimeShown;
BOOL shoudOffPanGesture;