//
//  Timer.h
//  KNURE-Sked
//
//  Created by Влад on 11/27/13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timer : NSObject
+ (void) getCurrentTime;
+ (void) comparisonOfTime;
+ (void) minusTime;
+ (void) cleaner;
@end
BOOL toLessonBool;
NSInteger hours;
NSInteger minutes;
NSInteger seconds;
NSInteger endHours;
NSInteger endMinutes;
NSInteger endSeconds;
NSInteger endInteger;
NSString *timer;