//
//  ViewController.m
//  KNURE-Sked
//
//  Created by Влад on 10/24/13.
//  Copyright (c) 2013 Влад. All rights reserved.
//
#import "ViewController.h"
#import "ECSlidingViewController.h"
#import "NewSkedCell.h"
#import "TabsViewController.h"
#import "InitViewController.h"
#import "GroupList.h"
#import "TeachersList.h"
#import "NoteForm.h"
#import "REMenu.h"
#import "Timer.h"

@implementation ViewController

@synthesize menuBtn;
@synthesize toggleBtn;

int remenuSize;
int standartScrollPosition;
NSMutableArray *sorted;
NSString *userAddLesson;
NSString *userAddLessonText;
NSString *userDeleteLesson;
NSMutableArray *rects;
NSMutableData *receivedData;
UIScrollView *remenuScroller;
UIView *remenuView;

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
            if(i == 499 && j < 8) {
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
    if([self isNull]==false) {
        @try {
            //[self getLastUpdate];
            [self createScrollMenu];
            [self createTimeMenu];
            [self initToggleMenu];
        }
        @catch(NSException *e) {
        
        }
    }
}

- (void)createScrollMenu {
    /*
     Создаёт scroll menu, в котором располагаются uiview.
     Данные берутся из userdefaults, с ключем, который равен id группы или преподавателя.
     полученные данные отрисовываются по очень большому и непродуманному алгоритму.
     */
    int dayShift = 0;
    int lessonShift = 25;
    int scrollViewSize = 0;
    int countDuplitateDays = 0;
    int maxContentSize = 55*5;
    NSString *curId = [[NSUserDefaults standardUserDefaults] valueForKey:@"ID"];
    NSUserDefaults *fullLessonsData = [NSUserDefaults standardUserDefaults];
    sorted = [fullLessonsData objectForKey:curId];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    mainSkedView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 95, self.view.frame.size.width, self.view.frame.size.height-95)];
    mainSkedView.delegate = self;
    [mainSkedView setShowsHorizontalScrollIndicator:NO];
    [mainSkedView setShowsVerticalScrollIndicator:NO];
    [self mainScrollViewAddDOUBLETAPGestureRecognizer];
    [self mainScrollViewAddLONGPRESSGestureRecognizer];
    NSString *notesXRequest = [NSString stringWithFormat:@"%@%@",@"usrNotesXFor",[fullLessonsData valueForKey:@"ID"]];
    NSString *notesYRequest = [NSString stringWithFormat:@"%@%@",@"usrNotesYFor",[fullLessonsData valueForKey:@"ID"]];
    for(int i=1; i<sorted.count; i++) {
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
        
        date.text = [self getWeekDay:[formatter stringFromDate:[[sorted objectAtIndex:i-1] valueForKey:@"date"]]];
        
        if([[formatter stringFromDate:[NSDate date]]isEqual:[formatter stringFromDate:[[sorted objectAtIndex:i] valueForKey:@"date"]]]) {
            mainSkedView.contentOffset = CGPointMake(dayShift, 0);
            standartScrollPosition = dayShift;
        }
        
        if([[[sorted objectAtIndex:i] valueForKey:@"object"] isEqual: @" "]) {
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
            skedCell.backgroundColor = [UIColor colorWithRed:1 green:0.961 blue:0.835 alpha:1.0];
        } else
            if ([temp containsObject:@"Пз"]) {
                skedCell = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 55, lessonShift + 5, 110, 50)];
                skedCell.backgroundColor = [UIColor colorWithRed:0.78 green:0.922 blue:0.769 alpha:1.0];
            } else
                if ([temp containsObject:@"Лб"]) {
                    skedCell = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 55, lessonShift + 5, 110, 50)];
                    skedCell.backgroundColor = [UIColor colorWithRed:0.804 green:0.8 blue:1 alpha:1.0];
                } else
                    if ([temp containsObject:@"Конс"]) {
                        skedCell = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 55, lessonShift + 5, 110, 50)];
                        skedCell.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.0];
                    } else
                        if ([temp containsObject:@"ЕкзУ"]) {
                            skedCell = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 55, lessonShift + 5, 110, 50)];
                            skedCell.backgroundColor = [UIColor colorWithRed:0.561 green:0.827 blue:0.988 alpha:1.0];
                        } else
                            if ([temp containsObject:@"ЕкзП"]) {
                                skedCell = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 55, lessonShift + 5, 110, 50)];
                                skedCell.backgroundColor = [UIColor colorWithRed:0.561 green:0.827 blue:0.988 alpha:1.0];
                            } else
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
        [sked setFont:[UIFont fontWithName: @"Helvetica Neue" size: 14.0f]];
        sked.textAlignment = NSTextAlignmentCenter;
        lessonShift = 25;
        skedCell.tag = i;
        [self skedCellAddLONGPRESSGestureRecognizer];
        [mainSkedView addSubview:dateGrid];
        [mainSkedView addSubview:skedCell];
        [dateGrid addSubview:date];
        [skedCell addSubview:sked];
    }
    [self drawUserChanges];
    @try {
        NSMutableArray *notesX = [[fullLessonsData valueForKeyPath:notesXRequest] mutableCopy];
        NSMutableArray *notesY = [[fullLessonsData valueForKeyPath:notesYRequest] mutableCopy];
        UIImage *noteImg = [UIImage imageNamed:@"note.png"];
        for (int i = 0;i < notesX.count;i++) {
            UIImageView *noteImageView = [[UIImageView alloc] initWithImage:noteImg];
            noteImageView.frame = (CGRect){.origin=CGPointMake([[notesX objectAtIndex:i] floatValue], [[notesY objectAtIndex:i] floatValue]), .size = noteImg.size};
            [self->mainSkedView addSubview:noteImageView];
        }
    }
    @catch (NSException *e) {
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
    //self.slidingViewController.panGesture.delegate = self;
    //[self.view addGestureRecognizer:self.slidingViewController.panGesture];
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
     Идёт переход на новую вьюшку, где нужно добавить название предмета илисобытия.
     Затем появляется пара на вьюшке.
     */
    /*
    CGRect skedRect;
    CGPoint touchPoint = [recogniser locationInView:recogniser.view];
    userAddLesson = [NSString stringWithFormat:@"%@%@", @"userDataFor-", [[NSUserDefaults standardUserDefaults]valueForKey:@"ID"]];
    userAddLessonText = [NSString stringWithFormat:@"%@%@", @"userDataTextFor-", [[NSUserDefaults standardUserDefaults]valueForKey:@"ID"]];
    if(recogniser.state == UIGestureRecognizerStateBegan) {
        //[self goToNewCell:nil];
        NSLog(@"WUT");
       // [self dismissViewControllerAnimated:YES completion:nil];
        NSUserDefaults *savedRectangles = [NSUserDefaults standardUserDefaults];
        NSUserDefaults *savedText = [NSUserDefaults standardUserDefaults];
        NSArray *temp = [savedRectangles objectForKey:userAddLesson];
        NSArray *temp2 = [savedText objectForKey:userAddLessonText];
        NSMutableArray *userSkedRects = nil;
        NSMutableArray *userSkedText = nil;
        
        if(temp) {
            userSkedRects = [temp mutableCopy];
        } else {
            userSkedRects = [[NSMutableArray alloc]init];
        }
        
        if(temp2) {
            userSkedText = [temp2 mutableCopy];
        } else {
            userSkedText = [[NSMutableArray alloc]init];
        }
        
        for(int i=0; i<rects.count; i++) {
            skedRect = [[rects objectAtIndex:i] CGRectValue];
            if(CGRectContainsPoint(skedRect, touchPoint) == YES) {
                
                lessonData = @"This is Лк test.";
                if(lessonData.length > 2) {
                    
                    
                    UILabel *lesson = [[UILabel alloc]initWithFrame:skedRect];
                    
                    lesson.text = lessonData;
                    lesson.textAlignment = NSTextAlignmentCenter;
                    lesson.backgroundColor = [UIColor clearColor];
                    [lesson setFont:[UIFont fontWithName: @"Helvetica Neue" size: 12.0f]];
                    lesson.lineBreakMode = 5;
                    lesson.numberOfLines = 3;
                    
                    newSkedCell = [[UIView alloc]initWithFrame:skedRect];
                    
                    if(!([lessonData rangeOfString:@"Лк"].location == NSNotFound)) {
                        newSkedCell.backgroundColor = [UIColor colorWithRed:1 green:0.961 blue:0.835 alpha:1.0];
                    } else
                        if(!([lessonData rangeOfString:@"Пз"].location == NSNotFound)) {
                            newSkedCell.backgroundColor = [UIColor colorWithRed:0.78 green:0.922 blue:0.769 alpha:1.0];
                        } else
                            if(!([lessonData rangeOfString:@"Лб"].location == NSNotFound)) {
                                newSkedCell.backgroundColor = [UIColor colorWithRed:0.804 green:0.8 blue:1 alpha:1.0];
                            } else
                                if(!([lessonData rangeOfString:@"Конс"].location == NSNotFound)) {
                                    newSkedCell.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.0];
                                } else
                                    if(!([lessonData rangeOfString:@"Зал"].location == NSNotFound)) {
                                        newSkedCell.backgroundColor = [UIColor colorWithRed:0.761 green:0.627 blue:0.722 alpha:1.0];
                                    } else
                                        if(!([lessonData rangeOfString:@"зач"].location == NSNotFound)) {
                                            newSkedCell.backgroundColor = [UIColor colorWithRed:0.761 green:0.627 blue:0.722 alpha:1.0];
                                        } else
                                            if(!([lessonData rangeOfString:@"ЕкзП"].location == NSNotFound)) {
                                                newSkedCell.backgroundColor = [UIColor colorWithRed:0.561 green:0.827 blue:0.988 alpha:1.0];
                                            } else
                                                if(!([lessonData rangeOfString:@"ЕкзУ"].location == NSNotFound)) {
                                                    newSkedCell.backgroundColor = [UIColor colorWithRed:0.561 green:0.827 blue:0.988 alpha:1.0];
                                                } else
                                                    if(!([lessonData rangeOfString:@"Екз"].location == NSNotFound)) {
                                                        newSkedCell.backgroundColor = [UIColor colorWithRed:0.561 green:0.827 blue:0.988 alpha:1.0];
                                                    } else
                                                        newSkedCell.backgroundColor = [UIColor colorWithRed:1 green:0.859 blue:0.957 alpha:1.0];
                    
                    
                    UILabel *spike=[[UILabel alloc]initWithFrame:skedRect];
                    spike.text = @"your mom";
                    
                    [mainSkedView addSubview:newSkedCell];
                    [newSkedCell addSubview:spike];
                    [newSkedCell addSubview:lesson];
                    
                   // [mainSkedView addSubview:lesson];
                   // [mainSkedView addSubview:spike];
                    
                    
                    
                    //newSkedCell.tag = i + 7000;
                    
                    [userSkedRects addObject:NSStringFromCGRect(skedRect)];
                    [userSkedText addObject:lessonData];
                    [savedRectangles setObject:userSkedRects forKey:userAddLesson];
                    [savedText setObject:userSkedText forKey:userAddLessonText];
                    [savedRectangles synchronize];
                    [savedText synchronize];
                
                    
                    
                    
                    [timeLineView removeFromSuperview];
                    [self createTimeMenu];
                    [self skedCellAddLONGPRESSGestureRecognizer];
                    break;
                }
            }
        }
    }
        */
}

