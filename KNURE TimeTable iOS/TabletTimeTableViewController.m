//
//  TabletTimeTableViewController.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 23.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import "TabletTimeTableViewController.h"
#import "MenuTableViewController.h"

@interface TabletTimeTableViewController () <UIPopoverPresentationControllerDelegate>

@end

@implementation TabletTimeTableViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [super initWithCoder:coder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupProperties];
}

#pragma mark - Setups



- (void)setupProperties {
    
}

#pragma mark - Events

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

@end
