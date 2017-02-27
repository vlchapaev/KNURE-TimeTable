//
//  Request.h
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 25.03.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "EventParser.h"

extern NSString *const RequestAddressGroupList;
extern NSString *const RequestAddressTeacherList;
extern NSString *const RequestAddressAuditoryList;

@protocol URLRequestDelegate <NSObject>

@optional
- (void)requestDidLoadItemList:(id)data ofType:(ItemType)itemType;
- (void)requestDidLoadTimeTable:(id)data ofType:(ItemType)itemType withID:(NSNumber *)itemID;
- (void)requestDidFailWithError:(NSError *)error;
- (void)requestDidFinishLoading;

@end

@interface Request : NSObject

+ (void)loadItemListOfType:(ItemType)itemType delegate:(id)delegate;
+ (void)loadTimeTableOfType:(ItemType)itemType itemID:(NSNumber *)itemID delegate:(id)delegate;

+ (NSURLRequest *)getGroupList;
+ (NSURLRequest *)getTeacherList;
+ (NSURLRequest *)getAuditoryList;
+ (NSURLRequest *)getTimetable:(NSNumber *)ID ofType:(ItemType)itemType;

@end
