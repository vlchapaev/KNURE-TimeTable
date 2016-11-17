//
//  Request.m
//  KNURE TimeTable iOS
//
//  Created by Vlad Chapaev on 25.03.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import "Request.h"

const NSString *baseURL = @"http://cist.nure.ua/ias/app/tt/";

@implementation Request

+ (NSURLRequest *)getGroupList {
    NSString *method = @"P_API_GROUP_JSON";
    NSString *address = [NSString stringWithFormat:@"%@%@", baseURL, method];
    NSURL *url = [[NSURL alloc]initWithString:address];
    return [[NSURLRequest alloc]initWithURL:url];
}

+ (NSURLRequest *)getTeacherList {
    NSString *method = @"P_API_PODR_JSON";
    NSString *address = [NSString stringWithFormat:@"%@%@", baseURL, method];
    NSURL *url = [[NSURL alloc]initWithString:address];
    return [[NSURLRequest alloc]initWithURL:url];
}

+ (NSURLRequest *)getAuditoryList {
    NSString *method = @"P_API_AUDITORIES_JSON";
    NSString *address = [NSString stringWithFormat:@"%@%@", baseURL, method];
    NSURL *url = [[NSURL alloc]initWithString:address];
    return [[NSURLRequest alloc]initWithURL:url];
}

+ (NSURLRequest *)getTimetable:(NSNumber *)ID {
    NSString *method = @"P_API_EVENT_JSON";
    NSString *address = [NSString stringWithFormat:@"%@%@?timetable_id=%@", baseURL, method, ID];
    NSURL *url = [[NSURL alloc]initWithString:address];
    return [[NSURLRequest alloc]initWithURL:url];
}

@end
