//
//  EventHandler.m
//  KNURE TimeTable iOS
//
//  Created by Vlad Chapaev on 08.11.14.
//  Copyright (c) 2014 Vlad Chapaev. All rights reserved.
//

#import "EventParser.h"
#import "AppDelegate.h"
#import "Lesson+CoreDataClass.h"

@implementation EventParser

+ (instancetype)sharedInstance {
    static EventParser *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[EventParser alloc] init];
    });
    return sharedInstance;
}

- (void)parseItemList:(id)itemList ofType:(ItemType)itemType {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    NSArray *facultList = [[itemList valueForKey:@"university"] valueForKey:@"faculties"];
    NSMutableArray *sections = nil;
    for(NSDictionary *facult in facultList) {
        for(NSDictionary *direction in [facult valueForKey:@"directions"]) {
            for(NSDictionary *group in [direction valueForKey:@"groups"]) {
                NSDictionary *dictionary = @{
                                             @"title" : [group valueForKey:@"name"],
                                             @"id" : [group valueForKey:@"id"],
                                             @0 : @"updated"
                                             };
                [items addObject:dictionary];
            }
            
            for(NSDictionary *speciality in [direction valueForKey:@"specialities"]) {
                for(NSDictionary *group in [speciality valueForKey:@"groups"]) {
                    NSDictionary *dictionary = @{
                                                 @"title" : [group valueForKey:@"name"],
                                                 @"id" : [group valueForKey:@"id"],
                                                 @0 : @"updated"
                                                 };
                    [items addObject:dictionary];
                }
            }
        }
    }
    [EventParser removeDublicate:items callBack:^(id response) {
        [self.delegate didParseItemListWithResponse:response sections:sections];
    }];
}

- (void)parseTimeTable:(NSData *)data callBack:(void (^)(void))callbackBlock {
    NSData *utfEncodingData = [self alignEncoding:data];
    id parsed = [NSJSONSerialization JSONObjectWithData:utfEncodingData options:0 error:nil];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    id events = [parsed valueForKey:@"events"];
    id groups = [parsed valueForKey:@"groups"];
    id subjects = [parsed valueForKey:@"subjects"];
    id teachers = [parsed valueForKey:@"teachers"];
    id types = [parsed valueForKey:@"types"];
    
    
    //NSLog(@"%@", parsed);
    
    for (id event in events) {
        Lesson *lesson = [[Lesson alloc]initWithContext:appDelegate.persistentContainer.viewContext];
        lesson.auditory = [event valueForKey:@"auditory"];
        lesson.number = [event valueForKey:@"number_pair"];
        lesson.start_date = [NSDate dateWithTimeIntervalSince1970:[[event valueForKey:@"start_time"] integerValue]];
        lesson.end_date = [NSDate dateWithTimeIntervalSince1970:[[event valueForKey:@"end_time"] integerValue]];
        lesson.title = [self getBriefByID:[event valueForKey:@"subject_id"] from:subjects];
        lesson.type = [event valueForKey:@"type"];
    }
    
    
    
    [appDelegate saveContext];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        callbackBlock();
    });
    
}

- (NSData *)alignEncoding:(NSData *)data {
    NSString *tempData = [[NSString alloc]initWithData:data encoding:NSWindowsCP1251StringEncoding];
    NSData *encResponce = [tempData dataUsingEncoding:NSUTF8StringEncoding];
    return [encResponce subdataWithRange:NSMakeRange(0, [encResponce length] - 1)];
}

- (NSString *)getFullNameByID:(NSInteger)ID from:(NSArray *)list {
    for(NSArray *record in list) {
        if([[record valueForKey:@"id"]integerValue] == ID) {
            return [record valueForKey:@"full_name"];
        }
    }
    return nil;
}

- (NSString *)getBriefByID:(NSNumber *)ID from:(id)subjectsList {
    for(NSDictionary *record in subjectsList) {
        if([record valueForKey:@"id"] == ID) {
            return [record valueForKey:@"brief"];
        }
    }
    return nil;
}

- (NSString *)getTypeNameByID:(NSInteger)typeID from:(NSArray *)typeList shortName:(BOOL)isShort {
    for(NSArray *record in typeList) {
        if([[record valueForKey:@"id"]integerValue] == typeID) {
            return (isShort) ? [record valueForKey:@"short_name"]:[record valueForKey:@"full_name"];
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

+ (UIColor *)getCellColorBy:(NSInteger)type {
    switch (type) {
        case 0: //255, 245, 212
            return [UIColor yellowColor];
            break;
        case 1:
            return [UIColor yellowColor];
            break;
        case 2:
            return [UIColor yellowColor];
            break;
        case 10: //198, 235, 196
            return [UIColor greenColor];
            break;
        case 11:
            return [UIColor greenColor];
            break;
        case 12:
            return [UIColor greenColor];
            break;
        case 20: //205, 204, 255
            return [UIColor magentaColor];
            break;
        case 21:
            return [UIColor magentaColor];
            break;
        case 22:
            return [UIColor magentaColor];
            break;
        case 23:
            return [UIColor magentaColor];
            break;
        case 24:
            return [UIColor magentaColor];
            break;
        case 30://237, 237, 237
            return [UIColor lightGrayColor];
            break;
        case 31:
            return [UIColor lightGrayColor];
            break;
        case 40:
            return [UIColor lightGrayColor];
            break;
        case 41:
            return [UIColor lightGrayColor];
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
    //NSString *brief = [self getBriefByID:[[[events objectAtIndex:index]valueForKey:@"subject_id"]integerValue] from:subjects shortName:YES];
    //NSString *typeName = [self getTypeNameByID:[[[events objectAtIndex:index]valueForKey:@"type"]integerValue] from:types shortName:YES];
    //NSString *auditory = [[events objectAtIndex:index]valueForKey:@"auditory"];
    //return [NSString stringWithFormat:@"%@ %@ %@", brief, typeName, auditory];
    return @"";
}

+ (void)alignEncoding:(NSData *)data callBack:(void (^)(NSData *data))callbackBlock {
    NSString *tempData = [[NSString alloc]initWithData:data encoding:NSWindowsCP1251StringEncoding];
    NSData *encResponce = [tempData dataUsingEncoding:NSUTF8StringEncoding];
    callbackBlock([encResponce subdataWithRange:NSMakeRange(0, [encResponce length] - 1)]);
}

+ (void)removeDublicate:(id)datasource callBack:(void (^)(id response))callbackBlock {
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:datasource];
    callbackBlock([orderedSet array]);
}

@end
