//
//  Timer.m
//  KNURE-Sked
//
//  Created by Влад on 11/27/13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import "Timer.h"

@implementation Timer

@synthesize currentTimeInSeconds, time, today;

- (id)initDateFormatter {
    self = [super init];
    today = [[NSDate alloc]init];
    _dayMonthYear = [[NSDateFormatter alloc]init];
    _dayMonthWeekDay = [[NSDateFormatter alloc]init];
    _dateFormatterDay = [[NSDateFormatter alloc]init];
    _dateFormatterHours = [[NSDateFormatter alloc]init];
    _dateFormatterMinutes = [[NSDateFormatter alloc]init];
    _dateFormatterSeconds = [[NSDateFormatter alloc]init];
    _dateFormatterMonth = [[NSDateFormatter alloc]init];
    _dateFormatterYear = [[NSDateFormatter alloc]init];
    _hourMinuteSecond = [[NSDateFormatter alloc]init];
    [_hourMinuteSecond setDateFormat:@"HH:mm:ss"];
    [_dateFormatterYear setDateFormat:@"yyyy"];
    [_dateFormatterMonth setDateFormat:@"MM"];
    [_dayMonthYear setDateFormat:@"dd.MM.yyyy"];
    [_dayMonthWeekDay setDateFormat:@"dd.MM, EE"];
    [_dateFormatterDay setDateFormat:@"dd"];
    [_dateFormatterHours setDateFormat:@"HH"];
    [_dateFormatterMinutes setDateFormat:@"mm"];
    [_dateFormatterSeconds setDateFormat:@"ss"];
    currentTimeInSeconds = [self getCurrentTimeInSeconds];
    //currentTimeInUnixEpoh = [self getCurrentTimeInUnixEpoh];
    return self;
}

- (int)getCurrentTimeInSeconds {
    today = [[NSDate alloc]init];
    int hours = [[_dateFormatterHours stringFromDate:today] intValue];
    int minutes = [[_dateFormatterMinutes stringFromDate:today] intValue];
    int seconds = [[_dateFormatterSeconds stringFromDate:today] intValue];
    return (hours * 3600) + (minutes * 60) + seconds;
}

- (int)getCurrentTimeInUnixEpoh {
    return [today timeIntervalSince1970];
}

- (void)initTimerWithEvent:(NSArray *)event {
    long currentTimeInUnixEpoh = [self getCurrentTimeInUnixEpoh];
    for(NSDictionary *record in event) {
        if([[record valueForKey:@"start_time"]longValue] >= currentTimeInUnixEpoh) {
            time = [[record valueForKey:@"start_time"]longValue];
            break;
        }
        
        if([[record valueForKey:@"end_time"]longValue] >= currentTimeInUnixEpoh) {
            time = [[record valueForKey:@"end_time"]longValue];
            break;
        }
    }
}

@end