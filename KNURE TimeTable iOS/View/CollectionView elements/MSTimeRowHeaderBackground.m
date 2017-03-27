//
//  MSTimeRowHeaderBackground.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 05.11.16.
//  Copyright (c) 2015 Vlad Chapaev. All rights reserved.
//

#import "MSTimeRowHeaderBackground.h"
#import "Configuration.h"

@implementation MSTimeRowHeaderBackground

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        BOOL isDarkTheme = [[NSUserDefaults standardUserDefaults]boolForKey:TimetableIsDarkMode];
        self.backgroundColor = (isDarkTheme) ? ApplicationThemeBackgroundColorDark : [UIColor whiteColor];
    }
    return self;
}

@end
