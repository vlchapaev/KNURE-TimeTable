//
//  Request.h
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 25.03.16.
//  Copyright © 2016 Shogunate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Request : NSObject

+ (NSURLRequest *)getGroupList;
+ (NSURLRequest *)getTeacherList;
+ (NSURLRequest *)getAuditoryList;

+ (NSURLRequest *)getTimetableFor:(NSString *)ID;

@end
