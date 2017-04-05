//
//  MSDayColumnHeader.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 05.11.16.
//  Copyright (c) 2015 Vlad Chapaev. All rights reserved.
//

#import "MSDayColumnHeader.h"
#import "Configuration.h"

@interface MSDayColumnHeader ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIView *titleBackground;
@property (assign, nonatomic) BOOL isDarkTheme;

@end

@implementation MSDayColumnHeader

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleBackground = [UIView new];
        self.titleBackground.layer.cornerRadius = nearbyintf(15.0);
        [self addSubview:self.titleBackground];
        
        self.backgroundColor = [UIColor clearColor];
        self.title = [UILabel new];
        self.title.backgroundColor = [UIColor clearColor];
        [self addSubview:self.title];
        
        self.isDarkTheme = [Configuration isDarkTheme];
        
        [self.titleBackground makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.title).with.insets(UIEdgeInsetsMake(-6.0, -12.0, -4.0, -12.0));
        }];
        
        [self.title makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return self;
}

- (void)setDay:(NSDate *)day {
    _day = day;
    
    self.title.text = [self.formatter stringFromDate:day];
    [self setNeedsLayout];
}

- (void)setCurrentDay:(BOOL)currentDay {
    _currentDay = currentDay;
    
    if (currentDay) {
        self.title.textColor = [UIColor whiteColor];
        self.title.font = [UIFont boldSystemFontOfSize:16.0];
        self.titleBackground.backgroundColor = (self.isDarkTheme) ? ApplicationThemeDarkCurrentTimeIndicator : ApplicationThemeLightCurrentTimeIndicator;
    } else {
        self.title.font = [UIFont systemFontOfSize:16.0];
        self.title.textColor = (self.isDarkTheme) ? ApplicationThemeDarkFontPrimaryColor : ApplicationThemeLightFontPrimaryColor;
        self.titleBackground.backgroundColor = [UIColor clearColor];
    }
}

@end
