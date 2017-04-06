//
//  MSCurrentTimeIndicator.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 05.11.16.
//  Copyright (c) 2015 Vlad Chapaev. All rights reserved.
//

#import "MSCurrentTimeIndicator.h"

@interface MSCurrentTimeIndicator ()

@property (nonatomic, strong) UILabel *time;
@property (nonatomic, retain) NSTimer *minuteTimer;

@end

@implementation MSCurrentTimeIndicator

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.time = [UILabel new];
        self.time.font = [UIFont boldSystemFontOfSize:12.0];
        self.time.textColor = [UIColor colorWithRed:0.91 green:0.31 blue:0.24 alpha:1.00];
        [self addSubview:self.time];
        
        [self.time makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.right.equalTo(self.right).offset(-5.0);
        }];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *oneMinuteInFuture = [[NSDate date] dateByAddingTimeInterval:60];
        NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:oneMinuteInFuture];
        NSDate *nextMinuteBoundary = [calendar dateFromComponents:components];
        
        self.minuteTimer = [[NSTimer alloc] initWithFireDate:nextMinuteBoundary interval:60 target:self selector:@selector(minuteTick:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.minuteTimer forMode:NSDefaultRunLoopMode];
        
        [self updateTime];
    }
    return self;
}

#pragma mark - MSCurrentTimeIndicator

- (void)minuteTick:(id)sender {
    [self updateTime];
}

- (void)updateTime {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"HH:mm"];
    self.time.text = [dateFormatter stringFromDate:[NSDate date]];
    [self.time sizeToFit];
}

@end
