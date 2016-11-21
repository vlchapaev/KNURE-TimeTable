//
//  EventParser.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 08.11.14.
//  Copyright (c) 2014 Vlad Chapaev. All rights reserved.
//

#import "EventParser.h"
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
    NSMutableArray *items = [[NSMutableArray alloc]init];
    NSMutableArray *sections = nil;
    switch (itemType) {
        case ItemTypeGroup:
            items = [self parseGroupList:itemList];
            break;
            
        case ItemTypeTeacher:
            items = [self parseTeacherList:itemList];
            break;
            
        case ItemtypeAuditory:
            items = [self parseAuditoryList:itemList];
            break;
    }
    [EventParser removeDublicate:items callBack:^(id response) {
        [self.delegate didParseItemListWithResponse:response sections:sections];
    }];
}

- (id)parseGroupList:(id)itemList {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    NSArray *facultList = [[itemList valueForKey:@"university"] valueForKey:@"faculties"];
    for(NSDictionary *facult in facultList) {
        for(NSDictionary *direction in [facult valueForKey:@"directions"]) {
            for(NSDictionary *group in [direction valueForKey:@"groups"]) {
                NSDictionary *dictionary = @{@"title" : [group valueForKey:@"name"], @"id": [group valueForKey:@"id"]};
                [items addObject:dictionary];
            }
            
            for(NSDictionary *speciality in [direction valueForKey:@"specialities"]) {
                for(NSDictionary *group in [speciality valueForKey:@"groups"]) {
                    NSDictionary *dictionary = @{@"title": [group valueForKey:@"name"], @"id": [group valueForKey:@"id"]};
                    [items addObject:dictionary];
                }
            }
        }
    }
    return items;
}

- (id)parseTeacherList:(id)itemList {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    NSArray *facultList = [[itemList valueForKey:@"university"] valueForKey:@"faculties"];
    for(NSDictionary *department in facultList) {
        for(NSArray *teachers in [[department valueForKey:@"departments"] valueForKey:@"teachers"]) {
            for (NSDictionary *teacher in teachers) {
                NSDictionary *dictionary = @{@"title": [teacher valueForKey:@"short_name"], @"full_name": [teacher valueForKey:@"full_name"], @"id": [teacher valueForKey:@"id"]};
                [items addObject:dictionary];
            }
        }
    }
    return items;
}

- (id)parseAuditoryList:(id)itemList {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    NSArray *buildings = [[itemList valueForKey:@"university"] valueForKey:@"buildings"];
    for(NSDictionary *building in buildings) {
        for (NSDictionary *auditory in [building valueForKey:@"auditories"]) {
            NSDictionary *dictionary = @{@"title": [auditory valueForKey:@"short_name"], @"id": [auditory valueForKey:@"id"]};
            [items addObject:dictionary];
            
        }
    }
    return items;
}

- (void)parseTimeTable:(NSData *)data itemID:(NSNumber *)itemID callBack:(void (^)(void))callbackBlock {
    NSData *utfEncodingData = [self alignEncoding:data];
    id parsed = [NSJSONSerialization JSONObjectWithData:utfEncodingData options:0 error:nil];
    
    id events = [parsed valueForKey:@"events"];
    //id groups = [parsed valueForKey:@"groups"];
    id subjects = [parsed valueForKey:@"subjects"];
    //id teachers = [parsed valueForKey:@"teachers"];
    id types = [parsed valueForKey:@"types"];
    
    //NSLog(@"%@", parsed);
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"item_id == %@", itemID];
    [Lesson MR_deleteAllMatchingPredicate:filter];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        for (id event in events) {
            Lesson *lesson = [Lesson MR_createEntityInContext:localContext];
            lesson.item_id = itemID.integerValue;
            lesson.auditory = [event valueForKey:@"auditory"];
            lesson.number_pair = [event valueForKey:@"number_pair"];
            lesson.start_time = [NSDate dateWithTimeIntervalSince1970:[[event valueForKey:@"start_time"] integerValue]];
            lesson.end_time = [NSDate dateWithTimeIntervalSince1970:[[event valueForKey:@"end_time"] integerValue]];
            lesson.brief = [self getLessonNameWithID:[event valueForKey:@"subject_id"] from:subjects shortName:YES];
            lesson.title = [self getLessonNameWithID:[event valueForKey:@"subject_id"] from:subjects shortName:NO];
            lesson.type = [event valueForKey:@"type"];
            lesson.type_brief = [self getTypeNameByID:[event valueForKey:@"type"] from:types shortName:YES];
            lesson.type_title = [self getTypeNameByID:[event valueForKey:@"type"] from:types shortName:NO];
        }
        [localContext MR_saveToPersistentStoreAndWait];
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        callbackBlock();
    }];

}

- (NSData *)alignEncoding:(NSData *)data {
    NSString *tempData = [[NSString alloc]initWithData:data encoding:NSWindowsCP1251StringEncoding];
    NSData *encResponce = [tempData dataUsingEncoding:NSUTF8StringEncoding];
    return [encResponce subdataWithRange:NSMakeRange(0, [encResponce length] - 1)];
}

- (NSString *)getLessonNameWithID:(NSNumber *)ID from:(id)list shortName:(BOOL)isShort {
    for(NSArray *record in list) {
        if([record valueForKey:@"id"] == ID) {
            return (isShort) ? [record valueForKey:@"brief"] : [record valueForKey:@"full_name"];
        }
    }
    return nil;
}

- (NSString *)getTypeNameByID:(NSNumber *)typeID from:(id)typeList shortName:(BOOL)isShort {
    for(NSArray *record in typeList) {
        if([record valueForKey:@"id"] == typeID) {
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
        case 50:// 143, 210, 251
            return [UIColor colorWithRed:0.40 green:0.80 blue:1.00 alpha:1.00];
            break;
        case 51:
            return [UIColor colorWithRed:0.40 green:0.80 blue:1.00 alpha:1.00];
            break;
        case 52:
            return [UIColor colorWithRed:0.40 green:0.80 blue:1.00 alpha:1.00];
            break;
        case 53:
            return [UIColor colorWithRed:0.40 green:0.80 blue:1.00 alpha:1.00];
            break;
        case 54:
            return [UIColor colorWithRed:0.40 green:0.80 blue:1.00 alpha:1.00];
            break;
        case 55:
            return [UIColor colorWithRed:0.40 green:0.80 blue:1.00 alpha:1.00];
            break;
        case 60:
            return [UIColor lightGrayColor];
            break;
        default:
            return [UIColor colorWithRed:1 green:0.859 blue:0.957 alpha:1.0];
            break;
    }
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
