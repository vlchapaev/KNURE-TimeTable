//
//  ApplicationStyle.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 25.03.17.
//  Copyright © 2017 Vlad Chapaev. All rights reserved.
//

#import "Configuration.h"

@implementation Configuration

+ (instancetype)sharedInstance {
    static Configuration *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Configuration alloc] init];
    });
    return sharedInstance;
}

- (void)setupTheme {
    BOOL isDarkTheme = [[NSUserDefaults standardUserDefaults]boolForKey:TimetableIsDarkMode];
    if (isDarkTheme) {
        [self setDarkTheme];
    } else {
        [self setDefaultTheme];
    }
}

- (void)setDarkTheme {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [UINavigationBar appearance].backgroundColor = ApplicationThemeBackgroundColorDark;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].barTintColor = ApplicationThemeBackgroundColorDark;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    [UITableView appearance].backgroundColor = ApplicationThemeBackgroundColorDark;
    [UITableViewCell appearance].backgroundColor = ApplicationThemeBackgroundColorDark;
    [UITableViewCell appearance].contentView.backgroundColor = ApplicationThemeBackgroundColorDark;
    [UITableViewCell appearance].textLabel.textColor = [UIColor whiteColor];
    
    [UICollectionView appearance].backgroundColor = ApplicationThemeBackgroundColorDark;
    
    [UILabel appearanceWhenContainedIn:UITableViewCell.class, nil].textColor = [UIColor whiteColor];
    
    [UISearchBar appearance].keyboardAppearance = UIKeyboardAppearanceDark;
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)setDefaultTheme {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [UINavigationBar appearance].backgroundColor = [UIColor whiteColor];
    [UINavigationBar appearance].tintColor = nil;
    [UINavigationBar appearance].barTintColor = nil;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    
    [UITableView appearance].backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    [UITableViewCell appearance].backgroundColor = [UIColor whiteColor];
    [UITableViewCell appearance].contentView.backgroundColor = nil;
    
    [UICollectionView appearance].backgroundColor = [UIColor whiteColor];
    
    [UILabel appearanceWhenContainedIn:UITableViewCell.class, nil].textColor = [UIColor blackColor];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)applyTheme {
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        for (UIView *view in window.subviews) {
            [view removeFromSuperview];
            [window addSubview:view];
        }
    }
}

@end