- (void) skedCellAddLONGPRESSGestureRecognizer {
    /*
     Добавляет этот же жест на каждую ячейку в расписании.
     */
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOnSkedCellDetected:)];
    [skedCell addGestureRecognizer:recognizer];
    [newSkedCell addGestureRecognizer:recognizer];
}

- (void) longPressOnSkedCellDetected:(UILongPressGestureRecognizer *)recogniser {
    if(recogniser.state == UIGestureRecognizerStateBegan) {
        skedCell = recogniser.view;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd.MM.yyyy"];
        NSString *cellDate = [formatter stringFromDate:[[sorted objectAtIndex:skedCell.tag] valueForKey:@"date"]];
        NSString *title = [[sorted objectAtIndex:skedCell.tag] valueForKey:@"object"];
        NSString *cellNum = [title substringToIndex:2];
        NSString *cellDT = @"";
        if ([cellNum isEqualToString:@" 1"]) {
            cellDT = [NSString stringWithFormat:@"%@ 7:45", cellDate];
        } else
            if ([cellNum isEqualToString:@" 2"]) {
                cellDT = [NSString stringWithFormat:@"%@ 9:30", cellDate];
            } else
                if ([cellNum isEqualToString:@" 3"]) {
                    cellDT = [NSString stringWithFormat:@"%@ 11:15", cellDate];
                } else
                    if ([cellNum isEqualToString:@" 4"]) {
                        cellDT = [NSString stringWithFormat:@"%@ 13:10", cellDate];
                    } else
                        if ([cellNum isEqualToString:@" 5"]) {
                            cellDT = [NSString stringWithFormat:@"%@ 14:55", cellDate];
                        } else
                            if ([cellNum isEqualToString:@" 6"]) {
                                cellDT = [NSString stringWithFormat:@"%@ 16:40", cellDate];
                            } else
                                if ([cellNum isEqualToString:@" 7"]) {
                                    cellDT = [NSString stringWithFormat:@"%@ 18:25",cellDate];
                                } else
                                    if ([cellNum isEqualToString:@" 8"]) {
                                        cellDT = [NSString stringWithFormat:@"%@ 20:10",cellDate];
                                    }
        float noteX = skedCell.frame.origin.x + skedCell.frame.size.width - 15;
        float noteY = skedCell.frame.origin.y - 5;
        NSUserDefaults *fullData = [NSUserDefaults standardUserDefaults];
        [fullData setValue:cellDT forKey:@"CellDate"];
        [fullData setValue:[NSString stringWithFormat:@"%f",noteX] forKey:@"cellX"];
        [fullData setValue:[NSString stringWithFormat:@"%f",noteY] forKey:@"cellY"];
        NSString *tempRequest = [NSString stringWithFormat:@"%@%@",@"usrNoteDatesFor",[fullData valueForKey:@"ID"]];
        if ([fullData valueForKeyPath:tempRequest] != nil) {
            NSMutableArray *noteDates = [fullData valueForKeyPath:tempRequest];
            if ([noteDates containsObject:cellDT]) {
                UIActionSheet *cellOptions = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:@"Убрать пару" otherButtonTitles:@"Редактировать заметку", @"Напомнить",nil];
                [cellOptions setActionSheetStyle:UIActionSheetStyleBlackOpaque];
                [cellOptions showInView:self.view];
                return;
            }
        }
        UIActionSheet *cellOptions = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:@"Убрать пару" otherButtonTitles:@"Добавить заметку", @"Напомнить",nil];
        [cellOptions setActionSheetStyle:UIActionSheetStyleBlackOpaque];
        [cellOptions showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Убрать пару"]) {
        userDeleteLesson = [NSString stringWithFormat:@"%@%@", @"userDeletedFor-", [[NSUserDefaults standardUserDefaults]valueForKey:@"ID"]];
        NSUserDefaults *deletedRectangles = [NSUserDefaults standardUserDefaults];
        NSArray *temp = [deletedRectangles objectForKey:userDeleteLesson];
        NSMutableArray *userSkedDeletedRects =  nil;
        if(temp) {
            userSkedDeletedRects = [temp mutableCopy];
        } else {
            userSkedDeletedRects = [[NSMutableArray alloc]init];
        }
        [userSkedDeletedRects addObject:[NSNumber numberWithInteger:skedCell.tag]];
        [deletedRectangles setObject:userSkedDeletedRects forKey:userDeleteLesson];
        [deletedRectangles synchronize];
        //NSLog(@"%ld", (long)skedCell.tag);
        [skedCell removeFromSuperview];
    }
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Добавить заметку"]||[[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Редактировать заметку"]) {
        UIViewController *topNoteForm = [self.storyboard instantiateViewControllerWithIdentifier:@"Заметка"];
        self.slidingViewController.topViewController = topNoteForm;
        [self.slidingViewController resetTopView];
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
    self.toggleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.toggleBtn.titleLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 24.0f]];
    toggleBtn.frame = CGRectMake((self.view.frame.size.width/5), 30, (self.view.frame.size.width/1.5f), 24);
    NSString *title = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"curName"],@" ▾"];//▴
    [toggleBtn setTitle:title forState:UIControlStateNormal];
    [toggleBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    toggleBtn.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    [self.view addSubview:toggleBtn];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    NSArray *grHistory = [[NSUserDefaults standardUserDefaults] valueForKey:@"SavedGroups"];
    NSArray *tHistory = [[NSUserDefaults standardUserDefaults] valueForKey:@"SavedTeachers"];
    remenuSize = 0;
    for (NSString *gr in grHistory) {
        REMenuItem *groupItem = [[REMenuItem alloc] initWithTitle:gr
                                                            image:[UIImage imageNamed:@"---"]
                                                 highlightedImage:nil
                                                           action:^(REMenuItem *item) {
                                                               [self getIdByName:gr];
                                                               [mainSkedView removeFromSuperview];
                                                               [toggleBtn removeFromSuperview];
                                                               [self viewDidLoad];
                                                           }];
        [items addObject:groupItem];
        remenuSize += 50;
    }
    for (NSString *tchr in tHistory) {
        REMenuItem *teacherItem = [[REMenuItem alloc] initWithTitle:tchr
                                                              image:[UIImage imageNamed:@"---"]
                                                   highlightedImage:nil
                                                             action:^(REMenuItem *item) {
                                                                 [self getIdByName:tchr];
                                                                 [mainSkedView removeFromSuperview];
                                                                 [toggleBtn removeFromSuperview];
                                                                 [self viewDidLoad];
                                                             }];
        [items addObject:teacherItem];
        remenuSize += 50;
    }
    self.menu = [[REMenu alloc] initWithItems:items];
    self.menu.liveBlur = YES;
    self.menu.bounce = YES;
    self.menu.borderColor = [UIColor clearColor];
    self.menu.textShadowColor = [UIColor clearColor];
    self.menu.textColor = [UIColor blackColor];
    self.menu.highlightedTextShadowColor = [UIColor clearColor];
    self.menu.highlightedTextColor = [UIColor blackColor];
    self.menu.highlightedBackgroundColor = [UIColor orangeColor];
    self.menu.separatorHeight = 0.5f;
    self.menu.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 22.0f];
    [toggleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void) toggleMenu {
    //Задаёт парамеры появленя выпадающего меню.
    remenuScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 62, self.view.frame.size.width, 320)];
    remenuView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, remenuSize)];
    remenuScroller.contentSize = CGSizeMake(0, remenuSize);
    [remenuScroller setShowsVerticalScrollIndicator:NO];
    
    if (self.menu.isOpen) {
        return [self.menu closeWithViews:remenuScroller view:remenuView];
    }
    
    [remenuScroller addSubview:remenuView];
    [self.view addSubview:remenuScroller];
    
    [self.menu showInView:remenuView];
    
}

