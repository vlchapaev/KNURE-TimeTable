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
#import "Timer.h"

@implementation ViewController

@synthesize menuBtn;
@synthesize toggleBtn;


- (id)initWithCoder:(NSCoder*)aDecoder {
    /*
     Инициализирует объекты перед началом выполнения, в частности, здесь иницилизируется массив координат всех возможных мест положений skedView. Позднее он будет использоваться при отрисовке новых пар пользователем.
     */
    if(self = [super initWithCoder:aDecoder]) {
        rects = [[NSMutableArray alloc]init];
        float pointX1 = 55;
        float pointY1 = 30;
        float pointX2 = 110;
        float pointY2 = 50;
        int j = 0;
        for(int i=0; i<500; i++) {
            [rects addObject:[NSValue valueWithCGRect:CGRectMake(pointX1, pointY1, pointX2, pointY2)]];
            pointX1 += 115;
            if(i==499 && j<8) {
                pointY1 += 55;
                pointX1 = 55;
                j++;
                i = 0;
            }
        }
    }
    return self;
}


- (void)viewDidLoad {
    /*
     Выполняет все возможные команды при запуске вьюшки с расписанием.
     Здесь выполняется: иницаилизация slide menu, таймера, какая-то штука, необходима, чтобы таймер тикал, отрисовка скроллвьюшки, шкалы времени и выпадающего меню.
     */
    [super viewDidLoad];
    
    [self initializeSlideMenu];
    [self aTimeUpdate];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(aTimeUpdate) userInfo:nil repeats:YES];
    @try {
        //[self getLastUpdate];
        [self createScrollMenu];
        [self createTimeMenu];
        [self initToggleMenu];
    }
    @catch(NSException *e) {
        
    }
}

- (void)createScrollMenu {
    /*
     Создаёт scroll menu, в котором располагаются uiview.
     Данные берутся из userdefaults, с ключем, который равен id группы или преподавателя.
     полученные данные отрисовываются по очень большому и непродуманному алгоритму.
     */
    NSString *curId = [[NSUserDefaults standardUserDefaults] valueForKey:@"ID"];
    if(curId.length < 1)
        return;
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
    [self mainScrollViewAddLONGPRESSGestureRecognizer];
    for(int i=1; i<sorted.count; i++) {
        [self skedCellAddLONGPRESSGestureRecognizer];
        //NSString *mydate = [formatter stringFromDate:[[sorted objectAtIndex:i] valueForKey:@"date"]];
        //NSLog(@"%@%@", mydate, [[sorted objectAtIndex:i] valueForKey:@"object"]);
        UIView *dateGrid = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 55, 5, 110, 20)];
        dateGrid.backgroundColor = [UIColor whiteColor];
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
            [date setFont:[UIFont fontWithName: @"Helvetica Neue" size: 14.0f]];
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
        sked.backgroundColor = [UIColor clearColor];
        [date setFont:[UIFont fontWithName: @"Helvetica Neue" size: 14.0f]];
        date.textAlignment = NSTextAlignmentCenter;
        [sked setFont:[UIFont fontWithName: @"Helvetica Neue" size: 12.0f]];
        sked.textAlignment = NSTextAlignmentCenter;
        lessonShift = 25;
        [mainSkedView addSubview:dateGrid];
        [mainSkedView addSubview:skedCell];
        [dateGrid addSubview:date];
        [skedCell addSubview:sked];
    }
    userChanges = [NSString stringWithFormat:@"%@%@", @"userDataFor-", [[NSUserDefaults standardUserDefaults]valueForKey:@"ID"]];
    NSLog(@"%@", userChanges);
    
    NSMutableArray *userSked = [[NSUserDefaults standardUserDefaults] objectForKey:userChanges];
    if(userSked.count > 0) {
        CGRect skedRect;
        for(int i=0;i<userSked.count;i++) {
            skedRect = CGRectFromString([userSked objectAtIndex:i]);
            newSkedCell = [[UIView alloc]initWithFrame:skedRect];
            newSkedCell.backgroundColor = [UIColor orangeColor];
            [mainSkedView addSubview:newSkedCell];
            [self skedCellAddLONGPRESSGestureRecognizer];
        }
    }
    
    mainSkedView.contentSize = CGSizeMake(scrollViewSize, maxContentSize + 85);
    mainSkedView.backgroundColor = [UIColor whiteColor];
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
        timeStart.backgroundColor = [UIColor clearColor];
        timeEnd.backgroundColor = [UIColor clearColor];
        [timeStart setFont:[UIFont fontWithName: @"Helvetica Neue" size: 16.0f]];
        [timeEnd setFont:[UIFont fontWithName: @"Helvetica Neue" size: 16.0f]];
        [timeGrid addSubview:timeStart];
        [timeGrid addSubview:timeEnd];
        timeGrid.backgroundColor = [UIColor whiteColor];
        framecounter += 55;
        [timeLineView addSubview:timeGrid];
        timeLineView.backgroundColor = [UIColor whiteColor];
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
    /* ЭТА ФУНКЦИЯ ОТКЮЧЕНА.
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
    /*
     Инициализирует slide menu.
     */
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

