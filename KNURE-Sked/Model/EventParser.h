//
//  EventHandler.h
//  KNURE TimeTable iOS
//
//  Created by Vlad Chapaev on 08.11.14.
//  Copyright (c) 2014 Vlad Chapaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    ItemTypeGroup,
    ItemTypeTeacher,
    ItemtypeAuditory
} ItemType;

@protocol EventParserDelegate <NSObject>

@optional
- (void)didParseItemListWithResponse:(id)response sections:(NSArray *)sections;

@end

@interface EventParser : NSObject

@property (weak, nonatomic) id <EventParserDelegate> delegate;

- (void)parseItemList:(id)itemList ofType:(ItemType)itemType;

- (void)parseTimeTable:(NSData *)data callBack:(void (^)(void))callbackBlock;

- (NSData *)alignEncoding:(NSData *)data;

+ (void)alignEncoding:(NSData *)data callBack:(void (^)(NSData *data))callbackBlock;

+ (void)removeDublicate:(id)datasource callBack:(void (^)(id response))callbackBlock;

+ (UIColor *)getCellColorBy:(NSInteger)type;

+ (instancetype)sharedInstance;

@end
