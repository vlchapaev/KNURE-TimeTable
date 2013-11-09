//
//  ViewController.m
//  KNURE-Sked
//
//  Created by Влад on 10/24/13.
//  Copyright (c) 2013 Влад. All rights reserved.
//
#import "ViewController.h"
#import "HTMLNode.h"
#import "ECSlidingViewController.h"
#import "TabsViewController.h"

@class HTMLNode;

@interface ViewController ()

@end

@implementation ViewController

@synthesize menuBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (void)skedGridPress:(UILongPressGestureRecognizer *)recogniser {}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self update];
    
    //инициализация кнопки и выдвигающегося меню
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
    
    //я хз вообще что это
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(update) userInfo:NULL repeats:YES];
    
    [self createTimeMenu];
    //вызов скролл меню
    @try {
        [self createScrollMenu];
    }
    @catch(NSException *e) {
        [self getLastUpdate:nil];
        [self createScrollMenu];
    }
}

- (void)createScrollMenu {
    
    //создаёт скролл меню, заполенное uiview
    //TODO придумат как заполнять в соответствии с предметами
    //эта часть кода вернёт все даты
    //TODO придумать как помесить это в отдельную функцию
    
    //задаём текущую дату для автопозиции scroll view
    NSUserDefaults *fullLessonsData = [NSUserDefaults standardUserDefaults];
    
    NSDateFormatter * dataformatter = [[NSDateFormatter alloc]init];
    [dataformatter setDateFormat:@"dd.MM.yyy"];
    
    //NSString *lessons = [fullLessonsData objectForKey:@"3417111"];
    NSArray *list = [fullLessonsData objectForKey:@"3417111"];
    //сортировка эелементов
    NSMutableArray *sorted = [[NSMutableArray alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    for (NSString *str in list) {
        if ([str isEqual:@""]) {
            continue;
        }
        NSRange rangeForSpace = [str rangeOfString:@" "];
        NSString *objectStr = [str substringFromIndex:rangeForSpace.location];
        NSString *dateStr = [str substringToIndex:rangeForSpace.location];
        NSDate *date = [formatter dateFromString:dateStr];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:objectStr, @"object", date, @"date", nil];
        [sorted addObject:dic];
    }
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    [sorted sortUsingDescriptors:[NSArray arrayWithObjects:sortDesc, nil]];
    
    //NSString *delRest =[delSpace stringByReplacingOccurrencesOfString:@"Дата Время начала Время завершения Пара Описание" withString:@""];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(50, 95, 270, 470)];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    
    int dayShift = 0;
    int lessonShift = 25;
    int scrollViewSize = 0;
    int countDuplitateDays = 0;
    
    //NSString *tempDay = [list objectAtIndex:1];
    //NSArray *temp = [tempDay componentsSeparatedByString:@" "];
    
    for(int i=1; i<sorted.count; i++) {
        //NSString *mydate = [formatter stringFromDate:[[sorted objectAtIndex:i] valueForKey:@"date"]];
        //NSLog(@"%@%@", mydate, [[sorted objectAtIndex:i] valueForKey:@"object"]);
        
        // инициализация сетки расписания
        
        
        UIView *dateGrid = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 5, 5, 110, 20)];
        
        
        UIView *skedGrid;
        dateGrid.backgroundColor = [UIColor clearColor];
        
        // инициализация текстовых полей
        UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 20)];
        UILabel *sked = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 110, 50)];
        
        //большой, непродуманный велосипед
        date.text = [formatter stringFromDate:[[sorted objectAtIndex:i-1] valueForKey:@"date"]];
        
        //запрещает сдвиг, если текущий день равен предыдущему
        
        NSString *prewDate = [formatter stringFromDate:[[sorted objectAtIndex:i] valueForKey:@"date"]];
        if(i>1&&[prewDate isEqual:[formatter stringFromDate:[[sorted objectAtIndex:i-1] valueForKey:@"date"]]]) {
            countDuplitateDays = 1;
        }
        else
            countDuplitateDays = 0;
        
        if(countDuplitateDays == 0 && i > 1) {
            dayShift += dateGrid.frame.size.width + 5;
        }

        NSString *tempDay = [[sorted objectAtIndex:i] valueForKey:@"object"];
        NSArray *temp = [tempDay componentsSeparatedByString:@" "];
        
        if(temp.count<6)
            continue;
        
        
        
        //если выводимое время равно текущему, то установить автопоизицию скроллера на этом месте
        if([[formatter stringFromDate:[[sorted objectAtIndex:i] valueForKey:@"date"]] isEqual: [dataformatter stringFromDate:[NSDate date]]]) {
            scrollView.contentOffset = CGPointMake(dayShift , 0);
        }
        
        if([[temp objectAtIndex:1] isEqual: @"2"]) {
            lessonShift += 55*1;
        }
        if([[temp objectAtIndex:1] isEqual: @"3"]) {
            lessonShift += 55*2;
        }
        if([[temp objectAtIndex:1] isEqual: @"4"]) {
            lessonShift += 55*3;
        }
        if([[temp objectAtIndex:1] isEqual: @"5"]) {
            lessonShift += 55*4;
        }
        if([[temp objectAtIndex:1] isEqual: @"6"]) {
            lessonShift += 55*5;
        }
        if([[temp objectAtIndex:1] isEqual: @"7"]) {
            lessonShift += 55*6;
        }
        if([[temp objectAtIndex:1] isEqual: @"8"]) {
            lessonShift += 55*7;
        }
        
        /*
        NSString *tempLesson = [NSString stringWithFormat:@"%@%@%@%@%@",
                                [temp objectAtIndex:2],
                                @" ",
                                [temp objectAtIndex:3],
                                @" ",
                                [temp objectAtIndex:4]];
         */
        
        sked.text = [[sorted objectAtIndex:i] valueForKey:@"object"];
        
        if ([[temp objectAtIndex:3] isEqual:@"Лк"]) {
            skedGrid = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 5, lessonShift + 5, 110, 50)];
            skedGrid.backgroundColor = [UIColor colorWithRed:0.996 green:0.996 blue:0.918 alpha:1.0];
        }
        if ([[temp objectAtIndex:3] isEqual:@"Пз"]) {
            skedGrid = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 5, lessonShift + 5, 110, 50)];
            skedGrid.backgroundColor = [UIColor colorWithRed:0.855 green:0.914 blue:0.851 alpha:1.0];
        }
        if ([[temp objectAtIndex:3] isEqual:@"Лб"]) {
            skedGrid = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 5, lessonShift + 5, 110, 50)];
            skedGrid.backgroundColor = [UIColor colorWithRed:0.804 green:0.8 blue:1 alpha:1.0];
        }
        if ([[temp objectAtIndex:3] isEqual:@"Конс"]) {
            skedGrid = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 5, lessonShift + 5, 110, 50)];
            skedGrid.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.0];
        }
        if ([[temp objectAtIndex:3] isEqual:@"ЕкзУ"]) {
            skedGrid = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 5, lessonShift + 5, 110, 50)];
            skedGrid.backgroundColor = [UIColor colorWithRed:0.561 green:0.827 blue:0.988 alpha:1.0];
        }
        
        //конец большого велосипеда
        
        [date setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
        date.textAlignment = NSTextAlignmentCenter;
        [sked setFont:[UIFont fontWithName: @"Trebuchet MS" size: 12.0f]];
        sked.textAlignment = NSTextAlignmentCenter;
        
        scrollViewSize += dateGrid.frame.size.width + 5;
        lessonShift = 25;
        
        [scrollView addSubview:dateGrid];
        [scrollView addSubview:skedGrid];
        [dateGrid addSubview:date];
        [skedGrid addSubview:sked];
    }
    
    scrollView.contentSize = CGSizeMake(scrollViewSize, scrollView.frame.size.height);
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:scrollView];
}

