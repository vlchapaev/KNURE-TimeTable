//
//  ViewController.m
//  KNURE-Sked
//
//  Created by Влад on 10/24/13.
//  Copyright (c) 2013 Влад. All rights reserved.
//
#import "ViewController.h"
#import "HTMLNode.h"

@class HTMLNode;
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *fullLessonsData = [NSUserDefaults standardUserDefaults];
    self->lessonsDataTextField.text = [fullLessonsData objectForKey:@"LastUpdate"];
    [self update];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(update) userInfo:NULL repeats:YES];
}

- (void)update {
    NSDateFormatter * dataformatter = [[NSDateFormatter alloc]init];
    [dataformatter setDateFormat:@"dd.MM.yyy HH:mm:ss"]; //вывод
    currntTime.text = [dataformatter stringFromDate:[NSDate date]];
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

@end
