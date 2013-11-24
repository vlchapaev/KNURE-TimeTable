//
//  ViewController.m
//  KNURE-Sked
//
//  Created by Влад on 10/24/13.
//  Copyright (c) 2013 Влад. All rights reserved.
//
#import "ViewController.h"
#import "ECSlidingViewController.h"
#import "TabsViewController.h"
#import "GroupList.h"
#import "TeachersList.h"
#import "REMenu.h"

@implementation ViewController

@synthesize menuBtn;
@synthesize toggleBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self update];
    [self aTimeUpdate];
    //инициализация кнопки и выдвигающегося меню
    [self initializeSlideMenu];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(aTimeUpdate) userInfo:nil repeats:YES];
    
    //вызов скролл меню
        
        @try {
            //[self getLastUpdate];
            [self createScrollMenu];
            [self createTimeMenu];
            [self initToggleMenu];
        }
        @catch(NSException *e) {
            /* UIAlertView *endGameMessage = [[UIAlertView alloc] initWithTitle:@"Ой" message:@"Кто-то сломал меня :С" delegate:self cancelButtonTitle:@"Окай" otherButtonTitles: nil];
            [endGameMessage show]; */
        }
}

- (void)createScrollMenu {
    /*
     * Создаёт scroll menu, в котором располагаются uiview.
     * Данные берутся из userdefaults, с ключем, который равен id группы или преподавателя.
     * Полученные данные заносятся в NSArray после чего сортируются.
     * После соритировки по дате внутри NSArray, данные заносятся в UILable, который располагается на UIView,
     * который располагается на scroll view.
     */
    NSString *curId = [[NSUserDefaults standardUserDefaults] valueForKey:@"ID"];
    int dayShift = 0;
    int lessonShift = 25;
    int scrollViewSize = 0;
    int countDuplitateDays = 0;
    int maxContentSize = 55*5;
    
    NSUserDefaults *fullLessonsData = [NSUserDefaults standardUserDefaults];
    NSArray *sorted = [fullLessonsData objectForKey:curId];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    mainSkedView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 95, self.view.frame.size.width, self.view.frame.size.height-95)];
    mainSkedView.delegate = self;
    [mainSkedView setShowsHorizontalScrollIndicator:NO];
    [mainSkedView setShowsVerticalScrollIndicator:NO];
    [self mainScrollViewAddDOUBLETAPGestureRecognizer];
    for(int i=1; i<sorted.count; i++) {
        [self skedCellAddLONGGestureRecognizer];
        //NSString *mydate = [formatter stringFromDate:[[sorted objectAtIndex:i] valueForKey:@"date"]];
        //NSLog(@"%@%@", mydate, [[sorted objectAtIndex:i] valueForKey:@"object"]);
        UIView *dateGrid = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 55, 5, 110, 20)];
        dateGrid.backgroundColor = [UIColor clearColor];
        UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 20)];
        UILabel *sked = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 50)];
        NSString *prewDate = [formatter stringFromDate:[[sorted objectAtIndex:i] valueForKey:@"date"]];
        
        if(i>1 && [prewDate isEqual:[formatter stringFromDate:[[sorted objectAtIndex:i-1] valueForKey:@"date"]]]) {
            countDuplitateDays = 1;
        }
        else
            countDuplitateDays = 0;
        
        if(countDuplitateDays == 0 && i > 1) {
            dayShift += dateGrid.frame.size.width + 5;
            scrollViewSize += dateGrid.frame.size.width + 6;
        }
        
        date.text = [formatter stringFromDate:[[sorted objectAtIndex:i-1] valueForKey:@"date"]];
        
        if([[formatter stringFromDate:[NSDate date]]isEqual:[formatter stringFromDate:[[sorted objectAtIndex:i] valueForKey:@"date"]]]) {
            mainSkedView.contentOffset = CGPointMake(dayShift, 0);
            standartScrollPosition = dayShift;
        }
        
        if([[[sorted objectAtIndex:i] valueForKey:@"object"]  isEqual: @" "]) {
            [date setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
            date.textAlignment = NSTextAlignmentCenter;
            [mainSkedView addSubview:dateGrid];
            [dateGrid addSubview:date];
            continue;
        }
        
        NSString *tempDay = [[sorted objectAtIndex:i] valueForKey:@"object"];
        NSArray *temp = [tempDay componentsSeparatedByString:@" "];
        if([[temp objectAtIndex:1] isEqual: @"2"]) {
            lessonShift += 55*1;
        } else
            if([[temp objectAtIndex:1] isEqual: @"3"]) {
                lessonShift += 55*2;
            } else
                if([[temp objectAtIndex:1] isEqual: @"4"]) {
                    lessonShift += 55*3;
                } else
                    if([[temp objectAtIndex:1] isEqual: @"5"]) {
                        lessonShift += 55*4;
                    } else
                        if([[temp objectAtIndex:1] isEqual: @"6"]) {
                            lessonShift += 55*5;
                        } else
                            if([[temp objectAtIndex:1] isEqual: @"7"]) {
                                lessonShift += 55*6;
                                maxContentSize = 55*6;
                            } else
                                if([[temp objectAtIndex:1] isEqual: @"8"]) {
                                    lessonShift += 55*7;
                                    maxContentSize = 55*7;
                                }
        if ([temp containsObject:@"Лк"]) {
            skedCell = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 55, lessonShift + 5, 110, 50)];
            skedCell.backgroundColor = [UIColor colorWithRed:0.996 green:0.996 blue:0.918 alpha:1.0];
        }
        else
            if ([temp containsObject:@"Пз"]) {
                skedCell = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 55, lessonShift + 5, 110, 50)];
                skedCell.backgroundColor = [UIColor colorWithRed:0.855 green:0.914 blue:0.851 alpha:1.0];
            }
            else
                if ([temp containsObject:@"Лб"]) {
                    skedCell = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 55, lessonShift + 5, 110, 50)];
                    skedCell.backgroundColor = [UIColor colorWithRed:0.804 green:0.8 blue:1 alpha:1.0];
                }
                else
                    if ([temp containsObject:@"Конс"]) {
                        skedCell = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 55, lessonShift + 5, 110, 50)];
                        skedCell.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.0];
                    }
                    else
                        if ([temp containsObject:@"ЕкзУ"]) {
                            skedCell = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 55, lessonShift + 5, 110, 50)];
                            skedCell.backgroundColor = [UIColor colorWithRed:0.561 green:0.827 blue:0.988 alpha:1.0];
                        }
                        else
                            if ([temp containsObject:@"ЕкзП"]) {
                                skedCell = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 55, lessonShift + 5, 110, 50)];
                                skedCell.backgroundColor = [UIColor colorWithRed:0.561 green:0.827 blue:0.988 alpha:1.0];
                            }
                            else
                                if ([temp containsObject:@"Зал"]) {
                                    skedCell = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 55, lessonShift + 5, 110, 50)];
                                    skedCell.backgroundColor = [UIColor colorWithRed:0.761 green:0.627 blue:0.722 alpha:1.0];
                                }
        sked.text = [tempDay stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@""];
        sked.numberOfLines = 3;
        sked.lineBreakMode = 5;
        [date setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
        date.textAlignment = NSTextAlignmentCenter;
        [sked setFont:[UIFont fontWithName: @"Trebuchet MS" size: 12.0f]];
        sked.textAlignment = NSTextAlignmentCenter;
        lessonShift = 25;
        [mainSkedView addSubview:dateGrid];
        [mainSkedView addSubview:skedCell];
        [dateGrid addSubview:date];
        [skedCell addSubview:sked];
        }
    mainSkedView.contentSize = CGSizeMake(scrollViewSize, maxContentSize + 85);
    mainSkedView.backgroundColor = [UIColor clearColor];
    mainSkedView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:mainSkedView];
}

