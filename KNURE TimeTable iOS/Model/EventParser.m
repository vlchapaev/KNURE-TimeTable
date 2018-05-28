//
//  EventParser.m
//  KNURE TimeTable
//
//  Created by Vladislav Chapaev on 08.11.14.
//  Copyright (c) 2014 Vladislav Chapaev. All rights reserved.
//

#import "EventParser.h"

#define LessonTypeLightColorLection [UIColor colorWithRed:1.00 green:0.81 blue:0.02 alpha:1.00]
#define LessonTypeLightColorPractice [UIColor colorWithRed:0.19 green:0.80 blue:0.44 alpha:1.00]
#define LessonTypeLightColorLaboratiry [UIColor colorWithRed:0.46 green:0.37 blue:0.77 alpha:1.00]
#define LessonTypeLightColorConsultation [UIColor lightGrayColor]
#define LessonTypeLightColorExam [UIColor colorWithRed:0.40 green:0.80 blue:1.00 alpha:1.00]
#define LessonTypeLightColorСredit [UIColor colorWithRed:0.76 green:0.62 blue:0.72 alpha:1.00]
#define LessonTypeLightColorUnknown [UIColor colorWithRed:1 green:0.859 blue:0.957 alpha:1.0]

#define LessonTypeDarkColorLection [UIColor colorWithRed:1.00 green:0.66 blue:0.00 alpha:1.00]
#define LessonTypeDarkColorPractice [UIColor colorWithRed:0.16 green:0.68 blue:0.38 alpha:1.00]
#define LessonTypeDarkColorLaboratiry [UIColor colorWithRed:0.36 green:0.28 blue:0.63 alpha:1.00]
#define LessonTypeDarkColorConsultation [UIColor lightGrayColor]
#define LessonTypeDarkColorExam [UIColor colorWithRed:0.16 green:0.50 blue:0.73 alpha:1.00]
#define LessonTypeDarkColorСredit [UIColor colorWithRed:0.76 green:0.62 blue:0.72 alpha:1.00]
#define LessonTypeDarkColorUnknown [UIColor colorWithRed:1 green:0.859 blue:0.957 alpha:1.0]

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
    [EventParser removeDuplicate:items callBack:^(id response) {
        NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
        id sortedArray = [response sortedArrayUsingDescriptors:sortDescriptors];
        [self.delegate didParseItemListWithResponse:sortedArray sections:sections];
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
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[[[events firstObject] valueForKey:@"start_time"] integerValue]];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[[[events lastObject] valueForKey:@"end_time"] integerValue]];
    
    NSMutableArray <NSDate *>*semesterDates = [[NSMutableArray alloc]init];
    [semesterDates addObject:startDate];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:startDate toDate:endDate options:0];
    
    for (int i = 1; i < components.day; ++i) {
        NSDateComponents *newComponents = [NSDateComponents new];
        newComponents.day = i;
        
        NSDate *date = [gregorianCalendar dateByAddingComponents:newComponents toDate:startDate options:0];
        [semesterDates addObject:date];
    }
    
    [semesterDates addObject:endDate];
    
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
            lesson.isDummy = NO;
        }
        
        //Check is there is no events then don't insert anything
        if (events) {
            for (NSDate *date in semesterDates) {
                
                Lesson *lesson = [Lesson MR_createEntityInContext:localContext];
                lesson.item_id = [itemID integerValue];
                lesson.start_time = date;
                lesson.end_time = date;
                lesson.isDummy = YES;
                
                lesson.brief = @"";
                lesson.title = @"";
                lesson.auditory = @"";
                lesson.type = @1;
            }
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

+ (UIColor *)getCellColorByType:(NSInteger)type isDarkTheme:(BOOL)isDark {
    if (type == 1 || type == 2 || type == 0) {
        return isDark ? LessonTypeDarkColorLection : LessonTypeLightColorLection;
        
    } else if (type == 10 || type == 11 || type == 12) {
        return isDark ? LessonTypeDarkColorPractice : LessonTypeLightColorPractice;
        
    } else if (type == 20 || type == 21 || type == 22 || type == 23 || type ==24) {
        return isDark ? LessonTypeDarkColorLaboratiry : LessonTypeLightColorLaboratiry;
        
    } else if (type == 30 || type == 31) {
        return isDark ? LessonTypeDarkColorConsultation : LessonTypeLightColorConsultation;
        
    } else if (type == 40 || type == 41) {
        return isDark ? LessonTypeDarkColorСredit : LessonTypeLightColorСredit;
        
    } else if (type == 50 || type == 51 || type == 52 || type == 53 || type == 54 || type == 55) {
        return isDark ? LessonTypeDarkColorExam : LessonTypeLightColorExam;
        
    } else if (type == 60) {
        return isDark ? LessonTypeDarkColorСredit : LessonTypeLightColorСredit;
        
    } else {
        return isDark ? LessonTypeDarkColorUnknown : LessonTypeLightColorUnknown;
    }
    
}

- (void)exportToCalendar:(Item *)item inRange:(CalendarExportRange)range {
    EKEventStore *store = [[EKEventStore alloc] init];
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *startDateComponent = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    startDateComponent.timeZone = [NSTimeZone timeZoneWithName:@"Europe/Kiev"];
    
    NSDateComponents *endDateComponents = [[NSDateComponents alloc]init];
    endDateComponents.timeZone = [NSTimeZone timeZoneWithName:@"Europe/Kiev"];
    
    NSDate *startDate;
    NSDate *endDate;
    NSPredicate *predicate;
    switch (range) {
        case CalendarExportRangeToday:
            startDate = [calendar dateFromComponents:startDateComponent];
            endDateComponents.day = 1;
            endDate = [calendar dateByAddingComponents:endDateComponents toDate:startDate options:0];
            predicate = [NSPredicate predicateWithFormat:@"item_id == %@ AND ((start_time >= %@) AND (end_time <= %@)) AND isDummy == NO", item.id, startDate, endDate];
            break;
            
        case CalendarExportRangeTomorrow:
            startDateComponent.day += 1;
            startDate = [calendar dateFromComponents:startDateComponent];
            endDateComponents.day = 1;
            endDate = [calendar dateByAddingComponents:endDateComponents toDate:startDate options:0];
            predicate = [NSPredicate predicateWithFormat:@"item_id == %@ AND ((start_time >= %@) AND (end_time <= %@)) AND isDummy == NO", item.id, startDate, endDate];
            break;
            
        case CalendarExportRangeThisWeek:
            [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&startDate interval:nil forDate:[NSDate date]];
            endDateComponents.day = 1;
            startDate = [calendar dateByAddingComponents:endDateComponents toDate:startDate options:0];
            endDateComponents.day = 0;
            endDateComponents.weekOfMonth = 1;
            endDate = [calendar dateByAddingComponents:endDateComponents toDate:startDate options:0];
            predicate = [NSPredicate predicateWithFormat:@"item_id == %@ AND ((start_time >= %@) AND (end_time <= %@)) AND isDummy == NO", item.id, startDate, endDate];
            break;
            
        case CalendarExportRangeNextWeek:
            [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&startDate interval:nil forDate:[NSDate date]];
            endDateComponents.day = 1;
            endDateComponents.weekOfMonth = 1;
            startDate = [calendar dateByAddingComponents:endDateComponents toDate:startDate options:0];
            endDateComponents.day = 0;
            endDate = [calendar dateByAddingComponents:endDateComponents toDate:startDate options:0];
            predicate = [NSPredicate predicateWithFormat:@"item_id == %@ AND ((start_time >= %@) AND (end_time <= %@)) AND isDummy == NO", item.id, startDate, endDate];
            break;
            
        case CalendarExportRangeThisMonth:
            break;
            
        case CalendarExportRangeNextMonth:
            break;
            
        case CalendarExportRangeFull:
            predicate = [NSPredicate predicateWithFormat:@"item_id == %@ AND isDummy == NO", item.id];
            break;
    }
    
    NSArray <Lesson *>*lessons = [Lesson MR_findAllWithPredicate:predicate];
    EKCalendar *eventCalendar;
    if (![self checkCalendarWithName:item.title inEventStore:store]) {
        eventCalendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:store];
        eventCalendar.title = item.title;
        eventCalendar.source = store.defaultCalendarForNewEvents.source;
        NSError *err = nil;
        if (![store saveCalendar:eventCalendar commit:YES error:&err]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate exportToCalendaerFailedWithError:err];
            });
            return;
        }
    } else {
        NSArray *calendarArray = [store calendarsForEntityType:EKEntityTypeEvent];
        for (EKCalendar *calendar in calendarArray) {
            if ([calendar.title isEqualToString:item.title]) {
                eventCalendar = calendar;
            }
        }
    }
    
    for (Lesson *lesson in lessons) {
        
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.title = [NSString stringWithFormat:@"%@ %@", lesson.brief, lesson.type_brief];
        event.location = lesson.auditory;
        event.startDate = lesson.start_time;
        event.endDate = lesson.end_time;
        event.notes = [NSString stringWithFormat:@"%@\n%@", lesson.title, lesson.type_title];
        event.calendar = eventCalendar;
        NSError *err = nil;
        if (![store saveEvent:event span:EKSpanThisEvent commit:YES error:&err]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate exportToCalendaerFailedWithError:err];
            });
            return;
        }
    }
    
    [self.delegate didFinishExportToCalendar];
    
}

- (BOOL)checkCalendarWithName:(NSString *)name inEventStore:(EKEventStore *)store {
    NSArray *calendarArray = [store calendarsForEntityType:EKEntityTypeEvent];
    for (EKCalendar *calendar in calendarArray) {
        if ([calendar.title isEqualToString:name]) {
            return YES;
        }
    }
    return NO;
}

+ (void)alignEncoding:(NSData *)data callBack:(void (^)(NSData *data))callbackBlock {
    NSString *tempData = [[NSString alloc]initWithData:data encoding:NSWindowsCP1251StringEncoding];
    NSData *encResponce = [tempData dataUsingEncoding:NSUTF8StringEncoding];
    callbackBlock([encResponce subdataWithRange:NSMakeRange(0, [encResponce length] - 1)]);
}

+ (void)removeDuplicate:(id)datasource callBack:(void (^)(id response))callbackBlock {
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:datasource];
    callbackBlock([orderedSet array]);
}

@end
