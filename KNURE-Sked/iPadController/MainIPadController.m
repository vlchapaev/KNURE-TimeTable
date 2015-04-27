//
//  MainIPadViewController.m
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 07.09.14.
//  Copyright (c) 2014 Влад. All rights reserved.
//

#import "MainIPadController.h"
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@implementation MainIPadController

@synthesize menuButton, skedCell, sked, date;

-(void)cleanOldCache {
    if(![[NSUserDefaults standardUserDefaults]boolForKey:@"CacheCleaned"]){
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SavedGroups"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SavedTeachers"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ID"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"CacheCleaned"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cleanOldCache];
    
    timer = [[Timer alloc]initDateFormatter];
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"ID"]) {
        eventHandler = [[EventHandler alloc]init];
        [timer initTimerWithEvent:eventHandler.events];
        [self timeUpdate];
        NSTimer *skedTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                              target:self
                                                            selector:@selector(timeUpdate)
                                                            userInfo:nil
                                                             repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:skedTimer forMode:NSRunLoopCommonModes];
        [self drawMainView];
        [self addDoubleTapGesture];
        [self initToggleMenu];
        [self drawLines];
    } else {
        [timeLineView removeFromSuperview];
        [timerLebel removeFromSuperview];
        UIImageView *hint = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Hint"]];
        [mainSkedView addSubview:hint];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    isTablet = YES;
    shoudOffPanGesture = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    shoudOffPanGesture = NO;
}

- (void)drawLines {
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(deleteSkedLine)
                                                name:UIApplicationWillEnterForegroundNotification
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(initAnimation)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
    if(viewNotFirstTimeShown) {
        [self initAnimation];
    } else {
        viewNotFirstTimeShown = YES;
    }
}