- (void) createTimeMenu {
    int framecounter = 0;
    for (int i=1; i<9; i++) {
        UIView *timeGrid = [[UIView alloc]initWithFrame:CGRectMake(5, 125 + framecounter, 50, 50)];
        UILabel *timeStart = [[UILabel alloc]initWithFrame:CGRectMake(5, -10, 50, 50)];
        UILabel *timeEnd = [[UILabel alloc]initWithFrame:CGRectMake(5, 15, 50, 50)];
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
        [timeStart setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
        [timeEnd setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
        [timeGrid addSubview:timeStart];
        [timeGrid addSubview:timeEnd];
        framecounter+=55;
        [self.view addSubview:timeGrid];
    }
}
    


- (IBAction)getLastUpdate:(id)sender {
    NSError *error = nil;
    NSUserDefaults* fullLessonsData = [NSUserDefaults standardUserDefaults];
    NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://cist.kture.kharkov.ua/ias/app/tt/WEB_IAS_TT_GNR_RASP.GEN_GROUP_POTOK_RASP?ATypeDoc=4&Aid_group=3417111&Aid_potok=0&ADateStart=01.09.2013&ADateEnd=31.01.2014&AMultiWorkSheet=0"]];
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
    [fullLessonsData setObject:list forKey: @"3417111"];
    [fullLessonsData synchronize];
}

- (void)update {
    NSDateFormatter *dataformatter = [[NSDateFormatter alloc]init];
    [dataformatter setDateFormat:@"HH.mm.ss"]; //вывод
    [currentTime setFont:[UIFont fontWithName:@"HalfLife2" size:24]];
    currentTime.text = [dataformatter stringFromDate:[NSDate date]];
}

- (IBAction)revealMenu:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
