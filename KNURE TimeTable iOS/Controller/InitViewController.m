//
//  InitViewController.m
//  KNURE TimeTable iOS
//
//  Created by Vlad Chapaev on 07.09.14.
//  Copyright (c) 2014 Vlad Chapaev. All rights reserved.
//

#import "InitViewController.h"

@implementation InitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath {
    NSString *identifier = [[NSString alloc]init];
    switch (indexPath.row) {
        case 0: identifier = @"Timetable"; break;
        case 4: identifier = @"Information"; break;
        default: identifier = @"ItemList"; break;
    }
    return identifier;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)configureLeftMenuButton:(UIButton *)button {
    CGRect frame = button.frame;
    frame.origin = (CGPoint){0, 0};
    frame.size = (CGSize){44, 44};
    button.frame = frame;
    [button setImage:[UIImage imageNamed:@"MenuButton"] forState:UIControlStateNormal];
}

- (void)openContentViewControllerForMenu:(AMSlideMenu)menu atIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", (long)indexPath.row);
}

@end