- (IBAction)revealMenu:(id)sender {
    //Событие срабатывает, если пользователь отпускает slide menu.
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void) mainScrollViewAddLONGPRESSGestureRecognizer {
    /*
     Добавляет на mainScrollView распознаватель жеста "длительно нажатие"
     */
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnMainSkedView:)];
    [mainSkedView addGestureRecognizer:longPressRecognizer];
}

- (void) longPressOnMainSkedView:(UITapGestureRecognizer *)recogniser {
    /*
     Обработчик события "длительное нажатие".
     При длительном нажатии на пустом месте появляется пара на вьюшке.
     */
    CGRect skedRect;
    CGPoint touchPoint = [recogniser locationInView:recogniser.view];
    userChanges = [NSString stringWithFormat:@"%@%@",@"userDataFor-", [[NSUserDefaults standardUserDefaults]valueForKey:@"ID"]];
    if(recogniser.state == UIGestureRecognizerStateBegan) {
        NSUserDefaults *savedRectangles = [NSUserDefaults standardUserDefaults];
        NSArray *temp = [savedRectangles objectForKey:userChanges];
        NSMutableArray *userSkedRects =  nil;
        if(temp) {
            userSkedRects = [temp mutableCopy];
        } else {
            userSkedRects = [[NSMutableArray alloc]init];
        }
        for(int i=0; i<rects.count; i++) {
            skedRect = [[rects objectAtIndex:i] CGRectValue];
            if(CGRectContainsPoint(skedRect, touchPoint)==YES) {
                newSkedCell = [[UIView alloc]initWithFrame:skedRect];
                [userSkedRects addObject:NSStringFromCGRect(skedRect)];
                [savedRectangles setObject:userSkedRects forKey:userChanges];
                [savedRectangles synchronize];
                [self skedCellAddLONGPRESSGestureRecognizer];
                break;
            }
        }
        newSkedCell.backgroundColor = [UIColor orangeColor];
        [mainSkedView addSubview:newSkedCell];
        [timeLineView removeFromSuperview];
        [self createTimeMenu];
    }
}

- (void) skedCellAddLONGPRESSGestureRecognizer {
    /*
     Добавляет этот же жест на каждую ячейку с в расписании.
     */
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOnSkedCellDetected:)];
    [skedCell addGestureRecognizer:recognizer];
    [newSkedCell addGestureRecognizer:recognizer];
}

- (void) longPressOnSkedCellDetected:(UILongPressGestureRecognizer *)recogniser {
    /*
     Обработчик события: при длительном нажатии на skedCell вызвать UIActionSheet.
     В ДАННЫЙ МОМЕНТ ЭТО ПРОСТО СКРОЕТ ПРЕДМЕТ ИЗ ВЬЮШКИ.
     */
    if(recogniser.state == UIGestureRecognizerStateBegan) {
        recogniser.view.self.hidden = YES;
    }
}

- (void) mainScrollViewAddDOUBLETAPGestureRecognizer {
    /*
     Добавляет жест "двойной тап" на скролл вьюшку
     */
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapOnMainSkedView:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [mainSkedView addGestureRecognizer:doubleTapRecognizer];
}

- (void) doubleTapOnMainSkedView:(UITapGestureRecognizer *)recogniser {
    //Обработчик события "двойной тап". Возвращает стандартную позицию скроллера на текущий день.
    mainSkedView.contentOffset = CGPointMake(standartScrollPosition, 0);
}

- (void) initToggleMenu {
    //Инициализирует выпадающее меню
    TeachersList *tl = [[TeachersList alloc] init];
    GroupList *hl = [[GroupList alloc] init];
    self.toggleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    toggleBtn.tintColor = [UIColor blackColor];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat centerX = screenSize.width/2.0;
    toggleBtn.frame = CGRectMake(centerX-100, 30, 200, 24);
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

- (void) toggleMenu {
    //Задаёт парамеры появленя выпадающего меню.
    if (self.menu.isOpen)
        return [self.menu close];
    [self.menu showFromRect:CGRectMake(0, 62, self.view.frame.size.width, 300) inView:self.view];
}

- (void) aTimeUpdate {
    //Инициализирует таймер]
    [Timer getCurrentTime];
    [Timer comparisonOfTime];
    [Timer minusTime];
    if (toLessonBool == NO) {
        timer.text = [[NSString alloc]initWithFormat:@"До конца пары: %.2d:%.2d:%.2d", endHours, endMinutes, endSeconds];
    }
    else {
        timer.text = [[NSString alloc]initWithFormat:@"До начала пары: %.2d:%.2d:%.2d", endHours, endMinutes, endSeconds];
    }
    [Timer cleaner];
}

@end