//
//  Timer.h
//  KNURE-Sked
//
//  Created by Влад on 11/27/13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timer : NSObject

@property (strong) NSDate *today;

@property (strong) NSDateFormatter *dayMonthYear;
@property (strong) NSDateFormatter *dayMonthWeekDay;
@property (strong) NSDateFormatter *dateFormatterYear;
@property (strong) NSDateFormatter *dateFormatterMonth;
@property (strong) NSDateFormatter *dateFormatterDay;
@property (strong) NSDateFormatter *dateFormatterHours;
@property (strong) NSDateFormatter *dateFormatterMinutes;
@property (strong) NSDateFormatter *dateFormatterSeconds;
@property (strong) NSDateFormatter *hourMinuteSecond;

@property long time;

@property int currentTimeInSeconds;
//@property int currentTimeInUnixEpoh;

- (id)initDateFormatter;
- (void)initTimerWithEvent:(NSArray *)event;
- (int)getCurrentTimeInSeconds;
- (int)getCurrentTimeInUnixEpoh;

@end
