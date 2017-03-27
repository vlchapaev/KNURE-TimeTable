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
#define TimetableIsDarkMode @"TimetableIsDarkMode"
#define TimetableShowEmptyDays @"TimetableShowEmptyDays"
#define TimetableBouncingCells @"TimetableBouncingCells"
#define TimetableDidUpdateDataNotification @"TimetableDidUpdateDataNotification"
#define TimetableCacheName @"TimetableCacheName"
#define TimetableHideHint @"TimetableHideHint"

#define TimetableAppStoreLinkShort @"https://appsto.re/i67M8zB"
#define TimetableAppStoreLinkFull @"https://itunes.apple.com/us/app/knure-sked/id797074875"
#define TimetableGithubLink @"https://github.com/ShogunPhyched/KNURE-TimeTable"

#define ApplicationThemeBackgroundColorDark [UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1.00]

@import Foundation;

@interface Configuration : NSObject

+ (instancetype)sharedInstance;

- (void)setupTheme;
- (void)setDarkTheme;
- (void)setDefaultTheme;
- (void)applyTheme;

@end
