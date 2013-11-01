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

- (void)skedGridPress:(UILongPressGestureRecognizer *)recogniser {
    
}

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
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(update) userInfo:NULL repeats:YES];
    NSUserDefaults *fullLessonsData = [NSUserDefaults standardUserDefaults];
    self->lessonsDataTextField.text = [fullLessonsData objectForKey:@"LastUpdate"];
    //вызов скролл меню
    [self createScrollMenu];
}

- (void)createScrollMenu {
    //создаёт скролл меню, заполенное uiview
    //TODO придумат как заполнять в соответствии с предметами
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(70, 75, 245, 490)];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    int x = 0;
    for (int i = 0; i < 5; i++) {
        // инициализация сетки расписания
        UIView *skedGrid = [[UIView alloc]initWithFrame:CGRectMake(x + 5, 5, 70, 40)];
        skedGrid.backgroundColor = [UIColor greenColor];
        // инициализация текстовых полей
        UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 40)];
        date.text = @"dd.mm.yy";
        [date setFont:[UIFont fontWithName: @"Trebuchet MS" size: 10.0f]];
        //date.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:skedGrid];
        [skedGrid addSubview:date];
        
        x += skedGrid.frame.size.width + 5;
    }
    scrollView.contentSize = CGSizeMake(x, scrollView.frame.size.height);
    scrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:scrollView];
}

- (int)countLessons {
    //пока не трогайте это
    int result = 0;
    return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getLastUpdate:(id)sender {
    // создаем запрос
    NSURLRequest *request = [NSURLRequest requestWithURL:
                            [NSURL URLWithString:@"http://cist.kture.kharkov.ua/ias/app/tt/f?p=778:201:2479955598984498:::201:P201_FIRST_DATE,P201_LAST_DATE,P201_GROUP,P201_POTOK:30.10.2013,30.10.2013,3417111,0:"]
                            cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    // создаём соединение и начинаем загрузку
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        // соединение началось
        lessonsDataTextField.text = @"Connecting...";
        // создаем NSMutableData, чтобы сохранить полученные данные
        receivedData = [NSMutableData data];
    }
    else {
        // при попытке соединиться произошла ошибка
        lessonsDataTextField.text = @"Connection error!";
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // получен ответ от сервера
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // добавляем новые данные к receivedData
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error {
    // освобождаем соединение и полученные данные
    // выводим сообщение об ошибке
    NSString *errorString = [[NSString alloc] initWithFormat:@"Connection failed! Error - %@ %@ %@",
                            [error localizedDescription],
                            [error description],
                            [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]];
    lessonsDataTextField.text = errorString;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // данные получены
    // здесь можно произвести операции с данными
    // если ожидаемые полученные данные - это строка, то можно вывести её
    NSString *dataString = [[NSString alloc] initWithData:receivedData encoding: NSWindowsCP1251StringEncoding];
    lessonsDataTextField.text = dataString;
    // парсинг:
    lessonsDataTextField.text = @"";
    NSError *error = nil;
    NSString *html = dataString;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    NSUserDefaults* fullLessonsData = [NSUserDefaults standardUserDefaults];
    HTMLNode *bodyNode = [parser body];
    NSArray *infoNodes = [bodyNode findChildTags:@"td"];
    for (HTMLNode *infoNode in infoNodes) {
            lessonsDataTextField.text = [lessonsDataTextField.text stringByAppendingString:
                         [@" " stringByAppendingString:
                         [infoNode.allContents copy]]];
    }
    [fullLessonsData setObject:self->lessonsDataTextField.text forKey: @"LastUpdate"];
    [fullLessonsData synchronize];
    NSLog(@"%@",[fullLessonsData objectForKey:@"LastUpdate"]);
    // освобождаем соединение и полученные данные
}

- (void)update {
    NSDateFormatter * dataformatter = [[NSDateFormatter alloc]init];
    [dataformatter setDateFormat:@"dd.MM.yyy HH:mm:ss"]; //вывод
    currentTime.text = [dataformatter stringFromDate:[NSDate date]];
}

- (IBAction)revealMenu:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end