- (void)redraw {
    [toggleButton removeFromSuperview];
    [[mainSkedView subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self deleteSkedLine];
    eventHandler = [[EventHandler alloc]init];
    [timer initTimerWithEvent:eventHandler.events];
    [self drawMainView];
    [self initToggleMenu];
    [self drawLines];
}

#pragma mark - методы отрисовки главной вьюшки расписния

- (void)drawMainView {
    maxContentSize = 895;
    int dayShift = 0;
    int lessonShift = 25;
    int scrollViewSize = 0;
    int eventIndex = 0;
    int numberPair;
    NSArray *dateList = [self getDateList];
    NSDate *startLessonDate = [NSDate dateWithTimeIntervalSince1970:
                               [[[eventHandler.events objectAtIndex:eventIndex]valueForKey:@"start_time"]doubleValue]];
    NSDate *nextLessonStartDate;
    NSString *name = [[NSUserDefaults standardUserDefaults]valueForKey:@"curName"];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.Shogunate.KNURE-Sked"];
            [sharedDefaults setObject:name forKey:@"SkedEx_Name"];
            [sharedDefaults setObject:eventHandler.schedule forKey:@"SkedEx_Schedule"];
            [sharedDefaults synchronize];
        });
    });
    
    NSString *todayDate = [timer.dayMonthYear stringFromDate:[[NSDate alloc]init]];
    
    for(NSDate *lessonDate in dateList) {
        date = [[UILabel alloc]initWithFrame:CGRectMake(dayShift + 75, 5, 105, 20)];
        date.text = [timer.dayMonthWeekDay stringFromDate:lessonDate];
        date.textAlignment = NSTextAlignmentCenter;
        [date setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 18.0f]];
        [mainSkedView addSubview:date];
        
        
        if([todayDate isEqualToString:[timer.dayMonthYear stringFromDate:lessonDate]]) {
            mainSkedView.contentOffset = CGPointMake(dayShift + 2, 0);
            standartScrollPosition = dayShift + 2;
        }
        
        while ([[timer.dayMonthYear stringFromDate:startLessonDate] isEqualToString: [timer.dayMonthYear stringFromDate:lessonDate]]) {
            if (eventIndex +1 >= eventHandler.events.count) {
                numberPair = [[[eventHandler.events objectAtIndex:eventIndex]valueForKey:@"number_pair"]intValue];
                lessonShift += (numberPair - 1) * 110;
                goto  m1;
            }
            nextLessonStartDate = [NSDate dateWithTimeIntervalSince1970:
                                   [[[eventHandler.events objectAtIndex:eventIndex + 1]valueForKey:@"start_time"]doubleValue]];
            
            numberPair = [[[eventHandler.events objectAtIndex:eventIndex]valueForKey:@"number_pair"]intValue];
            lessonShift += (numberPair - 1) * 110;
            
            if (numberPair == [[[eventHandler.events objectAtIndex:eventIndex + 1]valueForKey:@"number_pair"]intValue] &&
                [[timer.dayMonthYear stringFromDate:nextLessonStartDate] isEqualToString: [timer.dayMonthYear stringFromDate:startLessonDate]]) {
                UIScrollView *buildInView = [[UIScrollView alloc]initWithFrame:CGRectMake(dayShift + 75, lessonShift + 5, 110, 105)];
                UIImageView *link = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Link"]];
                int innerYPosition = 0;
                while (numberPair == [[[eventHandler.events objectAtIndex:eventIndex]valueForKey:@"number_pair"]intValue]) {
                    sked = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 110, 105)];
                    skedCell = [[UIView alloc]initWithFrame:CGRectMake(0, 0 + innerYPosition, 110, 105)];
                    
                    sked.text = [eventHandler getLessonByIndex:eventIndex];
                    sked.textAlignment = NSTextAlignmentCenter;
                    sked.numberOfLines = 3;
                    sked.lineBreakMode = 5;
                    [sked setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 18.0f]];
                    skedCell.backgroundColor = [eventHandler getCellColorBy:[[[eventHandler.events objectAtIndex:eventIndex]valueForKey:@"type"]integerValue]];
                    skedCell.tag = eventIndex;
                    
                    [skedCell addSubview:sked];
                    [buildInView addSubview:skedCell];
                    innerYPosition += 110;
                    eventIndex++;
                    [self addTapGesture];
                    if (eventIndex >= eventHandler.events.count) {
                        break;
                    }
                }
                [buildInView addSubview:link];
                buildInView.contentSize = CGSizeMake(0, innerYPosition - 5);
                lessonShift = 25;
                innerYPosition = 0;
                [mainSkedView addSubview:buildInView];
            } else {
            m1:
                sked = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 110, 105)];
                skedCell = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 75, lessonShift + 5, 110, 105)];
                
                sked.text = [eventHandler getLessonByIndex:eventIndex];
                sked.textAlignment = NSTextAlignmentCenter;
                sked.numberOfLines = 3;
                sked.lineBreakMode = 5;
                [sked setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 18.0f]];
                skedCell.backgroundColor = [eventHandler getCellColorBy:[[[eventHandler.events objectAtIndex:eventIndex]valueForKey:@"type"]integerValue]];
                skedCell.tag = eventIndex;
                [skedCell addSubview:sked];
                [mainSkedView addSubview:skedCell];
                eventIndex++;
                
                lessonShift = 25;
                [self addTapGesture];
                if (eventIndex >= eventHandler.events.count) {
                    break;
                }
            }
            if (eventIndex >= eventHandler.events.count) {
                break;
            }
            startLessonDate = [NSDate dateWithTimeIntervalSince1970:
                               [[[eventHandler.events objectAtIndex:eventIndex]valueForKey:@"start_time"]doubleValue]];
        }
        dayShift += 110 + 5;
        scrollViewSize += 110 + 6;
    }
    
    mainSkedView.contentSize = CGSizeMake(scrollViewSize, maxContentSize);
    newTimeLine = timeLineView;
    CGPoint content = [mainSkedView contentOffset];
    CGRect contentOffset = [mainSkedView bounds];
    CGRect center = CGRectMake(contentOffset.origin.x, contentOffset.origin.y+1+(content.y*(-1)), 70, 895);
    [newTimeLine setFrame:center];
    [mainSkedView addSubview:newTimeLine];
}