- (void) createTimeMenu {
    /*
     * Создаёт временную шкалу.
     */
    int framecounter = 0;
    CGPoint content = [mainSkedView contentOffset];
    CGRect contentOffset = [mainSkedView bounds];
    timeLineView = [[UIScrollView alloc] initWithFrame:CGRectMake(contentOffset.origin.x, contentOffset.origin.y+30+(content.y*(-1)), 50, 600)];
    for (int i=1; i<9; i++) {
        UIView *timeGrid = [[UIView alloc]initWithFrame:CGRectMake(0, 0 + framecounter, 50, 50)];
        UILabel *timeStart = [[UILabel alloc]initWithFrame:CGRectMake(5, -10, 50, 50)];
        UILabel *timeEnd = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 50, 50)];
        switch (i) {
            case 1:
                timeStart.text = @"7:45";
                timeEnd.text = @"9:20";
                break;
            case 2:
                timeStart.text = @"9:30";
                timeEnd.text = @"11:05";
                break;
            case 3:
                timeStart.text = @"11:15";
                timeEnd.text = @"12:50";
                break;
            case 4:
                timeStart.text = @"13:10";
                timeEnd.text = @"14:45";
                break;
            case 5:
                timeStart.text = @"14:55";
                timeEnd.text = @"16:30";
                break;
            case 6:
                timeStart.text = @"16:40";
                timeEnd.text = @"18:15";
                break;
            case 7:
                timeStart.text = @"18:25";
                timeEnd.text = @"20:00";
                break;
            case 8:
                timeStart.text = @"20:10";
                timeEnd.text = @"21:45";
                break;
        }
        [timeStart setFont:[UIFont fontWithName: @"Trebuchet MS" size: 16.0f]];
        [timeEnd setFont:[UIFont fontWithName: @"Trebuchet MS" size: 16.0f]];
        [timeGrid addSubview:timeStart];
        [timeGrid addSubview:timeEnd];
        timeGrid.backgroundColor = [UIColor whiteColor];
        framecounter += 55;
        [timeLineView addSubview:timeGrid];
        timeLineView.backgroundColor = [UIColor clearColor];
        [mainSkedView addSubview:timeLineView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint content = [mainSkedView contentOffset];
    CGRect contentOffset = [mainSkedView bounds];
    CGRect center = CGRectMake(contentOffset.origin.x, contentOffset.origin.y+30+(content.y*(-1)), 50, 600);
    [timeLineView setFrame:center];
}

