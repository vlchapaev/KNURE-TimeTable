//
//  EventHandler.h
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 08.11.14.
//  Copyright (c) 2014 Влад. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Timer.h"

@interface EventHandler : NSObject {
    Timer *timer;
}

- (NSString *)getBriefByID:(NSInteger)ID from:(NSArray *)subjectsList shortName:(BOOL)isShort;
- (NSString *)getTypeNameByID:(NSInteger)typeID from:(NSArray *)typeList shortName:(BOOL)isShort;
- (NSString *)getFullNameByID:(NSInteger)ID from:(NSArray *)list;
- (NSString *)getGroupNameByID:(NSInteger)ID from:(NSArray *)groupList;
- (NSString *)getNameFromEvent:(NSArray *)array inArray:(NSArray *)list isTeacher:(BOOL)isTeacher;
- (UIColor *)getCellColorBy:(NSInteger)type;
- (NSString *)getLessonByIndex:(int)index;
- (NSData *)alignEncoding:(NSData *)data;
- (id)init;

@property (weak) NSDictionary *schedule;
@property (weak) NSArray *events;
@property (weak) NSArray *subjects;
@property (weak) NSArray *teachers;
@property (weak) NSArray *groups;
@property (weak) NSArray *types;

@end