- (NSArray *)getDateList {
    NSInteger thisYear = [[timer.dateFormatterYear stringFromDate:timer.today] integerValue];
    NSInteger thisMonth = [[timer.dateFormatterMonth stringFromDate:timer.today] integerValue];
    NSInteger nextYear = thisYear + 1;
    NSInteger previousYear = thisYear - 1;
    NSString *startDate;
    NSString *endDate;
    
    if (thisMonth >= 8 && thisMonth <= 12) {
        startDate = [NSString stringWithFormat:@"%@%ld", @"01.09.", (long)thisYear];
        endDate = [NSString stringWithFormat:@"%@%ld", @"31.01.", (long)nextYear];
    } else
        if (thisMonth == 1) {
            startDate = [NSString stringWithFormat:@"%@%ld", @"01.09.", (long)previousYear];
            endDate = [NSString stringWithFormat:@"%@%ld", @"01.07.", (long)thisYear];
        } else {
            startDate = [NSString stringWithFormat:@"%@%ld", @"31.01.", (long)thisYear];
            endDate = [NSString stringWithFormat:@"%@%ld", @"01.07.", (long)thisYear];
        }
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    NSMutableArray *dateList = [NSMutableArray array];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    
    NSDate *currentDate = [timer.dayMonthYear dateFromString:startDate];
    [dateList addObject: currentDate];
    NSDate *endCurrentDate = [timer.dayMonthYear dateFromString:endDate];
    
    currentDate = [currentCalendar dateByAddingComponents:comps toDate:currentDate  options:0];
    while ( [endCurrentDate compare:currentDate] != NSOrderedAscending) {
        [dateList addObject:currentDate];
        currentDate = [currentCalendar dateByAddingComponents:comps toDate:currentDate  options:0];
    }
    return dateList;
}

#pragma mark - методы для мультитач жестов

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint content = [mainSkedView contentOffset];
    CGRect contentOffset = [mainSkedView bounds];
    CGRect center = CGRectMake(contentOffset.origin.x, contentOffset.origin.y+1+(content.y*(-1)), 70, 895);
    [newTimeLine setFrame:center];
}

- (void)addDoubleTapGesture {
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapOnMainSkedView:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    [mainSkedView addGestureRecognizer:doubleTapRecognizer];
}

- (void)addTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnCell:)];
    tap.numberOfTapsRequired = 1;
    [skedCell addGestureRecognizer:tap];
}

- (void)tapOnCell:(UIGestureRecognizer *)recogniser {
    skedCell = recogniser.view;
    ModalViewController *modalVC = [[ModalViewController alloc]initWithDictionary:eventHandler.schedule index:skedCell.tag isTablet:YES];
    modal = [[RNBlurModalView alloc]initWithView:modalVC.view];
    modal.dismissButtonRight = YES;
    [modal show];
    
}

- (void)doubleTapOnMainSkedView:(UITapGestureRecognizer *)recogniser {
    mainSkedView.contentOffset = CGPointMake(standartScrollPosition, 0);
}

#pragma mark - методы для выпадающего меню

