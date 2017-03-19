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

+ (void)initializeSharedStorage {
    NSManagedObjectModel *model = [NSManagedObjectModel MR_defaultManagedObjectModel];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.Shogunate.KNURE-Sked"];
    storeURL = [storeURL URLByAppendingPathComponent:@"DataStorage.sqlite"];
    
    [persistentStoreCoordinator MR_addSqliteStoreNamed:storeURL withOptions:nil];
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:persistentStoreCoordinator];
    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:persistentStoreCoordinator];
}

- (void)parseItemList:(id)itemList ofType:(ItemType)itemType {
    NSMutableArray *items = nil;
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
    id groups = [parsed valueForKey:@"groups"];
    id subjects = [parsed valueForKey:@"subjects"];
    id teachers = [parsed valueForKey:@"teachers"];
    id types = [parsed valueForKey:@"types"];
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"item_id == %@", itemID];
    [Lesson MR_deleteAllMatchingPredicate:filter];
    /*
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[[[events firstObject] valueForKey:@"start_time"] integerValue]];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[[[events lastObject] valueForKey:@"end_time"] integerValue]];
    
    NSMutableArray *semesterDates = [[NSMutableArray alloc]init];
    [semesterDates addObject:startDate];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:startDate toDate:endDate options:0];
    
    for (int i = 1; i < components.day; ++i) {
        NSDateComponents *newComponents = [NSDateComponents new];
        newComponents.day = i;
        //newComponents.hour = 7;
        //newComponents.minute = 45;
        
        NSDate *date = [gregorianCalendar dateByAddingComponents:newComponents toDate:startDate options:0];
        [semesterDates addObject:date];
    }
    
    [semesterDates addObject:endDate];
    */
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        for (id event in events) {
            Lesson *lesson = [Lesson MR_createEntityInContext:localContext];
            lesson.item_id = [itemID integerValue];
            lesson.auditory = [event valueForKey:@"auditory"];
            lesson.number_pair = [event valueForKey:@"number_pair"];
            lesson.start_time = [NSDate dateWithTimeIntervalSince1970:[[event valueForKey:@"start_time"] integerValue]];
            lesson.end_time = [NSDate dateWithTimeIntervalSince1970:[[event valueForKey:@"end_time"] integerValue]];
            lesson.brief = [self getLessonNameWithID:[[event valueForKey:@"subject_id"] longValue] from:subjects shortName:YES];
            lesson.title = [self getLessonNameWithID:[[event valueForKey:@"subject_id"] longValue] from:subjects shortName:NO];
            lesson.type = [event valueForKey:@"type"];
            lesson.type_brief = [self getTypeNameByID:[[event valueForKey:@"type"] longValue] from:types shortName:YES];
            lesson.type_title = [self getTypeNameByID:[[event valueForKey:@"type"] longValue] from:types shortName:NO];
            lesson.teachers = [self getItems:teachers withIDs:[event valueForKey:@"teachers"]];
            lesson.groups = [self getItems:groups withIDs:[event valueForKey:@"groups"]];
            lesson.subject_id = [[event valueForKeyPath:@"subject_id"] integerValue];
        }
        /*
        for (NSDate *date in semesterDates) {
            
            Lesson *lesson = [Lesson MR_createEntityInContext:localContext];
            lesson.item_id = [itemID integerValue];
            lesson.start_time = date;
            lesson.end_time = date;
            lesson.number_pair = @1;
            
            lesson.brief = @"";
            lesson.title = @"";
            lesson.auditory = @"";
            lesson.type = @1;
        }
        */
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

- (NSString *)getLessonNameWithID:(long)ID from:(id)list shortName:(BOOL)isShort {
    for(NSArray *record in list) {
        if([[record valueForKey:@"id"] longValue] == ID) {
            return (isShort) ? [record valueForKey:@"brief"] : [record valueForKey:@"title"];
        }
    }
    return nil;
}

- (NSString *)getTypeNameByID:(long)typeID from:(id)typeList shortName:(BOOL)isShort {
    for(NSArray *record in typeList) {
        if([[record valueForKey:@"id"] longValue] == typeID) {
            return (isShort) ? [record valueForKey:@"short_name"]:[record valueForKey:@"full_name"];
        }
    }
    return nil;
}

- (id)getItems:(id)items withIDs:(NSArray *)itemIDs {
    NSMutableArray *itemList = [[NSMutableArray alloc]init];
    for (NSNumber *itemID in itemIDs) {
        for (NSDictionary *record in items) {
            if ([[record valueForKey:@"id"] integerValue] == [itemID integerValue]) {
                [itemList addObject:record];
            }
        }
    }
    return itemList;
}

+ (UIColor *)getCellColorByType:(NSInteger)type {
    switch (type) {
        case 0:
            return [UIColor colorWithRed:1.00 green:0.81 blue:0.02 alpha:1.00];
            break;
        case 1:
            return [UIColor colorWithRed:1.00 green:0.81 blue:0.02 alpha:1.00];
            break;
        case 2:
            return [UIColor colorWithRed:1.00 green:0.81 blue:0.02 alpha:1.00];
            break;
        case 10:
            return [UIColor colorWithRed:0.19 green:0.80 blue:0.44 alpha:1.00];
            break;
        case 11:
            return [UIColor colorWithRed:0.19 green:0.80 blue:0.44 alpha:1.00];
            break;
        case 12:
            return [UIColor colorWithRed:0.19 green:0.80 blue:0.44 alpha:1.00];
            break;
        case 20:
            return [UIColor colorWithRed:0.46 green:0.37 blue:0.77 alpha:1.00];
            break;
        case 21:
            return [UIColor colorWithRed:0.46 green:0.37 blue:0.77 alpha:1.00];
            break;
        case 22:
            return [UIColor colorWithRed:0.46 green:0.37 blue:0.77 alpha:1.00];
            break;
        case 23:
            return [UIColor colorWithRed:0.46 green:0.37 blue:0.77 alpha:1.00];
            break;
        case 24:
            return [UIColor colorWithRed:0.46 green:0.37 blue:0.77 alpha:1.00];
            break;
        case 30:
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
