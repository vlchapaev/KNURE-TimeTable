//
//  Lesson.m
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 24.12.15.
//  Copyright © 2015 Shogunate. All rights reserved.
//

#import "Lesson.h"

@implementation Lesson

- (id)initWith:(NSString *)title
          name:(NSString *)fullName
      auditory:(NSString *)auditory
          type:(LessonType)type
     startDate:(NSDate *)startDate
       endDate:(NSDate *)endDate
   teacherName:(NSString *)teacherName
        groups:(NSArray *)groups {
    
    self = [super init];
    if (self) {
        self.title = title;
        self.fullName = fullName;
        self.auditory = auditory;
        self.type = type;
        self.startTime = startDate;
        self.endTime = endDate;
        self.teacherName = teacherName;
        self.groups = groups;
    }
    return self;
}

@end
