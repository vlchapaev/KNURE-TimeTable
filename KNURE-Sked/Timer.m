//
//  Timer.m
//  KNURE-Sked
//
//  Created by Влад on 11/27/13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import "Timer.h"
#import "ViewController.h"

@implementation Timer

+ (void) getCurrentTime {
    //Get date
    NSDate *currentDateTime = [NSDate date];
    
    //Set format for data
    NSDateFormatter *dateFormatterHours = [[NSDateFormatter alloc] init];
    [dateFormatterHours setDateFormat:@"HH"];
    NSDateFormatter *dateFormatterMinutes = [[NSDateFormatter alloc] init];
    [dateFormatterMinutes setDateFormat:@"mm"];
    NSDateFormatter *dateFormatterSeconds = [[NSDateFormatter alloc] init];
    [dateFormatterSeconds setDateFormat:@"ss"];
    
    //Write formated data to NSInteger
    hours = [[dateFormatterHours stringFromDate:currentDateTime] integerValue];
    minutes = [[dateFormatterMinutes stringFromDate:currentDateTime] integerValue];
    seconds = [[dateFormatterSeconds stringFromDate:currentDateTime] integerValue];
}

+ (void) comparisonOfTime {
    endInteger = (hours) * 10000;
    NSString *str = [NSString stringWithFormat:@"%d", minutes];
    if (str.length <= 0)
        endInteger *= 10;
    endInteger += (minutes)*100;
    str = [NSString stringWithFormat:@"%d", seconds];
    if (str.length <= 0)
        endInteger *= 10;
    endInteger += seconds;
    if (endInteger < 235959) {
        endHours = 7;
        endMinutes = 45;
        endSeconds = 00;
        toLessonBool = YES;
    }
    if (endInteger < 214500) {
        endHours = 21;
        endMinutes = 45;
        endSeconds = 00;
        toLessonBool = NO;
    }
    if (endInteger < 201000) {
        endHours = 20;
        endMinutes = 10;
        endSeconds = 00;
        toLessonBool = YES;
    }
    if (endInteger < 200000) {
        endHours = 20;
        endMinutes = 00;
        endSeconds = 00;
        toLessonBool = NO;
    }
    if (endInteger < 182500) {
        endHours = 18;
        endMinutes = 25;
        endSeconds = 00;
        toLessonBool = YES;
    }
    if (endInteger < 181500) {
        endHours = 18;
        endMinutes = 15;
        endSeconds = 00;
        toLessonBool = NO;
    }
    if (endInteger < 164000) {
        endHours = 16;
        endMinutes = 40;
        endSeconds = 00;
        toLessonBool = YES;
    }
    if (endInteger < 163000) {
        endHours = 16;
        endMinutes = 30;
        endSeconds = 00;
        toLessonBool = NO;
    }
    if (endInteger < 145500) {
        endHours = 14;
        endMinutes = 55;
        endSeconds = 00;
        toLessonBool = YES;
    }
    if (endInteger < 144500) {
        endHours = 14;
        endMinutes = 45;
        endSeconds = 00;
        toLessonBool = NO;
    }
    if (endInteger < 131000)
    {
        endHours = 13;
        endMinutes = 10;
        endSeconds = 00;
        toLessonBool = YES;
    }
    if (endInteger < 125000) {
        endHours = 12;
        endMinutes = 50;
        endSeconds = 00;
        toLessonBool = NO;
    }
    if (endInteger < 111500) {
        endHours = 11;
        endMinutes = 15;
        endSeconds = 00;
        toLessonBool = YES;
    }
    
    if (endInteger < 110500) {
        endHours = 11;
        endMinutes = 05;
        endSeconds = 00;
        toLessonBool = NO;
    }
    
    if (endInteger < 93000) {
        endHours = 9;
        endMinutes = 30;
        endSeconds = 00;
        toLessonBool = YES;
    }
    if (endInteger < 92000) {
        endHours = 9;
        endMinutes = 20;
        endSeconds = 00;
        toLessonBool = NO;
    }
    if (endInteger < 74500) {
        endHours = 7;
        endMinutes = 45;
        endSeconds = 00;
        toLessonBool = YES;
    }
}

//Counting time
+ (void) minusTime {
    //Cache for remainder
    BOOL cacheInMinusTime = NO;
    //Counting seconds
    if (seconds == endSeconds)
        endSeconds = 0;
    else {
        if (seconds > endSeconds) {
            cacheInMinusTime = YES;
            seconds -= endSeconds;
            endSeconds = 60 - seconds;
        }
        else {
            endSeconds -= seconds;
        }
        if (cacheInMinusTime == YES) {
            if (minutes == 60) {
                hours++;
                minutes = 0;
            }
            else
                minutes++;
            cacheInMinusTime = NO;
        }
    }
    //Counting minutes
    if (minutes == endMinutes)
        endMinutes = 0;
    else {
        if (minutes > endMinutes) {
            cacheInMinusTime = YES;
            minutes -= endMinutes;
            endMinutes = 60 - minutes;
        }
        else {
            endMinutes -= minutes;
        }
        if (cacheInMinusTime == YES) {
            hours++;
            cacheInMinusTime = NO;
        }
    }
    //Counting hours
    if (hours == endHours)
        endHours = 0;
    else {
        if (hours > endHours) {
            hours -= endHours;
            endHours = 24 - hours;
        } else {
            endHours -= hours;
        }
    }
}

+ (void) cleaner {
    hours = 0;
    minutes = 0;
    seconds = 0;
    endSeconds = 0;
    endMinutes = 0;
    endHours = 0;
}

@end
