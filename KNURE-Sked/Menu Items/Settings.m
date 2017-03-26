//
//  Settings.m
//  KNURE-Sked
//
//  Created by Влад on 11/2/13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import "Settings.h"
#import "ECSlidingViewController.h"
#import "TabsViewController.h"

@interface Settings ()

@end

@implementation Settings

@synthesize menuBtn;

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
    
    [self initScrollView];
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[TabsViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    self.slidingViewController.panGesture.delegate = self;
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(13, 30, 34, 24);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.menuBtn];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"changed"]){
        [showEmptyDaysSwith setOn:YES];
    } else {
        BOOL changed = [[NSUserDefaults standardUserDefaults] boolForKey:@"showEmptyDaysChanged"];
        [showEmptyDaysSwith setOn:changed];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)revealMenu:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void) initScrollView {
    scrollView.contentSize = CGSizeMake(0, 700);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return  YES;
}

- (IBAction)fontSizeChanged:(UISlider *)sender {
}

- (IBAction)showEmptyDaysChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"changed"];
    [[NSUserDefaults standardUserDefaults]setBool:(sender.on?YES:NO) forKey:@"showEmptyDaysChanged"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)showYearChanged:(UISwitch *)sender {
}

- (IBAction)showWeekChanged:(UISwitch *)sender {
}

- (IBAction)automaticUpdateChanged:(UISwitch *)sender {
}
@end
