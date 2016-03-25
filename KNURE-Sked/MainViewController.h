//
//  MainIPhoneController.h
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 24.10.2013.
//  Copyright (c) 2013 Shogunate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "InitViewController.h"
#import "REMenu.h"
#import "Timer.h"
#import "EventHandler.h"

@interface MainViewController : UIViewController <UIScrollViewDelegate> {
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

@property (nonatomic) NSUInteger colorIndex;

- (void)drawMainView;
- (void)initToggleMenu;

/**
 Инициализирует красный индикатор на шкале времени
 и на view с расписанием
 */
- (void)initAnimation;

/**
 Возвращает время, которое необходимо до завершения анимации
 @return время в секундах
 */
- (double)getAnimationDuration;

/**
 Позволяет получить значение высоты шкалы времени относительнго текущего времени
 Принцип работы описан внутри
 @return позиция Y для шкалы времени
 */
- (double)getYPosition;

@end

BOOL viewNotFirstTimeShown;
BOOL shoudOffPanGesture;