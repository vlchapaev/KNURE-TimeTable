////
////  EventParser.h
////  KNURE TimeTable
////
////  Created by Vladislav Chapaev on 08.11.14.
////  Copyright (c) 2014 Vladislav Chapaev. All rights reserved.
////
//
//@import Foundation;
//@import UIKit;
//@import EventKit;
//
//#import <MagicalRecord/MagicalRecord.h>
//
//#import "Item.h"
//#import "Lesson.h"
//
//typedef enum {
//    ItemTypeGroup = 1,
//    ItemTypeTeacher = 2,
//    ItemtypeAuditory = 3
//} ItemType;
//
//typedef enum {
//    CalendarExportRangeToday = 1,
//    CalendarExportRangeTomorrow,
//    CalendarExportRangeThisWeek,
//    CalendarExportRangeNextWeek,
//    CalendarExportRangeThisMonth,
//    CalendarExportRangeNextMonth,
//    CalendarExportRangeFull
//} CalendarExportRange;
//
//@protocol EventParserDelegate <NSObject>
//
//@optional
//- (void)didParseItemListWithResponse:(id)response sections:(NSArray *)sections;
//- (void)didFinishExportToCalendar;
//- (void)exportToCalendaerFailedWithError:(NSError *)error;
//
//@end
//
//@interface EventParser : NSObject
//
//@property (weak, nonatomic) id <EventParserDelegate> delegate;
//
//+ (instancetype)sharedInstance;
//
///**
// Shared storage used to store core data across the project targets
// This method should be called at each target you created to read shared core data
// */
//+ (void)initializeSharedStorage;
//
//- (void)parseItemList:(id)itemList ofType:(ItemType)itemType;
//
//- (void)parseTimeTable:(NSData *)data itemID:(NSNumber *)itemID callBack:(void (^)(void))callbackBlock;
//
///**
// Used to synchronously transform the encoding of a text to utf-8
//
// @param data raw cist server response
// @return utf-8 encoded data
// */
//- (NSData *)alignEncoding:(NSData *)data;
//
///**
// Used to asynchronously transform the encoding of a text to utf-8
//
// @param data raw cist server response
// @param callbackBlock utf-8 encoded data
// */
//+ (void)alignEncoding:(NSData *)data callBack:(void (^)(NSData *data))callbackBlock;
//
///**
// Used to asynchronously remove duplicate items in server response
//
// @param datasource json server response
// @param callbackBlock duplicate free response
// */
//+ (void)removeDuplicate:(id)datasource callBack:(void (^)(id response))callbackBlock;
//
//+ (UIColor *)getCellColorByType:(NSInteger)type isDarkTheme:(BOOL)isDarkTheme;
//
///**
// Events that belong to listed item will be export to iOS calendar
//
// @param item listed item
// @param range range of date to export
// */
//- (void)exportToCalendar:(Item *)item inRange:(CalendarExportRange)range;
//
//@end
