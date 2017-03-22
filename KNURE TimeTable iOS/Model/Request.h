//
//  Request.h
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 25.03.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

@import Foundation;

#import "AFNetworking.h"
#import "EventParser.h"
#import "Item+CoreDataClass.h"

extern NSString *const RequestAddressGroupList;
extern NSString *const RequestAddressTeacherList;
extern NSString *const RequestAddressAuditoryList;

@protocol URLRequestDelegate <NSObject>

@optional
- (void)requestDidLoadItemList:(id)data ofType:(ItemType)itemType;
- (void)requestDidLoadTimeTable:(id)data forItem:(Item *)item;
- (void)requestDidFailWithError:(NSError *)error;

@end

@interface Request : NSObject

/**
 Request to load list of grours, teachers or auditories depending of itemType parameter

 @param itemType type of list to load
 @param delegate confirmed to protocol class
 */
+ (void)loadItemListOfType:(ItemType)itemType delegate:(id)delegate;
+ (void)loadTimeTableForItem:(Item *)item delegate:(id)delegate;

+ (NSURLRequest *)getGroupList __deprecated_msg("use loadItemListOfType:delegate: instead.");
+ (NSURLRequest *)getTeacherList __deprecated_msg("use loadItemListOfType:delegate: instead.");;
+ (NSURLRequest *)getAuditoryList __deprecated_msg("use loadItemListOfType:delegate: instead.");
+ (NSURLRequest *)getTimetable:(NSNumber *)ID ofType:(ItemType)itemType __deprecated_msg("use loadTimeTableForItem:delegate: instead.");

@end