- (IBAction)goToNewCell:(id)sender {
    InitViewController *ini;
    ini = [self.storyboard instantiateViewControllerWithIdentifier:@"Init"];
    ini.location = @"ДобавлениеПары";
    NewSkedCell *second = [self.storyboard instantiateViewControllerWithIdentifier:@"ДобавлениеПары"];
    [self presentViewController:second animated:YES completion:nil];
}

- (void) aTimeUpdate {
    //Инициализирует таймер
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

- (void) drawUserChanges {
    // Вносит пользовательские изменения в расписании
    // добавленные\удалённые предметы
    userAddLesson = [NSString stringWithFormat:@"%@%@", @"userDataFor-", [[NSUserDefaults standardUserDefaults]valueForKey:@"ID"]];
    userAddLessonText = [NSString stringWithFormat:@"%@%@", @"userDataTextFor-", [[NSUserDefaults standardUserDefaults]valueForKey:@"ID"]];
    NSLog(@"%@", userAddLesson);
    NSLog(@"%@", userAddLessonText);
    NSMutableArray *userSked = [[NSUserDefaults standardUserDefaults] objectForKey:userAddLesson];
    NSMutableArray *userSkedText = [[NSUserDefaults standardUserDefaults] objectForKey:userAddLessonText];
    if(userSked.count > 0 && userSkedText.count > 0) {
        CGRect skedRect;
        for(int i=0;i<userSked.count;i++) {
            NSLog(@"Adding sked whith coordinates %@", [userSked objectAtIndex:i]);
            NSLog(@"Adding text to sked: %@", [userSkedText objectAtIndex:i]);
            skedRect = CGRectFromString([userSked objectAtIndex:i]);
            newSkedCell = [[UIView alloc]initWithFrame:skedRect];
            UILabel *lesson = [[UILabel alloc]initWithFrame:skedRect];
            NSString *temp = [userSkedText objectAtIndex:i];
            lesson.text = temp;
            lesson.lineBreakMode = 5;
            lesson.numberOfLines = 3;
            lesson.textColor = [UIColor blackColor];
            [lesson setFont:[UIFont fontWithName: @"Helvetica Neue" size: 12.0f]];
            lesson.textAlignment = NSTextAlignmentCenter;
            
            if(!([temp rangeOfString:@"Лк"].location == NSNotFound)) {
                newSkedCell.backgroundColor = [UIColor colorWithRed:1 green:0.961 blue:0.835 alpha:1.0];
            } else
                if(!([temp rangeOfString:@"Пз"].location == NSNotFound)) {
                    newSkedCell.backgroundColor = [UIColor colorWithRed:0.78 green:0.922 blue:0.769 alpha:1.0];
                } else
                    if(!([temp rangeOfString:@"Лб"].location == NSNotFound)) {
                        newSkedCell.backgroundColor = [UIColor colorWithRed:0.804 green:0.8 blue:1 alpha:1.0];
                    } else
                        if(!([temp rangeOfString:@"Конс"].location == NSNotFound)) {
                            newSkedCell.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.0];
                        } else
                            if(!([temp rangeOfString:@"Зал"].location == NSNotFound)) {
                                newSkedCell.backgroundColor = [UIColor colorWithRed:0.761 green:0.627 blue:0.722 alpha:1.0];
                            } else
                                if(!([temp rangeOfString:@"зач"].location == NSNotFound)) {
                                    newSkedCell.backgroundColor = [UIColor colorWithRed:0.761 green:0.627 blue:0.722 alpha:1.0];
                                } else
                                    if(!([temp rangeOfString:@"ЕкзП"].location == NSNotFound)) {
                                        newSkedCell.backgroundColor = [UIColor colorWithRed:0.561 green:0.827 blue:0.988 alpha:1.0];
                                    } else
                                        if(!([temp rangeOfString:@"ЕкзУ"].location == NSNotFound)) {
                                            newSkedCell.backgroundColor = [UIColor colorWithRed:0.561 green:0.827 blue:0.988 alpha:1.0];
                                        } else
                                            if(!([temp rangeOfString:@"Екз"].location == NSNotFound)) {
                                                newSkedCell.backgroundColor = [UIColor colorWithRed:0.561 green:0.827 blue:0.988 alpha:1.0];
                                            } else
                                                newSkedCell.backgroundColor = [UIColor colorWithRed:1 green:0.859 blue:0.957 alpha:1.0];
            
            lesson.backgroundColor = [UIColor clearColor];
            [mainSkedView addSubview:newSkedCell];
            [mainSkedView addSubview:lesson];
            [self skedCellAddLONGPRESSGestureRecognizer];
        }
    }
    
    userDeleteLesson = [NSString stringWithFormat:@"%@%@", @"userDeletedFor-", [[NSUserDefaults standardUserDefaults]valueForKey:@"ID"]];
    NSLog(@"%@", userDeleteLesson);
    NSMutableArray *deletedSked = [[NSUserDefaults standardUserDefaults]objectForKey:userDeleteLesson];
    if(deletedSked.count > 0) {
        for (int i=0;i<deletedSked.count;i++) {
            NSLog(@"cell at tag will be deleted %d", [[deletedSked objectAtIndex:i] integerValue]);
            [[mainSkedView viewWithTag:[[deletedSked objectAtIndex:i] integerValue]] removeFromSuperview];
        }
    }
}

-(BOOL) isNull {
    NSString *curId = [[NSUserDefaults standardUserDefaults] valueForKey:@"ID"];
    if(curId.length < 1) {
        UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(0, 95, self.view.frame.size.width, 300)];
        message.text = @"У вас ещё нет ни групп ни преподавателей, попробуйте их добавить.";
        [message setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:32.0f]];
        message.textAlignment = NSTextAlignmentCenter;
        message.numberOfLines = 5;
        [self.view addSubview:message];
        return true;
    } else
        return false;
}

- (NSString *) getWeekDay:(NSString*)today {
    NSDateFormatter* weekDayFormatter = [[NSDateFormatter alloc] init];
    [weekDayFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [weekDayFormatter setDateFormat:@"dd.MM, EE"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    NSDate *day = [formatter dateFromString:today];
    return [weekDayFormatter stringFromDate:day];
}

- (void) getIdByName:(NSString *)name {
    NSUserDefaults *fullData = [NSUserDefaults standardUserDefaults];
    [fullData setValue:name forKey:@"curName"];
    [fullData setValue:[[NSUserDefaults standardUserDefaults]valueForKey:name] forKey:@"ID"];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return  YES;
}

@end