- (void)getLastUpdate {
    /*
     * Посылается запрос на cist, в ответ получаем .csv файл.
     * Из файла убираем лишние символы, такие как: ", время:время:время
     * Очищенные данные отправляем в NSUserDefaults с ключем, равный id группы или преподавателя.
     */
    NSString *curId = [[NSUserDefaults standardUserDefaults] valueForKey:@"curGroupId"];
    NSString *curRequest = [NSString stringWithFormat:@"%@%@%@",@"http://cist.kture.kharkov.ua/ias/app/tt/WEB_IAS_TT_GNR_RASP.GEN_GROUP_POTOK_RASP?ATypeDoc=4&Aid_group=", curId, @"&Aid_potok=0&ADateStart=01.09.2013&ADateEnd=31.01.2014&AMultiWorkSheet=0"];
    NSLog(@"%@",curRequest);
    NSError *error = nil;
    NSUserDefaults* fullLessonsData = [NSUserDefaults standardUserDefaults];
    NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:curRequest]];
    NSString *csvResponseString = [[NSString alloc] initWithData:responseData encoding:NSWindowsCP1251StringEncoding];
    //NSLog(@"%@", csvResponseString);
    NSString *modifstr = [csvResponseString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSString *modifstr2 = [modifstr stringByReplacingOccurrencesOfString:@"," withString:@" "];
    //NSLog(@"%@", modifstr2);
    NSRegularExpression *delGRP = [NSRegularExpression regularExpressionWithPattern:@"[А-ЯІЇЄҐ;]+[-]+[0-9]+[-]+[0-9]"
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:&error];
    NSString *delgrp = [delGRP stringByReplacingMatchesInString:modifstr2
                                                        options:0
                                                          range:NSMakeRange(0, [modifstr2 length])
                                                   withTemplate:@""];
    NSRegularExpression *delTIME = [NSRegularExpression regularExpressionWithPattern:@"[0-9]+[:]+[0-9]+[0-9:0-9]+[0-9]"
                                                                             options:NSRegularExpressionCaseInsensitive
                                                                               error:&error];
    NSString *deltime = [delTIME stringByReplacingMatchesInString:delgrp
                                                          options:0
                                                            range:NSMakeRange(0, [delgrp length])
                                                     withTemplate:@""];
    NSString *delSpace = [deltime stringByReplacingOccurrencesOfString:@"   " withString:@" "];
    NSArray *list = [delSpace componentsSeparatedByString:@"\r"];
    [fullLessonsData setObject:list forKey: curId];
    [fullLessonsData synchronize];
}

- (void) initializeSlideMenu {
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[TabsViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(13, 30, 34, 24);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.menuBtn];
}

- (void)update {
    NSDateFormatter *dataformatter = [[NSDateFormatter alloc]init];
    [dataformatter setDateFormat:@"HH:mm:ss"];
    //[timer setFont:[UIFont fontWithName:@"HalfLife2" size:32]];
    timer.text = [dataformatter stringFromDate:[NSDate date]];
}

