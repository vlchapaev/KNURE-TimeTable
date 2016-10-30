//
//  InitViewController.m
//  SlideMenu
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
    NSString *identifier;
    switch (indexPath.row) {
        case 0:
            identifier = @"SkedSegue";
            break;
        case 1:
            identifier = @"GroupSegue";
            break;
        case 2:
            identifier = @"TeacherSegue";
            break;
        case 3:
            identifier = @"AuditorySegue";
            break;
        default: identifier = @"GroupSegue"; break;
    }
    return identifier;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)configureLeftMenuButton:(UIButton *)button {
    CGRect frame = button.frame;
    frame.origin = (CGPoint){0, 0};
    frame.size = (CGSize){40,40};
    button.frame = frame;
    [button setImage:[UIImage imageNamed:@"MenuButton"] forState:UIControlStateNormal];
}

@end
