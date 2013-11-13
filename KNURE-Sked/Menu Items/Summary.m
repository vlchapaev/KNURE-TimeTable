//
//  Summary.m
//  KNURE-Sked
//
//  Created by Влад on 11/2/13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import "Summary.h"
#import "ECSlidingViewController.h"
#import "TabsViewController.h"
#import "HTMLNode.h"
#import "HTMLParser.h"

@interface Summary ()

@end

@implementation Summary

@synthesize menuBtn;
@synthesize abrvTextView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    
    
    //Сводка
    NSString *idgroup = [[NSUserDefaults standardUserDefaults] valueForKey:@"ID"]; //присвоение значения ID группы
    
    NSError *error = nil;
    //NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://cist.kture.kharkov.ua/ias/app/tt/f?p=778:201:648211543257687:::201:P201_FIRST_DATE,P201_LAST_DATE,P201_GROUP,P201_POTOK:01.09.2013,31.01.2014,3417083,0:"]];
    NSString *URL = [NSString stringWithFormat: @"%@%@", @"http://cist.kture.kharkov.ua/ias/app/tt/f?p=778:201:648211543257687:::201:P201_FIRST_DATE,P201_LAST_DATE,P201_GROUP,P201_POTOK:01.09.2013,31.01.2014,", idgroup];
    
    NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];

    NSString *textHTML = [[NSString alloc] initWithData:responseData encoding:NSWindowsCP1251StringEncoding];
    
    HTMLParser *parser = [[HTMLParser alloc] initWithString:textHTML error:&error];

    HTMLNode *bodyNode = [parser body];
    NSString *result = @"";
    NSString *deltag;
    NSArray *tableNodes = [bodyNode findChildTags:@"table"];
    for (HTMLNode *tableNode in tableNodes) {
        if ([[tableNode getAttributeNamed:@"class"] isEqualToString:@"footer"]) {
            NSArray *postNodes = [tableNode findChildTags:@"td"];
            for (HTMLNode *postNode in postNodes) {
                NSArray *aTags = [postNode findChildTags:@"a"];
                result = [NSString stringWithFormat:@"%@%@%@", result, @" ", postNode.allContents];
            }
        }
    }
    
    
    abrvTextView.text = result;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)revealMenu:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end
