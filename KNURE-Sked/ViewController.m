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
    [self createScrollMenu];
}

- (void)createScrollMenu {
    NSUserDefaults *fullLessonsData = [NSUserDefaults standardUserDefaults];
    //создаёт скролл меню, заполенное uiview
    //TODO придумат как заполнять в соответствии с предметами
    //эта часть кода вернёт все даты
    //TODO придумать как помесить это в отдельную функцию
    
    //задаём текущую дату для автопозиции scroll view
    NSDateFormatter * dataformatter = [[NSDateFormatter alloc]init];
    [dataformatter setDateFormat:@"dd.MM.yyy"];
    
    NSString *source = [fullLessonsData objectForKey:@"3802949"];
    NSError *error = nil;
    NSRegularExpression *delGRP = [NSRegularExpression regularExpressionWithPattern:@"[А-ЯІЇЄҐ;]+[-]+[0-9]+[-]+[0-9]"
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:&error];
    NSString *delgrp = [delGRP stringByReplacingMatchesInString:source
                                                        options:0
                                                          range:NSMakeRange(0, [source length])
                                                   withTemplate:@""];
    
    NSRegularExpression *delTIME = [NSRegularExpression regularExpressionWithPattern:@"[0-9]+[:]+[0-9]+[0-9:0-9]+[0-9]"
                                                                             options:NSRegularExpressionCaseInsensitive
                                                                               error:&error];
    NSString *deltime = [delTIME stringByReplacingMatchesInString:delgrp
                                                          options:0
                                                            range:NSMakeRange(0, [delgrp length])
                                                     withTemplate:@""];
    NSString *delSpace = [deltime stringByReplacingOccurrencesOfString:@"   " withString:@" "];
    //NSLog(@"%@", delSpace);
    //
    NSArray *list = [delSpace componentsSeparatedByString:@"\r"];
    
    /*NSArray *stringsArray = [NSArray arrayWithObjects:
     @"string 1",
     @"String 21",
     @"string 12",
     @"String 11",
     @"String 02", nil];*/
    
    static NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch | NSNumericSearch |
    NSWidthInsensitiveSearch | NSForcedOrderingSearch;
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSComparator finderSort = ^(id string1, id string2) {
        NSRange string1Range = NSMakeRange(0, [delSpace length]);
        return [string1 compare:string2 options:comparisonOptions range:string1Range locale:currentLocale];
    };
    
    NSArray *sortedArray = [list sortedArrayUsingComparator:finderSort];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(70, 75, 245, 490)];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    
    int x = 0;
    int y = 25;
    int z = 0;
    int frameCounter = 115;
    int lessonShift = 0;
    
    for(int i = 0; i<sortedArray.count; i++) {
        NSLog(@"%@", [sortedArray objectAtIndex:i]);
        // инициализация сетки расписания
        UIView *dateGrid = [[UIView alloc]initWithFrame:CGRectMake(x + 5, 5, 110, 20)];
        UIView *skedGrid = [[UIView alloc]initWithFrame:CGRectMake(x + 5, y + 5, 110, 50)];
        dateGrid.backgroundColor = [UIColor yellowColor];
        skedGrid.backgroundColor = [UIColor greenColor];
        // инициализация текстовых полей
        UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 110, 20)];
        UILabel *sked = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 110, 50)];
        date.text = [sortedArray objectAtIndex:i];
        sked.text = [sortedArray objectAtIndex:i];
        [date setFont:[UIFont fontWithName: @"Trebuchet MS" size: 10.0f]];
        date.textAlignment = NSTextAlignmentCenter;
        [sked setFont:[UIFont fontWithName: @"Trebuchet MS" size: 10.0f]];
        sked.textAlignment = NSTextAlignmentCenter;
        //if([[source substringWithRange:[matches[i] range]]  isEqual: [dataformatter stringFromDate:[NSDate date]]]) {
            //если выводимая дата равна текущей, то ставим эту позицию для скроллера
        x += skedGrid.frame.size.width + 5;
        z += dateGrid.frame.size.width + 5;
        [scrollView addSubview:dateGrid];
        [scrollView addSubview:skedGrid];
        [dateGrid addSubview:date];
        [skedGrid addSubview:sked];
    }
    
    /*
    //прорисовка пар
    y = 25;
    //убираем &nbsp
    NSRegularExpression *delNBSP = [NSRegularExpression regularExpressionWithPattern:@"[&nbsp]"
                                                                             options:NSRegularExpressionCaseInsensitive
                                                                               error:&error];
    NSString *delnbsp = [delNBSP stringByReplacingMatchesInString:source
                                                          options:0
                                                            range:NSMakeRange(0, [source length])
                                                     withTemplate:@"$2$1"];
    //NSLog(@"%@", delnbsp);
    //убираем даты
    NSRegularExpression *delDATES = [NSRegularExpression regularExpressionWithPattern:@"[0-9]+[.]+[0-9]+[.]+[0-9]+[0-9]"
                                                                              options:NSRegularExpressionCaseInsensitive
                                                                                error:&error];
    NSString *deldates = [delDATES stringByReplacingMatchesInString:delnbsp
                                                            options:0
                                                              range:NSMakeRange(0, [delnbsp length])
                                                       withTemplate:@"$2$1"];
    //NSLog(@"%@", deldates);
    //убираем время
    NSRegularExpression *delTIMES = [NSRegularExpression regularExpressionWithPattern:@"[0-9]+[:]+[0-9]+[0-9]"
                                                                              options:NSRegularExpressionCaseInsensitive
                                                                                error:&error];
    NSString *deltimes = [delTIMES stringByReplacingMatchesInString:deldates
                                                            options:0
                                                              range:NSMakeRange(0, [deldates length])
                                                       withTemplate:@"$2$1"];
    //NSLog(@"%@", deltimes);
    NSString *del = [deltimes stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    NSLog(@"%@", del);
    //удаляем остальное
    NSRegularExpression *delREST = [NSRegularExpression regularExpressionWithPattern:@"\\s?[*]?[а-яіїєґ,А-ЯІЇЄҐ,a-z.',0-9]+\\s"
                                                                             options:NSRegularExpressionCaseInsensitive
                                                                               error:&error];
    NSArray *matches1 = [delREST matchesInString:del
                                        options:0
                                          range:NSMakeRange(0, [del length])];
    i = 28;
    for(int j = 0; j < 6; j++) {
        i = 28;
        for(NSTextCheckingResult *match in matches1) {
            if(i>=795) {
                break;
            }
            NSString *result = [del substringWithRange:[matches1[i] range]];
            NSLog(@"%@", result);
            UIView *skedGrid = [[UIView alloc]initWithFrame:CGRectMake(x + 5, y + 5, 110, 50)];
            skedGrid.backgroundColor = [UIColor greenColor];
            UILabel *lesson = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 40)];
                NSString *lection = [deltimes substringWithRange:[matches1[i] range]];
                NSString *type = [deltimes substringWithRange:[matches1[i+1] range]];
                NSString *room  =[deltimes substringWithRange:[matches1[i+2] range]];
                NSString *tempLection = [NSString stringWithFormat:@"%@%@%@", lection,type,room];
            
            lesson.text = tempLection;//[deltimes substringWithRange:[matches1[i] range]];
            [lesson setFont:[UIFont fontWithName: @"Trebuchet MS" size: 10.0f]];
            lesson.textAlignment = NSTextAlignmentCenter;
            [scrollView addSubview:skedGrid];
            [skedGrid addSubview:lesson];
            x += skedGrid.frame.size.width + 5;
        i+=3;
        }
        x = 0;
        y += 55;
   }*/
    scrollView.contentSize = CGSizeMake(z, scrollView.frame.size.height);
    scrollView.backgroundColor = [UIColor grayColor];
    scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:scrollView];
}

- (IBAction)getLastUpdate:(id)sender {
    NSUserDefaults* fullLessonsData = [NSUserDefaults standardUserDefaults];
    NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://cist.kture.kharkov.ua/ias/app/tt/WEB_IAS_TT_GNR_RASP.GEN_GROUP_POTOK_RASP?ATypeDoc=4&Aid_group=3802949&Aid_potok=0&ADateStart=01.09.2013&ADateEnd=31.01.2014&AMultiWorkSheet=0"]];
    NSString *csvResponseString = [[NSString alloc] initWithData:responseData encoding:NSWindowsCP1251StringEncoding];
    NSString *modifstr = [csvResponseString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSString *modifstr2 = [modifstr stringByReplacingOccurrencesOfString:@"," withString:@" "];
    [fullLessonsData setObject:modifstr2 forKey: @"3802949"];
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
