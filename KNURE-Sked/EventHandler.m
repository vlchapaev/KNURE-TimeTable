//
//  EventHandler.m
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 08.11.14.
//  Copyright (c) 2014 Влад. All rights reserved.
//

#import "EventHandler.h"

@implementation EventHandler

@synthesize schedule, events, subjects, teachers, types, groups;

- (id)init {
    self = [super init];
    NSString *curId = [[NSUserDefaults standardUserDefaults] valueForKey:@"ID"];
    schedule = [[NSUserDefaults standardUserDefaults] valueForKey:curId];
    events = [schedule valueForKey:@"events"];
    subjects = [schedule valueForKey:@"subjects"];
    types = [schedule valueForKey:@"types"];
    teachers = [schedule valueForKey:@"teachers"];
    groups = [schedule valueForKey:@"groups"];
    return self;
}

- (NSString *)getFullNameByID:(NSInteger)ID from:(NSArray *)list {
    for(NSArray *record in list) {
        if([[record valueForKey:@"id"]integerValue] == ID) {
            return [record valueForKey:@"full_name"];
        }
    }
    return nil;
}

- (NSString *)getBriefByID:(NSInteger)ID from:(NSArray *)subjectsList shortName:(BOOL)isShort {
    for(NSArray *record in subjectsList) {
        if([[record valueForKey:@"id"]integerValue] == ID) {
            return (isShort)?[record valueForKey:@"brief"]:[record valueForKey:@"title"];
        }
    }
    return nil;
}

- (NSString *)getTypeNameByID:(NSInteger)typeID from:(NSArray *)typeList shortName:(BOOL)isShort {
    for(NSArray *record in typeList) {
        if([[record valueForKey:@"id"]integerValue] == typeID) {
            return (isShort)? [record valueForKey:@"short_name"]:[record valueForKey:@"full_name"];
        }
    }
    return nil;
}

- (NSString *)getGroupNameByID:(NSInteger)ID from:(NSArray *)groupList {
    for(NSArray *record in groupList) {
        if([[record valueForKey:@"id"]integerValue] == ID) {
            return [record valueForKey:@"name"];
        }
    }
    return nil;
}

- (NSString *)getNameFromEvent:(NSArray *)array inArray:(NSArray *)list isTeacher:(BOOL)isTeacher {
    NSString *result;
    NSString *key = (isTeacher)?@"full_name":@"name";
    for (NSString *record in array) {
        for (NSArray *subrecord in list) {
            if([[subrecord valueForKey:@"id"] integerValue] == [record integerValue]) {
                result = (result)?[NSString stringWithFormat:@"%@\n%@", result, [subrecord valueForKey:key]]:
                [NSString stringWithFormat:@"%@", [subrecord valueForKey:key]];
            }
        }
    }
    return result;
}

- (UIColor *)getCellColorBy:(NSInteger)type {
    switch (type) {
        case 0:
            return [UIColor colorWithRed:1 green:0.961 blue:0.835 alpha:1.0];
            break;
        case 1:
            return [UIColor colorWithRed:1 green:0.961 blue:0.835 alpha:1.0];
            break;
        case 2:
            return [UIColor colorWithRed:1 green:0.961 blue:0.835 alpha:1.0];
            break;
        case 10:
            return [UIColor colorWithRed:0.78 green:0.922 blue:0.769 alpha:1.0];
            break;
        case 11:
            return [UIColor colorWithRed:0.78 green:0.922 blue:0.769 alpha:1.0];
            break;
        case 12:
            return [UIColor colorWithRed:0.78 green:0.922 blue:0.769 alpha:1.0];
            break;
        case 20:
            return [UIColor colorWithRed:0.804 green:0.8 blue:1 alpha:1.0];
            break;
        case 21:
            return [UIColor colorWithRed:0.804 green:0.8 blue:1 alpha:1.0];
            break;
        case 22:
            return [UIColor colorWithRed:0.804 green:0.8 blue:1 alpha:1.0];
            break;
        case 23:
            return [UIColor colorWithRed:0.804 green:0.8 blue:1 alpha:1.0];
            break;
        case 24:
            return [UIColor colorWithRed:0.804 green:0.8 blue:1 alpha:1.0];
            break;
        case 30:
            return [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.0];
            break;
        case 31:
            return [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.0];
            break;
        case 40:
            return [UIColor colorWithRed:0.761 green:0.627 blue:0.722 alpha:1.0];
            break;
        case 41:
            return [UIColor colorWithRed:0.761 green:0.627 blue:0.722 alpha:1.0];
            break;
        case 50:
            return [UIColor colorWithRed:0.561 green:0.827 blue:0.988 alpha:1.0];
            break;
        case 51:
            return [UIColor colorWithRed:0.561 green:0.827 blue:0.988 alpha:1.0];
            break;
        case 52:
            return [UIColor colorWithRed:0.561 green:0.827 blue:0.988 alpha:1.0];
            break;
        case 53:
            return [UIColor colorWithRed:0.561 green:0.827 blue:0.988 alpha:1.0];
            break;
        case 54:
            return [UIColor colorWithRed:0.561 green:0.827 blue:0.988 alpha:1.0];
            break;
        case 55:
            return [UIColor colorWithRed:0.561 green:0.827 blue:0.988 alpha:1.0];
            break;
        case 60:
            return [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.0];
            break;
        default:
            return [UIColor colorWithRed:1 green:0.859 blue:0.957 alpha:1.0];
            break;
    }
}

- (NSString *)getLessonByIndex:(int)index {
    NSString *brief = [self getBriefByID:[[[events objectAtIndex:index]valueForKey:@"subject_id"]integerValue] from:subjects shortName:YES];
    NSString *typeName = [self getTypeNameByID:[[[events objectAtIndex:index]valueForKey:@"type"]integerValue] from:types shortName:YES];
    NSString *auditory = [[events objectAtIndex:index]valueForKey:@"auditory"];
    return [NSString stringWithFormat:@"%@ %@ %@", brief, typeName, auditory];
}

- (NSData *)alignEncoding:(NSData *)data {
    NSString *tempData = [[NSString alloc]initWithData:data encoding:NSWindowsCP1251StringEncoding];
    NSData *encResponce = [tempData dataUsingEncoding:NSUTF8StringEncoding];
    return [encResponce subdataWithRange:NSMakeRange(0, [encResponce length] - 1)];
}

@end