- (void)initToggleMenu {
    REMenuTitle = [NSString stringWithFormat:@"%@%@",
                   [[NSUserDefaults standardUserDefaults] valueForKey:@"curName"],
                   @" ⌵"];
    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"curName"]) {
        REMenuTitle = @"";
    }
    
    toggleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [toggleButton setTintColor:[UIColor blackColor]];
    [toggleButton setTitle:REMenuTitle forState:UIControlStateNormal];
    [toggleButton.titleLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 22.0f]];
    [toggleButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = toggleButton;
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    NSArray *groupList = [[NSUserDefaults standardUserDefaults] valueForKey:@"SavedGroups"];
    NSArray *teacherList = [[NSUserDefaults standardUserDefaults] valueForKey:@"SavedTeachers"];
    NSArray *auditoryList = [[NSUserDefaults standardUserDefaults] valueForKey:@"SavedAuditories"];
    remenuSize = 0;
    int index = 0;
    for (NSString *group in [groupList valueForKey:@"title"]) {
        REMenuItem *groupItem = [[REMenuItem alloc] initWithTitle:group
                                                            image:[UIImage imageNamed:@"---"]
                                                 highlightedImage:nil
                                                           action:^(REMenuItem *item) {
                                                               [[NSUserDefaults standardUserDefaults]setValue:[[groupList objectAtIndex:index]valueForKey:@"key"] forKey:@"ID"];
                                                               [[NSUserDefaults standardUserDefaults]setValue:[[groupList objectAtIndex:index]valueForKey:@"title"] forKey:@"curName"];
                                                               [[NSUserDefaults standardUserDefaults]synchronize];
                                                               [self redraw];
                                                           }];
        [items addObject:groupItem];
        remenuSize += 50;
        index++;
    }
    index = 0;
    for (NSString *teacher in [teacherList valueForKey:@"title"]) {
        REMenuItem *teacherItem = [[REMenuItem alloc] initWithTitle:teacher
                                                              image:[UIImage imageNamed:@"---"]
                                                   highlightedImage:nil
                                                             action:^(REMenuItem *item) {
                                                                 [[NSUserDefaults standardUserDefaults]setValue:[[teacherList objectAtIndex:index]valueForKey:@"key"] forKey:@"ID"];
                                                                 [[NSUserDefaults standardUserDefaults]setValue:[[teacherList objectAtIndex:index]valueForKey:@"title"] forKey:@"curName"];
                                                                 [[NSUserDefaults standardUserDefaults]synchronize];
                                                                 [self redraw];
                                                             }];
        [items addObject:teacherItem];
        remenuSize += 50;
        index++;
    }
    index = 0;
    for(NSString *auditory in [auditoryList valueForKey:@"title"]) {
        REMenuItem *auditoryItem = [[REMenuItem alloc] initWithTitle:auditory
                                                               image:[UIImage imageNamed:@"---"]
                                                    highlightedImage:nil
                                                              action:^(REMenuItem *item) {
                                                                  [[NSUserDefaults standardUserDefaults]setValue:[[auditoryList objectAtIndex:index]valueForKey:@"key"]forKey:@"ID"];
                                                                  [[NSUserDefaults standardUserDefaults]setValue:[[auditoryList objectAtIndex:index]valueForKey:@"title"]forKey:@"curName"];
                                                                  [[NSUserDefaults standardUserDefaults]synchronize];
                                                                  [self redraw];
                                                              }];
        [items addObject:auditoryItem];
        remenuSize += 50;
        index++;
    }
    
    self.menu = [[REMenu alloc]initWithItems:items];
    self.menu.liveBlur = YES;
    self.menu.bounce = YES;
    self.menu.appearsBehindNavigationBar = YES;
    self.menu.liveBlurBackgroundStyle = REMenuLiveBackgroundStyleLight;
    self.menu.borderColor = [UIColor clearColor];
    self.menu.textShadowColor = [UIColor clearColor];
    self.menu.backgroundColor = [UIColor clearColor];
    self.menu.textColor = [UIColor blackColor];
    self.menu.highlightedTextShadowColor = [UIColor clearColor];
    self.menu.highlightedBackgroundColor = [UIColor orangeColor];
    self.menu.separatorHeight = 1.0f;
    self.menu.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 22.0f];
    __weak REMenu *menu = _menu;
    [menu setCloseCompletionHandler:^{
        [remenuView removeFromSuperview];
        [remenuScroller removeFromSuperview];
    }];
    
    if(SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        self.menu.backgroundColor = [UIColor whiteColor];
    }
    [toggleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)toggleMenu {
    if (self.menu.isOpen) {
        REMenuTitle = [NSString stringWithFormat:@"%@%@",
                       [[NSUserDefaults standardUserDefaults] valueForKey:@"curName"],
                       @" ⌵"];
        [toggleButton setTitle:REMenuTitle forState:UIControlStateNormal];
        return [self.menu close];
    } else {
        REMenuTitle = [NSString stringWithFormat:@"%@%@",
                       [[NSUserDefaults standardUserDefaults] valueForKey:@"curName"],
                       @" ^"];
        [toggleButton setTitle:REMenuTitle forState:UIControlStateNormal];
    }
    remenuScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(self.navigationController.navigationBar.frame.size.width/4,
                                                                   self.navigationController.navigationBar.frame.size.height + 20,
                                                                   self.navigationController.navigationBar.frame.size.width/2,
                                                                   400)];
    
    remenuView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                         0,
                                                         self.navigationController.navigationBar.frame.size.width/2,
                                                         remenuSize)];
    remenuView.backgroundColor = [UIColor orangeColor];
    remenuView.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    remenuScroller.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    remenuScroller.contentSize = CGSizeMake(0, remenuSize);
    remenuScroller.backgroundColor = [UIColor clearColor];
    remenuView.backgroundColor = [UIColor clearColor];
    [remenuScroller setShowsVerticalScrollIndicator:NO];
    [remenuScroller addSubview:remenuView];
    [self.view addSubview:remenuScroller];
    [self.menu showInView:remenuView];
}

