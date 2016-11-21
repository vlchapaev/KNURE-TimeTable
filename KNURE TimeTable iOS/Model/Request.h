//
//  Request.h
//  KNURE TimeTable iOS
//
//  Created by Vlad Chapaev on 25.03.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventParser.h"

extern NSString *const RequestAddressGroupList;
extern NSString *const RequestAddressTeacherList;
extern NSString *const RequestAddressAuditoryList;
extern NSString *const RequestAddressTimetable;

@interface Request : NSObject

+ (NSURLRequest *)getGroupList;
+ (NSURLRequest *)getTeacherList;
+ (NSURLRequest *)getAuditoryList;

+ (NSURLRequest *)getTimetable:(NSNumber *)ID ofType:(ItemType)itemType;

@end
