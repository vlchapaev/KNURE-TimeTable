//
//  ApplicationStyle.m
//  KNURE TimeTable
//
//  Created by Vladislav Chapaev on 25.03.17.
//  Copyright © 2017 Vladislav Chapaev. All rights reserved.
//

#import "Configuration.h"

#import "MSDayColumnHeaderBackground.h"
#import "MSTimeRowHeaderBackground.h"
#import "MSGridline.h"
#import "MSCurrentTimeGridline.h"
#import "MSCurrentTimeIndicator.h"
#import "SettingsViewController.h"

@implementation Configuration

+ (instancetype)sharedInstance {
    static Configuration *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Configuration alloc] init];
    });
    return sharedInstance;
}

+ (BOOL)isDarkTheme {
    return [[NSUserDefaults standardUserDefaults]boolForKey:ApplicationIsDarkTheme];
}

- (void)setupTheme {
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    BOOL isDarkTheme = [Configuration isDarkTheme];
    if (isDarkTheme) {
        [self setDarkTheme];
    } else {
        [self setLightTheme];
    }
}

- (void)setDarkTheme {
    [UIView appearance].tintColor = ApplicationThemeLightTintColor;
    [UIButton appearance].tintColor = ApplicationThemeDarkTintColor;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [UIImageView appearance].tintColor = ApplicationThemeDarkTintColor;
    [UIImageView appearanceWhenContainedIn:SettingsViewController.class, nil].tintColor = [UIColor whiteColor];
    
    [UINavigationBar appearance].backgroundColor = ApplicationThemeDarkBackgroundPrimaryColor;
    [UINavigationBar appearance].tintColor = ApplicationThemeDarkTintColor;
    [UINavigationBar appearance].barTintColor = ApplicationThemeDarkBackgroundPrimaryColor;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : ApplicationThemeDarkFontPrimaryColor};
    
    [UITableView appearance].backgroundColor = ApplicationThemeDarkBackgroundPrimaryColor;
    [UITableViewCell appearance].backgroundColor = ApplicationThemeDarkBackgroundPrimaryColor;
    [UITableViewCell appearance].contentView.backgroundColor = ApplicationThemeDarkBackgroundPrimaryColor;
    [UITableViewCell appearance].textLabel.textColor = ApplicationThemeDarkFontPrimaryColor;
    [UITableViewCell appearance].multipleSelectionBackgroundView = [self tableViewCellSelectedBackgroundView:YES];
    
    [UICollectionView appearance].backgroundColor = ApplicationThemeDarkBackgroundPrimaryColor;
    [MSDayColumnHeaderBackground appearance].backgroundColor = ApplicationThemeDarkBackgroundSecondnaryColor;
    [MSTimeRowHeaderBackground appearance].backgroundColor = ApplicationThemeDarkBackgroundPrimaryColor;
    [MSGridline appearance].backgroundColor = ApplicationThemeDarkSeparatorColor;
    [MSCurrentTimeGridline appearance].backgroundColor = ApplicationThemeDarkCurrentTimeIndicator;
    [MSCurrentTimeIndicator appearance].backgroundColor = ApplicationThemeDarkBackgroundPrimaryColor;
    
    [UILabel appearanceWhenContainedIn:UITableViewCell.class, nil].textColor = ApplicationThemeDarkFontPrimaryColor;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        [UISearchBar appearance].keyboardAppearance = UIKeyboardAppearanceDark;
    }
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:ApplicationThemeDarkFontPrimaryColor}];
}

- (void)setLightTheme {
    [UIView appearance].tintColor = ApplicationThemeLightTintColor;
    [UIButton appearance].tintColor = ApplicationThemeLightTintColor;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [UIImageView appearance].tintColor = ApplicationThemeLightTintColor;
    [UIImageView appearanceWhenContainedIn:SettingsViewController.class, nil].tintColor = [UIColor blackColor];
    
    [UINavigationBar appearance].backgroundColor = ApplicationThemeLightBackgroundPrimaryColor;
    [UINavigationBar appearance].tintColor = ApplicationThemeLightTintColor;
    [UINavigationBar appearance].barTintColor = ApplicationThemeLightBackgroundPrimaryColor;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : ApplicationThemeLightFontPrimaryColor};
    
    [UITableView appearance].backgroundColor = ApplicationThemeLightBackgroundPrimaryColor;
    [UITableViewCell appearance].backgroundColor = ApplicationThemeLightBackgroundPrimaryColor;
    [UITableViewCell appearance].contentView.backgroundColor = ApplicationThemeLightBackgroundPrimaryColor;
    [UITableViewCell appearance].multipleSelectionBackgroundView = [self tableViewCellSelectedBackgroundView:NO];
    
    [UICollectionView appearance].backgroundColor = ApplicationThemeLightBackgroundPrimaryColor;
    [MSDayColumnHeaderBackground appearance].backgroundColor = ApplicationThemeLightBackgroundSecondnaryColor;
    [MSTimeRowHeaderBackground appearance].backgroundColor = ApplicationThemeLightBackgroundPrimaryColor;
    [MSGridline appearance].backgroundColor = ApplicationThemeLightSeparatorColor;
    [MSCurrentTimeGridline appearance].backgroundColor = ApplicationThemeLightCurrentTimeIndicator;
    [MSCurrentTimeIndicator appearance].backgroundColor = ApplicationThemeLightBackgroundPrimaryColor;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        [UISearchBar appearance].keyboardAppearance = UIKeyboardAppearanceDefault;
    }
    
    [UILabel appearanceWhenContainedIn:UITableViewCell.class, nil].textColor = ApplicationThemeLightFontPrimaryColor;
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:ApplicationThemeLightFontPrimaryColor}];
}

- (void)applyTheme {
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        for (UIView *view in window.subviews) {
            [view removeFromSuperview];
            [window addSubview:view];
        }
    }
}

- (UIView *)tableViewCellSelectedBackgroundView:(BOOL)isDarkTheme {
    UIView *view = [UIView new];
    if (isDarkTheme) {
        view.backgroundColor = [UIColor darkGrayColor];
    } else {
        view.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
    }
    return view;
}

@end