- (void)deleteSkedLine {
    [timeLineIndicator removeFromSuperview];
    [skedLineIndicator removeFromSuperview];
}

- (void)initAnimation {
    double yPosition = [self getYPosition];
    if (yPosition >= 895) {
        return;
    }
    double xPosition = standartScrollPosition;
    double animationDuration = [self getAnimationDuration];
    timeLineIndicator = [[UIView alloc]initWithFrame:CGRectMake(0, yPosition,  70, 2)];
    skedLineIndicator = [[UIView alloc]initWithFrame:CGRectMake(xPosition + 70.0f, yPosition + 1, 115, 2)];
    timeLineIndicator.backgroundColor = [UIColor redColor];
    skedLineIndicator.backgroundColor = [UIColor redColor];
    [mainSkedView addSubview:skedLineIndicator];
    [timeLineView addSubview:timeLineIndicator];
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:(UIViewAnimationOptionCurveLinear |
                                 UIViewAnimationOptionAutoreverse |
                                 UIViewAnimationOptionRepeat |
                                 UIViewAnimationOptionAllowUserInteraction |
                                 UIViewAnimationOptionBeginFromCurrentState) animations:^{
                            [timeLineIndicator setFrame:CGRectMake(0, 895, 70, 2)];
                        } completion:nil];
    
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:(UIViewAnimationOptionCurveLinear |
                                 UIViewAnimationOptionAutoreverse |
                                 UIViewAnimationOptionRepeat |
                                 UIViewAnimationOptionAllowUserInteraction |
                                 UIViewAnimationOptionBeginFromCurrentState) animations:^{
                            [skedLineIndicator setFrame:CGRectMake(xPosition + 50.0f, 895, 115, 2)];
                        } completion:nil];
}

- (double)getAnimationDuration {
    return 78300 - timer.currentTimeInSeconds;
}

- (double)getYPosition {
    /*
     получается текущее время в секундах
     от него отнимается 7:45 в секундах
     27900 = 7:45 в секундах
     78300 = 21:45 в секундах
     50400 = 78300 - 27900;
     пропорция 50400 -> 100%;
     seconds -> x%
     нижняя координата по Y = 895, верхняя 30, значит шкала времени всего 865
     865 -> 100%, 8.65 -> 1%
     30 получается сдвиг
     */
    int seconds = timer.currentTimeInSeconds - 27900;
    return ((((seconds*100)/50400)*8.65)+30);
}

- (void)timeUpdate {
    NSDate *time = [NSDate dateWithTimeIntervalSince1970:(timer.time - [timer getCurrentTimeInSeconds])];
    timerLebel.text = [timer.hourMinuteSecond stringFromDate:time];
    //TODO: по истечению времени таймер должен быть переинициализирован
}

@end
