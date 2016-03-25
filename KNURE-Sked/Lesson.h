//
//  Lesson.h
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 24.12.15.
//  Copyright © 2015 Shogunate. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    lecture = 0,
    practice = 10,
    lab = 20,
    consultation = 30,
    ladder = 40,
    exam = 50,
    courseWork = 60
} LessonType;

@interface Lesson : NSObject

@property NSString *title;
@property NSString *fullName;
@property NSString *auditory;
@property LessonType type;
@property NSDate *startTime;
@property NSDate *endTime;
@property NSString *teacherName;
@property NSArray *groups;

- (id)initWith:(NSString *)title
          name:(NSString *)fullName
      auditory:(NSString *)auditory
          type:(LessonType)type
     startDate:(NSDate *)startDate
       endDate:(NSDate *)endDate
   teacherName:(NSString *)teacherName
        groups:(NSArray *)groups;

@end
