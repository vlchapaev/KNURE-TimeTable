//
//  ApplicationStyle.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 25.03.17.
//  Copyright © 2017 Vlad Chapaev. All rights reserved.
//

#import "Configuration.h"

#import "MSDayColumnHeaderBackground.h"
#import "MSTimeRowHeaderBackground.h"
#import "MSGridline.h"
#import "MSCurrentTimeGridline.h"

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
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    BOOL isDarkTheme = [[NSUserDefaults standardUserDefaults]boolForKey:ApplicationIsDarkTheme];
    if (isDarkTheme) {
        [self setDarkTheme];
    } else {
        [self setLightTheme];
    }
}

- (void)setDarkTheme {
    [UIView appearance].tintColor = ApplicationThemeDarkTintColor;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [UINavigationBar appearance].backgroundColor = ApplicationThemeDarkBackgroundPrimaryColor;
    [UINavigationBar appearance].tintColor = ApplicationThemeDarkTintColor;
    [UINavigationBar appearance].barTintColor = ApplicationThemeDarkBackgroundPrimaryColor;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : ApplicationThemeDarkFontPrimaryColor};
    
    [UITableView appearance].backgroundColor = ApplicationThemeDarkBackgroundPrimaryColor;
    [UITableViewCell appearance].backgroundColor = ApplicationThemeDarkBackgroundPrimaryColor;
    [UITableViewCell appearance].contentView.backgroundColor = ApplicationThemeDarkBackgroundPrimaryColor;
    [UITableViewCell appearance].textLabel.textColor = ApplicationThemeDarkFontPrimaryColor;
    
    [UICollectionView appearance].backgroundColor = ApplicationThemeDarkBackgroundPrimaryColor;
    [MSDayColumnHeaderBackground appearance].backgroundColor = ApplicationThemeDarkBackgroundSecondnaryColor;
    [MSTimeRowHeaderBackground appearance].backgroundColor = ApplicationThemeDarkBackgroundPrimaryColor;
    [MSGridline appearance].backgroundColor = [ApplicationThemeDarkFontSecondnaryColor colorWithAlphaComponent:0.2];
    [MSCurrentTimeGridline appearance].backgroundColor = ApplicationThemeDarkCurrentTimeIndicator;
    
    [UILabel appearanceWhenContainedIn:UITableViewCell.class, nil].textColor = ApplicationThemeDarkFontPrimaryColor;
    
    [UISearchBar appearance].keyboardAppearance = UIKeyboardAppearanceDark;
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:ApplicationThemeDarkFontPrimaryColor}];
}

- (void)setLightTheme {
    [UIView appearance].tintColor = ApplicationThemeLightTintColor;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [UINavigationBar appearance].backgroundColor = ApplicationThemeLightBackgroundPrimaryColor;
    [UINavigationBar appearance].tintColor = ApplicationThemeLightTintColor;
    [UINavigationBar appearance].barTintColor = ApplicationThemeLightBackgroundPrimaryColor;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : ApplicationThemeLightFontPrimaryColor};
    
    [UITableView appearance].backgroundColor = ApplicationThemeLightBackgroundPrimaryColor;
    [UITableViewCell appearance].backgroundColor = ApplicationThemeLightBackgroundPrimaryColor;
    [UITableViewCell appearance].contentView.backgroundColor = ApplicationThemeLightBackgroundPrimaryColor;
    
    [UICollectionView appearance].backgroundColor = ApplicationThemeLightBackgroundPrimaryColor;
    [MSDayColumnHeaderBackground appearance].backgroundColor = ApplicationThemeLightBackgroundSecondnaryColor;
    [MSTimeRowHeaderBackground appearance].backgroundColor = ApplicationThemeLightBackgroundPrimaryColor;
    [MSGridline appearance].backgroundColor = [ApplicationThemeLightFontSecondnaryColor colorWithAlphaComponent:0.2];
    [MSCurrentTimeGridline appearance].backgroundColor = ApplicationThemeLightCurrentTimeIndicator;
    
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

@end