- (IBAction)revealMenu:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void) skedCellAddLONGGestureRecognizer {
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOnSkedCellDetected:)];
    [skedCell addGestureRecognizer:recognizer];
}

- (void) longPressOnSkedCellDetected:(UILongPressGestureRecognizer *)recogniser {
    skedCell.backgroundColor = [UIColor blackColor];
}

- (void) mainScrollViewAddDOUBLETAPGestureRecognizer {
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapOnMainSkedView:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [mainSkedView addGestureRecognizer:doubleTapRecognizer];
}

- (void) doubleTapOnMainSkedView:(UITapGestureRecognizer *)recogniser {
    mainSkedView.contentOffset = CGPointMake(standartScrollPosition, 0);
}

- (void) aTimeUpdate {
    //Get current time
    [self getCurrentTime];
    //Get nearest lesson
    [self comparisonOfTime];
    
    //Count time
    [self minusTime];
    
    //Print time
    timer.lineBreakMode = 2;
    if (toLessonBool == NO) {
        //NSLog(@"До конца пары: %d:%d:%d", endHours, endMinutes, endSeconds);
        timer.text = [[NSString alloc]initWithFormat:@"До конца пары: %d:%d:%d", endHours, endMinutes, endSeconds];
    }
    else {
        //NSLog(@"До начала пары: твоя мама %d:%d:%d", endHours, endMinutes, endSeconds);
        timer.text = [[NSString alloc]initWithFormat:@"До начала пары: %d:%d:%d", endHours, endMinutes, endSeconds];
    }
    //Clean values
    [self cleaner];
}

-(void) getCurrentTime {
    //Get data
    NSDate *currentDateTime = [NSDate date];
    
    //Set format for data
    NSDateFormatter *dateFormatterHours = [[NSDateFormatter alloc] init];
    [dateFormatterHours setDateFormat:@"HH"];
    NSDateFormatter *dateFormatterMinutes = [[NSDateFormatter alloc] init];
    [dateFormatterMinutes setDateFormat:@"mm"];
    NSDateFormatter *dateFormatterSeconds = [[NSDateFormatter alloc] init];
    [dateFormatterSeconds setDateFormat:@"ss"];
    
    //Write formated data to NSInteger
    hours = [[dateFormatterHours stringFromDate:currentDateTime] integerValue];
    minutes = [[dateFormatterMinutes stringFromDate:currentDateTime] integerValue];
    seconds = [[dateFormatterSeconds stringFromDate:currentDateTime] integerValue];
}

- (void) initToggleMenu {
    TeachersList *tl = [[TeachersList alloc] init];
    HistoryList *hl = [[HistoryList alloc] init];
    self.toggleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat centerX = screenSize.width/2.0;
    toggleBtn.frame = CGRectMake(centerX-100, 30, 200, 24);;
    [toggleBtn setTitle:[[NSUserDefaults standardUserDefaults] valueForKey:@"curName"] forState:UIControlStateNormal];
    [toggleBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:toggleBtn];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    NSArray *grHistory = [[NSUserDefaults standardUserDefaults] valueForKey:@"SavedGroups"];
    NSArray *tHistory = [[NSUserDefaults standardUserDefaults] valueForKey:@"SavedTeachers"];
    for (NSString *gr in grHistory) {
        REMenuItem *groupItem = [[REMenuItem alloc] initWithTitle:gr
                                image:[UIImage imageNamed:@"---"]
                                highlightedImage:nil
                                action:^(REMenuItem *item) {
                                [hl getGroupId:gr];
                                [mainSkedView removeFromSuperview];
                                [toggleBtn removeFromSuperview];
                                [self viewDidLoad];
                                }];
        [items addObject:groupItem];
    }
    for (NSString *tchr in tHistory) {
        REMenuItem *teacherItem = [[REMenuItem alloc] initWithTitle:tchr
                                    image:[UIImage imageNamed:@"---"]
                                    highlightedImage:nil
                                    action:^(REMenuItem *item) {
                                    [tl getTeacherId:tchr];
                                    [mainSkedView removeFromSuperview];
                                    [toggleBtn removeFromSuperview];
                                    [self viewDidLoad];
                                    }];
        [items addObject:teacherItem];
    }
    self.menu = [[REMenu alloc] initWithItems:items];
    
}

- (void)toggleMenu {
    if (self.menu.isOpen)
        return [self.menu close];
    [self.menu showInView:self.view];
}

