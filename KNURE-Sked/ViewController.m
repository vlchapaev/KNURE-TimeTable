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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)Connect:(id)sender {
    // создаем запрос
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://cist.kture.kharkov.ua/ias/app/tt/f?p=778:201:2479955598984498:::201:P201_FIRST_DATE,P201_LAST_DATE,P201_GROUP,P201_POTOK:01.09.2013,31.01.2014,3417111,0:"]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    
    // создаём соединение и начинаем загрузку
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
        // соединение началось
        label.text = @"Connecting...";
        // создаем NSMutableData, чтобы сохранить полученные данные
        receivedData = [NSMutableData data];
    } else {
        // при попытке соединиться произошла ошибка
        label.text = @"Connection error!";
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // получен ответ от сервера
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
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
    label.text = errorString;
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // данные получены
    // здесь можно произвести операции с данными
    
    // можно узнать размер загруженных данных
    //NSString *dataString = [[NSString alloc] initWithFormat:@"Received %d bytes of data",[receivedData length]];
    
    // если ожидаемые полученные данные - это строка, то можно вывести её
    NSString *dataString = [[NSString alloc] initWithData:receivedData encoding: NSWindowsCP1251StringEncoding];
    
    label.text = dataString;
    
    // освобождаем соединение и полученные данные
}

@end
