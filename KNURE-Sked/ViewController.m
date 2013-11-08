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
    menuBtn.frame = CGRectMake(13, 20, 34, 24);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.menuBtn];
    
    //я хз вообще что это
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(update) userInfo:NULL repeats:YES];
    
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
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(70, 75, 245, 490)];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    
    int dayShift = 0;
    int lessonShift = 25;
    int scrollViewSize = 0;
    int countDuplitateDays = 0;
    
    NSString *prewDate = [formatter stringFromDate:[[sorted objectAtIndex:1] valueForKey:@"date"]];
    //NSString *tempDay = [list objectAtIndex:1];
    //NSArray *temp = [tempDay componentsSeparatedByString:@" "];
    
    
    for(int i=1; i<sorted.count; i++) {
        NSString *mydate = [formatter stringFromDate:[[sorted objectAtIndex:i] valueForKey:@"date"]];
        NSLog(@"%@%@", mydate, [[sorted objectAtIndex:i] valueForKey:@"object"]);
        
        // инициализация сетки расписания
        
        
        UIView *dateGrid = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 5, 5, 110, 20)];
        
        
        UIView *skedGrid;
        dateGrid.backgroundColor = [UIColor yellowColor];
        
        // инициализация текстовых полей
        UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 110, 20)];
        UILabel *sked = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 110, 50)];
        
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
            scrollView.contentOffset = CGPointMake(dayShift + 20, 5);
        }
        
        if([[temp objectAtIndex:1] isEqual: @"2"])
            lessonShift += 55*1;
        if([[temp objectAtIndex:1] isEqual: @"3"])
            lessonShift += 55*2;
        if([[temp objectAtIndex:1] isEqual: @"4"])
            lessonShift += 55*3;
        if([[temp objectAtIndex:1] isEqual: @"5"])
            lessonShift += 55*4;
        if([[temp objectAtIndex:1] isEqual: @"6"])
            lessonShift += 55*5;
        if([[temp objectAtIndex:1] isEqual: @"7"])
            lessonShift += 55*6;
        if([[temp objectAtIndex:1] isEqual: @"8"])
            lessonShift += 55*7;
        
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
            skedGrid.backgroundColor = [UIColor yellowColor];
        }
        if ([[temp objectAtIndex:3] isEqual:@"Пз"]) {
            skedGrid = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 5, lessonShift + 5, 110, 50)];
            skedGrid.backgroundColor = [UIColor greenColor];
        }
        if ([[temp objectAtIndex:3] isEqual:@"Лб"]) {
            skedGrid = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 5, lessonShift + 5, 110, 50)];
            skedGrid.backgroundColor = [UIColor purpleColor];
        }
        if ([[temp objectAtIndex:3] isEqual:@"Конс"]) {
            skedGrid = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 5, lessonShift + 5, 110, 50)];
            skedGrid.backgroundColor = [UIColor whiteColor];
        }
        if ([[temp objectAtIndex:3] isEqual:@"ЕкзУ"]) {
            skedGrid = [[UIView alloc]initWithFrame:CGRectMake(dayShift + 5, lessonShift + 5, 110, 50)];
            skedGrid.backgroundColor = [UIColor redColor];
        }
        
        
        
        //конец большого велосипеда
        
       
        
        [date setFont:[UIFont fontWithName: @"Trebuchet MS" size: 10.0f]];
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
    scrollView.backgroundColor = [UIColor grayColor];
    scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:scrollView];
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
    NSDateFormatter * dataformatter = [[NSDateFormatter alloc]init];
    [dataformatter setDateFormat:@"dd.MM.yyy HH.mm.ss"]; //вывод
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