//Find nearst lessons time
-(void) comparisonOfTime {
    endInteger = (hours) * 10000;
    NSString *str = [NSString stringWithFormat:@"%d", minutes];
    if (str.length <= 0)
        endInteger *= 10;
    endInteger += (minutes)*100;
    str = [NSString stringWithFormat:@"%d", seconds];
    if (str.length <= 0)
        endInteger *= 10;
    endInteger += seconds;
    if (endInteger < 235959) {
        endHours = 7;
        endMinutes = 45;
        endSeconds = 00;
        toLessonBool = YES;
    }
    if (endInteger < 214500) {
        endHours = 21;
        endMinutes = 45;
        endSeconds = 00;
        toLessonBool = NO;
    }
    if (endInteger < 201000) {
        endHours = 20;
        endMinutes = 10;
        endSeconds = 00;
        toLessonBool = YES;
    }
    if (endInteger < 200000) {
        endHours = 20;
        endMinutes = 00;
        endSeconds = 00;
        toLessonBool = NO;
    }
    if (endInteger < 182500) {
        endHours = 18;
        endMinutes = 25;
        endSeconds = 00;
        toLessonBool = YES;
    }
    if (endInteger < 181500) {
        endHours = 18;
        endMinutes = 15;
        endSeconds = 00;
        toLessonBool = NO;
    }
    if (endInteger < 164000) {
        endHours = 16;
        endMinutes = 40;
        endSeconds = 00;
        toLessonBool = YES;
    }
    if (endInteger < 163000) {
        endHours = 16;
        endMinutes = 30;
        endSeconds = 00;
        toLessonBool = NO;
    }
    if (endInteger < 145500) {
        endHours = 14;
        endMinutes = 55;
        endSeconds = 00;
        toLessonBool = YES;
    }
    if (endInteger < 144500) {
        endHours = 14;
        endMinutes = 45;
        endSeconds = 00;
        toLessonBool = NO;
    }
    if (endInteger < 131000)
    {
        endHours = 13;
        endMinutes = 10;
        endSeconds = 00;
        toLessonBool = YES;
    }
    if (endInteger < 125000) {
        endHours = 12;
        endMinutes = 50;
        endSeconds = 00;
        toLessonBool = NO;
    }
    if (endInteger < 111500) {
        endHours = 11;
        endMinutes = 15;
        endSeconds = 00;
        toLessonBool = YES;
    }
    
    if (endInteger < 110500) {
        endHours = 11;
        endMinutes = 05;
        endSeconds = 00;
        toLessonBool = NO;
    }
    
    if (endInteger < 93000) {
        endHours = 9;
        endMinutes = 30;
        endSeconds = 00;
        toLessonBool = YES;
    }
    if (endInteger < 92000) {
        endHours = 9;
        endMinutes = 20;
        endSeconds = 00;
        toLessonBool = NO;
    }
    if (endInteger < 74500) {
        endHours = 7;
        endMinutes = 45;
        endSeconds = 00;
        toLessonBool = YES;
    }
}

//Counting time
-(void) minusTime {
    //Cache for remainder
    BOOL cacheInMinusTime = NO;
    //Counting seconds
    if (seconds == endSeconds)
        endSeconds = 0;
    else {
        if (seconds > endSeconds) {
            cacheInMinusTime = YES;
            seconds -= endSeconds;
            endSeconds = 60 - seconds;
        }
        else {
            endSeconds -= seconds;
        }
        if (cacheInMinusTime == YES) {
            if (minutes == 60) {
                hours++;
                minutes = 0;
            }
            else
                minutes++;
            cacheInMinusTime = NO;
        }
    }
    //Counting minutes
    if (minutes == endMinutes)
        endMinutes = 0;
    else {
        if (minutes > endMinutes) {
            cacheInMinusTime = YES;
            minutes -= endMinutes;
            endMinutes = 60 - minutes;
        }
        else {
            endMinutes -= minutes;
        }
        if (cacheInMinusTime == YES) {
            hours++;
            cacheInMinusTime = NO;
        }
    }
    //Counting hours
    if (hours == endHours)
        endHours = 0;
    else {
        if (hours > endHours) {
            hours -= endHours;
            endHours = 24 - hours;
        } else {
            endHours -= hours;
        }
    }
}

-(void) cleaner {
    hours = 0;
    minutes = 0;
    seconds = 0;
    endSeconds = 0;
    endMinutes = 0;
    endHours = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end