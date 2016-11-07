//
//  Request.h
//  KNURE TimeTable iOS
//
//  Created by Vlad Chapaev on 25.03.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Request : NSObject

+ (NSURLRequest *)getGroupList;
+ (NSURLRequest *)getTeacherList;
+ (NSURLRequest *)getAuditoryList;

+ (NSURLRequest *)getTimetable:(NSNumber *)ID;

@end
