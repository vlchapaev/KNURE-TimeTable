//
//  Configuration.h
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 19.03.17.
//  Copyright © 2017 Vlad Chapaev. All rights reserved.
//

#define TimetableSelectedItem @"TimetableSelectedItem"
#define TimetableSelectedItemGroup @"group.Shogunate.KNURE-Sked"
#define TimetableVerticalMode @"TimetableVerticalMode"
#define TimetableRemoveEmptyDays @"TimetableRemoveEmptyDays"
#define TimetableHourlyGridLayout @"TimetableHourlyGridLayout"

#define TimetableDidUpdateDataNotification @"TimetableDidUpdateDataNotification"
#define ApplicationDidChangeThemeNotification @"ApplicationDidChangeThemeNotification"
#define TimetableDidChangeGridLayoutNotification @"TimetableDidChangeGridLayoutNotification"
#define TimetableDidRemoveEmptyDaysNotification @"TimetableDidRemoveEmptyDaysNotification"
#define TimetableDidEnableBouncingCellsNotification @"TimetableDidEnableBouncingCellsNotification"

//Not in production
#define TimetableBouncingCells @"TimetableBouncingCells"

#define ApplicationIsDarkTheme @"ApplicationIsDarkTheme"
#define ApplicationCacheName @"ApplicationCacheName"
#define ApplicationHideHint @"ApplicationHideHint"

#define ApplicationAppStoreLinkShort @"https://appsto.re/i67M8zB"
#define ApplicationAppStoreLinkFull @"https://itunes.apple.com/us/app/knure-sked/id797074875"
#define ApplicationSupportGithubLink @"https://github.com/ShogunPhyched/KNURE-TimeTable"
#define ApplicationSupportVkontakteLink @"vk://vk.com/im?sel=40842906"
#define ApplicationSupportTelegramLink @"http://t.me/chapaev_vlad"
#define ApplicationSupportMessengerLink @"fb-messenger://user/chapaev.vlad"

#define ApplicationPopoverSize CGSizeMake(400, 600)
#define ApplicationOpenCount @"ApplicationOpenCount"

#define ApplicationThemeLightTintColor [UIColor colorWithRed:0.21 green:0.60 blue:0.86 alpha:1.00]
#define ApplicationThemeLightBackgroundPrimaryColor [UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:1.00]
#define ApplicationThemeLightBackgroundSecondnaryColor [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00]
#define ApplicationThemeLightFontPrimaryColor [UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:1.00]
#define ApplicationThemeLightFontSecondnaryColor [UIColor darkGrayColor]
#define ApplicationThemeLightCurrentTimeIndicator [UIColor colorWithRed:0.91 green:0.30 blue:0.24 alpha:1.00]
#define ApplicationThemeLightSeparatorColor [[UIColor darkGrayColor] colorWithAlphaComponent:0.2]

#define ApplicationThemeDarkTintColor [UIColor colorWithRed:0.92 green:0.94 blue:0.95 alpha:1.00]
#define ApplicationThemeDarkBackgroundPrimaryColor [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1.00]
#define ApplicationThemeDarkBackgroundSecondnaryColor [UIColor darkGrayColor]
#define ApplicationThemeDarkFontPrimaryColor [UIColor colorWithRed:0.92 green:0.94 blue:0.95 alpha:1.00]
#define ApplicationThemeDarkFontSecondnaryColor [UIColor colorWithRed:0.92 green:0.94 blue:0.95 alpha:1.00]
#define ApplicationThemeDarkCurrentTimeIndicator [UIColor colorWithRed:0.75 green:0.23 blue:0.17 alpha:1.00]
#define ApplicationThemeDarkSeparatorColor [[UIColor colorWithRed:0.92 green:0.94 blue:0.95 alpha:1.00] colorWithAlphaComponent:0.2]

@import Foundation;

@interface Configuration : NSObject

+ (instancetype)sharedInstance;

- (void)setupTheme;
- (void)setDarkTheme;
- (void)setLightTheme;
- (void)applyTheme;

@end
