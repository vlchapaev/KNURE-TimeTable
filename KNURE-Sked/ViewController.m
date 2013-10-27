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
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://flapps.ru/example/user-info.php"]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    
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
    NSString *dataString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    label.text = dataString;
}

    /*
    NSURL *url = [NSURL URLWithString:@"http://google.com"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
    }*/

    /*
    NSString *html = nil;
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    
    HTMLNode *bodyNode = [parser body];
    //
    NSError *error = nil;
    NSString *html =
    @"<ul>"
    "<li><input type='image' name='input1' value='string1value' /></li>"
    "<li><input type='image' name='input2' value='string2value' /></li>"
    "</ul>"
    "<span class='spantext'><b>Hello World 1</b></span>"
    "<span class='spantext'><b>Hello World 2</b></span>";
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    
    HTMLNode *bodyNode = [parser body];
    
    NSArray *inputNodes = [bodyNode findChildTags:@"input"];
    
    for (HTMLNode *inputNode in inputNodes) {
        if ([[inputNode getAttributeNamed:@"name"] isEqualToString:@"input2"]) {
            NSLog(@"%@", [inputNode getAttributeNamed:@"value"]); //Answer to first question
        }
    }
    
    NSArray *spanNodes = [bodyNode findChildTags:@"span"];
    
    for (HTMLNode *spanNode in spanNodes) {
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"spantext"]) {
            NSLog(@"%@", [spanNode rawContents]); //Answer to second question
        }
    }
    */
@end
