//
//  MSDayColumnHeaderBackground.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 05.11.16.
//  Copyright (c) 2015 Vlad Chapaev. All rights reserved.
//

#import "MSDayColumnHeaderBackground.h"
#import "Configuration.h"

@implementation MSDayColumnHeaderBackground

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        BOOL isDarkTheme = [[NSUserDefaults standardUserDefaults]boolForKey:TimetableIsDarkMode];
        self.backgroundColor = (isDarkTheme) ? [UIColor darkGrayColor] : [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
    }
    return self;
}

@end
